//
//  ZZWidgetImageBrowser.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/2.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZWidgetImageBrowser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

#pragma mark - ZZWidgetImageBrowser

static NSString *cellId = @"ZZWidgetImageItemCell";

//cell之间的间隔
static CGFloat lineSpacing = 10.0f;

@interface ZZWidgetImageBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource>

//滚动的ScrollView
@property (nonatomic, strong) UICollectionView *collectionView;
//第一次加载的位置
@property (nonatomic, assign) NSInteger startIndex;
//当前滚动位置
@property (nonatomic, assign) NSInteger currentIndex;
//开始加载时的图片位置
@property (nonatomic, assign) CGRect anchorFrame;
//图片地址
@property (nonatomic, strong) NSArray *imageUrls;
//图片容器
@property (nonatomic, strong) UIView *imageContainer;
//是否显示网络图片
@property (nonatomic, assign) BOOL showNetImages;
//工具栏
@property (nonatomic, strong) ZZWidgetImageToolBar *toolBar;

@end

@implementation ZZWidgetImageBrowser

+(ZZWidgetImageBrowser *)shareInstanse {
    
    static ZZWidgetImageBrowser *viewer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        viewer = [[ZZWidgetImageBrowser alloc] init];
    });
    return viewer;
}

-(instancetype)init {
    
    if (self = [super init]) {
        [self _zz_buildUI];
    }
    return self;
}

#pragma mark - 功能方法

//显示网络图片方法
-(void)zz_showNetImages:(NSArray <NSString *> *)imageUrls index:(NSInteger)index fromImageContainer:(UIView *)imageContainer {
    
    _showNetImages = true;
    [self zz_showImages:imageUrls index:index container:imageContainer];
}

-(void)zz_showLocalImages:(NSArray <NSString *> *)imagePathes index:(NSInteger)index fromImageContainer:(UIView *)imageContainer {
    
    _showNetImages = false;
    [self zz_showImages:imagePathes index:index container:imageContainer];
}

-(void)zz_showImages:(NSArray<NSString *> *)images index:(NSInteger)index container:(UIView *)container {
    
    //设置图片容器
    _imageContainer = container;
    //设置数据源
    _imageUrls = images;
    //设置起始位置
    _startIndex = index;
    //初始化锚点
    _anchorFrame = [_imageContainer convertRect:_imageContainer.bounds toView:self];
    //更新显示
    _toolBar.text = [NSString stringWithFormat:@"%zd/%zd",_currentIndex + 1,_imageUrls.count];
    [_toolBar zz_show];
    
    //刷新CollectionView
    [_collectionView reloadData];
    //滚动到指定位置
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:false];
    //找到指定Cell执行放大动画
    __weak typeof(self) weakSelf = self;
    [_collectionView performBatchUpdates:nil completion:^(BOOL finished) {
        ZZWidgetImageItemCell *item = (ZZWidgetImageItemCell *)[weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [item zz_showEnlargeAnimation];
        //添加到屏幕上
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf];
    }];
}

//初始化视图
-(void)_zz_buildUI {
    //设置ImageViewer属性
    self.frame = [UIScreen mainScreen].bounds;
    
    //初始化CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    layout.minimumLineSpacing = lineSpacing;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, lineSpacing);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    CGRect frame = self.bounds;
    frame.size.width += lineSpacing;
    _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = true;
    [_collectionView registerClass:[ZZWidgetImageItemCell class] forCellWithReuseIdentifier:cellId];
    _collectionView.showsHorizontalScrollIndicator = false;
    [self addSubview:_collectionView];
    
    _startIndex = 0;
    _currentIndex = 0;
    
    _toolBar = [[ZZWidgetImageToolBar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - ToolBarHeight, self.bounds.size.width, ToolBarHeight)];
    [self addSubview:_toolBar];
}

#pragma mark - CollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _imageUrls.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZWidgetImageItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    //设置属性
    cell.showNetImage = _showNetImages;
    cell.isStart = indexPath.row == _startIndex;
    cell.collectionView = collectionView;
    cell.anchorFrame = _anchorFrame;
    cell.imageViewContentMode = [self _zz_imageViewContentMode];
    cell.imageUrl = _imageUrls[indexPath.row];
    //添加回调
    __weak typeof(self) weakSelf = self;
    [cell zz_addHideBlockStart:^{
        [weakSelf.toolBar zz_hide];
    } finish:^{
        [self removeFromSuperview];
    } cancel:^{
        [weakSelf.toolBar zz_show];
    }];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _currentIndex = scrollView.contentOffset.x/scrollView.bounds.size.width;
    _toolBar.text = [NSString stringWithFormat:@"%zd/%zd",_currentIndex + 1,_imageUrls.count];
}

#pragma mark - 获取上级ImageView的ContentMode

-(UIViewContentMode)_zz_imageViewContentMode {
    
    UIViewContentMode contentMode = UIViewContentModeScaleToFill;
    if ([_imageContainer isKindOfClass:[UIImageView class]]) {
        contentMode = _imageContainer.contentMode;
    }else{
        for (UIView *subView in _imageContainer.subviews) {
            if ([subView isKindOfClass:[UIImageView class]]) {
                contentMode = subView.contentMode;
            }else{
                for (UIView *subView2 in subView.subviews) {
                    if ([subView2 isKindOfClass:[UIImageView class]]) {
                        contentMode = subView2.contentMode;
                    }
                }
            }
        }
    }
    return contentMode;
}

#pragma mark 存储图片方法

-(void)_zz_saveImage {
    
    ZZWidgetImageItemCell *item = (ZZWidgetImageItemCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    [item zz_saveImage];
}

@end

#pragma mark - ZZWidgetImageItemCell

static CGFloat maxZoomScale = 2.0f;
static CGFloat minZoomScale = 1.0f;

// 最小拖拽返回相应距离
static CGFloat minPanLength = 100.0f;

@interface ZZWidgetImageItemCell ()<UIScrollViewDelegate>

// ScrollView
@property (nonatomic, strong) UIScrollView   *scrollView;

// ImageView
@property (nonatomic, strong) UIImageView    *imageView;

// 加载动画
@property (nonatomic, strong) ZZWidgetImageLoadingView *loading;

// 是否正在执行动画
@property (nonatomic, assign) BOOL isAnimating;

// 返回方法
@property (nonatomic, copy) ZZWidgetImageBrowserVoidBlock startHideBlock;
@property (nonatomic, copy) ZZWidgetImageBrowserVoidBlock finishHideBlock;
@property (nonatomic, copy) ZZWidgetImageBrowserVoidBlock cancelIdleBlock;

@end

#pragma mark - ZZWidgetImageItemCell

@implementation ZZWidgetImageItemCell

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self _zz_buildUI];
    }
    return self;
}

-(void)_zz_buildUI {
    
    //设置ScrollView 利用ScrollView完成图片的放大功能
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = maxZoomScale;
    _scrollView.minimumZoomScale = minZoomScale;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.showsVerticalScrollIndicator = false;
    _scrollView.decelerationRate = 0.1f;
    [_scrollView.panGestureRecognizer addTarget:self action:@selector(scrollViewPanMethod:)];
    _scrollView.userInteractionEnabled = true;
    [self.contentView addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
    _imageView.layer.masksToBounds = true;
    _imageView.userInteractionEnabled = true;
    [_scrollView addSubview:_imageView];
    
    //添加双击方法
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_zz_enlargeImageView)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    //添加单击方法
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_zz_showShrinkDownAnimation)];
    [self addGestureRecognizer:singleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    //添加加载动画
    _loading = [ZZWidgetImageLoadingView zz_showInView:self];
    [_loading zz_hide];
}

#pragma mark - 点击方法
//双击 放大缩小
-(void)_zz_enlargeImageView {
    
    //已经放大后 双击还原 未放大则双击放大
    CGFloat zoomScale = _scrollView.zoomScale != minZoomScale ? minZoomScale : maxZoomScale;
    [_scrollView setZoomScale:zoomScale animated:true];
}

#pragma mark - ScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    [self _zz_updateImageFrame];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    if (scale != 1) {return;}
    CGFloat height = [self _zz_imageViewFrame].size.height > _scrollView.bounds.size.height ? [self _zz_imageViewFrame].size.height : _scrollView.bounds.size.height + 1;
    _scrollView.contentSize = CGSizeMake(_imageView.bounds.size.width, height);
}

#pragma mark - ImageView设置Frame相关方法
-(void)_zz_updateImageFrame {
    
    CGRect imageFrame = _imageView.frame;
    if (imageFrame.size.width < self.bounds.size.width) {
        imageFrame.origin.x = (self.bounds.size.width - imageFrame.size.width)/2.0f;
    }else{
        imageFrame.origin.x = 0;
    }
    
    if (imageFrame.size.height < self.bounds.size.height) {
        imageFrame.origin.y = (self.bounds.size.height - imageFrame.size.height)/2.0f;
    }else{
        imageFrame.origin.y = 0;
    }
    
    if (!CGRectEqualToRect(_imageView.frame, imageFrame)) {
        _imageView.frame = imageFrame;
    }
}

-(CGRect)_zz_imageViewFrame {
    
    if (!_imageView.image) {
        return _scrollView.bounds;
    }
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    return CGRectMake(0, 0, width, height);
}

-(void)_zz_setImageViewFrame {
    
    if (!_imageView.image) {return;}
    //这只imageview的图片和范围
    _imageView.frame = [self _zz_imageViewFrame];
    //设置ScrollView的滚动范围
    CGFloat height = [self _zz_imageViewFrame].size.height > _scrollView.bounds.size.height ? [self _zz_imageViewFrame].size.height : _scrollView.bounds.size.height + 1;
    _scrollView.contentSize = CGSizeMake(_imageView.bounds.size.width, height);
}

#pragma mark Setter

- (void)setImageUrl:(NSString *)imageUrl {
    
    _imageUrl = imageUrl;
    _scrollView.zoomScale = minZoomScale;
    //显示本地图片
    if (!_showNetImage) {
        _imageView.image = [UIImage imageWithContentsOfFile:_imageUrl];
        [self _zz_setImageViewFrame];
        [_loading zz_hide];
        return;
    }
    //显示网络图片
    __weak typeof(self) weakSelf = self;
    if ([ZZWidgetImageBrowser shareInstanse].zzLoadImageBlock != nil) {
        // 开发者可以自己实现加载逻辑
        ZZWidgetImageBrowserVoidBlock finished = ^{
            [weakSelf _zz_setImageViewFrame];
        };
        [ZZWidgetImageBrowser shareInstanse].zzLoadImageBlock(_imageView, _imageUrl, _loading, finished);
    }else{
        // 默认的加载图片逻辑
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.loading zz_show];
                weakSelf.loading.progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
            });
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [weakSelf _zz_setImageViewFrame];
            //隐藏加载
            [weakSelf.loading zz_hide];
        }];
    }
}

- (void)setImageViewContentMode:(UIViewContentMode)imageViewContentMode {
    
    _imageViewContentMode = imageViewContentMode;
    _imageView.contentMode = imageViewContentMode;
}

#pragma mark - Block方法
-(void)zz_addHideBlockStart:(ZZWidgetImageBrowserVoidBlock)start finish:(ZZWidgetImageBrowserVoidBlock)finish cancel:(ZZWidgetImageBrowserVoidBlock)cancel {
    
    _startHideBlock = start;
    _finishHideBlock = finish;
    _cancelIdleBlock = cancel;
}

#pragma mark - 显示/隐藏动画

//放大动画
-(void)zz_showEnlargeAnimation {
    
    //如果还没加载完成网络图片则不显示动画
    _imageView.frame = _anchorFrame;
    _collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        weakSelf.imageView.frame = [weakSelf _zz_imageViewFrame];
    }completion:^(BOOL finished) {
        if (!weakSelf.imageView.image) {
            [weakSelf.loading zz_show];
        }
    }];
}

//缩小动画
-(void)_zz_showShrinkDownAnimation {
    
    _startHideBlock == nil ? : _startHideBlock();
    //如果还没加载完成网络图片则不显示动画
    if (_imageView.image) {
        CGRect startRect = CGRectMake(-_scrollView.contentOffset.x + _imageView.frame.origin.x, -_scrollView.contentOffset.y + _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
        _imageView.frame = startRect;
        [self.contentView addSubview:_imageView];
    }
    __weak typeof(self) weakSelf = self;
    //设置CollectionView透明度
    _collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        if (weakSelf.isStart && weakSelf.imageView.image) {
            weakSelf.imageView.frame = weakSelf.anchorFrame;
        }else{
            weakSelf.alpha = 0;
        }
    }completion:^(BOOL finished) {
        //通知回调
        weakSelf.finishHideBlock == nil ? : weakSelf.finishHideBlock();
        weakSelf.imageView.frame = [weakSelf _zz_imageViewFrame];
        weakSelf.alpha = 1;
        weakSelf.scrollView.zoomScale = minZoomScale;
        [weakSelf.scrollView addSubview:weakSelf.imageView];
        [weakSelf.scrollView setContentOffset:CGPointZero];
    }];
}

#pragma mark - 拖拽返回方法
-(void)scrollViewPanMethod:(UIPanGestureRecognizer *)pan {
    
    if (_scrollView.zoomScale != 1.0f) {return;}
    if (_scrollView.contentOffset.y > 0) {return;}
    __weak typeof(self) weakSelf = self;
    //拖拽结束后判断位置
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (ABS(_scrollView.contentOffset.y) < minPanLength) {
            _cancelIdleBlock == nil ? : _cancelIdleBlock();
            [UIView animateWithDuration:0.35 animations:^{
                weakSelf.scrollView.contentInset = UIEdgeInsetsZero;
            }];
        }else{
            [UIView animateWithDuration:0.35 animations:^{
                //设置移除动画
                CGRect frame = weakSelf.imageView.frame;
                frame.origin.y = weakSelf.scrollView.bounds.size.height;
                weakSelf.imageView.frame = frame;
                weakSelf.collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
            }completion:^(BOOL finished) {
                //先通知上层返回
                weakSelf.finishHideBlock == nil ? : weakSelf.finishHideBlock();
                //重置状态
                weakSelf.imageView.frame = [weakSelf _zz_imageViewFrame];
                weakSelf.scrollView.contentInset = UIEdgeInsetsZero;
            }];
        }
    }else{
        //拖拽过程中逐渐改变透明度
        _scrollView.contentInset = UIEdgeInsetsMake(-_scrollView.contentOffset.y, 0, 0, 0);
        CGFloat alpha = 1 - ABS(_scrollView.contentOffset.y/(_scrollView.bounds.size.height));
        _collectionView.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
        _startHideBlock == nil ? : _startHideBlock();
    }
}

#pragma mark - 保存图片
-(void)zz_saveImage {
    
    if (!_imageView.image) {return;}
    UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

#pragma mark - 保存图片代理
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error != NULL) {return;}
    [ZZWidgetImageLoadingView zz_showAlertInView:self message:@"图片存储成功"];
}

@end

#pragma mark - ZZWidgetImageLoadingView

@interface ZZWidgetImageLoadingView ()
{
    UILabel      *_loadingLabel;
    CAShapeLayer *_progressLayer;
}
@end

@implementation ZZWidgetImageLoadingView

+(ZZWidgetImageLoadingView *)zz_showInView:(UIView *)view {
    
    ZZWidgetImageLoadingView *loading = [[ZZWidgetImageLoadingView alloc] initWithFrame:view.bounds];
    [view addSubview:loading];
    return loading;
}

+(ZZWidgetImageLoadingView *)zz_showAlertInView:(UIView *)view message:(NSString *)message {
    
    ZZWidgetImageLoadingView *loading = [[ZZWidgetImageLoadingView alloc] initWithFrame:view.bounds mesasge:message];
    [view addSubview:loading];
    return loading;
}

-(void)zz_show {
    
    self.hidden = false;
}

-(void)zz_hide {
    
    self.hidden = true;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self _zz_buildLoadingView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame mesasge:(NSString *)message {
    
    if (self = [super initWithFrame:frame]) {
        [self _zz_buildAlertView:message];
    }
    return self;
}

-(void)_zz_buildLoadingView {
    
    CGFloat viewWidth = 35.0f;
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    _loadingLabel.textColor = [UIColor whiteColor];
    _loadingLabel.font = [UIFont systemFontOfSize:10.0f];
    _loadingLabel.center = self.center;
    _loadingLabel.text = @"0%";
    [self addSubview:_loadingLabel];
    CGFloat lineWidth = 3.0f;
    float centerX = viewWidth/2.0;
    float centerY = viewWidth/2.0;
    //半径
    float radius = (viewWidth - lineWidth)/2.0f;
    //创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:( -0.5f * M_PI ) endAngle:( 1.5f * M_PI ) clockwise:YES];
    //添加背景圆环
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = _loadingLabel.bounds;
    backLayer.fillColor =  [[UIColor clearColor] CGColor];
    backLayer.strokeColor  = [UIColor colorWithRed:50.0/255.0f green:50.0/255.0f blue:50.0/255.0f alpha:1].CGColor;
    backLayer.lineWidth = lineWidth;
    backLayer.path = [path CGPath];
    backLayer.strokeEnd = 1;
    [_loadingLabel.layer addSublayer:backLayer];
    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = _loadingLabel.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    _progressLayer.strokeColor  = [[UIColor whiteColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = lineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    [_loadingLabel.layer addSublayer:_progressLayer];
}

-(void)_zz_buildAlertView:(NSString *)message {
    
    CGFloat alertHeignt = 70.0f;
    CGFloat alertWidth = 120;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertWidth, alertHeignt)];
    view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    view.center = self.center;
    view.layer.cornerRadius = 10.0f;
    view.layer.masksToBounds = true;
    [self addSubview:view];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = view.bounds;
    [view addSubview:effectView];
    UILabel *label = [[UILabel alloc] initWithFrame:effectView.bounds];
    label.text = message;
    label.textColor = [UIColor colorWithRed:68.0/255.0f green:68.0/255.0f blue:69.0/255.0f alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:16];
    [view addSubview:label];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    __weak typeof(self) weakSelf = self;
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf removeFromSuperview];
    });
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress <= 0 ? 0 : progress;
    _progress = progress >= 1 ? 1 : progress;
    _loadingLabel.text = [NSString stringWithFormat:@"%.0f%%",_progress*100.0f];
    _progressLayer.strokeEnd = _progress;
}

@end

#pragma mark - ZZWidgetImageToolBar

@implementation ZZWidgetImageToolBar
{
    UILabel *_pageLabel;
}

-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self _zz_buildUI];
    }
    return self;
}

-(void)_zz_buildUI {
    
    //显示分页的label
    _pageLabel = [[UILabel alloc] init];
    _pageLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _pageLabel.layer.cornerRadius = 2.0f;
    _pageLabel.layer.masksToBounds = true;
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.font = [UIFont systemFontOfSize:12];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_pageLabel];
    self.alpha = 0;
    __weak typeof(self) weakSelf = self;
    [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.equalTo(@50.0);
        make.height.equalTo(@20.0);
    }];
}

- (void)setText:(NSString *)text {
    
    _pageLabel.text = text;
}

-(void)zz_show {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.alpha = 1;
    }];
}

-(void)zz_hide {
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.alpha = 0;
    }];
}

@end
