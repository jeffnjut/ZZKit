//
//  ViewController.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TestFontVC.h"
#import "TestGCDVC.h"
#import "TestRunLoopVC.h"
#import "TestOperationQueueVC.h"
#import "TestZZDispatchQueueVC.h"
#import "TestUIResponderBlockVC.h"
#import "TestUIimageVC.h"
#import "TestNotificationVC.h"
#import "TestTimerVC.h"
#import "TestUIVC.h"
#import "TestZZTableViewVC.h"
#import "TestZZCollectionViewVC.h"
#import "TestWidgetVC.h"
#import "TestZZWebView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 48.0;
    [self.view addSubview:self.tableView];
    
    self.dataSource = @[@[@"测试字体",[TestFontVC class]],
                        @[@"测试GCD",[TestGCDVC class]],
                        @[@"测试RunLoop",[TestRunLoopVC class]],
                        @[@"测试NSOperationQueue",[TestOperationQueueVC class]],
                        @[@"测试ZZDispatchQueue",[TestZZDispatchQueueVC class]],
                        @[@"测试UIResponder点击",[TestUIResponderBlockVC class]],
                        @[@"测试UIImage",[TestUIimageVC class]],
                        @[@"测试Notification",[TestNotificationVC class]],
                        @[@"测试ZZTimer",[TestTimerVC class]],
                        @[@"测试UI",[TestUIVC class]],
                        @[@"测试ZZTableView",[TestZZTableViewVC class]],
                        @[@"测试ZZCollectionView",[TestZZCollectionViewVC class]],
                        @[@"测试Widget小组件",[TestWidgetVC class]],
                        @[@"测试ZZWebView",[TestZZWebView class]]];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate &  DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"TestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.row][0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class cls = self.dataSource[indexPath.row][1];
    UIViewController *vc = [[cls alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
