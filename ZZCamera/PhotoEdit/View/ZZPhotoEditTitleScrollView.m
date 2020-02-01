//
//  ZZPhotoEditTitleScrollView.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZPhotoEditTitleScrollView.h"
#import <SMPageControl/SMPageControl.h>
#import <Masonry/Masonry.h>
#import "ZZMacro.h"
#import "NSString+ZZKit.h"

@interface ZZPhotoEditTitleScrollView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) SMPageControl *pageControl;

@end

@implementation ZZPhotoEditTitleScrollView

- (void)dealloc
{
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    SMPageControl *pageControl = [[SMPageControl alloc] init];
    [pageControl setUserInteractionEnabled:NO];
    pageControl.numberOfPages = 9;
    pageControl.pageIndicatorImage = @"ZZPhotoEditTitleScrollView.ic_pagecontrol_unselected".zz_image;
    pageControl.currentPageIndicatorImage = @"ZZPhotoEditTitleScrollView.ic_pagecontrol_selected".zz_image;
    [self addSubview:pageControl];
    ZZ_WEAK_SELF
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
    }];
    [pageControl sizeToFit];
    self.pageControl = pageControl;
}

+ (ZZPhotoEditTitleScrollView *)create:(NSUInteger)count {
    
    ZZPhotoEditTitleScrollView *view = ZZ_LOAD_NIB(@"ZZPhotoEditTitleScrollView");
    [view updateTitle:@"编辑图片"];
    if (count < 2) {
        view.pageControl.hidden = YES;
    }else {
        view.pageControl.hidden = NO;
    }
    view.pageControl.numberOfPages = count;
    return view;
}

- (void)updateTitle:(NSString *)title {
    
    self.titleLabel.text = title;
}

- (void)updateCount:(NSUInteger)count {
    
    self.pageControl.numberOfPages = count;
}

- (void)updateIndex:(NSUInteger)index {
    
    self.pageControl.currentPage = index;
}

- (NSUInteger)currentIndex {
    
    return self.pageControl.currentPage;
}

- (void)setPageControllHidden:(BOOL)hidden {
    
    self.pageControl.hidden = hidden;
}

- (CGSize)intrinsicContentSize {
    
    return CGSizeMake(240, 48);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
