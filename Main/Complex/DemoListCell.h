//
//  DemoListCell.h
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoListCell : ZZTableViewCell

@end

@interface DemoListCellDataSource : ZZTableViewCellDataSource

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *color;

@end

NS_ASSUME_NONNULL_END
