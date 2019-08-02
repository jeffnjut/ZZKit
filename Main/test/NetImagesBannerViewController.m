//
//  NetImagesBannerViewController.m
//  ZZWidgetImageBrowserDemo
//
//  Created by Jeff on 2017/8/2.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "NetImagesBannerViewController.h"
#import "ZZWidgetImageBrowser.h"
#import "BannerClCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface NetImagesBannerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIActionSheetDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation NetImagesBannerViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearImageCache)];
    
    [self collectionView];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        __block CGFloat w = [UIScreen mainScreen].bounds.size.width;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize = CGSizeMake(w,150.0);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, w, 150.0) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[BannerClCell class] forCellWithReuseIdentifier:@"BannerCell"];
        [self.view addSubview:_collectionView];
        _collectionView.clipsToBounds = YES;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate CollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self imageUrls].count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellId = @"BannerCell";
    BannerClCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.layer.borderWidth = 1.0f;
    float r = arc4random() % 255 / 255.0;
    float g = arc4random() % 255 / 255.0;
    float b = arc4random() % 255 / 255.0;
    cell.color = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    cell.imageUrl = [self imageUrls][indexPath.row];
    return  cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //利用ZZWidgetImageBrowser显示网络图片
    if ([ZZWidgetImageBrowser shareInstanse].zzLoadImageBlock == nil) {
        [ZZWidgetImageBrowser shareInstanse].zzLoadImageBlock = ^(UIImageView *imageView, NSString *imageUrl, ZZWidgetImageLoadingView *loadingView, ZZWidgetImageBrowserVoidBlock finished) {
            
            [loadingView zz_hide];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {

            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                finished == nil ? : finished();
            }];
        };
    }
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
