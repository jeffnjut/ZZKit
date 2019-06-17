//
//  TestZZTableViewVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/14.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestZZTableViewVC.h"
#import "TestCell.h"

@interface TestZZTableViewVC ()

@property (nonatomic, strong) ZZTableView *tableView;

@end

@implementation TestZZTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView = [ZZTableView zz_quickAdd:ZZTableViewCellEditingStyleSlidingDelete backgroundColor:UIColor.redColor onView:self.view frame:CGRectZero constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(superView);
    } actionBlock:^(ZZTableView *__weak  _Nonnull tableView, NSInteger section, NSInteger row, ZZTableViewCellAction action, __kindof ZZTableViewCellDataSource * _Nullable cellData, __kindof ZZTableViewCell * _Nullable cell, __kindof ZZTableViewHeaderFooterViewDataSource * _Nullable headerFooterData, __kindof ZZTableViewHeaderFooterView * _Nullable headerFooterView) {
        if (action == ZZTableViewCellActionTapped) {
            if ([cellData isKindOfClass:[TestCellDataSource class]]) {
                TestCellDataSource *testCellData = cellData;
                NSLog(@"Section : %ld, Row : %ld, Text : %@", section, row, testCellData.text);
            }
        }else if (action == ZZTableViewCellActionCustomeTapped) {
            if ([cellData isKindOfClass:[TestCellDataSource class]]) {
                TestCellDataSource *testCellData = cellData;
                NSLog(@"Section : %ld, Row : %ld, Text : %@", section, row, testCellData.text);
            }
        }else if (action == ZZTableViewCellActionMultiSelect) {
            if ([cellData isKindOfClass:[TestCellDataSource class]]) {
                TestCellDataSource *testCellData = cellData;
                NSLog(@"Section : %ld, Row : %ld, Text : %@ isSelected : %d", section, row, testCellData.text, testCellData.zzSelected);
            }
        }
    }];
    
    for (int i = 0; i < 100; i++) {
        TestCellDataSource *ds = [[TestCellDataSource alloc] init];
        ds.text = [NSString stringWithFormat:@"测试：%d", i];
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
