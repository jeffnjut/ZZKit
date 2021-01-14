//
//  InnerScrollCell.h
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InnerScrollCell : ZZTableViewCell

@property (nonatomic, weak) UIScrollView *visibleScrollView;

@end

@interface InnerScrollCellDataSource : ZZTableViewCellDataSource

@property (nonatomic, weak) UIViewController *superComplexChildListVC;
@property (nonatomic, strong) NSArray *titles;

@end

NS_ASSUME_NONNULL_END
