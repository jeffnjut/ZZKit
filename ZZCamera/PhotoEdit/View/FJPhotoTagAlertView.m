//
//  FJPhotoTagAlertView.m
//  FJCamera
//
//  Created by Fu Jie on 2018/11/6.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "FJPhotoTagAlertView.h"
#import "ZZMacro.h"
#import "UIView+ZZKit.h"

@interface FJPhotoTagAlertView()

@property(nonatomic, copy) void(^deleteBlock)(void);
@property(nonatomic, copy) void(^switchBlock)(void);

@end

@implementation FJPhotoTagAlertView

- (void)dealloc {
    
}

+ (FJPhotoTagAlertView *)create:(CGRect)frame deleteBlock:(void(^)(void))deleteBlock switchBlock:(void(^)(void))switchBlock {
    
    FJPhotoTagAlertView *view = ZZ_LOAD_NIB(@"FJPhotoTagAlertView");
    view.frame = frame;
    [view zz_cornerRadius:4.0];
    view.deleteBlock = deleteBlock;
    view.switchBlock = switchBlock;
    return view;
}

- (IBAction)_tapDelete:(id)sender {
    
    self.deleteBlock == nil ? : self.deleteBlock();
}

- (IBAction)_tapSwitch:(id)sender {
    
    self.switchBlock == nil ? : self.switchBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
