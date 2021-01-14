//
//  ChildListVC.h
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZComplexChildBaseVC.h"
#import "UIScrollView+Complex.h"

@protocol ChildSubScrollViewDelegate <NSObject>

- (void)subScrollViewDidScroll:(UIScrollView *_Nullable)scrollView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ChildListVC : ZZComplexChildBaseVC

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, strong, readonly) ZZTableView *tableView;
@property (nonatomic, assign) BOOL shouldRecognizeSimultaneouslyWithGestureRecognizer;
@property (nonatomic, weak) id<ChildSubScrollViewDelegate> subScrollDelegate;

@end

NS_ASSUME_NONNULL_END
