//
//  ZZPhotoTagAlertView.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/6.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZPhotoTagAlertView.h"
#import "ZZMacro.h"
#import "UIView+ZZKit.h"

@interface ZZPhotoTagAlertView()

@property(nonatomic, copy) void(^deleteBlock)(void);
@property(nonatomic, copy) void(^switchBlock)(void);

@end

@implementation ZZPhotoTagAlertView

- (void)dealloc {
    
}

+ (ZZPhotoTagAlertView *)create:(CGRect)frame deleteBlock:(void(^)(void))deleteBlock switchBlock:(void(^)(void))switchBlock {
    
    ZZPhotoTagAlertView *view = ZZ_LOAD_NIB(@"ZZPhotoTagAlertView");
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
