//
//  PracticeVC.m
//  ZZKit
//
//  Created by Fu Jie on 2020/3/17.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import "PracticeVC.h"
#import "NSString+ZZKit.h"
#import "UIViewController+ZZKit.h"
#import "TestPushVC.h"

@interface PracticeVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation PracticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 48.0;
    [self.view addSubview:self.tableView];
    
    self.dataSource = @[@[@"推送", [TestPushVC class]]
                        ];
    
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
    [self.navigationController zz_push:vc animated:YES];
}

@end
