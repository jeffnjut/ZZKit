//
//  ZZTableView+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/20.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZTableView (ZZKit)

// 获取CellDataSource对应的Cell
- (nullable __kindof ZZTableViewCell *)zz_cellForDataSource:(nullable __kindof ZZTableViewCellDataSource *)data;

// 根据DataSource的类型获得Cell （若存在多个，仅返回第一个cell）
- (nullable __kindof ZZTableViewCell *)zz_cellForClass:(id)cellClass;

@end

NS_ASSUME_NONNULL_END
