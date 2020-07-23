//
//  ZZTableView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/14.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZTableView.h"
#import <YYModel/YYModel.h>
#import <pthread.h>
#import "NSArray+ZZKit.h"
#import "NSBundle+ZZKit.h"
#import "UIView+ZZKit_Blocks.h"
#import "NSString+ZZKit.h"
#import "UIImage+ZZKit.h"
#import "ZZMacro.h"
#import "UIView+ZZKit.h"

#pragma mark - ZZTableView类

@interface ZZTableView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

// 锁
@property (nonatomic, assign) pthread_mutex_t lock;
// 数据源
@property (nonatomic, strong) NSMutableArray *zzDataSource;
// 是否Section数据
@property (nonatomic, assign) BOOL sectionEnabled;
// SuperView
@property (nonatomic, weak) UIView *superView;
// ResuableCells
@property (nonatomic, strong) NSMutableDictionary *resuableCells;

@end

@implementation ZZTableView

#pragma mark - 属性设置、获取

- (void)setZzTableViewCellEditingStyle:(ZZTableViewCellEditingStyle)zzTableViewCellEditingStyle {
    
    _zzTableViewCellEditingStyle = zzTableViewCellEditingStyle;
    switch (zzTableViewCellEditingStyle) {
        case ZZTableViewCellEditingStyleNone:
        {
            self.editing = NO;
            break;
        }
        case ZZTableViewCellEditingStyleInsert:
        {
            self.editing = YES;
            break;
        }
        case ZZTableViewCellEditingStyleMoveSystem:
        {
            self.editing = YES;
            break;
        }
        case ZZTableViewCellEditingStyleMoveDefault:
        case ZZTableViewCellEditingStyleMoveShaking:
        {
            self.editing = NO;
            break;
        }
        case ZZTableViewCellEditingStyleMultiSelect:
        {
            self.allowsMultipleSelection = YES;
            self.editing = YES;
            break;
        }
        case ZZTableViewCellEditingStyleSlidingDelete:
        case ZZTableViewCellEditingStyleLongPressDelete:
        {
            self.editing = NO;
            break;
        }
        default:
            self.editing = NO;
            break;
    }
    
    if (zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleLongPressDelete) {
        __weak ZZTableView *weakSelf = self;
        [self zz_longPress:1.0 block:^(UILongPressGestureRecognizer * _Nonnull longPressGesture, __kindof UIView * _Nonnull sender) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            ZZTableView *_tableView = (ZZTableView *)sender;
            if (![_tableView isKindOfClass:[ZZTableView class]]) {
                return;
            }
            CGPoint point = [longPressGesture locationInView:_tableView];
            NSIndexPath *_indexPath = [_tableView indexPathForRowAtPoint:point];
            ZZTableViewCell *_cell = [_tableView cellForRowAtIndexPath:_indexPath];
            ZZTableViewCellDataSource *_cellData = _cell.zzData;
            
            if (!_cellData.zzAllowEditing) {
                return;
            }
            
            // 确认后删除
            ZZTableViewVoidBlock _deleteAction = ^{
                if (strongSelf.sectionEnabled) {
                    ZZTableSectionObject *sectionObject = [strongSelf.zzDataSource zz_arrayObjectAtIndex:_indexPath.section];
                    [sectionObject.zzCellDataSource zz_arrayRemoveObjectAtIndex:_indexPath.row];
                }else {
                    [strongSelf zz_removeDataSourceObjectAtIndex:_indexPath.row];
                }
                [strongSelf zz_refresh];
                strongSelf.zzActionBlock == nil ? : strongSelf.zzActionBlock(strongSelf, _indexPath.section, _indexPath.row, ZZTableViewCellActionInsert, _cellData, _cell, nil, nil);
            };
            if (_cellData.zzDeletionConfirmBlock != nil) {
                _cellData.zzDeletionConfirmBlock(_deleteAction);
            }else if (strongSelf.zzDeletionConfirmBlock != nil) {
                strongSelf.zzDeletionConfirmBlock(_deleteAction);
            }
        }];
    }else {
        [self zz_removeLongPress];
    }
}

#pragma mark - 初始化函数

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _zzDataSource = [[NSMutableArray alloc] init];
        _zzTableViewSectionIndexTitleHeight = 0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.reusable = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _zzDataSource = [[NSMutableArray alloc] init];
        _zzTableViewSectionIndexTitleHeight = 0;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.reusable = YES;
    }
    return self;
}

/**
 *  创建ZZTableView的方法
 */
+ (nonnull ZZTableView *)zz_quickAdd:(ZZTableViewCellEditingStyle)editingStyle backgroundColor:(nullable UIColor *)backgroundColor onView:(nullable UIView *)onView frame:(CGRect)frame constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock actionBlock:(nullable ZZTableViewCellActionBlock)actionBlock {
    
    return [ZZTableView zz_quickAdd:editingStyle backgroundColor:backgroundColor onView:onView frame:frame constraintBlock:constraintBlock actionBlock:actionBlock scrollBlock:nil];
}

/**
 *  创建ZZTableView的方法（全）
 */
+ (nonnull ZZTableView *)zz_quickAdd:(ZZTableViewCellEditingStyle)editingStyle backgroundColor:(nullable UIColor *)backgroundColor onView:(nullable UIView *)onView frame:(CGRect)frame constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock actionBlock:(nullable ZZTableViewCellActionBlock)actionBlock scrollBlock:(nullable ZZTableViewScrollActionBlock)scrollBlock {
    
    ZZTableView *tableView = [[ZZTableView alloc] initWithFrame:frame];
    tableView.backgroundColor = backgroundColor;
    tableView.zzTableViewCellEditingStyle = editingStyle;
    tableView.zzActionBlock = actionBlock;
    tableView.zzScrollBlock = scrollBlock;
    tableView.delegate = tableView;
    tableView.dataSource = tableView;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.scrollsToTop = YES;
    tableView.estimatedRowHeight = 0;
    // 默认分割线贴边
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 8.0) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }else if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7.0) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if (onView != nil) {
        tableView.superView = onView;
        [onView addSubview:tableView];
        if (constraintBlock != nil) {
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                constraintBlock(onView, make);
            }];
        }
    }
    
    return tableView;
}

/**
 *  一组安全的操作datasource的方法
 */
- (void)zz_addDataSource:(nonnull id)data {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_zzDataSource zz_arrayAddObject:data];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_insertDataSource:(nonnull id)anObject atIndex:(NSUInteger)index {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_zzDataSource zz_arrayInsertObject:anObject atIndex:index];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeDataSource:(nonnull id)data {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_zzDataSource zz_arrayRemoveObject:data];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeDataSourceObjectAtIndex:(NSInteger)index {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_zzDataSource zz_arrayRemoveObjectAtIndex:index];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeFirstDataSource {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_zzDataSource zz_arrayRemoveFirstObject];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeLastDataSource {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_zzDataSource zz_arrayRemoveLastObject];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeAllDataSource {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_zzDataSource removeAllObjects];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_replaceDataSourceAtIndex:(NSUInteger)index withObject:(nonnull id)data {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_zzDataSource zz_arrayReplaceObjectAtIndex:index withObject:data];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_exchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2 {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_zzDataSource zz_arrayExchangeObjectAtIndex:index1 withObjectAtIndex:index2];
    pthread_mutex_unlock(&_lock);
}

/**
 *  TableView安全加载刷新Data
 */
- (void)zz_refresh {
    
    [self zz_refresh:YES];
}

/**
 *  TableView安全加载刷新Data(Scrollable)
 */
- (void)zz_refresh:(BOOL)scrollable {
    
    pthread_mutex_lock(&_lock);
    if ([_zzDataSource zz_arrayContainsClassType:[ZZTableSectionObject class]]) {
        _sectionEnabled = YES;
        for (ZZTableSectionObject *sectionObject in _zzDataSource) {
            if (![sectionObject isKindOfClass:[ZZTableSectionObject class]]) {
                NSAssert(NO, @"ZZTableView ## dataSource数据类型不一致");
                break;
            }
        }
    }else {
        _sectionEnabled = NO;
        for (ZZTableViewCellDataSource *ds in _zzDataSource) {
            if (![ds isKindOfClass:[ZZTableViewCellDataSource class]]) {
                NSAssert(NO, @"ZZTableView ## dataSource数据类型不一致");
                break;
            }
        }
    }
    [self reloadData];
    self.scrollEnabled = scrollable;
    [self.resuableCells removeAllObjects];
    pthread_mutex_unlock(&_lock);
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_sectionEnabled) {
        return _zzDataSource.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_sectionEnabled) {
        return ((ZZTableSectionObject *)_zzDataSource[section]).zzCellDataSource.count;
    }else {
        return _zzDataSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZTableViewCellDataSource *cellData = nil;
    if (_sectionEnabled) {
        cellData = [((ZZTableSectionObject *)_zzDataSource[indexPath.section]).zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
    }else {
        cellData = _zzDataSource[indexPath.row];
    }
    return cellData.zzHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_sectionEnabled) {
        ZZTableViewHeaderFooterViewDataSource *headerData = ((ZZTableSectionObject *)_zzDataSource[section]).zzHeaderDataSource;
        if (headerData == nil && self.zzTableViewSectionIndexesBlock != nil) {
            return self.zzTableViewSectionIndexTitleHeight;
        }
        return headerData.zzHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (_sectionEnabled) {
        ZZTableViewHeaderFooterViewDataSource *footerData = ((ZZTableSectionObject *)_zzDataSource[section]).zzFooterDataSource;
        return footerData.zzHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZTableViewCellDataSource *cellData = nil;
    if (_sectionEnabled) {
        cellData = [((ZZTableSectionObject *)_zzDataSource[indexPath.section]).zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
    }else {
        cellData = _zzDataSource[indexPath.row];
    }
    if (!cellData) {
        return nil;
    }
    NSString *cellClassName = [NSString stringWithUTF8String:object_getClassName(cellData)];
    cellClassName = [cellClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, cellClassName.length)];
    
    ZZTableViewCell *cell = nil;
    if (self.reusable) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
        if (!cell) {
            NSBundle *bundle = [NSBundle zz_resourceClass:[cellData class] bundleName:nil];
            if ([bundle pathForResource:cellClassName ofType:@"nib"] == nil) {
                [tableView registerClass:NSClassFromString(cellClassName) forCellReuseIdentifier:cellClassName];
                cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
            }else {
                [tableView registerNib:[UINib nibWithNibName:cellClassName bundle:bundle] forCellReuseIdentifier:cellClassName];
                cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
            }
        }
    }else {
        
        if (self.resuableCells == nil) {
            self.resuableCells = [[NSMutableDictionary alloc] init];
        }
        NSString *indexPathKey = [NSString stringWithFormat:@"%d-%d", (int)indexPath.section, (int)indexPath.row];
        cell = [self.resuableCells objectForKey:indexPathKey];
        // cellForRowAtIndexPath:返回nil
        // cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            NSBundle *bundle = [NSBundle zz_resourceClass:[cellData class] bundleName:nil];
            if ([bundle pathForResource:cellClassName ofType:@"nib"] == nil) {
                cell = [[NSClassFromString(cellClassName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
            }else {
                cell = [[bundle loadNibNamed:cellClassName owner:nil options:nil] lastObject];
            }
            [self.resuableCells setObject:cell forKey:indexPathKey];
        }
    }
    
    if (cellData.zzAllowEditing == NO) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        if (self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleMultiSelect) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            if (self.zzSelectedImage && self.zzUnselectedImage) {
                cell.zzSelectedImage = self.zzSelectedImage;
                cell.zzUnselectedImage = self.zzUnselectedImage;
            }
        }else if (cellData.zzUsingSelectionStyleNone) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else {
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        }
    }
    cell.zzData = cellData;
    if (cell.zzTapBlock == nil) {
        __weak ZZTableView *weakSelf = self;
        cell.zzTapBlock = ^(__kindof ZZTableViewCell * _Nonnull cell) {
            __strong ZZTableView *strongSelf = weakSelf;
            if (cell != nil && cell.zzData != nil) {
                NSIndexPath *_indexPath = [strongSelf indexPathForCell:cell];
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.zzActionBlock == nil ? : strongSelf.zzActionBlock(strongSelf, _indexPath.section, _indexPath.row, ZZTableViewCellActionCustomTapped, cell.zzData, cell, nil, nil);
                });
            }
        };
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_sectionEnabled) {
        ZZTableSectionObject *sectionObject = _zzDataSource[section];
        ZZTableViewHeaderFooterViewDataSource *headerData = sectionObject.zzHeaderDataSource;
        if (headerData) {
            NSString *headerDataClassName = [NSString stringWithUTF8String:object_getClassName(headerData)];
            NSString *headerViewClassName = [headerDataClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
            headerViewClassName = [headerDataClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, headerDataClassName.length)];
            ZZTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewClassName];
            if (!headerView) {
                NSBundle *bundle = [NSBundle zz_resourceClass:[headerData class] bundleName:nil];
                if ([bundle pathForResource:headerViewClassName ofType:@"nib"] == nil) {
                    [tableView registerClass:NSClassFromString(headerViewClassName) forHeaderFooterViewReuseIdentifier:headerViewClassName];
                    headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewClassName];
                }else {
                    [tableView registerNib:[UINib nibWithNibName:headerViewClassName bundle:bundle] forHeaderFooterViewReuseIdentifier:headerViewClassName];
                    headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewClassName];
                }
            }
            headerView.zzData = headerData;
            if (headerView.zzTapBlock == nil) {
                __weak ZZTableView *weakSelf = self;
                headerView.zzTapBlock = ^(__kindof ZZTableViewHeaderFooterView * _Nonnull view) {
                    __strong ZZTableView *strongSelf = weakSelf;
                    if (strongSelf.sectionEnabled && view != nil && view.zzData != nil) {
                        for (NSUInteger i = 0; i < strongSelf.zzDataSource.count; i++) {
                            ZZTableSectionObject *sectionObject = [strongSelf.zzDataSource zz_arrayObjectAtIndex:i];
                            if (sectionObject.zzHeaderDataSource == nil) {
                                continue;
                            }
                            if (sectionObject.zzHeaderDataSource == view.zzData) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    strongSelf.zzActionBlock == nil ? : strongSelf.zzActionBlock(strongSelf, i, NSUIntegerMax, ZZTableViewCellActionCustomTapped, nil, nil, view.zzData, view);
                                });
                                break;
                            }
                        }
                    }
                };
            }
            return headerView;
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (_sectionEnabled) {
        ZZTableSectionObject *sectionObject = _zzDataSource[section];
        ZZTableViewHeaderFooterViewDataSource *footerData = sectionObject.zzFooterDataSource;
        if (footerData) {
            NSString *footerDataClassName = [NSString stringWithUTF8String:object_getClassName(footerData)];
            NSString *footerViewClassName = [footerDataClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
            footerViewClassName = [footerDataClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, footerDataClassName.length)];
            ZZTableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerViewClassName];
            if (!footerView) {
                NSBundle *bundle = [NSBundle zz_resourceClass:[footerData class] bundleName:nil];
                if ([bundle pathForResource:footerViewClassName ofType:@"nib"] == nil) {
                    [tableView registerClass:NSClassFromString(footerViewClassName) forHeaderFooterViewReuseIdentifier:footerViewClassName];
                    footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerViewClassName];
                }else {
                    [tableView registerNib:[UINib nibWithNibName:footerViewClassName bundle:bundle] forHeaderFooterViewReuseIdentifier:footerViewClassName];
                    footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerViewClassName];
                }
            }
            footerView.zzData = footerData;
            if (footerView.zzTapBlock == nil) {
                __weak ZZTableView *weakSelf = self;
                footerView.zzTapBlock = ^(__kindof ZZTableViewHeaderFooterView * _Nonnull view) {
                    __strong ZZTableView *strongSelf = weakSelf;
                    if (strongSelf.sectionEnabled && view != nil && view.zzData != nil) {
                        for (NSUInteger i = 0; i < strongSelf.zzDataSource.count; i++) {
                            ZZTableSectionObject *sectionObject = [strongSelf.zzDataSource zz_arrayObjectAtIndex:i];
                            if (sectionObject.zzFooterDataSource == nil) {
                                continue;
                            }
                            if (sectionObject.zzFooterDataSource == view.zzData) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    strongSelf.zzActionBlock == nil ? : strongSelf.zzActionBlock(strongSelf, i, NSUIntegerMax, ZZTableViewCellActionCustomTapped, nil, nil, view.zzData, view);
                                });
                                break;
                            }
                        }
                    }
                };
            }
            return footerView;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZTableViewCellDataSource *cellData = nil;
    if (_sectionEnabled) {
        cellData = [((ZZTableSectionObject *)_zzDataSource[indexPath.section]).zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
    }else {
        cellData = _zzDataSource[indexPath.row];
    }
    ZZTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleMultiSelect) {
        // 多选操作
        cellData.zzSelected = YES;
        self.zzActionBlock == nil ? : self.zzActionBlock(self, indexPath.section, indexPath.row, ZZTableViewCellActionMultiSelect, cellData, cell, nil, nil);
    }else {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        // 其它
        self.zzActionBlock == nil ? : self.zzActionBlock(self, indexPath.section, indexPath.row, ZZTableViewCellActionTapped, cellData, cell, nil, nil);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleMultiSelect) {
        ZZTableViewCellDataSource *cellData = nil;
        if (_sectionEnabled) {
            cellData = [((ZZTableSectionObject *)_zzDataSource[indexPath.section]).zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
        }else {
            cellData = _zzDataSource[indexPath.row];
        }
        ZZTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cellData.zzSelected = NO;
        self.zzActionBlock == nil ? : self.zzActionBlock(self, indexPath.section, indexPath.row, ZZTableViewCellActionMultiSelect, cellData, cell, nil, nil);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZTableViewCellDataSource *cellData = nil;
    if (_sectionEnabled) {
        cellData = [((ZZTableSectionObject *)_zzDataSource[indexPath.section]).zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
    }else {
        cellData = _zzDataSource[indexPath.row];
    }
    if (cellData == nil) {
        return NO;
    }
    // 是否可以删除、插入和选择
    return self.zzTableViewCellEditingStyle != ZZTableViewCellEditingStyleNone && cellData.zzAllowEditing == YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /**
     * 删除风格:
     * UITableViewCellEditingStyleDelete （默认风格）  当tableView.editing=YES时，显示删除  /  当tableView.editing=NO时，隐藏删除，滑动出现  ||| 相应方法：commitEditingStyle
     
     * 插入风格:
     * UITableViewCellEditingStyleInsert  当tableView.editing=YES生效  ||| 相应方法：commitEditingStyle
     
     * 无风格:
     * UITableViewCellEditingStyleNone
     
     * 多组选中风格:
     * UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete  ||| 相应方法：didSelectRowAtIndexPath
     */
    ZZTableViewCellDataSource *cellData = nil;
    if (_sectionEnabled) {
        cellData = [((ZZTableSectionObject *)_zzDataSource[indexPath.section]).zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
    }else {
        cellData = _zzDataSource[indexPath.row];
    }
    if (cellData.zzAllowEditing) {
        switch (self.zzTableViewCellEditingStyle) {
            case ZZTableViewCellEditingStyleNone:
            {
                return UITableViewCellEditingStyleNone;
            }
            case ZZTableViewCellEditingStyleInsert:
            {
                return UITableViewCellEditingStyleInsert;
            }
            case ZZTableViewCellEditingStyleMoveSystem:
            case ZZTableViewCellEditingStyleMoveDefault:
            case ZZTableViewCellEditingStyleMoveShaking:
            {
                return UITableViewCellEditingStyleNone;
            }
            case ZZTableViewCellEditingStyleMultiSelect:
            {
                return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
            }
            case ZZTableViewCellEditingStyleSlidingDelete:
            case ZZTableViewCellEditingStyleLongPressDelete:
            {
                return UITableViewCellEditingStyleDelete;
            }
            default:
                return UITableViewCellEditingStyleNone;
        }
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 插入、删除操作的响应API
    // 当TableView的Cell的编辑风格为UITableViewCellEditingStyleDelete 或 UITableViewCellEditingStyleInsert时，响应事件
    __weak typeof(self) weakSelf = self;
    ZZTableViewCellDataSource *cellData = nil;
    if (_sectionEnabled) {
        cellData = [((ZZTableSectionObject *)_zzDataSource[indexPath.section]).zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
    }else {
        cellData = _zzDataSource[indexPath.row];
    }
    if (cellData) {
        ZZTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleInsert) {
            // 插入
            self.zzActionBlock == nil ? : self.zzActionBlock(self, indexPath.section, indexPath.row, ZZTableViewCellActionInsert, cellData, cell, nil, nil);
        }else if (self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleSlidingDelete ||
                  self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleLongPressDelete) {
            // 确认后删除
            ZZTableViewVoidBlock _deleteAction = ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf.sectionEnabled) {
                    ZZTableSectionObject *sectionObject = [strongSelf.zzDataSource zz_arrayObjectAtIndex:indexPath.section];
                    [sectionObject.zzCellDataSource zz_arrayRemoveObjectAtIndex:indexPath.row];
                }else {
                    [strongSelf zz_removeDataSourceObjectAtIndex:indexPath.row];
                }
                [strongSelf zz_refresh];
                strongSelf.zzActionBlock == nil ? : strongSelf.zzActionBlock(strongSelf, indexPath.section, indexPath.row, ZZTableViewCellActionDelete, cellData, cell, nil, nil);
            };
            if (cellData.zzDeletionConfirmBlock != nil) {
                cellData.zzDeletionConfirmBlock(_deleteAction);
            }else if (self.zzDeletionConfirmBlock != nil) {
                self.zzDeletionConfirmBlock(_deleteAction);
            }else {
                _deleteAction();
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleMoveSystem) {
        ZZTableViewCellDataSource *cellData = nil;
        if (_sectionEnabled) {
            cellData = [((ZZTableSectionObject *)_zzDataSource[indexPath.section]).zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
        }else {
            cellData = _zzDataSource[indexPath.row];
        }
        return cellData.zzAllowEditing;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // 移动交换数据源
    if (_sectionEnabled) {
        ZZTableSectionObject *section1 = _zzDataSource[sourceIndexPath.section];
        ZZTableSectionObject *section2 = _zzDataSource[destinationIndexPath.section];
        ZZTableViewCellDataSource *ds = [section1.zzCellDataSource zz_arrayObjectAtIndex:sourceIndexPath.row];
        [section1.zzCellDataSource zz_arrayRemoveObjectAtIndex:sourceIndexPath.row];
        [section2.zzCellDataSource zz_arrayInsertObject:ds atIndex:destinationIndexPath.row];
    }else {
        pthread_mutex_lock(&_lock);
        ZZTableViewCellDataSource *ds = _zzDataSource[sourceIndexPath.row];
        [_zzDataSource zz_arrayRemoveObjectAtIndex:sourceIndexPath.row];
        [_zzDataSource zz_arrayInsertObject:ds atIndex:destinationIndexPath.row];
        pthread_mutex_unlock(&_lock);
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    return self.zzTableViewSectionIndexesBlock == nil ? nil : self.zzTableViewSectionIndexesBlock(self);
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    return self.zzTableViewSectionIndexBlock == nil ? 0 : self.zzTableViewSectionIndexBlock(self, title, index);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.zzTableViewSectionIndexTitleBlock == nil ? nil : self.zzTableViewSectionIndexTitleBlock(self, section);
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleSlidingDelete) {
        ZZTableViewCellDataSource *cellData = nil;
        if (_sectionEnabled) {
            cellData = [((ZZTableSectionObject *)_zzDataSource[indexPath.section]).zzCellDataSource zz_arrayObjectAtIndex:indexPath.row];
        }else {
            cellData = _zzDataSource[indexPath.row];
        }
        
        if (cellData.zzAllowEditing == NO || (cellData && cellData.zzCustomSwipes && cellData.zzCustomSwipes.count == 0)) {
            return nil;
        }
        
        NSArray *_customSwipes = cellData.zzCustomSwipes;
        if (!_customSwipes) {
            _customSwipes = self.zzCustomSwipes;
        }
        if (_customSwipes) {
            __weak ZZTableView *weakSelf = self;
            ZZTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in _customSwipes) {
                NSString *text = [dict objectForKey:kZZCellSwipeText];
                // UIColor *color = [dict objectForKey:kZZCellSwipeTextColor];
                // UIFont *font = [dict objectForKey:kZZCellSwipeTextFont];
                UIColor *backgroundColor = [dict objectForKey:kZZCellSwipeBackgroundColor];
                __block ZZTableViewDeleteConfirmBlock block = [dict objectForKey:kZZCellSwipeAction];
                // 确认后删除
                __block ZZTableViewVoidBlock _deleteAction = ^{
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    if (strongSelf.sectionEnabled) {
                        ZZTableSectionObject *sectionObject = [strongSelf.zzDataSource zz_arrayObjectAtIndex:indexPath.section];
                        [sectionObject.zzCellDataSource zz_arrayRemoveObjectAtIndex:indexPath.row];
                    }else {
                        [strongSelf zz_removeDataSourceObjectAtIndex:indexPath.row];
                    }
                    [strongSelf zz_refresh];
                    strongSelf.zzActionBlock == nil ? : strongSelf.zzActionBlock(strongSelf, indexPath.section, indexPath.row, ZZTableViewCellActionInsert, cellData, cell, nil, nil);
                };
                UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                                  title:text
                                                                                handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                    // 这句很重要，退出编辑模式，隐藏左滑菜单
                                                                                    [tableView setEditing:NO animated:YES];
                                                                                    block == nil ? : block(_deleteAction);
                                                                                }];
                
                action.backgroundColor = backgroundColor;
                [array zz_arrayAddObject:action];
            }
            return array;
        }
    }
    return nil;
}

// 处理Cell间的分割线偏移的问题
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - UIScrollView

// any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZTableViewScrollActionDidScroll, CGPointZero, CGPointZero, NO);
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZTableViewScrollActionWillBeginDragging, CGPointZero, CGPointZero, NO);
}

// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0) {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZTableViewScrollActionWillEndDragging, velocity, CGPointMake(targetContentOffset->x, targetContentOffset->y), NO);
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZTableViewScrollActionDidEndDragging, CGPointZero, CGPointZero, decelerate);
}

// called on finger up as we are moving
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZTableViewScrollActionWillBeginDecelerating, CGPointZero, CGPointZero, NO);
}

// called when scroll view grinds to a halt
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZTableViewScrollActionDidEndDecelerating, CGPointZero, CGPointZero, NO);
}

// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZTableViewScrollActionDidEndScrollingAnimation, CGPointZero, CGPointZero, NO);
}

// called when scrolling animation finished. may be called immediately if already at top
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    self.zzScrollBlock == nil ? : self.zzScrollBlock(self, ZZTableViewScrollActionDidScrollToTop, CGPointZero, CGPointZero, NO);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

#pragma mark - ZZTableSectionObject类

@implementation ZZTableSectionObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.zzCellDataSource = (NSMutableArray<ZZTableViewCellDataSource *> *)[[NSMutableArray alloc] init];
    }
    return self;
}

@end

#pragma mark - ZZTableViewCell类

@implementation ZZTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews {
    
    if (self.zzSelectedImage && self.zzUnselectedImage) {
        for (UIControl *control in self.subviews){
            if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                for (UIView *v in control.subviews)
                {
                    if ([v isKindOfClass: [UIImageView class]]) {
                        UIImageView *img = (UIImageView *)v;
                        if (self.selected) {
                            img.image = self.zzSelectedImage;
                        }else {
                            img.image = self.zzUnselectedImage;
                        }
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    if (self.zzSelectedImage && self.zzUnselectedImage) {
        for (UIControl *control in self.subviews){
            if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                for (UIView *v in control.subviews) {
                    if ([v isKindOfClass: [UIImageView class]]) {
                        UIImageView *img=(UIImageView *)v;
                        if (!self.selected) {
                            img.image = self.zzUnselectedImage;
                        }
                    }
                }
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    // UITableViewCell多选状态多出分割线（分割线偏移）解决方案
    for (UIView *view in self.subviews) {
        if ([@"_UITableViewCellSeparatorView" isEqualToString:NSStringFromClass([view class])]) {
            if (view.frame.origin.x > 0) {
                //多余分割线
                view.hidden = YES;
            }
        }
    }
    [super setSelected:selected animated:animated];
}

- (void)zz_reloadSelf {
    
    UITableView *tableView = [self zz_findView:[UITableView class]];
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    if (indexPath) {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end

@implementation ZZTableViewCellDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.zzUsingSelectionStyleNone = YES;
        self.zzAllowEditing = YES;
        self.zzHeight = 0;
    }
    return self;
}

@end

#pragma mark - ZZTableViewHeaderFooterView类

@implementation ZZTableViewHeaderFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

@implementation ZZTableViewHeaderFooterViewDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.zzHeight = 0;
    }
    return self;
}

@end
