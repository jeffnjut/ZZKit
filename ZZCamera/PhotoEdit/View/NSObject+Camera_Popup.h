//
//  NSObject+Camera_Popup.h
//  FJCamera
//
//  Created by Fu Jie on 2019/4/11.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Camera_Popup)


// 弹出编辑窗口
+ (void)popupDraftEditTool:(void(^)(void))editBlock;

@end
