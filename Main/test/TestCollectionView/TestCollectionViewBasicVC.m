//
//  TestCollectionViewBasicVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/9/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestCollectionViewBasicVC.h"
#import "BasicHeaderView.h"
#import "BasicFooterView.h"
#import "BasicCollectionViewCell.h"

@interface TestCollectionViewBasicVC () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<NSMutableArray<UIColor *> *> *colors;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation TestCollectionViewBasicVC

+ (UIColor *)randomColor {
    
    return [UIColor colorWithRed:(arc4random() % 255 / 255.0) green:(arc4random() % 255 / 255.0) blue:(arc4random() % 255 / 255.0) alpha:1.0];
}

+ (NSMutableArray<UIColor *> *)generateColors:(int)cnt {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < cnt; i++) {
        [arr addObject:[self randomColor]];
    }
    return (NSMutableArray<UIColor *> *)arr;
}

/*
 * Basic 01
 */

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = (UIScreen.mainScreen.bounds.size.width - 4.0) / 3.0;
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.itemSize = CGSizeMake(width, width);
    self.flowLayout.minimumLineSpacing = 1;
    self.flowLayout.minimumInteritemSpacing = 1;
    // Section Header Sticky
    self.flowLayout.sectionHeadersPinToVisibleBounds = YES;
    // Section Footer Sticky
    self.flowLayout.sectionFootersPinToVisibleBounds = YES;
    self.flowLayout.headerReferenceSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 60.0);
    self.flowLayout.footerReferenceSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 60.0);
    
    self.colors = (NSMutableArray<NSMutableArray<UIColor *> *> *)[NSMutableArray new];
    [self.colors addObject:[TestCollectionViewBasicVC generateColors:8]];
    [self.colors addObject:[TestCollectionViewBasicVC generateColors:5]];
    [self.colors addObject:[TestCollectionViewBasicVC generateColors:7]];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.flowLayout];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BasicHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BasicHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BasicFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"BasicFooterView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BasicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BasicCollectionViewCell"];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.layer.masksToBounds = YES;
    
    self.collectionView.dataSource = self;
    /*
     * Basic 02
     */
    // UICollectionViewDelegateFlowLayout 生效必须设置delegate
    self.collectionView.delegate = self;
    
    [self.view addSubview:self.collectionView];
    
    
    /*
     * Basic 03
     */
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longGestureAction:)];
    [self.collectionView addGestureRecognizer:longGesture];
}

- (void)_longGestureAction:(UILongPressGestureRecognizer *)longGesture {
    
    CGPoint point = [longGesture locationInView:self.collectionView];
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
            [self.collectionView cancelInteractiveMovement];
            break;
            
        }
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.colors.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.colors[section].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BasicCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = self.colors[indexPath.section][indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BasicHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BasicHeaderView" forIndexPath:indexPath];
        return headerView;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        BasicFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"BasicFooterView" forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

/*
 * Basic 03
 */

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    UIColor *color = self.colors[sourceIndexPath.section][sourceIndexPath.row];
    [self.colors[sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.row];
    [self.colors[destinationIndexPath.section] insertObject:color atIndex:destinationIndexPath.row];
}

#pragma mark - UICollectionViewDelegateFlowLayout


/*
 * Basic 02
 */

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat w = 0;
    switch (indexPath.section) {
        case 0:
        {
            w = (self.view.bounds.size.width - 4.0) / 3.0;
            return CGSizeMake(w, w);
            break;
        }
        case 1:
        {
            w = self.view.bounds.size.width - 10.0;
            return CGSizeMake(w, 100.0);
            break;
        }
        case 2:
        default:
            w = (self.view.bounds.size.width - 15.0) / 2.0;
            return CGSizeMake(w, w);
            break;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            return UIEdgeInsetsMake(0, 1, 0, 1);
            break;
        }
        case 1:
        {
            return UIEdgeInsetsMake(0, 0, 0, 0);
            break;
        }
        case 2:
        default:
            return UIEdgeInsetsMake(0, 5, 0, 5);
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            return 1;
            break;
        }
        case 1:
        {
            return 2;
            break;
        }
        case 2:
        default:
            return 5;
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            return 1;
            break;
        }
        case 1:
        {
            return 2;
            break;
        }
        case 2:
        default:
            return 5;
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
        {
            return CGSizeMake(self.view.bounds.size.width, 30);
            break;
        }
        case 1:
        {
            return CGSizeMake(self.view.bounds.size.width, 50);
            break;
        }
        case 2:
        default:
            return CGSizeMake(self.view.bounds.size.width, 70);
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    return CGSizeMake(self.view.bounds.size.width, 20.0);
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
