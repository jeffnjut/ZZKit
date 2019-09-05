//
//  TestWebImageVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/26.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestWebImageVC.h"
#import "UIImageView+ZZKit.h"
#import "NSString+ZZKit.h"
#import "TestImageTableViewCell.h"

@interface TestWebImageVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation TestWebImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = @[@"https://n.sinaimg.cn/tech/transform/408/w204h204/20190826/d7fe-icuacrz4584330.gif",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/237/467d0245bd96fd25fc328e2449a3ca83.jpeg@!webp_jpg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201906/06/430fipshben85n8tqnnbc92b7d.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/20/23hnpbakagsunhd5egs4d3dou9.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/20/srdfq8q6hhodne250ns9i48bb.jpeg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/232/e28e8391d85863e570b2091b2759583c.jpeg@!webp_jpg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/19/6r4fj6amvp5e7h7iavs91g36u.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/19/57llhhlcvv5t66tcvhltrsvgsi.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/19/4ll4a03gqkrufteufmovpd4dfr.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/19/4633kcio6pesnmmooaqra9cu0s.jpeg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/237/7a4f19773c52cb8b0be8761148e04e56.jpeg@!webp_jpg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/19/6r4fj6amvp5e7h7iavs91g36u.jpeg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/232/e28e8391d85863e570b2091b2759583c.jpeg@!webp_jpg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/20/srdfq8q6hhodne250ns9i48bb.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/19/57llhhlcvv5t66tcvhltrsvgsi.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/19/4ll4a03gqkrufteufmovpd4dfr.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/19/4633kcio6pesnmmooaqra9cu0s.jpeg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/237/7a4f19773c52cb8b0be8761148e04e56.jpeg@!webp_jpg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/228/0360fb52f69fa6fa6c300544a72079cc.jpeg@!webp_jpg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/226/969b82f712773c92361053d2b7d3c81d.jpeg@!webp_jpg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/226/b5d8d8b2ec1c974bc1c67e8c46e795d0.jpeg@!webp_jpg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/226/de6738fd09b24a2c4827386d31269e73.jpeg@!webp_jpg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/226/9e7d672e3e084a5db491c490a073fba4.jpeg@!webp_jpg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/226/969b82f712773c92361053d2b7d3c81d.jpeg@!webp_jpg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/13/1q11c0tn8qb4up7507g9306oju.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/13/14sl5qn0eaav3sovtmv79bjjsh.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/13/uedconerc5j24a1ie7lfd3mj5.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/13/1565658207892.jpg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/226/969b82f712773c92361053d2b7d3c81d.jpeg@!webp_jpg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/226/de6738fd09b24a2c4827386d31269e73.jpeg@!webp_jpg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/226/9e7d672e3e084a5db491c490a073fba4.jpeg@!webp_jpg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/13/1q11c0tn8qb4up7507g9306oju.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/13/14sl5qn0eaav3sovtmv79bjjsh.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/13/uedconerc5j24a1ie7lfd3mj5.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/13/1565658207892.jpg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/13/1565658167091.jpg",
                        @"https://55haitao-test.oss-cn-qingdao.aliyuncs.com/bbs/data/attachment/forum/201908/09/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20190809133510_201908091335.jpg@!webp_jpg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/09/4hah7b0tdnijqgsjksiuc1qsmu.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/09/25ejidvbqs2rdch5a032t9jjoa.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/08/1q8jkkj2bjup7vpk2ibfv2clsg.jpeg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/08/1564792625270.jpg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/08/1565103524320.jpg",
                        @"https://cdn-test.55haitao.com/bbs/data/attachment/forum/201908/08/3jvuf5vvjdslp7mbu7mqenpl4d.jpeg"];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TestImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"A"];
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"TestImageTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"A"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"A"];
    }
    NSString *url = [self.dataSource objectAtIndex:indexPath.row];
    [cell.iv zz_load:url placeholderImage:@"logo".zz_image backgroundColor:[UIColor lightGrayColor] contentMode:UIViewContentModeScaleAspectFit completion:^(UIImageView * _Nullable imageView, UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, NSString * _Nullable url) {
        
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 250;
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
