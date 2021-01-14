//
//  ComplexChildListVC.m
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "ComplexChildListVC.h"
#import "DemoListCell.h"
#import "DemoBannerCell.h"
#import "DemoIconCell.h"
#import "DemoHowtoCell.h"
#import "DemoSelectedCell.h"

@interface ComplexChildListVC ()

@property (nonatomic, strong) ZZTableView *tableView;
@property (nonatomic, weak) InnerScrollCell *innerScrollCell;
@property (nonatomic, weak) UIScrollView *superScrollView;
@property (nonatomic, assign) CGFloat superScrollViewOrignalY;
@property (nonatomic, assign) CGFloat superScrollViewOrignalH;
@property (nonatomic, assign) CGFloat hiddenSegmentViewOriginalY;

@end

@implementation ComplexChildListVC

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    if (self.hiddenSegmentView && self.hiddenSegmentViewOriginalY == 0) {
        ZZ_WEAK_SELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.hiddenSegmentView && weakSelf.hiddenSegmentViewOriginalY == 0) {
                weakSelf.hiddenSegmentViewOriginalY = weakSelf.hiddenSegmentView.frame.origin.y;
                if ([weakSelf.view.superview isKindOfClass:[UIScrollView class]]) {
                    weakSelf.superScrollView = (UIScrollView *)weakSelf.view.superview;
                    weakSelf.superScrollViewOrignalY = weakSelf.superScrollView.frame.origin.y;
                    weakSelf.superScrollViewOrignalH = weakSelf.superScrollView.frame.size.height;
                }
            }
        });
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.tableView = [ZZTableView zz_quickAdd:ZZTableViewCellEditingStyleNone
                              backgroundColor:@"#F8F8F8".zz_color
                                       onView:self.view
                                        frame:CGRectZero
                              constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(superView);
    } actionBlock:^(ZZTableView * _Nonnull __weak tableView, NSInteger section, NSInteger row, ZZTableViewCellAction action, __kindof ZZTableViewCellDataSource * _Nullable cellData, __kindof ZZTableViewCell * _Nullable cell, __kindof ZZTableViewHeaderFooterViewDataSource * _Nullable headerFooterData, __kindof ZZTableViewHeaderFooterView * _Nullable headerFooterView) {
        
        if ([cellData isKindOfClass:[DemoBannerCellDataSource class]]) {
            DemoBannerCellDataSource *ds = cellData;
            [weakSelf.view zz_toast:[NSString stringWithFormat:@"选中第%d张", (int)ds.selectedIndex + 1]];
        }
        
    } scrollBlock:^(ZZTableView * _Nonnull __weak tableView, ZZTableViewScrollAction action, CGPoint velocity, CGPoint targetContentOffset, BOOL decelerate) {
        
        [weakSelf scrollViewDidScroll:tableView];
        
        if (weakSelf.hiddenSegmentView) {
            if (tableView.contentOffset.y >= 0 && tableView.contentOffset.y <= weakSelf.hiddenSegmentView.frame.size.height) {
                weakSelf.hiddenSegmentView.frame = CGRectMake(weakSelf.hiddenSegmentView.frame.origin.x,
                                                          weakSelf.hiddenSegmentViewOriginalY - tableView.contentOffset.y,
                                                          weakSelf.hiddenSegmentView.frame.size.width,
                                                          weakSelf.hiddenSegmentView.frame.size.height);
                weakSelf.superScrollView.frame = CGRectMake(weakSelf.superScrollView.frame.origin.x,
                                                       weakSelf.superScrollViewOrignalY - tableView.contentOffset.y,
                                                       weakSelf.superScrollView.frame.size.width,
                                                       weakSelf.superScrollViewOrignalH + tableView.contentOffset.y);
                
            }else if (tableView.contentOffset.y < 0) {
                weakSelf.hiddenSegmentView.frame = CGRectMake(weakSelf.hiddenSegmentView.frame.origin.x,
                                                              weakSelf.hiddenSegmentViewOriginalY,
                                                              weakSelf.hiddenSegmentView.frame.size.width,
                                                              weakSelf.hiddenSegmentView.frame.size.height);
                weakSelf.superScrollView.frame = CGRectMake(weakSelf.superScrollView.frame.origin.x,
                                                            weakSelf.superScrollViewOrignalY,
                                                            weakSelf.superScrollView.frame.size.width,
                                                            weakSelf.superScrollViewOrignalH);
            }else {
                weakSelf.hiddenSegmentView.frame = CGRectMake(weakSelf.hiddenSegmentView.frame.origin.x,
                                                              weakSelf.hiddenSegmentViewOriginalY - weakSelf.hiddenSegmentView.frame.size.height,
                                                              weakSelf.hiddenSegmentView.frame.size.width,
                                                              weakSelf.hiddenSegmentView.frame.size.height);
                weakSelf.superScrollView.frame = CGRectMake(weakSelf.superScrollView.frame.origin.x,
                                                            weakSelf.superScrollViewOrignalY - weakSelf.hiddenSegmentView.frame.size.height,
                                                            weakSelf.superScrollView.frame.size.width,
                                                            weakSelf.superScrollViewOrignalH + weakSelf.hiddenSegmentView.frame.size.height);
            }
        }
        
        if (weakSelf.innerScrollCell == nil) {
            
            [[tableView visibleCells] enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:[InnerScrollCell class]]) {
                    weakSelf.innerScrollCell = (InnerScrollCell *)obj;
                }
                
            }];
            
        }
    }];
    [self _render];
}

- (void)_render {
    
    ZZTableSectionObject *section = [[ZZTableSectionObject alloc] init];
    [self.tableView zz_addDataSource:section];
    DemoBannerCellDataSource *banner = [[DemoBannerCellDataSource alloc] init];
    [section.zzCellDataSource addObject:banner];
    
    DemoIconCellDataSource *icons = [[DemoIconCellDataSource alloc] init];
    [section.zzCellDataSource addObject:icons];
    
    DemoHowtoCellDataSource *howto = [[DemoHowtoCellDataSource alloc] init];
    [section.zzCellDataSource addObject:howto];
    
    DemoSelectedCellDataSource *selected = [[DemoSelectedCellDataSource alloc] init];
    [section.zzCellDataSource addObject:selected];
    
    section = [[ZZTableSectionObject alloc] init];
    [self.tableView zz_addDataSource:section];
    InnerScrollCellDataSource *ds = [[InnerScrollCellDataSource alloc] init];
    ds.superComplexChildListVC = self;
    ds.titles = @[@"最新推荐", @"美妆个护", @"服饰鞋包", @"直邮中国", @"电子数码", @"日用百货", @"食品保健"];
    
    ds.zzHeight = ZZDevice.zz_screenHeight - self.headViewHeight - ZZ_DEVICE_TAB_BAR_HEIGHT;
    [section.zzCellDataSource addObject:ds];
    [self.tableView zz_refresh];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *_Nullable)scrollView {
    
    NSLog(@"ScrollView %f", scrollView.contentOffset.y);
    // NSLog(@"%f  %f", self.innerScrollCell.frame.origin.y, scrollView.contentOffset.y);
    if (self.innerScrollCell) {
        
        if (self.innerScrollCell.visibleScrollView.contentOffset.y > 1) {
            self.tableView.contentOffset = CGPointMake(0, self.innerScrollCell.frame.origin.y);
        }
        
        if (self.tableView.contentOffset.y > self.innerScrollCell.frame.origin.y) {
            self.tableView.contentOffset = CGPointMake(0, self.innerScrollCell.frame.origin.y);
        }
    }
}

#pragma mark - ChildSubScrollViewDelegate

- (void)subScrollViewDidScroll:(UIScrollView *_Nullable)scrollView {
    
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointZero;
    }
    if (self.tableView.contentOffset.y < self.innerScrollCell.frame.origin.y) {
        scrollView.contentOffset = CGPointZero;
    }
    NSLog(@"SubScrollView %f", scrollView.contentOffset.y);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
