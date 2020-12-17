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
#import "TestZZCollectionReusableView.h"

@interface TestZZCollectionViewVC ()

@property (nonatomic, strong) ZZCollectionView *collectionView;

@end

@implementation TestZZCollectionViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.collectionView = [ZZCollectionView zz_quickAdd:[UIColor lightGrayColor] onView:self.view frame:CGRectZero registerCellsBlock:^NSArray * _Nonnull{
        return @[[TestCollectionViewCell class],[TestHeadCollectionViewCell class]];
    } registerHeadersBlock:^NSArray * _Nonnull{
        return @[[TestZZCollectionReusableView class]];
    } registerFootersBlock:^NSArray * _Nonnull{
        return nil;
    } constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
        make.edges.equalTo(superView);
    } actionBlock:^(ZZCollectionView * _Nonnull __weak collectionView, NSInteger section, NSInteger row, ZZCollectionViewCellAction action, __kindof ZZCollectionViewCellDataSource * _Nullable cellData, __kindof ZZCollectionViewCell * _Nullable cell, __kindof ZZCollectionReusableViewDataSource * _Nullable reusableViewData, __kindof ZZCollectionReusableView * _Nullable reusableView) {
      
        if (action == ZZCollectionViewCellActionCustomTapped) {
            if ([cellData isKindOfClass:[TestHeadCollectionViewCellDataSource class]]) {
                NSLog(@"Tap Header Button");
            }
            
            if ([reusableViewData isKindOfClass:[TestZZCollectionReusableViewDataSource class]]) {
                TestZZCollectionReusableViewDataSource *ds = reusableViewData;
                NSLog(@"Tap Title:%@", ds.txt.length > 0 ? ds.txt : @"");
            }
            
        }else if (action == ZZCollectionViewCellActionTapped) {
            
            if ([cellData isKindOfClass:[TestHeadCollectionViewCellDataSource class]]) {
                NSLog(@"Tap Header");
            }
        }
    } scrollBlock:^(ZZCollectionView * _Nonnull __weak collectionView, ZZCollectionViewScrollAction action, CGPoint velocity, CGPoint targetContentOffset, BOOL decelerate) {
        
    }];
    
    self.collectionView.zzDraggable = NO;
    
    ZZCollectionSectionObject *sectionObject = [ZZCollectionSectionObject new];
    TestZZCollectionReusableViewDataSource *head = [TestZZCollectionReusableViewDataSource new];
    head.txt = @"Title 111";
    sectionObject.zzHeaderData = head;
    sectionObject.zzMinimumLineSpacing = 0;
    sectionObject.zzMinimumInteritemSpacing = 0;
    sectionObject.zzColumns = 1;
    sectionObject.zzEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    TestHeadCollectionViewCellDataSource *ds = [[TestHeadCollectionViewCellDataSource alloc] init];
    [sectionObject.zzCellDataSource addObject:ds];
    for (int i = 0; i < 15; i ++) {
        TestCollectionViewCellDataSource *ds = [[TestCollectionViewCellDataSource alloc] init];
        ds.backgroundColor = [UIColor colorWithRed:(arc4random() % 255 / 255.0) green:(arc4random() % 255 / 255.0) blue:(arc4random() % 255 / 255.0) alpha:1.0];
        ds.text = [NSString stringWithFormat:@"%u", arc4random() % 10000];
        [sectionObject.zzCellDataSource addObject:ds];
    }
    [self.collectionView zz_addDataSource:sectionObject];
    
    sectionObject = [ZZCollectionSectionObject new];
    sectionObject.zzMinimumLineSpacing = 0;
    sectionObject.zzMinimumInteritemSpacing = 0;
    sectionObject.zzColumns = 2;
    sectionObject.zzEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    ds = [[TestHeadCollectionViewCellDataSource alloc] init];
    [sectionObject.zzCellDataSource addObject:ds];
    [self.collectionView zz_addDataSource:sectionObject];

    sectionObject = [ZZCollectionSectionObject new];
    head = [TestZZCollectionReusableViewDataSource new];
    head.txt = @"Title 222";
    sectionObject.zzHeaderData = head;
    sectionObject.zzMinimumInteritemSpacing = 5;
    sectionObject.zzMinimumLineSpacing = 5;
    sectionObject.zzColumns = 10;
    sectionObject.zzEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    for (int i = 0; i < 30; i ++) {
        TestCollectionViewCellDataSource *ds = [[TestCollectionViewCellDataSource alloc] init];
        ds.backgroundColor = [UIColor colorWithRed:(arc4random() % 255 / 255.0) green:(arc4random() % 255 / 255.0) blue:(arc4random() % 255 / 255.0) alpha:1.0];
        ds.text = [NSString stringWithFormat:@"%u", arc4random() % 10000];
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
