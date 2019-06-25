//
//  TestZZCollectionViewVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/24.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestZZCollectionViewVC.h"
#import "ZZCollectionView.h"
#import "TestCollectionViewCell.h"
#import "TestHeadCollectionViewCell.h"

@interface TestZZCollectionViewVC ()

@property (nonatomic, strong) ZZCollectionView *collectionView;

@end

@implementation TestZZCollectionViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.collectionView = [ZZCollectionView zz_quickAdd:[UIColor redColor] onView:self.view frame:CGRectZero registerCellsBlock:^NSArray * _Nonnull{
        return @[[TestCollectionViewCell class],[TestHeadCollectionViewCell class]];
    } constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(superView);
    } actionBlock:^(ZZCollectionView *__weak  _Nonnull collectionView, NSInteger section, NSInteger row, ZZCollectionViewCellAction action, __kindof ZZCollectionViewCellDataSource * _Nullable cellData, __kindof ZZCollectionViewCell * _Nullable cell) {
        
        if (action == ZZCollectionViewCellActionCustomTapped) {
            if ([cellData isKindOfClass:[TestHeadCollectionViewCellDataSource class]]) {
                NSLog(@"Tap Header");
            }
        }
        
    }];
    
    [self.collectionView reloadData];
    
    __weak typeof(self) weakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"%@", strongSelf);
    });
    self.collectionView.zzLayout.zzContentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    ZZCollectionSectionObject *sectionObject = [ZZCollectionSectionObject new];
    sectionObject.zzMinimumLineSpacing = 10.0;
    sectionObject.zzMinimumInteritemSpacing = 10.0;
    sectionObject.zzColumns = 2;
    sectionObject.zzEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    sectionObject = [ZZCollectionSectionObject new];
    sectionObject.zzMinimumLineSpacing = 10.0;
    sectionObject.zzMinimumInteritemSpacing = 10.0;
    sectionObject.zzColumns = 1;
    sectionObject.zzEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    TestHeadCollectionViewCellDataSource *ds = [[TestHeadCollectionViewCellDataSource alloc] init];
    [sectionObject.zzCellDataSource addObject:ds];
    [self.collectionView zz_addDataSource:sectionObject];

    sectionObject = [ZZCollectionSectionObject new];
    sectionObject.zzMinimumLineSpacing = 10.0;
    sectionObject.zzMinimumInteritemSpacing = 10.0;
    sectionObject.zzColumns = 2;
    sectionObject.zzEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    for (int i = 0; i < 30; i ++) {
        TestCollectionViewCellDataSource *ds = [[TestCollectionViewCellDataSource alloc] init];
        [sectionObject.zzCellDataSource addObject:ds];
    }
    [self.collectionView zz_addDataSource:sectionObject];
    
    [self.collectionView zz_refresh];
    
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
