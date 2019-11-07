//
//  FJPhotoDraftEditPopupView.m
//  FJCamera
//
//  Created by Fu Jie on 2019/4/11.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import "FJPhotoDraftEditPopupView.h"

@implementation FJPhotoDraftEditPopupView

-(IBAction)_tapEdit:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    self.zzPopupDisappearAnimationBlock(^{
        weakSelf.zzPopupActionBlock == nil ? : weakSelf.zzPopupActionBlock(@"1");
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
