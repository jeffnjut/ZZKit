//
//  ZZTableView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/14.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

@class ZZTableSectionObject,ZZTableViewCell,ZZTableViewCellDataSource,ZZTableViewHeaderFooterView,ZZTableViewHeaderFooterViewDataSource,ZZTableView;

#pragma mark - 类型定义

// 自定义按钮左滑功能键的常量
#define kZZCellSwipeText            @"kZZCellSwipeText"
#define kZZCellSwipeBackgroundColor @"kZZCellSwipeBackgroundColor"
#define kZZCellSwipeAction          @"kZZCellSwipeAction"
// #define kZZCellSwipeTextColor       @"kZZCellSwipeTextColor"  // (暂不支持)
// #define kZZCellSwipeTextFont        @"kZZCellSwipeTextColor"  // (暂不支持)

// 定义EditingCellType
typedef NS_ENUM(NSInteger, ZZTableViewCellEditingStyle) {
    ZZTableViewCellEditingStyleNone,                    // 没有Cell编辑式样
    ZZTableViewCellEditingStyleInsert,                  // 插入Cell（系统）
    ZZTableViewCellEditingStyleMoveSystem,              // 移动Cell（系统）
    ZZTableViewCellEditingStyleMoveDefault,             // 移动Cell（默认无动画）   TODO
    ZZTableViewCellEditingStyleMoveShaking,             // 移动Cell（默认无动画）   TODO
    ZZTableViewCellEditingStyleMultiSelect,             // 多选Cell
    ZZTableViewCellEditingStyleSlidingDelete,           // 滑动删除Cell，有确认
    ZZTableViewCellEditingStyleLongPressDelete          // 长按删除Cell，有确认
};

// 定义Cell事件类型
typedef NS_ENUM(NSInteger, ZZTableViewCellAction) {
    ZZTableViewCellActionTapped,          // 点击Cell
    ZZTableViewCellActionCustomTapped,    // 点击Cell上自定义事件（按钮或其它部件的事件监听）
    ZZTableViewCellActionInsert,          // 插入Cell
    ZZTableViewCellActionMultiSelect,     // 多选Cell
    ZZTableViewCellActionDelete,          // 删除Cell
};

// ZZTableView Void Block定义
typedef void (^ZZTableViewVoidBlock)(void);

// 点击Cell Block定义
typedef void (^ZZTableViewCellActionBlock)(__weak ZZTableView * _Nonnull tableView,
                                           NSInteger section,
                                           NSInteger row,
                                           ZZTableViewCellAction action,
                                           __kindof ZZTableViewCellDataSource * _Nullable cellData,
                                           __kindof ZZTableViewCell * _Nullable cell,
                                           __kindof ZZTableViewHeaderFooterViewDataSource * _Nullable headerFooterData,
                                           __kindof ZZTableViewHeaderFooterView * _Nullable headerFooterView);

// 移动Cell Block定义
typedef void (^ZZTableViewCellMoveBlock)(__weak ZZTableView * _Nonnull tableView,
                                         NSIndexPath * _Nonnull fromIndex,
                                         NSIndexPath * _Nonnull toIndex,
                                         __kindof ZZTableViewCellDataSource * _Nonnull fromCellData,
                                         __kindof ZZTableViewCell * _Nonnull fromCell,
                                         __kindof ZZTableViewCellDataSource * _Nonnull toCellData,
                                         __kindof ZZTableViewCell * _Nonnull toCell);

// UITableViewCell Indexes Block定义
// 设置Indexes数组，return list of section titles to display in section index view (e.g. "ABCD...Z#")
typedef NSArray* _Nonnull (^ZZTableViewSectionIndexesBlock)(__weak ZZTableView * _Nonnull tableView);

// UITableViewCell Index Block定义
// 设置点击Index返回Section位置，tell table which section corresponds to section title/index (e.g. "B",1))
typedef NSUInteger (^ZZTableViewSectionIndexBlock)(__weak ZZTableView * _Nonnull tableView, NSString * _Nonnull title, NSUInteger index);

// UITableViewCell Index Title Block定义
// 设置返回Section的Title
typedef NSString * _Nonnull (^ZZTableViewSectionIndexTitleBlock)(__weak ZZTableView * _Nonnull tableView, NSUInteger section);

// 删除Cell的Block定义
typedef void (^ZZTableViewDeleteConfirmBlock)(ZZTableViewVoidBlock _Nonnull deleteAction);

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ZZTableView类

@interface ZZTableView : UITableView

/**
 *  ZZTableViewCellEditingStyleNone                     editing = YES, UITableViewCellEditingStyleNone
 *  ZZTableViewCellEditingStyleInsert                   editing = YES, UITableViewCellEditingStyleInsert
 *  ZZTableViewCellEditingStyleMove                     editing = YES, UITableViewCellEditingStyleNone
 *  ZZTableViewCellEditingStyleMultiSelect              editing = YES, UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete
 *  ZZTableViewCellEditingStyleSlidingDelete
 *  ZZTableViewCellEditingStyleLongPressDelete          editing = NO, UITableViewCellEditingStyleDelete
 */
@property (nonatomic, assign) ZZTableViewCellEditingStyle zzTableViewCellEditingStyle;

// TableView IndexesBlock 返回索引数字
@property (nonatomic, copy) ZZTableViewSectionIndexesBlock zzTableViewSectionIndexesBlock;

// TableView IndexBlock 快速索引条对应关系
@property (nonatomic, copy) ZZTableViewSectionIndexBlock zzTableViewSectionIndexBlock;

// TableView Index Title Block返回Section对应的Title
@property (nonatomic, copy) ZZTableViewSectionIndexTitleBlock zzTableViewSectionIndexTitleBlock;

// Cell 响应事件Block
@property (nonatomic, copy) ZZTableViewCellActionBlock zzActionBlock;

// Cell 删除确认Block
@property (nonatomic, copy) ZZTableViewDeleteConfirmBlock zzDeletionConfirmBlock;

// Cell 左滑自定义按钮，
// 当设置了ZZTableView的zzCustomSwipes Block,ZZTableView的zzDeletionConfirmBlock失效
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> *zzCustomSwipes;

// Cell 多选选中Selected状态图标
@property (nonatomic, strong) UIImage *zzSelectedImage;

// Cell 多选未选中Selected状态图标
@property (nonatomic, strong) UIImage *zzUnselectedImage;

// TableView Index Title Section对应的Title高度
@property (nonatomic, assign) CGFloat zzTableViewSectionIndexTitleHeight;

/**
 *  创建ZZTableView的方法
 */
+ (nonnull ZZTableView *)zz_quickAdd:(ZZTableViewCellEditingStyle)editingStyle backgroundColor:(nullable UIColor *)backgroundColor onView:(nullable UIView *)onView frame:(CGRect)frame constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock actionBlock:(ZZTableViewCellActionBlock)actionBlock;

/**
 *  一组安全的操作datasource的方法
 */
- (void)zz_addDataSource:(nonnull id)data;
- (void)zz_insertDataSource:(nonnull id)anObject atIndex:(NSUInteger)index;
- (void)zz_removeDataSource:(nonnull id)data;
- (void)zz_removeDataSourceObjectAtIndex:(NSInteger)index;
- (void)zz_removeFirstDataSource;
- (void)zz_removeLastDataSource;
- (void)zz_removeAllDataSource;
- (void)zz_replaceDataSourceAtIndex:(NSUInteger)index withObject:(nonnull id)data;
- (void)zz_exchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2;

/**
 *  TableView安全加载刷新Data
 */
- (void)zz_refresh;

@end

#pragma mark - ZZTableSectionObject类

@interface ZZTableSectionObject : NSObject

@property (nonatomic, strong) ZZTableViewHeaderFooterViewDataSource *zzHeaderDataSource;
@property (nonatomic, strong) ZZTableViewHeaderFooterViewDataSource *zzFooterDataSource;
@property (nonatomic, strong) NSMutableArray<ZZTableViewCellDataSource *> *zzCellDataSource;

@end

#pragma mark - ZZTableViewCell类

@interface ZZTableViewCell : UITableViewCell

// 数据
@property (nonatomic, strong) __kindof ZZTableViewCellDataSource *zzData;

// 用户自定义点击Block
@property (nonatomic, copy) void(^zzTapBlock)(__kindof ZZTableViewCellDataSource * _Nonnull data, __kindof ZZTableViewCell * _Nonnull cell);

// Cell 多选选中Selected状态图标
@property (nonatomic, strong) UIImage *zzSelectedImage;

// Cell 多选未选中Selected状态图标
@property (nonatomic, strong) UIImage *zzUnselectedImage;

@end

@interface ZZTableViewCellDataSource : NSObject

// 用户自定义式样
@property (nonatomic, assign) BOOL zzUsingSelectionStyleNone;

// 高度
@property (nonatomic, assign) CGFloat zzHeight;

// 多选的选中状态
@property (nonatomic, assign) BOOL zzSelected;

// 支持删除操作
@property (nonatomic, assign) BOOL zzAllowEditing;

// Cell 删除确认Block
@property (nonatomic, copy) ZZTableViewDeleteConfirmBlock zzDeletionConfirmBlock;

// Cell 左滑自定义按钮
// 当设置了ZZTableViewCell的zzCustomSwipes Block,将覆盖ZZTableView的zzCustomSwipes，
// 并且ZZTableView的zzDeletionConfirmBlock失效
@property (nonatomic, strong) NSArray<NSDictionary<NSString *, id> *> *zzCustomSwipes;

@end

#pragma mark - ZZTableViewHeaderFooterView类

@interface ZZTableViewHeaderFooterView : UITableViewHeaderFooterView

// 数据
@property (nonatomic, strong) ZZTableViewHeaderFooterViewDataSource *zzData;

// 用户自定义点击Block
@property (nonatomic, copy) void(^zzTapBlock)(__kindof ZZTableViewHeaderFooterViewDataSource * _Nonnull data, __kindof ZZTableViewHeaderFooterView * _Nonnull view);

@end

@interface ZZTableViewHeaderFooterViewDataSource : NSObject

// 高度
@property (nonatomic, assign) CGFloat zzHeight;

@end

NS_ASSUME_NONNULL_END
