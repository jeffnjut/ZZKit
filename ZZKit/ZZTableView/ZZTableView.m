//
//  ZZTableView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/14.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZTableView.h"
#import <pthread.h>
#import "NSArray+ZZKit.h"
#import "NSBundle+ZZKit.h"

#pragma mark - ZZTableView类

@interface ZZTableView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
{
    @private
    // 锁
    pthread_mutex_t _lock;
    // 数据源
    NSMutableArray *_dataSource;
    // 是否Section数据
    BOOL _sectionEnabled;
}

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
        case ZZTableViewCellEditingStyleMove:
        {
            self.editing = YES;
            break;
        }
        case ZZTableViewCellEditingStyleMultiSelect:
        {
            self.allowsMultipleSelection = YES;
            self.editing = YES;
            break;
        }
        case ZZTableViewCellEditingStyleDirectDelete:
        case ZZTableViewCellEditingStyleDirectDeleteConfirm:
        {
            self.editing = YES;
            break;
        }
        case ZZTableViewCellEditingStyleSlidingDelete:
        case ZZTableViewCellEditingStyleSlidingDeleteConfirm:
        case ZZTableViewCellEditingStyleLongPressDelete:
        case ZZTableViewCellEditingStyleLongPressDeleteConfirm:
        {
            self.editing = NO;
            break;
        }
        default:
            self.editing = NO;
            break;
    }
}

#pragma mark - 初始化函数

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

/**
 *  创建ZZTableView的方法
 */
+ (nonnull ZZTableView *)zz_quickAdd:(ZZTableViewCellEditingStyle)editingStyle backgroundColor:(nullable UIColor *)backgroundColor onView:(nullable UIView *)onView frame:(CGRect)frame constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock actionBlock:(ZZTableViewCellActionBlock)actionBlock {
    
    ZZTableView *tableView = [[ZZTableView alloc] initWithFrame:frame];
    tableView.zzTableViewCellEditingStyle = editingStyle;
    tableView.zzActionBlock = actionBlock;
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
    [_dataSource zz_arrayAddObject:data];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_insertDataSource:(nonnull id)anObject atIndex:(NSUInteger)index {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_dataSource zz_arrayInsertObject:anObject atIndex:index];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeDataSource:(nonnull id)data {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_dataSource zz_arrayRemoveObject:data];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeDataSourceObjectAtIndex:(NSInteger)index {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_dataSource zz_arrayRemoveObjectAtIndex:index];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeFirstDataSource {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_dataSource zz_arrayRemoveFirstObject];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeLastDataSource {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_dataSource zz_arrayRemoveLastObject];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_removeAllDataSource {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_dataSource removeAllObjects];
    pthread_mutex_unlock(&_lock);
}

- (void)zz_replaceDataSourceAtIndex:(NSUInteger)index withObject:(nonnull id)data {
    
    pthread_mutex_lock(&_lock);
    self.scrollEnabled = NO;
    [_dataSource zz_arrayReplaceObjectAtIndex:index withObject:data];
    pthread_mutex_unlock(&_lock);
}

/**
 *  TableView安全加载刷新Data
 */
- (void)zz_refresh {
    
    pthread_mutex_lock(&_lock);
    if ([_dataSource zz_arrayContainsClassType:[ZZTableSectionObject class]]) {
        _sectionEnabled = YES;
    }else {
        _sectionEnabled = NO;
    }
    [self reloadData];
    self.scrollEnabled = YES;
    pthread_mutex_unlock(&_lock);
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_sectionEnabled) {
        return _dataSource.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_sectionEnabled) {
        return ((ZZTableSectionObject *)_dataSource[section]).cellDataSource.count;
    }else {
        return _dataSource.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZTableViewCellDataSource *cellData = nil;
    if (_sectionEnabled) {
        cellData = [((ZZTableSectionObject *)_dataSource[indexPath.section]).cellDataSource zz_arrayObjectAtIndex:indexPath.row];
    }else {
        cellData = _dataSource[indexPath.row];
    }
    return cellData.zzHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_sectionEnabled) {
        ZZTableViewHeaderFooterViewDataSource *headerData = ((ZZTableSectionObject *)_dataSource[section]).headerDataSource;
        return headerData.zzHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (_sectionEnabled) {
        ZZTableViewHeaderFooterViewDataSource *footerData = ((ZZTableSectionObject *)_dataSource[section]).footerDataSource;
        return footerData.zzHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZTableViewCellDataSource *cellData = nil;
    if (_sectionEnabled) {
        cellData = [((ZZTableSectionObject *)_dataSource[indexPath.section]).cellDataSource zz_arrayObjectAtIndex:indexPath.row];
    }else {
        cellData = _dataSource[indexPath.row];
    }
    if (!cellData) {
        return nil;
    }
    NSString *cellClassName = [NSString stringWithUTF8String:object_getClassName(cellData)];
    cellClassName = [cellClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, cellClassName.length)];
    ZZTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    if (!cell) {
        NSBundle *bundle = [NSBundle zz_resourceClass:[cellData class] bundleName:nil];
        [tableView registerNib:[UINib nibWithNibName:cellClassName bundle:bundle] forCellReuseIdentifier:cellClassName];
        cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
        if (self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleMultiSelect) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [UIColor blackColor];
        }else if (cellData.zzUsingSelectionStyleNone) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else {
            /* 这种方式会导致其它UI的颜色设置全部失效 */
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        }
    }
    cell.zzData = cellData;
    if (cell.zzTapBlock == nil) {
        __weak ZZTableView *weakSelf = self;
        cell.zzTapBlock = ^(__kindof ZZTableViewCellDataSource * _Nonnull data, __kindof ZZTableViewCell * _Nonnull cell) {
            __strong ZZTableView *strongSelf = weakSelf;
            if (data != nil && cell != nil) {
                NSIndexPath *_indexPath = [strongSelf indexPathForCell:cell];
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.zzActionBlock == nil ? : strongSelf.zzActionBlock(strongSelf, _indexPath.section, _indexPath.row, ZZTableViewCellActionCustomeTapped, data, cell, nil, nil);
                });
            }
        };
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_sectionEnabled) {
        ZZTableSectionObject *sectionObject = _dataSource[section];
        ZZTableViewHeaderFooterViewDataSource *headerData = sectionObject.headerDataSource;
        if (headerData) {
            NSString *headerDataClassName = [NSString stringWithUTF8String:object_getClassName(headerData)];
            NSString *headerViewClassName = [headerDataClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
            headerViewClassName = [headerDataClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, headerDataClassName.length)];
            ZZTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewClassName];
            if (!headerView) {
                NSBundle *bundle = [NSBundle zz_resourceClass:[headerData class] bundleName:nil];
                [tableView registerNib:[UINib nibWithNibName:headerViewClassName bundle:bundle] forCellReuseIdentifier:headerViewClassName];
                headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewClassName];
            }
            headerView.zzData = headerData;
            if (headerView.zzTapBlock == nil) {
                __weak ZZTableView *weakSelf = self;
                headerView.zzTapBlock = ^(__kindof ZZTableViewHeaderFooterViewDataSource * _Nonnull data, __kindof ZZTableViewHeaderFooterView * _Nonnull view) {
                    __strong ZZTableView *strongSelf = weakSelf;
                    if (strongSelf->_sectionEnabled && data != nil && view != nil) {
                        for (NSUInteger i = 0; i < strongSelf->_dataSource.count; i++) {
                            ZZTableSectionObject *sectionObject = [strongSelf->_dataSource zz_arrayObjectAtIndex:i];
                            if (sectionObject.headerDataSource == nil) {
                                continue;
                            }
                            if (sectionObject.headerDataSource == data) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    strongSelf.zzActionBlock == nil ? : strongSelf.zzActionBlock(strongSelf, i, NSUIntegerMax, ZZTableViewCellActionCustomeTapped, nil, nil, data, view);
                                });
                                break;
                            }
                        }
                    }
                };
            }
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (_sectionEnabled) {
        ZZTableSectionObject *sectionObject = _dataSource[section];
        ZZTableViewHeaderFooterViewDataSource *footerData = sectionObject.footerDataSource;
        if (footerData) {
            NSString *footerDataClassName = [NSString stringWithUTF8String:object_getClassName(footerData)];
            NSString *footerViewClassName = [footerDataClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@""];
            footerViewClassName = [footerDataClassName stringByReplacingOccurrencesOfString:@"DataSource" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, footerDataClassName.length)];
            ZZTableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerViewClassName];
            if (!footerView) {
                NSBundle *bundle = [NSBundle zz_resourceClass:[footerData class] bundleName:nil];
                [tableView registerNib:[UINib nibWithNibName:footerViewClassName bundle:bundle] forCellReuseIdentifier:footerViewClassName];
                footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerViewClassName];
            }
            footerView.zzData = footerData;
            if (footerView.zzTapBlock == nil) {
                __weak ZZTableView *weakSelf = self;
                footerView.zzTapBlock = ^(__kindof ZZTableViewHeaderFooterViewDataSource * _Nonnull data, __kindof ZZTableViewHeaderFooterView * _Nonnull view) {
                    __strong ZZTableView *strongSelf = weakSelf;
                    if (strongSelf->_sectionEnabled && data != nil && view != nil) {
                        for (NSUInteger i = 0; i < strongSelf->_dataSource.count; i++) {
                            ZZTableSectionObject *sectionObject = [strongSelf->_dataSource zz_arrayObjectAtIndex:i];
                            if (sectionObject.footerDataSource == nil) {
                                continue;
                            }
                            if (sectionObject.footerDataSource == data) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    strongSelf.zzActionBlock == nil ? : strongSelf.zzActionBlock(strongSelf, i, NSUIntegerMax, ZZTableViewCellActionCustomeTapped, nil, nil, data, view);
                                });
                                break;
                            }
                        }
                    }
                };
            }
        }
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZTableViewCellDataSource *cellData = nil;
    if (_sectionEnabled) {
        cellData = [((ZZTableSectionObject *)_dataSource[indexPath.section]).cellDataSource zz_arrayObjectAtIndex:indexPath.row];
    }else {
        cellData = _dataSource[indexPath.row];
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
            cellData = [((ZZTableSectionObject *)_dataSource[indexPath.section]).cellDataSource zz_arrayObjectAtIndex:indexPath.row];
        }else {
            cellData = _dataSource[indexPath.row];
        }
        ZZTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cellData.zzSelected = NO;
        self.zzActionBlock == nil ? : self.zzActionBlock(self, indexPath.section, indexPath.row, ZZTableViewCellActionMultiSelect, cellData, cell, nil, nil);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
    ZZTableViewCellDataSource *cellData = nil;
    if (_sectionEnabled) {
        cellData = [((ZZTableSectionObject *)_dataSource[indexPath.section]).cellDataSource zz_arrayObjectAtIndex:indexPath.row];
    }else {
        cellData = _dataSource[indexPath.row];
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
    switch (self.zzTableViewCellEditingStyle) {
        case ZZTableViewCellEditingStyleNone:
        {
            return UITableViewCellEditingStyleNone;
        }
        case ZZTableViewCellEditingStyleInsert:
        {
            return UITableViewCellEditingStyleInsert;
        }
        case ZZTableViewCellEditingStyleMove:
        {
            return UITableViewCellEditingStyleNone;
        }
        case ZZTableViewCellEditingStyleMultiSelect:
        {
            return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
        }
        case ZZTableViewCellEditingStyleDirectDelete:
        case ZZTableViewCellEditingStyleDirectDeleteConfirm:
        {
            return UITableViewCellEditingStyleDelete;
        }
        case ZZTableViewCellEditingStyleSlidingDelete:
        case ZZTableViewCellEditingStyleSlidingDeleteConfirm:
        case ZZTableViewCellEditingStyleLongPressDelete:
        case ZZTableViewCellEditingStyleLongPressDeleteConfirm:
        {
            return UITableViewCellEditingStyleDelete;
        }
            default:
            return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    // 插入、删除操作的响应API
    // 当TableView的Cell的编辑风格为UITableViewCellEditingStyleDelete 或 UITableViewCellEditingStyleInsert时，响应事件
    __weak typeof(self) weakSelf = self;
    ZZTableViewCellDataSource *cellData = nil;
    if (_sectionEnabled) {
        cellData = [((ZZTableSectionObject *)_dataSource[indexPath.section]).cellDataSource zz_arrayObjectAtIndex:indexPath.row];
    }else {
        cellData = _dataSource[indexPath.row];
    }
    if (cellData) {
        ZZTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleInsert) {
            // 插入
            self.zzActionBlock == nil ? : self.zzActionBlock(self, indexPath.section, indexPath.row, ZZTableViewCellActionInsert, cellData, cell, nil, nil);
        }else if (self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleDirectDelete ||
                  self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleSlidingDelete ||
                  self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleLongPressDelete) {
            // 删除
            if (_sectionEnabled) {
                ZZTableSectionObject *sectionObject = [_dataSource zz_arrayObjectAtIndex:indexPath.section];
                [sectionObject.cellDataSource zz_arrayRemoveObjectAtIndex:indexPath.row];
            }else {
                [self zz_removeDataSourceObjectAtIndex:indexPath.row];
            }
            [self zz_refresh];
            self.zzActionBlock == nil ? : self.zzActionBlock(self, indexPath.section, indexPath.row, ZZTableViewCellActionInsert, cellData, cell, nil, nil);
        }else if (self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleDirectDeleteConfirm ||
                  self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleSlidingDeleteConfirm ||
                  self.zzTableViewCellEditingStyle == ZZTableViewCellEditingStyleLongPressDeleteConfirm) {
            // 确认后删除
            ZZTableViewVoidBlock _okAction = ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf->_sectionEnabled) {
                    ZZTableSectionObject *sectionObject = [strongSelf->_dataSource zz_arrayObjectAtIndex:indexPath.section];
                    [sectionObject.cellDataSource zz_arrayRemoveObjectAtIndex:indexPath.row];
                }else {
                    [strongSelf zz_removeDataSourceObjectAtIndex:indexPath.row];
                }
                [strongSelf zz_refresh];
                strongSelf.zzActionBlock == nil ? : strongSelf.zzActionBlock(strongSelf, indexPath.section, indexPath.row, ZZTableViewCellActionInsert, cellData, cell, nil, nil);
            };
            self.zzDeletionConfirmBlock == nil ? : self.zzDeletionConfirmBlock(_okAction);
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // TODO
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // TODO
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    // TODO
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    // TODO
    return 0;
}

#pragma mark - UIScrollView

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
        self.cellDataSource = (NSMutableArray<ZZTableViewCellDataSource *> *)[[NSMutableArray alloc] init];
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
