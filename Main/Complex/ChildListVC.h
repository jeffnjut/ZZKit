//
//  ChildListVC.h
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZComplexChildBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChildListVC : ZZComplexChildBaseVC

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, strong, readonly) ZZTableView *tableView;
 

@end

NS_ASSUME_NONNULL_END
