//
//  ComplexChildListVC.h
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZComplexChildBaseVC.h"
#import "InnerScrollCell.h"
#import "ChildListVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComplexChildListVC : ZZComplexChildBaseVC <ChildSubScrollViewDelegate>

@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong, readonly) ZZTableView *tableView;
@property (nonatomic, weak, readonly) InnerScrollCell *innerScrollCell;

@end

NS_ASSUME_NONNULL_END
