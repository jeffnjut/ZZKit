//
//  TestPopupView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/6.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestPopupView.h"
#import "UIView+ZZKit_Blocks.h"

@interface TestPopupView ()


@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation TestPopupView

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

- (IBAction)_tap:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    self.zzPopupDisappearAnimationBlock(^{
        weakSelf.zzPopupActionBlock == nil ? : weakSelf.zzPopupActionBlock(@(weakSelf.imageView.image.hash));
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
