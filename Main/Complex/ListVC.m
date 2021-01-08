//
//  ListVC.m
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "ListVC.h"
#import "ZZTableView.h"
#import "ListCell.h"
#import "NSString+ZZKit.h"

@interface ListVC ()

@property (nonatomic, strong) ZZTableView *tableView;

@end

@implementation ListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [ZZTableView zz_quickAdd:ZZTableViewCellEditingStyleNone
                              backgroundColor:@"#F8F8F8".zz_color
                                       onView:self.view
                                        frame:CGRectZero
                              constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(superView);
    } actionBlock:^(ZZTableView * _Nonnull __weak tableView, NSInteger section, NSInteger row, ZZTableViewCellAction action, __kindof ZZTableViewCellDataSource * _Nullable cellData, __kindof ZZTableViewCell * _Nullable cell, __kindof ZZTableViewHeaderFooterViewDataSource * _Nullable headerFooterData, __kindof ZZTableViewHeaderFooterView * _Nullable headerFooterView) {
        
    } scrollBlock:^(ZZTableView * _Nonnull __weak tableView, ZZTableViewScrollAction action, CGPoint velocity, CGPoint targetContentOffset, BOOL decelerate) {
        
    }];
    [self _render];
}

- (void)_render {
    
    for (int i = 0; i < 30; i++) {
        ListCellDataSource *ds = [[ListCellDataSource alloc] init];
        [self.tableView zz_addDataSource:ds];
    }
    [self.tableView zz_refresh];
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
