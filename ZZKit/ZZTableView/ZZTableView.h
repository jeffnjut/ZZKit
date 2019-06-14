//
//  ZZTableView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/14.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTableViewCell,ZZTableViewCellDataSource,ZZTableViewHeaderFooterView,ZZTableViewHeaderFooterViewDataSource,ZZTableView;

#pragma mark - 类型定义

typedef NS_ENUM(NSInteger, ZZTableViewCellEditingStyle) {
    ZZTableViewCellEditingStyleNone,                    // 没有Cell编辑式样
    ZZTableViewCellEditingStyleInsert,                  // 插入Cell
    ZZTableViewCellEditingStyleMove,                    // 移动Cell
    ZZTableViewCellEditingStyleMultiSelect,             // 多选Cell
    ZZTableViewCellEditingStyleDirectDelete,            // 调用方法显示删除
    ZZTableViewCellEditingStyleDirectDeleteConfirm,     // 调用方法显示删除，有确认
    ZZTableViewCellEditingStyleSlidingDelete,           // 滑动删除Cell
    ZZTableViewCellEditingStyleSlidingDeleteConfirm,    // 滑动删除Cell，有确认
    ZZTableViewCellEditingStyleLongPressDelete,         // 长按删除Cell
    ZZTableViewCellEditingStyleLongPressDeleteConfirm   // 长按删除Cell，有确认
};

typedef NS_ENUM(NSInteger, ZZTableViewCellAction) {
    ZZTableViewCellActionTapped,          // 点击Cell
    ZZTableViewCellActionCustomeTapped,   // 点击Cell上自定义事件（按钮或其它部件的事件监听）
    ZZTableViewCellActionInsert,          // 插入Cell
    ZZTableViewCellActionMultiSelect,     // 多选Cell
    ZZTableViewCellActionDelete,          // 删除Cell
    ZZTableViewCellActionDeleteConfirm    // 删除Cell，有确认
};

// 点击Cell Block定义
typedef void (^ZZTableViewCellActionBlock)(__weak ZZTableView * _Nonnull tableView, NSInteger section, NSInteger row, ZZTableViewCellAction action,  __kindof ZZTableViewCellDataSource * _Nullable cellData, __kindof ZZTableViewCell * _Nullable cell, __kindof ZZTableViewHeaderFooterViewDataSource * _Nullable headerFooterData, __kindof ZZTableViewHeaderFooterView * _Nullable headerFooterView);

// 移动Cell Block定义
typedef void (^ZZTableViewCellMoveBlock)(__weak ZZTableView * _Nonnull tableView, NSIndexPath * _Nonnull fromIndex, NSIndexPath * _Nonnull toIndex, __kindof ZZTableViewCellDataSource * _Nonnull fromCellData, __kindof ZZTableViewCell * _Nonnull fromCell, __kindof ZZTableViewCellDataSource * _Nonnull toCellData, __kindof ZZTableViewCell * _Nonnull toCell);

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ZZTableViewCell类

@interface ZZTableViewCell : UITableViewCell

@end

@interface ZZTableViewCellDataSource : NSObject

@end

#pragma mark - ZZTableViewHeaderFooterView类

@interface ZZTableViewHeaderFooterView : UITableViewHeaderFooterView

@end

@interface ZZTableViewHeaderFooterViewDataSource : NSObject

@end

#pragma mark - ZZTableView类

@interface ZZTableView : UITableView


/**
 *  ZZTableViewCellEditingStyleNone                     editing = YES, UITableViewCellEditingStyleNone
 *  ZZTableViewCellEditingStyleInsert                   editing = YES, UITableViewCellEditingStyleInsert
 *  ZZTableViewCellEditingStyleMove                     editing = YES, UITableViewCellEditingStyleNone
 *  ZZTableViewCellEditingStyleMultiSelect              editing = YES, UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete
 *  ZZTableViewCellEditingStyleDirectDelete
 *  ZZTableViewCellEditingStyleDirectDeleteConfirm      editing = YES, UITableViewCellEditingStyleDelete
 *  ZZTableViewCellEditingStyleSlidingDelete
 *  ZZTableViewCellEditingStyleSlidingDeleteConfirm
 *  ZZTableViewCellEditingStyleLongPressDelete
 *  ZZTableViewCellEditingStyleLongPressDeleteConfirm   editing = NO, UITableViewCellEditingStyleDelete
 */
@property (nonatomic, assign) ZZTableViewCellEditingStyle zzTableViewCellEditingStyle;


@end

NS_ASSUME_NONNULL_END
