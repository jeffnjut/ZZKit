//
//  NSObject+Camera_Popup.m
//  FJCamera
//
//  Created by Fu Jie on 2019/4/11.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import "NSObject+Camera_Popup.h"
#import "FJPhotoDraftEditPopupView.h"
#import "ZZMacro.h"
#import "ZZDevice.h"

@implementation NSObject (Camera_Popup)

// 弹出编辑窗口
+ (void)popupDraftEditTool:(void(^)(void))editBlock {
    
    FJPhotoDraftEditPopupView *view = ZZ_LOAD_NIB(@"FJPhotoDraftEditPopupView");
    view.frame = CGRectMake(0, 0, ZZDevice.zz_screenWidth, 48.0);
    view.zzPopupAppearAnimation = ZZPopupViewAnimationPopBottom;
    [ZZ_KEY_WINDOW zz_popup:view blurColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] userInteractionEnabled:YES springs:nil actionBlock:^(id  _Nonnull value) {
        if ([value isEqualToString:@"1"]) {
            editBlock == nil ? : editBlock();
        }
    }];
}

@end
