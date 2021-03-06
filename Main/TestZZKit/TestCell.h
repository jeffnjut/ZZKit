//
//  TestCell.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/15.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestCell : ZZTableViewCell

@end

@interface TestCellDataSource : ZZTableViewCellDataSource

@property (nonatomic, copy) NSString *text;

@end

NS_ASSUME_NONNULL_END
