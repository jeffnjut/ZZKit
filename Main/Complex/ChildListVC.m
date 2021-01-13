//
//  ChildListVC.m
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "ChildListVC.h"
#import "DemoBannerCell.h"
#import "DemoListCell.h"
#import "ComplexTableView.h"
#import "ComplexChildListVC.h"

@interface ChildListVC ()

@property (nonatomic, strong) ComplexTableView *tableView;

@end

@implementation ChildListVC

- (void)viewDidLoad {
    
    ZZ_WEAK_SELF
    [super viewDidLoad];
    self.tableView = [ComplexTableView zz_quickAdd:ZZTableViewCellEditingStyleNone
                                   backgroundColor:@"#F8F8F8".zz_color
                                            onView:self.view
                                             frame:CGRectZero
                                   constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(superView);
    } actionBlock:^(ZZTableView * _Nonnull __weak tableView, NSInteger section, NSInteger row, ZZTableViewCellAction action, __kindof ZZTableViewCellDataSource * _Nullable cellData, __kindof ZZTableViewCell * _Nullable cell, __kindof ZZTableViewHeaderFooterViewDataSource * _Nullable headerFooterData, __kindof ZZTableViewHeaderFooterView * _Nullable headerFooterView) {
        
        if ([cellData isKindOfClass:[DemoListCellDataSource class]]) {
            DemoListCellDataSource *ds = cellData;
            [ZZ_KEY_WINDOW zz_toast:[NSString stringWithFormat:@"点击了%@", ds.title]];
        }else if ([cellData isKindOfClass:[DemoBannerCellDataSource class]]) {
            DemoBannerCellDataSource *ds = cellData;
            [ZZ_KEY_WINDOW zz_toast:[NSString stringWithFormat:@"选中第%d张", (int)ds.selectedIndex + 1]];
        }
        
    } scrollBlock:^(ZZTableView * _Nonnull __weak tableView, ZZTableViewScrollAction action, CGPoint velocity, CGPoint targetContentOffset, BOOL decelerate) {
        
        if (tableView.contentOffset.y < 0) {
            ComplexChildListVC *complexChildListVC = [tableView zz_findViewController:[ComplexChildListVC class]];
            NSLog(@"%@",weakSelf.nextResponder);
            NSLog(@"%@  %f",tableView.name, tableView.contentOffset.y);
            [complexChildListVC.innerScrollCell setUserInteractionEnabled:NO];
            tableView.contentOffset = CGPointZero;
        }
        
    }];
    if (self.tableName.length > 0) {
        self.tableView.name = self.tableName;
    }
    [self _render];
}

- (void)_render {
    
    if (self.id.length >= 4) {
        DemoBannerCellDataSource *demo = [[DemoBannerCellDataSource alloc] init];
        [self.tableView zz_addDataSource:demo];
    }
    
    for (int i = 0; i < 30; i++) {
        DemoListCellDataSource *ds = [[DemoListCellDataSource alloc] init];
        ds.title = [NSString stringWithFormat:@"%@ - %d", ZZ_OBJECT_NIL_TO_EMPTY(self.id), i+1];
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
