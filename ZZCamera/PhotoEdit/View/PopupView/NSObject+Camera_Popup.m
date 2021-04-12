//
//  NSObject+Camera_Popup.m
//  ZZCamera
//
//  Created by Fu Jie on 2019/4/11.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import "NSObject+Camera_Popup.h"
#import "ZZPhotoDraftEditPopupView.h"
#import "ZZMacro.h"
#import "ZZDevice.h"

@implementation NSObject (Camera_Popup)

// 弹出编辑窗口
+ (void)popupDraftEditTool:(void(^)(void))editBlock {
    
    ZZPhotoDraftEditPopupView *view = ZZ_LOAD_NIB(@"ZZPhotoDraftEditPopupView");
    view.frame = CGRectMake(0, 0, ZZDevice.zz_screenWidth, 48.0);
    view.zzPopupAppearAnimation = ZZPopupViewAnimationPopBottom;
    [view zz_popup:^(id  _Nonnull value) {
        if ([value isEqualToString:@"1"]) {
            editBlock == nil ? : editBlock();
        }
    }];
}

@end
