//
//  ImageClCell.m
//  ZZWidgetImageBrowserDemo
//

#import "ImageClCell.h"
#import "UIImageView+WebCache.h"

@interface ImageClCell ()
{
    UIImageView *_imageView;
}
@end

@implementation ImageClCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI
{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = true;
    [self.contentView addSubview:_imageView];
}


-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    __weak typeof(self) weakSelf = self;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"PlaceHolder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_imageView.contentMode = UIViewContentModeScaleAspectFit;
    }];
}

-(void)setImagePath:(NSString *)imagePath
{
    _imagePath = imagePath;
    _imageView.image = [UIImage imageWithContentsOfFile:imagePath];
}

@end
