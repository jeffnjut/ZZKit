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
- (nullable ZZTableViewCell *)zz_cellForDataSource:(nullable __kindof ZZTableViewCellDataSource *)data;

@end

NS_ASSUME_NONNULL_END
