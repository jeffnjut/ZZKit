//
//  NetImagesCollectionViewController.m
//  FJImageBrowserDemo
//
//  Created by Jeff on 2017/8/2.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "NetImagesCollectionViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import "ZZWidgetImageBrowser.h"
#import "ImageClCell.h"

@interface NetImagesCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIActionSheetDelegate>
{
    UICollectionView *_collectionView;
    
    NSMutableArray *_imageItems;
}

@end

@implementation NetImagesCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
}

-(NSArray*)imageUrls {
    return @[
             @"https://cdn.55haitao.com/bbs/data/attachment/banner/2019/08/02/cb5cd20592898e0e2db5687f948e7e65.jpg",
             @"https://cdn.55haitao.com/bbs/data/attachment/banner/2019/08/02/f3497ce0e7293050427c5a604409b99b.jpg",
             @"https://cdn.55haitao.com/bbs/data/attachment/banner/2019/08/01/c2f5fbde32809ef4d9d603492901bcf1.jpg",
             @"https://cdn.55haitao.com/bbs/data/attachment/banner/2019/08/02/cf9f38ff9f0dc2433df35c2e267aee9e.jpg",
             @"https://cdn.55haitao.com/bbs/data/attachment/banner/2019/08/01/9cac520cf5082aa00c14a76ec2b3d454.jpg",
             @"https://cdn.55haitao.com/bbs/data/attachment/banner/2019/08/01/652aca7282bfe2b106d64c890bbe8de1.jpg",
             @"https://cdn.55haitao.com/bbs/data/attachment/banner/2019/07/31/cbd1d797e511d1727df7ec040fb10db3.jpg",
             @"https://cdn.55haitao.com/bbs/data/attachment/banner/2019/07/31/88c35d1ebf43dd12b406b71cbc5e819a.jpg",
             @"https://cdn.55haitao.com/bbs/data/attachment/deal/20190802165201522.jpg@!bbsc1",
             @"https://cdn.55haitao.com/bbs/data/attachment/deal/2019/08/02/722c7d321063d2dc7ba0ca63d49fab17182.jpg@!bbsc1",
             @"https://cdn.55haitao.com/bbs/data/attachment/deal/20181009130824661.jpg@!bbsc1",
             @"https://cdn.55haitao.com/bbs/data/attachment/deal/20190624194050892.jpg@!bbsc1",
             @"https://cdn.55haitao.com/bbs/data/attachment/deal/2019062419460923.png@!bbsc1",
             @"https://cdn.55haitao.com/bbs/data/attachment/deal/2019/08/02/86024657d435e2e6c100b78ef2db75eec98.jpg@!bbsc1",
             @"https://cdn.55haitao.com/bbs/data/attachment/deal/20180821225358113.JPG@!bbsc1",
             @"https://cdn.55haitao.com/bbs/data/attachment/deal/2019/01/16/2307868336b443553e20b0b61bce6ade104.jpg@!bbsc1",
             @"https://cdn.55haitao.com/bbs/data/attachment/deal/2019/08/02/962ecfb90332a04ff009f2f3b86f767d3b8.png@!bbsc1",
             @"https://cdn.55haitao.com/bbs/data/attachment/deal/20190802113929598.png@!bbsc1"];
}

-(void)buildUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearImageCache)];
    
    NSInteger ColumnNumber = 3;
    CGFloat imageMargin = 10.0f;
    CGFloat itemWidth = (self.view.bounds.size.width - (ColumnNumber + 1)*imageMargin)/ColumnNumber;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 0, 0, 0);
    flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[ImageClCell class] forCellWithReuseIdentifier:@"ImageCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
}

#pragma mark -
#pragma mark CollectionViewDelegate&DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self imageUrls].count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"ImageCell";
    ImageClCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.layer.borderWidth = 1.0f;
    cell.imageUrl = [self imageUrls][indexPath.row];
    return  cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //利用FJImageBrowser显示网络图片
    [[ZZWidgetImageBrowser shareInstanse] zz_showNetImages:[self imageUrls] index:indexPath.row fromImageContainer:[collectionView cellForItemAtIndexPath:indexPath]];
}

-(void)clearImageCache {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"删除本地图片缓存？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
    [sheet showInView:self.view];
}

//清除本地图片缓存
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [_collectionView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
