//
//  NSString+ZZKit.h
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZZStringTrimmingType) {
    ZZStringTrimmingTypeNone,                     // 不去除空格
    ZZStringTrimmingTypeDefault,                  // 默认（去除两端的空格）
    ZZStringTrimmingTypeWhiteSpace,               // 去除两端的空格
    ZZStringTrimmingTypeWhiteSpaneAndNewline,     // 去除两端的空格和回车
    ZZStringTrimmingTypeAllSpace                  // 去除所有的空格
};

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZZKit)

#pragma mark - Color

/**
 *  获取颜色
 */
- (UIColor *)zz_color;

/**
 *  获取颜色, alpha
 */
- (UIColor *)zz_color:(CGFloat)alpha;

#pragma mark - 图片

/**
 *  根据String获取Image
 *  “AA”.zz_image,当前app包的图片AA
 *  "BB.AA".zz_image,BB为类时，返回BB所在app包的图片AAl；当BB非类时，返回当前app包的BB的Bundle中图片AA
 *  "CC.BB.AA".zz_image, CC必须为类，BB必须为Bundle名称，AA为图片名称
 */
- (UIImage *)zz_image;

/**
 * Base64字符串转UIImage
 */
- (UIImage *)zz_base64toImage;

#pragma mark - 校验、比较、转换

/**
 *  去除空格字符
 */
- (NSString *)zz_trim:(ZZStringTrimmingType)type;

/**
 *  是否包含相同的字符串（大小写敏感）
 */
- (BOOL)zz_containsStringMatchingCase:(NSString *)aString;

/**
 *  是否包含相同的字符串（大小写不敏感）
 */
- (BOOL)zz_containsStringIgnoringCase:(NSString *)aString;

/**
 *  是否包含Emoji
 */
- (BOOL)zz_containsEmoji;

/**
 *  字符串是否相同（空格去除可控，大小写敏感）
 */
- (BOOL)zz_isEqual:(NSString *)aString type:(ZZStringTrimmingType)type;

/**
 *  字符串是否相同（空格不可去除，大小写敏感可控）
 */
- (BOOL)zz_isEqual:(NSString *)aString ignoringCase:(BOOL)ignoringCase;

/**
 *  字符串是否相同（空格去除可控，大小写敏感可控）
 */
- (BOOL)zz_isEqual:(NSString *)aString type:(ZZStringTrimmingType)type ignoringCase:(BOOL)ignoringCase;

/**
 *  去除所有空格，是否为空
 */
- (BOOL)zz_isEmptyTrimmingAllSpace;

/**
 *  截取两段字符串之间的子字符串
 */
- (NSString *)zz_substringFromSting:(NSString *)fromString toString:(NSString *)toString;

/**
 *  获取字符串Byte数（汉字2byte，英文1byte）
 */
- (NSUInteger)zz_bytesLength;

/**
 *  首字母是否是英文字母
 */
- (BOOL)zz_isTopCharacterLetter;

/**
 *  首字母是否小写
 */
- (BOOL)zz_isTopLowerCaseAlphabetic;

/**
 *  首字母是否大写
 */
- (BOOL)zz_isTopUpperCaseAlphabetic;

/**
 *  比较版本字符串大小，是否大于right
 */
- (BOOL)zz_greaterThan:(NSString *)right;

/**
 *  比较版本字符串大小，是否大于等于right
 */
- (BOOL)zz_greaterThanOrEqualTo:(NSString *)right;

/**
 *  比较版本字符串大小，是否小于right
 */
- (BOOL)zz_lessThan:(NSString *)right;

/**
 *  比较版本字符串大小，是否小于等于right
 */
- (BOOL)zz_lessThanOrEqualTo:(NSString *)right;

/**
 *  中国固定电话
 */
- (BOOL)zz_validChineseLandLine;

/**
 *  中国手机号码
 */
- (BOOL)zz_validChineseMobile;

/**
 *  邮件合法性校验
 */
- (BOOL)zz_validEmail;

/**
 *  用户名合法性校验,允许输入[X,Y]位字母、数字、下划线的组合
 */
- (BOOL)zz_validUserName:(NSUInteger)shortest longest:(NSUInteger)longest enableUnderLine:(BOOL)enableUnderLine enableNumber:(BOOL)enableNumber initialAlphabetic:(BOOL)initialAlphabetic;

/**
 *  两次密码的合法性校验
 */
- (BOOL)zz_validPassword:(NSString *)password another:(NSString *)anotherPassword;

/**
 *  判断全汉字
 */
- (BOOL)zz_isChinese;

/**
 *  判断全数字（正整数和小数）
 */
- (BOOL)zz_isNumeric;

/**
 *  判断全字母
 */
- (BOOL)zz_isAlphabetic;

/**
 *  判断仅输入字母或数字
 */
- (BOOL)zz_isAlphabeticOrNumeric;

#pragma mark - 字符串尺寸、高度和宽度计算

/**
 *  计算限宽行高（字体，宽度）
 */
- (CGFloat)zz_height:(UIFont *)font renderWidth:(CGFloat)renderWidth enableCeil:(BOOL)enableCeil;

/**
 *  计算单行宽度（字体）
 */
- (CGFloat)zz_width:(UIFont *)font enableCeil:(BOOL)enableCeil;

/**
 *  计算单行行高（字体）
 */
- (CGFloat)zz_height:(UIFont *)font enableCeil:(BOOL)enableCeil;

/**
 *  计算限制显示行数（字体，字间距，行数，限制单行最大最小间距，渲染画布尺寸）
 */
- (CGFloat)zz_height:(UIFont *)font kern:(CGFloat)kern limitedlineHeight:(CGFloat)limitedlineHeight renderWidth:(CGFloat)renderWidth maxLineCount:(int)maxLineCount enableCeil:(BOOL)enableCeil;

/**
 *  计算字体渲染宽高（字体，字间距，行间距，换行模式，限制单行最大最小间距，渲染画布尺寸）
 */
- (CGSize)zz_size:(UIFont *)font kern:(CGFloat)kern space:(CGFloat)space linebreakmode:(NSLineBreakMode)linebreakmode limitedlineHeight:(CGFloat)limitedlineHeight renderSize:(CGSize)renderSize;

/**
 *  计算字体渲染宽高（字体，字间距，行间距，换行模式，最大单行间距，最小单行间距，文字排版模式，渲染画布尺寸）
 */
- (CGSize)zz_size:(UIFont *)font kern:(CGFloat)kern space:(CGFloat)space linebreakmode:(NSLineBreakMode)linebreakmode maxLineHeight:(CGFloat)maxLineHeight minLineHeight:(CGFloat)minLineHeight textAlignment:(NSTextAlignment)textAlignment renderSize:(CGSize)renderSize;

#pragma mark - NSURL, NSURLRequest

/**
 *  NSString转NSURL
 */
- (NSURL *)zz_URL;

/**
 *  NSString转NSURLRequest
 */
- (NSURLRequest *)zz_URLRequest;

#pragma mark - JSON字符串处理

/**
 *  JSON字符串转NSDictionary或NSArray
 */
- (id)zz_jsonToCocoaObject;

#pragma mark - Cookie字符串处理

/**
 *  将单条Cookie字符串转成NSHTTPCookie对象
 *  Cookie的规范可以见相应的RFC文档
 *  http://tools.ietf.org/html/rfc6265
 */
- (NSHTTPCookie *)zz_cookie;

/**
 *  Cookie字符串转NSDictionary
 */
- (NSDictionary *)zz_cookieToDictionary;

/**
 *  获取 Cookie Properties
 */
- (NSDictionary *)zz_cookieProperties;

#pragma mark - 哈希

/**
 *  字符串的MD5值
 */
- (NSString *)zz_md5;

#pragma mark - UUID

/**
 *  UUID - IDFA
 */
+ (NSString *)zz_uuidIDFA;

/**
 *  UUID - IDFA Trimming Line
 */
+ (NSString *)zz_uuidIDFATrimmingLine;

/**
 *  UUID - IDFV
 */
+ (NSString *)zz_uuidIDFV;

/**
 *  UUID - IDFV Trimming Line
 */
+ (NSString *)zz_uuidIDFVTrimmingLine;

/**
 *  UUID - 随机UUID
 */
+ (NSString *)zz_uuidRandom;

/**
 *  UUID - 随机UUID Trimming Line
 */
+ (NSString *)zz_uuidRandomTrimmingLine;

/**
 *  UUID - 随机UUID + 时间戳TimeStamp
 */
+ (NSString *)zz_uuidRandomTimestamp;

/**
 *  UUID - 随机UUID + 时间戳TimeStamp Trimming Line
 */
+ (NSString *)zz_uuidRandomTimestampTrimmingLine;

/**
 *  UUID - OpenUDID(iOS6后已废弃使用)
 */
+ (NSString *)zz_uuidOpenUDID;

#pragma mark - UUID

/**
 *  Error - 转Error
 */
- (NSError *)zz_error;

@end

NS_ASSUME_NONNULL_END
