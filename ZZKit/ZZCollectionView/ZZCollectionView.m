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
#import "UIView+ZZKit.h"
#import "ZWHCollectionViewFlowWaterfallLayout.h"

#pragma mark - ZZCollectionView

@interface ZZCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZWHCollectionViewFlowWaterfallLayoutDelegateFlowLayout, UIScrollViewDelegate>

// 锁
@property (nonatomic, assign) pthread_mutex_t lock;
// SuperView
@property (nonatomic, weak) UIView *superView;
// LongGesture
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;
// 垂直/水平滚动
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@end

@implementation ZZCollectionView

- (void)dealloc
{
    
}

#pragma mark - ZZCollectionView 属性

- (void)setZzDraggable:(BOOL)zzDraggable {
    
    _zzDraggable = zzDraggable;
    if (zzDraggable) {
        self.longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDrag:)];
        [self addGestureRecognizer:self.longGesture];
    }else {
        [self removeGestureRecognizer:self.longGesture];
    }
}

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
+ (nonnull ZZCollectionView *)zz_quickAdd:(nullable UIColor *)backgroundColor
                                   onView:(nullable UIView *)onView
                                    frame:(CGRect)frame
                       registerCellsBlock:(nullable NSArray *(^)(void))registerCellsBlock
                     registerHeadersBlock:(nullable NSArray *(^)(void))registerHeadersBlock
                     registerFootersBlock:(nullable NSArray *(^)(void))registerFootersBlock
                          constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock
                              actionBlock:(ZZCollectionViewCellActionBlock)actionBlock
                              scrollBlock:(ZZCollectionViewScrollActionBlock)scrollBlock {
    
    return [[self class] zz_quickAdd:backgroundColor
                              onView:onView
                               frame:frame
                     scrollDirection:UICollectionViewScrollDirectionVertical
                  registerCellsBlock:registerCellsBlock
                registerHeadersBlock:registerHeadersBlock
                registerFootersBlock:registerFootersBlock
                     constraintBlock:constraintBlock
                         actionBlock:actionBlock
                         scrollBlock:scrollBlock];
}

/**
 *  创建ZZCollectionView的方法
 */
+ (nonnull ZZCollectionView *)zz_quickAdd:(nullable UIColor *)backgroundColor
                                   onView:(nullable UIView *)onView
                                    frame:(CGRect)frame
                          scrollDirection:(UICollectionViewScrollDirection)scrollDirection
                       registerCellsBlock:(nullable NSArray *(^)(void))registerCellsBlock
                     registerHeadersBlock:(nullable NSArray *(^)(void))registerHeadersBlock
                     registerFootersBlock:(nullable NSArray *(^)(void))registerFootersBlock
                          constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock
                              actionBlock:(ZZCollectionViewCellActionBlock)actionBlock
                              scrollBlock:(ZZCollectionViewScrollActionBlock)scrollBlock {
    
    UICollectionViewFlowLayout *flowLayout = nil;
    if (scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }else {
        flowLayout = [[ZWHCollectionViewFlowWaterfallLayout alloc] init];
    }
    if (@available(iOS 9.0, *)) {
        flowLayout.sectionHeadersPinToVisibleBounds = YES;
    }
    ZZCollectionView *collectionView = [[ZZCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    collectionView.scrollDirection = scrollDirection;
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
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
        [[self class] registerWidgets:array collectionView:collectionView type:1];
    }
    
    if (registerHeadersBlock) {
        NSArray *array = registerHeadersBlock();
        [[self class] registerWidgets:array collectionView:collectionView type:2];
    }
    
    if (registerFootersBlock) {
        NSArray *array = registerFootersBlock();
        [[self class] registerWidgets:array collectionView:collectionView type:3];
    }
    // Default 0.01 Header & Footer
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
    collectionView.zzActionBlock = actionBlock;
    collectionView.zzScrollBlock = scrollBlock;
    collectionView.backgroundColor = backgroundColor;
    return collectionView;
}

+ (void)registerWidgets:(NSArray *)array collectionView:(UICollectionView *)collectionView type:(NSUInteger)type {
    
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
        if (type == 1) {
            [collectionView registerNib:nib forCellWithReuseIdentifier:cellClassName];
        }else if (type == 2) {
            [collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellClassName];
        }else if (type == 3) {
            [collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:cellClassName];
        }
    }
}

+ (NSString *)getCellName:(id)object {
    
    NSString *cellClassName = NSStringFromClass([object class]);
    cellClassName = [cellClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, cellClassName.length)];
    return cellClassName;
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

- (void)longPressToDrag:(UILongPressGestureRecognizer*)longp {
    
    if (self.zzDraggable == NO) {
        return;
    }
    
    CGPoint point = [longp locationInView:self];
    NSIndexPath *index = [self indexPathForItemAtPoint:point];
    ZZCollectionViewCell *cell = (ZZCollectionViewCell*)[self cellForItemAtIndexPath:index];
    switch (longp.state) {
        case UIGestureRecognizerStateBegan:
        {
            [UIView animateWithDuration:0.2 animations:^{
                cell.transform = CGAffineTransformMakeScale(1.3, 1.3);
            } completion:^(BOOL finished) {
            }];
            
            if (!index) {
                break;
            }
            
            BOOL canMove = NO;
            if (@available(iOS 9.0, *)) {
                canMove = [self beginInteractiveMovementForItemAtIndexPath:index];
            }
            if (!canMove) {
                break;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (@available(iOS 9.0, *)) {
                [self updateInteractiveMovementTargetPosition:point];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (@available(iOS 9.0, *)) {
                [self endInteractiveMovement];
            }
        }
            break;
        default:
        {
            if (@available(iOS 9.0, *)) {
                [self cancelInteractiveMovement];
            }
        }
            break;
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.zzDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:section];
    if (sectionObject == nil) {
        return 0;
    }
    return sectionObject.zzCellDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:indexPath.section];
    if (sectionObject == nil) {
        return nil;
    }
    ZZCollectionViewCellDataSource *ds = [sectionObject.zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
    NSString *cellClassName = [[self class] getCellName:ds];
    ZZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellClassName forIndexPath:indexPath];
    if (!cell) {
        NSBundle *bundle = [NSBundle zz_resourceClass:NSClassFromString(cellClassName) bundleName:nil];
        UINib *nib = [UINib nibWithNibName:cellClassName bundle:bundle];
        [collectionView registerNib:nib forCellWithReuseIdentifier:cellClassName];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellClassName forIndexPath:indexPath];
    }
    cell.zzData = ds;
    __weak ZZCollectionView *weakSelf = self;
    cell.zzTapBlock = ^(__kindof ZZCollectionViewCell * _Nonnull cell) {
        if (cell != nil && cell.zzData != nil) {
            __block NSIndexPath *_indexPath = [weakSelf indexPathForCell:cell];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.zzActionBlock == nil ? : weakSelf.zzActionBlock(weakSelf, _indexPath.section, _indexPath.row, ZZCollectionViewCellActionCustomTapped, cell.zzData, cell, nil, nil);
            });
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak ZZCollectionView *weakSelf = self;
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:indexPath.section];
    if (sectionObject == nil) {
        return;
    }
    ZZCollectionViewCellDataSource *data = [sectionObject.zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
    ZZCollectionViewCell *cell = (ZZCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell != nil && cell.zzData != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.zzActionBlock == nil ? : weakSelf.zzActionBlock(weakSelf, indexPath.section, indexPath.row, ZZCollectionViewCellActionTapped, data, cell, nil, nil);
        });
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.zzDraggable;
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    ZZCollectionSectionObject *sourceSection = [self.zzDataSource zz_arrayObjectAtIndex:sourceIndexPath.section];
    ZZCollectionViewCellDataSource *tmp = [sourceSection.zzCellDataSource zz_arrayObjectAtIndex:sourceIndexPath.row];
    [sourceSection.zzCellDataSource zz_arrayRemoveObjectAtIndex:sourceIndexPath.row];
    
    ZZCollectionSectionObject *destSection = [self.zzDataSource zz_arrayObjectAtIndex:destinationIndexPath.section];
    [destSection.zzCellDataSource zz_arrayInsertObject:tmp atIndex:destinationIndexPath.row];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:indexPath.section];
        if (sectionObject == nil) {
            return nil;
        }
        NSString *headCellName = [[self class] getCellName:sectionObject.zzHeaderData];
        if (headCellName.length > 0) {
            ZZCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headCellName forIndexPath:indexPath];
            if ([view respondsToSelector:@selector(setZzData:)]) {
                view.zzData = sectionObject.zzHeaderData;
                __weak ZZCollectionView *weakSelf = self;
                view.zzTapBlock = ^(__kindof ZZCollectionReusableView * _Nonnull reusableView) {
                    if (reusableView != nil && reusableView.zzData != nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.zzActionBlock == nil ? : weakSelf.zzActionBlock(weakSelf, 0, 0, ZZCollectionViewCellActionCustomTapped, nil, nil, reusableView.zzData, reusableView);
                        });
                    }
                };
            }
            return view;
        }else {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
            return view;
        }
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:indexPath.section];
        if (sectionObject == nil) {
            return nil;
        }
        NSString *headCellName = [[self class] getCellName:sectionObject.zzFooterData];
        if (headCellName.length > 0) {
            ZZCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:headCellName forIndexPath:indexPath];
            if ([view respondsToSelector:@selector(setZzData:)]) {
                view.zzData = sectionObject.zzFooterData;
                __weak ZZCollectionView *weakSelf = self;
                view.zzTapBlock = ^(__kindof ZZCollectionReusableView * _Nonnull reusableView) {
                    if (reusableView != nil && reusableView.zzData != nil) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.zzActionBlock == nil ? : weakSelf.zzActionBlock(weakSelf, 0, 0, ZZCollectionViewCellActionCustomTapped, nil, nil, reusableView.zzData, reusableView);
                        });
                    }
                };
            }
            return view;
        }else {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot" forIndexPath:indexPath];
            return view;
        }
    }
    return nil;
}

#pragma mark - ZWHCollectionViewFlowWaterfallLayoutDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnNumberAtSection:(NSInteger)section {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:section];
    if (sectionObject == nil) {
        return 0;
    }
    return sectionObject.zzColumns;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:indexPath.section];
    if (sectionObject == nil) {
        return CGSizeZero;
    }
    ZZCollectionViewCellDataSource *ds = [sectionObject.zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake((self.frame.size.width - sectionObject.zzEdgeInsets.left - sectionObject.zzEdgeInsets.right - (sectionObject.zzColumns - 1) * sectionObject.zzMinimumInteritemSpacing) / sectionObject.zzColumns, ds.zzSize.height);
    }else {
        return CGSizeMake(ds.zzSize.width, self.frame.size.height - sectionObject.zzEdgeInsets.top - sectionObject.zzEdgeInsets.bottom);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:section];
    if (sectionObject == nil) {
        return UIEdgeInsetsZero;
    }
    return sectionObject.zzEdgeInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:section];
    if (sectionObject == nil) {
        return 0;
    }
    return sectionObject.zzMinimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:section];
    if (sectionObject == nil) {
        return 0;
    }
    return sectionObject.zzMinimumInteritemSpacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:section];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (sectionObject.zzHeaderData) {
            return CGSizeMake(self.frame.size.width, sectionObject.zzHeaderData.zzSize.height);
        }
        return CGSizeMake(self.frame.size.width, 0.01);
    }else {
        if (sectionObject.zzHeaderData) {
            return CGSizeMake(sectionObject.zzHeaderData.zzSize.width, self.frame.size.height);
        }
        return CGSizeMake(0.01, self.frame.size.height);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    ZZCollectionSectionObject *sectionObject = [self.zzDataSource zz_arrayObjectAtIndex:section];
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        if (sectionObject.zzFooterData) {
            return CGSizeMake(self.frame.size.width, sectionObject.zzFooterData.zzSize.height);
        }
        return CGSizeMake(self.frame.size.width, 0.01);
    }else {
        if (sectionObject.zzFooterData) {
            return CGSizeMake(sectionObject.zzFooterData.zzSize.width, self.frame.size.height);
        }
        return CGSizeMake(0.01, self.frame.size.height);
    }
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

- (void)zz_reloadSelf {
    
    UICollectionView *collectionView = [self zz_findView:[UICollectionView class]];
    NSIndexPath *indexPath = [collectionView indexPathForCell:self];
    if (indexPath) {
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }
}

@end

#pragma mark - ZZCollectionViewCellDataSource

@implementation ZZCollectionViewCellDataSource : NSObject

@end

#pragma mark - ZZCollectionReusableView

@implementation ZZCollectionReusableView

@end

#pragma mark - ZZCollectionReusableViewDataSource

@implementation ZZCollectionReusableViewDataSource

@end


