//
//  BannerClCell.m
//  ZZWidgetImageBrowserDemo
//
//  Created by Jeff on 2017/8/2.
//  Copyright © 2017年 Jeff. All rights reserved.
//

#import "BannerClCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BannerClCell()

@property (nonatomic, strong) UIImageView *iv_banner;

@end

@implementation BannerClCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIImageView *_imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    self.iv_banner = _imageView;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.iv_banner.backgroundColor = color;
    
}

-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    [self.iv_banner sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
}

@end
