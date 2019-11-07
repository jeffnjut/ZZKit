//
//  StaticScaleCropView.m
//  TagTest
//
//  Created by mark meng on 16/9/22.
//  Copyright © 2016年 mark meng. All rights reserved.
//

#import "StaticScaleCropView.h"
#import <Masonry/Masonry.h>
#import "ZZMacro.h"
#import "FJFilterManager.h"

@interface StaticScaleCropView ()<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isZooming;

// 裁切容器
@property (nonatomic, strong) UIScrollView *scrollView;

// 裁切对象
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *topBlur;
@property (nonatomic, strong) UIView *leftBlur;
@property (nonatomic, strong) UIView *bottomBlur;
@property (nonatomic, strong) UIView *rightBlur;

// 原图
@property (nonatomic, strong) UIImage *image;

// 宽/高
@property (nonatomic, assign) CGFloat ratio;

@end

@implementation StaticScaleCropView

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self _setupSubViews];
    }
    return self;
}

- (void)updateImage:(UIImage*)image ratio:(CGFloat)ratio {
    
    if (image == nil || ratio <= 0) {
        return;
    }
    self.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = image;
    self.imageView.highlightedImage = image;
    self.ratio = ratio;
    [self _updateSubViewsFrame];
}

- (UIImage *)croppedImage {
    
    float zoomScale = 1.0 / [_scrollView zoomScale];
    CGRect rect;
    rect.origin.x = [_scrollView contentOffset].x * zoomScale;
    rect.origin.y = [_scrollView contentOffset].y * zoomScale;
    rect.size.width = [_scrollView bounds].size.width * zoomScale;
    rect.size.height = [_scrollView bounds].size.height * zoomScale;
    
    CGImageRef cr = CGImageCreateWithImageInRect([_imageView.highlightedImage CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:cr];
    CGImageRelease(cr);
    
    return cropped;
}

- (void)updateCurrentTuning:(FJTuningObject *)tuningObject {
    
    UIImage *image = [[FJFilterManager shared] getImage:self.imageView.image tuningObject:tuningObject appendFilterType:tuningObject.filterType];
    self.imageView.image = image;
}

- (void)_setupSubViews {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.clipsToBounds = NO;
    _scrollView.layer.cornerRadius = 0.0;
    _scrollView.layer.borderWidth = 2.0;
    _scrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setDelegate:self];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setMaximumZoomScale:3.0];
    [self addSubview:_scrollView];
    
    // image view
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_imageView];
    [self _initialBlurViewAndConstraint];
    self.clipsToBounds = YES;
}

// blur && 约束
- (void)_initialBlurViewAndConstraint {
    
    _topBlur = [[UIView alloc] init];
    _topBlur.backgroundColor = [UIColor blackColor];
    _topBlur.alpha = 0.5;
    [self addSubview:_topBlur];
    
    _leftBlur = [[UIView alloc] init];
    _leftBlur.backgroundColor = [UIColor blackColor];
    _leftBlur.alpha = 0.5;
    [self addSubview:_leftBlur];
    
    _bottomBlur = [[UIView alloc] init];
    _bottomBlur.backgroundColor = [UIColor blackColor];
    _bottomBlur.alpha = 0.5;
    [self addSubview:_bottomBlur];
    
    _rightBlur = [[UIView alloc] init];
    _rightBlur.backgroundColor = [UIColor blackColor];
    _rightBlur.alpha = 0.5;
    [self addSubview:_rightBlur];
    
    ZZ_WEAK_SELF
    [_topBlur mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top);
        make.left.mas_equalTo(weakSelf.mas_left);
        make.bottom.mas_equalTo(weakSelf.scrollView.mas_top);
        make.right.mas_equalTo(weakSelf.mas_right);
    }];
    
    [_leftBlur mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topBlur.mas_bottom);
        make.left.mas_equalTo(weakSelf.mas_left);
        make.bottom.mas_equalTo(weakSelf.bottomBlur.mas_top);
        make.right.mas_equalTo(weakSelf.scrollView.mas_left);
    }];
    
    [_bottomBlur mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.scrollView.mas_bottom);
        make.left.mas_equalTo(weakSelf.mas_left);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
        make.right.mas_equalTo(weakSelf.mas_right);
    }];
    
    [_rightBlur mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topBlur.mas_bottom);
        make.left.mas_equalTo(weakSelf.scrollView.mas_right);
        make.bottom.mas_equalTo(weakSelf.bottomBlur.mas_top);
        make.right.mas_equalTo(weakSelf.mas_right);
    }];
}

- (void)_updateSubViewsFrame {
    
    // 重置
    [_scrollView setMinimumZoomScale:1.0];
    [_scrollView setZoomScale:1.0];
    _scrollView.contentOffset = CGPointZero;
    
    CGSize imageSize = _image.size;
    _imageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    _scrollView.contentSize = _imageView.frame.size;
    
    // set scrollView FRAME
    CGFloat maxWidth = self.frame.size.width;
    CGFloat maxHeight = self.frame.size.height;
    CGFloat ratio = maxWidth / maxHeight;
    
    if (ratio > _ratio) {
        
        CGFloat y = 0;
        CGFloat h = maxHeight;
        CGFloat w = maxHeight * _ratio;
        CGFloat x = (maxWidth - w)/2.0;
        _scrollView.frame = CGRectMake(x, y, w, h);
    }else {
        CGFloat x = 0;
        CGFloat w = maxWidth;
        CGFloat h = maxWidth / _ratio;
        CGFloat y = (maxHeight - h) / 2.0;
        _scrollView.frame = CGRectMake(x, y, w, h);
    }
    
    // zoom
    float zoom = 0.0;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    CGFloat wRate = imageSize.width / _scrollView.frame.size.width;
    CGFloat hRate = imageSize.height / _scrollView.frame.size.height;
    if (wRate < hRate) {
        //  缩放 width
        zoom = _scrollView.frame.size.width / _imageView.frame.size.width;
        [_scrollView setMinimumZoomScale:zoom];
        [_scrollView setZoomScale:zoom];
        // 图片居中
        offsetY = (imageSize.height*zoom - _scrollView.frame.size.height)/2.0;
        //offsetY = (zoom-1.0)*imageSize.height / 2.0;
    }else {
        //  缩放 height
        zoom = [_scrollView frame].size.height / [_imageView frame].size.height;
        [_scrollView setMinimumZoomScale:zoom];
        [_scrollView setZoomScale:zoom];
        
        // 图片居中
        //offsetX = (zoom-1.0)*imageSize.width / 2.0;
        offsetX = (imageSize.width*zoom-_scrollView.frame.size.width)/2.0;
        
    }
    _scrollView.contentOffset = CGPointMake(offsetX, offsetY);
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    _isZooming = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _isZooming = NO;
}

@end
