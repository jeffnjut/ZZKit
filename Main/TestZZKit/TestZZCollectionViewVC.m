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
#import "ZWHCollectionViewFlowWaterfallLayout.h"

@interface TestZZCollectionViewVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ZZCollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *collectionView2;

@end

@implementation TestZZCollectionViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self testHorizontal];
}

- (void)testVertical {
    
    self.collectionView = [ZZCollectionView zz_quickAdd:[UIColor lightGrayColor] onView:self.view frame:CGRectZero scrollDirection:UICollectionViewScrollDirectionVertical registerCellsBlock:^NSArray * _Nonnull{
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

- (void)testHorizontal {
    
    self.collectionView = [ZZCollectionView zz_quickAdd:[UIColor lightGrayColor] onView:self.view frame:CGRectMake(0, 100, UIScreen.mainScreen.bounds.size.width, 200) scrollDirection:UICollectionViewScrollDirectionHorizontal registerCellsBlock:^NSArray * _Nonnull {
        return @[[TestCollectionViewCell class],[TestHeadCollectionViewCell class]];
    } registerHeadersBlock:^NSArray * _Nonnull{
        return @[[TestZZCollectionReusableView class]];
    } registerFootersBlock:^NSArray * _Nonnull{
        return nil;
    } constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
        
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
    
    /*
    self.collectionView.zzDraggable = NO;
    ZZCollectionSectionObject *sectionObject = [ZZCollectionSectionObject new];
    sectionObject.zzMinimumLineSpacing = 5;
    for (int i = 0; i < 10; i ++) {
        TestCollectionViewCellDataSource *ds = [[TestCollectionViewCellDataSource alloc] init];
        ds.backgroundColor = [UIColor colorWithRed:(arc4random() % 255 / 255.0) green:(arc4random() % 255 / 255.0) blue:(arc4random() % 255 / 255.0) alpha:1.0];
        ds.text = [NSString stringWithFormat:@"%u", arc4random() % 10000];
        ds.zzHeight = arc4random() % 100 + 50;
        [sectionObject.zzCellDataSource addObject:ds];
    }
    [self.collectionView zz_addDataSource:sectionObject];
    [self.collectionView zz_refresh];
    */
    
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

- (void)testHorizontal2 {
    
    UICollectionViewFlowLayout *horizontalCellLayout = [UICollectionViewFlowLayout new];
    horizontalCellLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    horizontalCellLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView2 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 300, UIScreen.mainScreen.bounds.size.width, 100) collectionViewLayout:horizontalCellLayout];
    
    [self.collectionView2 registerClass:[TestCollectionViewCell class] forCellWithReuseIdentifier:@"id"];
    [self.collectionView2 registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    self.collectionView2.backgroundColor = [UIColor lightGrayColor];
    self.collectionView2.dataSource = self;
    self.collectionView2.delegate = self;
    [self.view addSubview:self.collectionView2];
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 30;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"id";
    TestCollectionViewCell * cell = (TestCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1.0];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head" forIndexPath:indexPath];
    head.backgroundColor = UIColor.blueColor;
    return head;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(0.01, self.collectionView2.frame.size.height);
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(80.0, 100);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
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
