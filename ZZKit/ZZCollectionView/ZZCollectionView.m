//
//  ZZCollectionView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/24.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZCollectionView.h"
#import <pthread.h>
#import "NSBundle+ZZKit.h"
#import "NSArray+ZZKit.h"

#pragma mark - ZZCollectionViewFlowLayout

@interface ZZCollectionViewFlowLayout()
{
@private
    // 保存Section每一列的最大的Y值，然后获取到最短的一列，将下一个Cell放在该列中。
    NSMutableArray *_maxYOfColumns;
    
    // 保存所有Cell的位置信息
    NSMutableArray *_layoutAttributes;
    
    // 保存UICollectionView的bounds的高度。
    CGFloat _contentHeight;
}

@end

@implementation ZZCollectionViewFlowLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    NSAssert(_zzFlowLayoutDelegate != nil, @"ZZCollectionViewFlowLayout需要代理");
    
    // 重新赋值
    _contentHeight = self.zzContentInset.top;
    _layoutAttributes = [[NSMutableArray alloc] init];
    
    // 使用delegate获取section的数量
    NSInteger numberOfSection = [_zzFlowLayoutDelegate zz_numberOfSection];
    
    for (int section = 0; section < numberOfSection; section++) {
        NSMutableArray *sectionLayoutAttributes = [self _computeLayoutAttributesInSection:section];
        [_layoutAttributes addObjectsFromArray:sectionLayoutAttributes];
    }
}

// Overwrite
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 返回每个cell的位置信息等
    NSInteger section = indexPath.section;
    NSArray *sectionLayoutAttributes = _layoutAttributes[section];
    
    return sectionLayoutAttributes[indexPath.row];
}

// Overwrite
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return _layoutAttributes;
}

// Overwrite
- (CGSize)collectionViewContentSize {
    
    // 返回collectionView滑动的大小，因为横向没有滑动，X值不重要，也可以返回0
    return CGSizeMake(0.0, _contentHeight + self.zzContentInset.bottom);
}

#pragma mark - Private

/**
 * 计算每个section的位置信息
 * @return 与位置相关的信息。
 */
- (NSMutableArray *)_computeLayoutAttributesInSection:(NSInteger)section {
    
    // 获取Section的列数和Cell的个数
    NSInteger column = [_zzFlowLayoutDelegate zz_numberOfColumnInSectionAtIndex:section];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
    
    NSMutableArray *attributesArr = [NSMutableArray new];
    CGFloat itemSpace = 0.0;
    CGFloat lineSpace = 0.0;
    UIEdgeInsets sectionInset;
    
    // 获取间距等信息，下面计算位置时需要用到
    // 因为是可选的实现方法，在直接使用时需要判断是否已经实现了。
    if ([_zzFlowLayoutDelegate respondsToSelector:@selector(zz_contentInsetOfSectionAtIndex:)]) {
        sectionInset = [_zzFlowLayoutDelegate zz_contentInsetOfSectionAtIndex:section];
    }
    
    if ([_zzFlowLayoutDelegate respondsToSelector:@selector(zz_minimumLineSpacingForSectionAtIndex:)]) {
        itemSpace = [_zzFlowLayoutDelegate zz_minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    if ([_zzFlowLayoutDelegate respondsToSelector:@selector(zz_minimumLineSpacingForSectionAtIndex:)]) {
        lineSpace = [_zzFlowLayoutDelegate zz_minimumLineSpacingForSectionAtIndex:section];
    }
    
    // 留出每个section的顶部与上一个section的距离
    _contentHeight += sectionInset.top;
    
    if (column == 1) {
        // 一列，Cell会占满屏幕
        for (int index = 0; index < itemCount; index++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: indexPath];
            
            // 获取cell的大小
            CGSize size = [_zzFlowLayoutDelegate zz_sizeForItemAtIndexPath:indexPath];
            
            // 为了让collectionView.contentInset和sectionInset有效果，需要将width减去这个两个inset的左右的数值
            attributes.frame = CGRectMake(self.zzContentInset.left + sectionInset.left, _contentHeight, size.width - self.zzContentInset.left - self.zzContentInset.right - sectionInset.left - sectionInset.right, size.height);
            
            [attributesArr addObject:attributes];
            
            // 保存下一个cell的Y轴的数值
            _contentHeight += attributes.size.height + lineSpace;
        }
        
        // 减去最后一行底部添加的lineSpace
        _contentHeight += (sectionInset.bottom - lineSpace);
        return attributesArr;
    }
    
    // 不止一列时
    // 保存每一个最后一个Cell的底部Y轴的数值
    _maxYOfColumns = [NSMutableArray new];
    
    for (int i = 0; i < column; i++) {
        _maxYOfColumns[i] = @(0);
    }
    
    CGSize size;
    CGFloat x = 0.0;
    CGFloat y = 0.0;
    NSInteger currentColumn = 0;
    CGFloat width = 0.0;
    
    for (int index = 0; index < itemCount; index++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
        size = [_zzFlowLayoutDelegate zz_sizeForItemAtIndexPath:indexPath];
        
        if (index < column) {
            // 第一行直接添加到当前的列
            currentColumn = index;
        }else {
            // 其他行添加到最短的那一列
            // 这里使用!会得到期望的值
            NSNumber *minMaxY = [_maxYOfColumns valueForKeyPath:@"@min.self"];
            currentColumn = [_maxYOfColumns indexOfObject:minMaxY];
        }
        
        // 根据列数计算出每个cell的宽度
        width = (self.collectionView.bounds.size.width - itemSpace * (column - 1) - self.zzContentInset.left - self.zzContentInset.right - sectionInset.left - sectionInset.right) / column;
        
        // 根据将cell放在那一列，来计算出x坐标
        x = self.zzContentInset.left + sectionInset.left + currentColumn * (width + itemSpace);
        // 每个cell的y坐标
        y = lineSpace + [_maxYOfColumns[currentColumn] floatValue];
        
        // 记录每一列的最后一个cell的最大Y
        _maxYOfColumns[currentColumn] = @(y + size.height);

        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: indexPath];
        
        // 设置用于瀑布流效果的attributes的frame
        attributes.frame = CGRectMake(x, y + _contentHeight, width, size.height);
        [attributesArr addObject:attributes];
    }
    
    // 将所有列最大的Y值作为整个collectionView.cententSize的高度
    CGFloat maxY = [[_maxYOfColumns valueForKeyPath:@"@max.self"] floatValue];
    _contentHeight += maxY + sectionInset.bottom;
    return attributesArr;
}

@end

#pragma mark - ZZCollectionView

@interface ZZCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource, ZZCollectionViewFlowLayoutDelegate, UIScrollViewDelegate>

// 锁
@property (nonatomic, assign) pthread_mutex_t lock;
// SuperView
@property (nonatomic, weak) UIView *superView;
// FlowLayout
@property (nonatomic, strong) ZZCollectionViewFlowLayout *zzLayout;

@end

@implementation ZZCollectionView

- (void)dealloc
{
    
}

#pragma mark - ZZCollectionView 属性

#pragma mark - ZZCollectionView 初始化

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        self.zzDataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

/**
 *  创建ZZCollectionView的方法
 */
+ (nonnull ZZCollectionView *)zz_quickAdd:(nullable UIColor *)backgroundColor onView:(nullable UIView *)onView frame:(CGRect)frame registerCellsBlock:(nullable NSArray *(^)(void))registerCellsBlock constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock actionBlock:(ZZCollectionViewCellActionBlock)actionBlock {
    
    ZZCollectionViewFlowLayout *flowLayout = [[ZZCollectionViewFlowLayout alloc] init];
    ZZCollectionView *collectionView = [[ZZCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    flowLayout.zzFlowLayoutDelegate = collectionView;
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
    
    collectionView.zzLayout = flowLayout;
    collectionView.superView = onView;
    if (onView) {
        [onView addSubview:collectionView];
        if (constraintBlock) {
            [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                constraintBlock(onView, make);
            }];
        }
    }
    if (registerCellsBlock) {
        NSArray *array = registerCellsBlock();
        for (id object in array) {
            NSString *cellClassName = nil;
            if ([object isKindOfClass:[NSString class]]) {
                // NSString
                cellClassName = object;
            }else {
                // Class
                cellClassName = NSStringFromClass(object);
            }
            if ([cellClassName hasSuffix:@"DataSource"]) {
                cellClassName = [cellClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
            }
            NSBundle *bundle = [NSBundle zz_resourceClass:NSClassFromString(cellClassName) bundleName:nil];
            UINib *nib = [UINib nibWithNibName:cellClassName bundle:bundle];
            [collectionView registerNib:nib forCellWithReuseIdentifier:cellClassName];
        }
    }
    collectionView.zzActionBlock = actionBlock;
    collectionView.backgroundColor = backgroundColor;
    return collectionView;
}

/**
 *  一组安全的操作datasource的方法
 */
- (void)zz_addDataSource:(nonnull id)data {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [self.zzDataSource zz_arrayAddObject:data];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_insertDataSource:(nonnull id)anObject atIndex:(NSUInteger)index {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [self.zzDataSource zz_arrayInsertObject:anObject atIndex:index];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeDataSource:(nonnull id)data {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [self.zzDataSource zz_arrayRemoveObject:data];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeDataSourceObjectAtIndex:(NSInteger)index {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [self.zzDataSource zz_arrayRemoveObjectAtIndex:index];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeFirstDataSource {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [self.zzDataSource zz_arrayRemoveFirstObject];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeLastDataSource {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [self.zzDataSource zz_arrayRemoveLastObject];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeAllDataSource {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    for (ZZCollectionSectionObject *section in self.zzDataSource) {
        [section.zzCellDataSource removeAllObjects];
    }
    [self.zzDataSource removeAllObjects];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_replaceDataSourceAtIndex:(NSUInteger)index withObject:(nonnull id)data {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [self.zzDataSource zz_arrayReplaceObjectAtIndex:index withObject:data];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_exchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2 {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [self.zzDataSource zz_arrayExchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    pthread_mutex_unlock(&_lock);
}

/**
 *  CollectionView安全加载刷新Data
 */
- (void)zz_refresh {
    
    pthread_mutex_lock(&_lock);
    int cnt = 0;
    for (ZZCollectionSectionObject *sectionObject in self.zzDataSource) {
        if ([sectionObject isKindOfClass:[ZZCollectionSectionObject class]]) {
            cnt++;
        }
    }
    if (cnt == 0) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        ZZCollectionSectionObject *sectionObject = [[ZZCollectionSectionObject alloc] init];
        [sectionObject.zzCellDataSource addObjectsFromArray:self.zzDataSource];
        [arr zz_arrayAddObject:sectionObject];
        self.zzDataSource = arr;
    }else if (cnt == self.zzDataSource.count) {
        // 格式正确
    }else {
        NSAssert(NO, @"ZZCollectionView:数据源类型异常");
    }
    [self reloadData];
    self.scrollEnabled = YES;
    pthread_mutex_unlock(&_lock);
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.zzDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource objectAtIndex:section];
    return sectionObject.zzCellDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource objectAtIndex:indexPath.section];
    ZZCollectionViewCellDataSource *ds = [sectionObject.zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
    NSString *cellClassName = NSStringFromClass([ds class]);
    cellClassName = [cellClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, cellClassName.length)];
    ZZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellClassName forIndexPath:indexPath];
    if (!cell) {
        NSBundle *bundle = [NSBundle zz_resourceClass:NSClassFromString(cellClassName) bundleName:nil];
        UINib *nib = [UINib nibWithNibName:cellClassName bundle:bundle];
        [collectionView registerNib:nib forCellWithReuseIdentifier:cellClassName];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellClassName forIndexPath:indexPath];
    }
    cell.zzData = ds;
    __weak ZZCollectionView *weakSelf = self;
    cell.zzTapBlock = ^(__kindof ZZCollectionViewCellDataSource * _Nonnull data, __kindof ZZCollectionViewCell * _Nonnull cell) {
        __strong ZZCollectionView *strongSelf = weakSelf;
        if (data != nil && cell != nil) {
            __block NSIndexPath *_indexPath = [strongSelf indexPathForCell:cell];
            __weak typeof(strongSelf) weakSelf = strongSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.zzActionBlock == nil ? : weakSelf.zzActionBlock(weakSelf, _indexPath.section, _indexPath.row, ZZCollectionViewCellActionCustomTapped, data, cell);
            });
        }
    };
    return cell;
}

#pragma mark - ZZCollectionViewFlowLayoutDelegate

// Required

// Section的数量
- (NSInteger)zz_numberOfSection {
    
    return [self numberOfSectionsInCollectionView:self];
}

// Cell的大小
- (CGSize)zz_sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource objectAtIndex:indexPath.section];
    ZZCollectionViewCellDataSource *ds = [sectionObject.zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
    return ds.zzSize;
}

// 每个Section对应的列数
- (NSInteger)zz_numberOfColumnInSectionAtIndex:(NSInteger)section {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource objectAtIndex:section];
    return sectionObject.zzColumns;
}

// Optional

- (CGFloat)zz_minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource objectAtIndex:section];
    return sectionObject.zzMinimumLineSpacing;
}

- (CGFloat)zz_minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource objectAtIndex:section];
    return sectionObject.zzMinimumInteritemSpacing;
}

- (UIEdgeInsets)zz_contentInsetOfSectionAtIndex:(NSInteger)section {
 
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource objectAtIndex:section];
    return sectionObject.zzEdgeInsets;
}

#pragma mark - UIScrollView

// any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZCollectionViewScrollActionDidScroll, CGPointZero, CGPointZero, NO);
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZCollectionViewScrollActionWillBeginDragging, CGPointZero, CGPointZero, NO);
}

// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZCollectionViewScrollActionWillEndDragging, velocity, CGPointMake(targetContentOffset->x, targetContentOffset->y), NO);
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZCollectionViewScrollActionDidEndDragging, CGPointZero, CGPointZero, decelerate);
}

// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZCollectionViewScrollActionWillBeginDecelerating, CGPointZero, CGPointZero, NO);
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZCollectionViewScrollActionDidEndDecelerating, CGPointZero, CGPointZero, NO);
}

// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZCollectionViewScrollActionDidEndScrollingAnimation, CGPointZero, CGPointZero, NO);
}

// called when scrolling animation finished. may be called immediately if already at top
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZCollectionViewScrollActionDidScrollToTop, CGPointZero, CGPointZero, NO);
}

@end

#pragma mark - ZZCollectionSectionObject

@implementation ZZCollectionSectionObject : NSObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.zzCellDataSource = (NSMutableArray<ZZCollectionViewCellDataSource *> *)[[NSMutableArray alloc] init];
        self.zzColumns = 1;
        self.zzEdgeInsets = UIEdgeInsetsZero;
        self.zzMinimumInteritemSpacing = 0;
        self.zzMinimumLineSpacing = 0;
    }
    return self;
}

@end

#pragma mark - ZZCollectionViewCell

@implementation ZZCollectionViewCell : UICollectionViewCell

@end

#pragma mark - ZZCollectionViewCellDataSource

@implementation ZZCollectionViewCellDataSource : NSObject

@end
