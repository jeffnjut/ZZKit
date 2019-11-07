//
//  FJImageTagModel.h
//  FJCamera
//
//  Created by Fu Jie on 2018/10/31.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// (0：话题 1：商家 20：人民币，21：美元，22：欧元)
typedef NS_ENUM(NSUInteger, FJImageTagType) {
    
    FJImageTagTypeTopic = 0,        // 话题标签 Topic Tag
    FJImageTagTypeStore = 1,        // 商家标签 Store Tag
    FJImageTagTypePriceRMB = 20,    // 货币标签 人民币 RMB Tag
    FJImageTagTypePriceDollar = 21, // 货币标签 美元 DOLLAR Tag
    FJImageTagTypePriceEuro = 22,   // 货币标签 欧元 EURO Tag
    FJImageTagTypeActivity = 30     // 活动标签 Activity Tag
};

@protocol FJImageTagModel <NSObject>
@end

@interface FJImageTagModel : NSObject

// Tag的ID
@property (nonatomic, copy) NSString *tagId;
// Tag的名称
@property (nonatomic, copy) NSString *name;
// Tag的类型(0：话题 1：商家 20：人民币，21：美元，22：欧元)
@property (nonatomic, assign) FJImageTagType type;
// 图片上的x偏移比例 (版本0以左上角的坐标位置占全图为比例，版本1以Ripple点的中心坐标占全图为比例)
@property (nonatomic, assign) float xPercent;
// 图片上的y偏移比例
@property (nonatomic, assign) float yPercent;
// Tag方向
@property (nonatomic, assign) int direction;
// Tag创建时间
@property (nonatomic, assign) long long createdTime;
// Tag版本号
@property (nonatomic, copy) NSString *v;
// Tag状态 @“0”表示正常  其它异常
@property (nonatomic, copy) NSString *status;

// Tag View Frame (计算后填入，用于页面滑动刷新)
@property (nonatomic, assign) CGRect adjustedFrame;
// isHint
@property (nonatomic, assign) BOOL isHint;

@end
