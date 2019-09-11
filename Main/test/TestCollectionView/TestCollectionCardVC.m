//
//  TestCollectionCardVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/9/11.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestCollectionCardVC.h"
#import "BasicCollectionViewCell.h"

@interface CardLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat collectionViewHeight;
@property (nonatomic, assign) CGFloat collectionViewWidth;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellMargin;
@property (nonatomic, assign) CGFloat margin;

@end

@implementation CardLayout

- (CGFloat)collectionViewHeight {
    
    return self.collectionView.frame.size.height;
}

- (CGFloat)collectionViewWidth {
    
    return self.collectionView.frame.size.width;
}

- (CGFloat)cellWidth {
    
    return self.collectionViewWidth * 0.7;
}

- (CGFloat)cellMargin {
    
    return ( self.collectionViewWidth - self.cellWidth ) / 7.0;
}

- (CGFloat)margin {
    
    return ( self.collectionViewWidth - self.cellWidth ) / 2.0;
}

- (void)prepareLayout {
    
    [super prepareLayout];
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = self.cellMargin;
    self.itemSize = CGSizeMake(self.cellWidth, self.collectionViewHeight * 0.75);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    if (self.collectionView) {
        
        NSArray<__kindof UICollectionViewLayoutAttributes *> *visibleAttributes = [super layoutAttributesForElementsInRect:rect];
        CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0;
        for (UICollectionViewLayoutAttributes *attribute in visibleAttributes) {
            CGFloat distance = fabs(attribute.center.x - centerX);
            
            CGFloat aprtScale = distance / self.collectionView.bounds.size.width;
            
            CGFloat scale = fabs(cos(aprtScale * 3.14159265358979323846 / 4.0));
            
            attribute.transform = CGAffineTransformMakeScale(scale, scale);
        }
        
        return visibleAttributes;
        
    }
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

@end

@interface TestCollectionCardVC () <UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<UIColor *> *colors;

@property (nonatomic, strong) CardLayout *flowLayout;

@end

@implementation TestCollectionCardVC

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.flowLayout = [[CardLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:self.flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BasicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BasicCollectionViewCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.dataSource = self;
    
    self.colors = [TestCollectionCardVC generateColors:30];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.colors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BasicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BasicCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = self.colors[indexPath.row];
    return cell;
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
