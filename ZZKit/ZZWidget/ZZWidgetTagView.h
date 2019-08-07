//
//  ZZWidgetTagView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/8/6.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZTagButtonConfig, ZZTagConfig, ZZTagModel;

typedef NS_ENUM(NSInteger, ZZTagViewPattern) {
    
    ZZTagViewPatternFixedWidthDynamicHeight,          // 固定宽度，高度随控件增加而增加
    ZZTagViewPatternFixedHeightDynamicWidth,          // 固定高度，宽度随控件增加而增加
    ZZTagViewPatternFixedWidthFixedHeightVertical,    // 固定宽度和高度，垂直均分
    ZZTagViewPatternFixedWidthFixedHeightHorizontal   // 固定宽度和高度，水平均分
};

#pragma mark - ZZWidgetTagView

@interface ZZWidgetTagView : UIView

- (instancetype)initWithFrame:(CGRect)frame pattern:(ZZTagViewPattern)pattern;

// 设置点击Tag事件的Block
@property (nonatomic, copy) void(^zzTagTappedBlock)(__kindof ZZTagModel *tag);

// 设置Multi点击Tag事件的Block
@property (nonatomic, copy) void(^zzTagMultiTappedBlock)(__kindof ZZTagModel *tag, BOOL selected);

// 添加Tags
- (void)zz_addTags:(nonnull NSArray<ZZTagModel *> *)tags;

// 添加Tags(Config)
- (void)zz_addTags:(nonnull NSArray<ZZTagModel *> *)tags config:(nullable ZZTagConfig*)config;

// 插入Tags
- (void)zz_insertTag:(nonnull ZZTagModel *)tag atIndex:(NSUInteger)index;

// 插入Tags(Config)
- (void)zz_insertTag:(nonnull ZZTagModel *)tag atIndex:(NSUInteger)index config:(nullable ZZTagConfig*)config;

// 删除Tags(名称)
- (void)zz_removeTag:(nonnull ZZTagModel *)tag;

// 删除Tags(Index)
- (void)zz_removeTagAt:(NSUInteger)index;

// 删除所有Tags
- (void)zz_removeAllTags;

// 获取TagCollectionView的大小
- (CGSize)zz_getTagViewSize;

// 获取所有Tags
- (NSArray<ZZTagModel *> *)zz_allTags;

// 获取所有已选的Tags
- (NSArray<ZZTagModel *> *)zz_allSelectedTags;

// 刷新UI
// 自动根据设置的固定宽度调整高度
// 或者当设置固定高度后自动调节间距
// 带callback
- (CGSize)zz_refresh;

// 重置所有TagButton
- (void)zz_reset;

// 计算控件高度
+ (CGSize)zz_calculateSize:(CGFloat)width tags:(nonnull NSArray<ZZTagModel *> *)tags config:(nonnull ZZTagConfig*)config;

@end

#pragma mark - ZZTagButtonConfig

@interface ZZTagButtonConfig : NSObject

// Tag的背景颜色
@property (nonatomic, strong, nullable) UIColor *zzBackgroundColor;

// Tag的字体颜色
@property (nonatomic, strong, nullable) UIColor *zzTitleColor;

// Tag的字体
@property (nonatomic, strong, nullable) UIFont *zzTitleFont;

// Tag的边框宽度
@property (nonatomic, assign) CGFloat zzBorderWidth;

// Tag的边框颜色
@property (nonatomic, strong, nullable) UIColor *zzBorderColor;

// Tag的Corner Radius
@property (nonatomic, assign) CGFloat zzCornerRadius;

// Tag是否多选
@property (nonatomic, assign) BOOL zzEnableMultiTap;

// Tag勾选图片(NSString, UIImage)
@property (nonatomic, strong, nullable) id zzSelectedImage;

// Tag勾选图片 EdgeInsets
@property (nonatomic, assign) UIEdgeInsets zzSelectedImageEdgeInsets;

// Tag的Highlighted字体颜色(当zz_enableMultiTap为YES有效)
@property (nonatomic, strong, nullable) UIColor *zzMultiTappedTitleColor;

// Tag的Highlighted字体(当zz_enableMultiTap为YES有效)
@property (nonatomic, strong, nullable) UIFont *zzMultiTappedTitleFont;

// Tag的Highlighted背景颜色(当zz_enableMultiTap为YES有效)
@property (nonatomic, strong, nullable) UIColor *zzMultiTappedBackgroundColor;

// Tag的Highlighted边框宽度
@property (nonatomic, assign) CGFloat zzMultiTappedBorderWidth;

// Tag的Highlighted边框颜色(当zz_enableMultiTap为YES有效)
@property (nonatomic, strong, nullable) UIColor *zzMultiTappedBorderColor;

// Tag的Disabled字体颜色
@property (nonatomic, strong, nullable) UIColor *zzDisabledTitleColor;

// Tag的Disabled字体
@property (nonatomic, strong, nullable) UIFont *zzDisabledTitleFont;

// Tag的Disabled背景颜色
@property (nonatomic, strong, nullable) UIColor *zzDisabledBackgroundColor;

// Tag的Highlighted边框宽度
@property (nonatomic, assign) CGFloat zzDisabledBorderWidth;

// Tag的Disabled边框颜色
@property (nonatomic, strong, nullable) UIColor *zzDisabledBorderColor;

@end

#pragma mark - ZZTagConfig

@interface ZZTagConfig : ZZTagButtonConfig

// Padding EdgeInsets
@property (nonatomic, assign) UIEdgeInsets zzEdgeInsets;

// Item Horizontal Space
@property (nonatomic, assign) CGFloat zzItemHorizontalSpace;

// Item Vertical Space
@property (nonatomic, assign) CGFloat zzItemVerticalSpace;

// 每行固定个数 (值大于0时,横向间距zz_itemMinWidth失效)
@property (nonatomic, assign) NSInteger zzNumsPerRow;

// Item Minmun Width(zz_numsPerRow值大于0时,zz_itemMinWidth失效)
@property (nonatomic, assign) CGFloat zzItemMinWidth;

// Item Minmun Height
@property (nonatomic, assign) CGFloat zzItemMinHeight;

// Item Text Padding (For Each Side)
@property (nonatomic, assign) CGFloat zzItemTextPadding;

// Debug(色块显示边距)
@property (nonatomic, assign) BOOL zzDebug;

@end

#pragma mark - ZZTagModel

@interface ZZTagModel : NSObject

@property (nonatomic, copy, nonnull)   NSString *zzName;
@property (nonatomic, assign) BOOL     zzSelected;
@property (nonatomic, assign) BOOL     zzDisabled;
@property (nonatomic, strong, nullable) id       zzReservedData;

- (instancetype)initWithName:(nonnull NSString *)name;

- (instancetype)initWithName:(nonnull NSString *)name selected:(BOOL)selected;

- (instancetype)initWithName:(nonnull NSString *)name selected:(BOOL)selected reservedData:(nullable id)reservedData;

- (instancetype)initWithName:(nonnull NSString *)name selected:(BOOL)selected disabled:(BOOL)disbaled;

- (instancetype)initWithName:(nonnull NSString *)name selected:(BOOL)selected disabled:(BOOL)disbaled reservedData:(nullable id)reservedData;

// 创建ZZTagModel（默认selected为NO）
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name;

// 创建ZZTagModel
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name selected:(BOOL)selected;

// 创建ZZTagModel
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name reservedData:(nullable id)reservedData;

// 创建ZZTagModel
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name selected:(BOOL)selected reservedData:(nullable id)reservedData;

// 创建ZZTagModel
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name selected:(BOOL)selected disabled:(BOOL)disbaled;

// 创建ZZTagModel
+ (ZZTagModel*)zz_tagName:(nonnull NSString *)name selected:(BOOL)selected disabled:(BOOL)disbaled reservedData:(nullable id)reservedData;

@end


@protocol ZZTagModel <NSObject>

@end

#pragma mark - ZZTextButton

@interface ZZTextButton : UIButton

@property (nonatomic, strong) __kindof ZZTagModel *zzTag;

- (void)zz_setTitle:(nonnull NSString *)title selected:(BOOL)selected disabled:(BOOL)disabled config:(nonnull ZZTagButtonConfig *)config;

- (BOOL)zz_selected;

- (void)zz_reset;

@end

#pragma mark - NSArray (ZZTagModel)

@interface NSArray (ZZTagModel)

// 是否包含TagModel (判断tag名称)
- (BOOL)zz_containsTagName:(nonnull NSString *)tag;

// 是否包含TagModel (判断内存)
- (BOOL)zz_containsTagModel:(nonnull ZZTagModel *)tagModel;

// 删除TagModel (判断tag名称)
- (void)zz_removeTagName:(nonnull ZZTagModel *)tagModel;

// 删除TagModel (判断内存)
- (void)zz_removeTagModel:(nonnull ZZTagModel *)tagModel;

@end


NS_ASSUME_NONNULL_END
