//
//  TestZZTableViewVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/14.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestZZTableViewVC.h"
#import "ZZTableView.h"

@interface TestZZTableViewVC ()

@property (nonatomic, strong) ZZTableView *tableView;

@end

@implementation TestZZTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView = [ZZTableView new];
    ZZTableViewCell *cell = [ZZTableViewCell new];
    cell.zzTapBlock = ^(ZZTableViewCellDataSource * _Nonnull data, ZZTableViewCell * _Nonnull cell) {
        
    };

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
