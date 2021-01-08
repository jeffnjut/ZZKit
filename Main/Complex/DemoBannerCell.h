//
//  DemoBannerCell.h
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoBannerCell : ZZTableViewCell

@end

@interface DemoBannerCellDataSource : ZZTableViewCellDataSource

@property (nonatomic, assign) NSUInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
