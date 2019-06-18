//
//  TestZZTableViewVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/14.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestZZTableViewVC.h"
#import "TestCell.h"
#import "UIView+ZZKit_Blocks.h"
#import "NSString+ZZKit.h"

@interface TestZZTableViewVC ()

@property (nonatomic, strong) ZZTableView *tableView;

@end

@implementation TestZZTableViewVC

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    
    __weak typeof(self) weakSelf = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView = [ZZTableView zz_quickAdd:ZZTableViewCellEditingStyleLongPressDelete backgroundColor:UIColor.redColor onView:self.view frame:CGRectZero constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(superView);
    } actionBlock:^(ZZTableView *__weak  _Nonnull tableView, NSInteger section, NSInteger row, ZZTableViewCellAction action, __kindof ZZTableViewCellDataSource * _Nullable cellData, __kindof ZZTableViewCell * _Nullable cell, __kindof ZZTableViewHeaderFooterViewDataSource * _Nullable headerFooterData, __kindof ZZTableViewHeaderFooterView * _Nullable headerFooterView) {
        if (action == ZZTableViewCellActionTapped) {
            if ([cellData isKindOfClass:[TestCellDataSource class]]) {
                TestCellDataSource *testCellData = cellData;
                NSLog(@"Tap ### Section : %ld, Row : %ld, Text : %@", section, row, testCellData.text);
            }
        }else if (action == ZZTableViewCellActionCustomeTapped) {
            if ([cellData isKindOfClass:[TestCellDataSource class]]) {
                TestCellDataSource *testCellData = cellData;
                NSLog(@"CustomeTapped ### Section : %ld, Row : %ld, Text : %@", section, row, testCellData.text);
            }
        }else if (action == ZZTableViewCellActionMultiSelect) {
            if ([cellData isKindOfClass:[TestCellDataSource class]]) {
                TestCellDataSource *testCellData = cellData;
                NSLog(@"Select ### Section : %ld, Row : %ld, Text : %@ isSelected : %d", section, row, testCellData.text, testCellData.zzSelected);
            }
        }else if (action == ZZTableViewCellActionInsert) {
            if ([cellData isKindOfClass:[TestCellDataSource class]]) {
                TestCellDataSource *testCellData = cellData;
                NSLog(@"Insert ### Section : %ld, Row : %ld, Text : %@", section, row, testCellData.text);
            }
        }
    }];
    
    self.tableView.zzDeletionConfirmBlock = ^(ZZTableViewVoidBlock  _Nonnull deleteAction) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"删除" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *_okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            deleteAction();
        }];
        UIAlertAction *_cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [controller addAction:_okAction];
        [controller addAction:_cancelAction];
        [weakSelf presentViewController:controller animated:YES completion:nil];
        
    };
    
    for (int i = 0; i < 100; i++) {
        TestCellDataSource *ds = [[TestCellDataSource alloc] init];
        [self.tableView zz_addDataSource:ds];
        /*
        if (i % 10 == 0 ) {
            ds.text = [NSString stringWithFormat:@"直接删除（Cell设置）：%d", i];
            ds.zzDeletionConfirmBlock = ^(ZZTableViewVoidBlock  _Nonnull deleteAction) {
                deleteAction();
            };
        }else if (i % 10 == 1 ) {
            ds.zzAllowEditing = NO;
            ds.text = [NSString stringWithFormat:@"不能编辑：%d", i];
        }else if (i % 10 == 2) {
            ds.text = [NSString stringWithFormat:@"确认后删除（Cell设置）：%d", i];
            ds.zzCustomSwipes = @[@{kZZCellSwipeText : @"消息", kZZCellSwipeBackgroundColor : [UIColor purpleColor], kZZCellSwipeAction : ^(ZZTableViewVoidBlock deleteAction){
                NSLog(@"消息");
                
            }}, @{kZZCellSwipeText : @"删除", kZZCellSwipeBackgroundColor : [UIColor redColor], kZZCellSwipeAction : ^(ZZTableViewVoidBlock deleteAction){
                NSLog(@"删除");
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"删除" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *_okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    deleteAction();
                }];
                UIAlertAction *_cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [controller addAction:_okAction];
                [controller addAction:_cancelAction];
                [weakSelf presentViewController:controller animated:YES completion:nil];
            }}];
        }else {
            ds.text = [NSString stringWithFormat:@"[自定义滑动按钮]全局设置：%d", i];
        }
        */
    }
    
    self.tableView.zzCustomSwipes = @[@{kZZCellSwipeText : @"全局定义功能按钮", kZZCellSwipeBackgroundColor : [UIColor purpleColor], kZZCellSwipeAction : ^(ZZTableViewVoidBlock deleteAction){
        NSLog(@"全局定义功能按钮");
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"全局定义功能按钮 - 删除" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *_okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            deleteAction();
        }];
        UIAlertAction *_cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [controller addAction:_okAction];
        [controller addAction:_cancelAction];
        [weakSelf presentViewController:controller animated:YES completion:nil];
    }}];
    
    self.tableView.zzSelectedImage = @"ic_select".zz_image;
    self.tableView.zzUnselectedImage = @"ic_unselect".zz_image;
    
    [self.tableView zz_refresh];
    
    self.tableView.zzTableViewCellEditingStyle = ZZTableViewCellEditingStyleLongPressDelete;
    self.tableView.zzTableViewCellEditingStyle = ZZTableViewCellEditingStyleSlidingDelete;
    self.tableView.zzTableViewCellEditingStyle = ZZTableViewCellEditingStyleNone;
    self.tableView.zzTableViewCellEditingStyle = ZZTableViewCellEditingStyleInsert;
    self.tableView.zzTableViewCellEditingStyle = ZZTableViewCellEditingStyleMultiSelect;
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
