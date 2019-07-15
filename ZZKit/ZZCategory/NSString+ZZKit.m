//
//  NSString+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "NSString+ZZKit.h"
#import "UIColor+ZZKit.h"
#import "NSBundle+ZZKit.h"
#import <CommonCrypto/CommonCrypto.h>
#import <AdSupport/AdSupport.h>
#import <OpenUDID/OpenUDID.h>

@interface _ZZImageTemporaryObject : NSObject

@end

@implementation _ZZImageTemporaryObject

@end

@implementation NSString (ZZKit)

#pragma mark - Color

/**
 *  获取颜色
 */
- (UIColor *)zz_color {
    
    if ([self characterAtIndex:0] == '#') {
        if ([self length] == 9) {
            NSString *colorHex = [self substringToIndex:7];
            NSString *alphaPercent = [self substringFromIndex:7];
            float alpha = [alphaPercent floatValue] / 100.0;
            return [UIColor zz_colorHexString:colorHex withAlpha:alpha];
        }else if ([self length] == 7) {
            return [UIColor zz_colorHexString:self];
        }
    }else{
        if ([self length] == 8) {
            NSString *colorHex = [NSString stringWithFormat:@"#%@",[self substringToIndex:6]];
            NSString *alphaPercent = [self substringFromIndex:6];
            float alpha = [alphaPercent floatValue] / 100.0;
            return [UIColor zz_colorHexString:colorHex withAlpha:alpha];
        }else if ([self length] == 6) {
            return [UIColor zz_colorHexString:[NSString stringWithFormat:@"#%@",self]];
        }
    }
    return nil;
}

/**
 *  获取颜色, alpha
 */
- (UIColor *)zz_color:(CGFloat)alpha {
    
    return [[self zz_color] colorWithAlphaComponent:alpha];
}

#pragma mark - 图片

/**
 *  根据String获取Image
 *  “AA”.zz_image,当前app包的图片AA
 *  "BB.AA".zz_image,BB为类时，返回BB所在app包的图片AAl；当BB非类时，返回当前app包的BB的Bundle中图片AA
 *  "CC.BB.AA".zz_image, CC必须为类，BB必须为Bundle名称，AA为图片名称
 */
- (UIImage *)zz_image {
    
    UIImage *image = nil;
    if (![self containsString:@"."]) {
        image = [UIImage imageNamed:self];
        if (image != nil) {
            return image;
        }
    }
    NSArray *components = [self componentsSeparatedByString:@"."];
    if (components.count < 2) {
        return nil;
    }
    NSString *className = nil;
    NSString *bundleName = nil;
    NSString *imageName = nil;
    Class cls = nil;
    if (components.count == 2) {
        className = [components objectAtIndex:0];
        imageName = [components objectAtIndex:1];
        cls = NSClassFromString(className);
        if (cls == nil) {
            // 当cls为空时，代表className并不是类名，而是Bundle名称（ZZKit Class Package下）
            cls = [_ZZImageTemporaryObject class];
            bundleName = className;
        }
    }else if (components.count == 3) {
        className = [components objectAtIndex:0];
        bundleName = [components objectAtIndex:1];
        imageName =[components objectAtIndex:2];
        cls = NSClassFromString(className);
    }
    return [NSBundle zz_image:imageName extension:nil class:cls bunldeName:bundleName memCache:NO];
}

/**
 * Base64字符串转UIImage
 */
- (UIImage *)zz_base64toImage {
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:self options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    if (decodedData == nil) {
        NSString *base64Str = [[self componentsSeparatedByString:@"base64,"] lastObject];
        if (base64Str == nil) {
            return nil;
        }
        decodedData = [[NSData alloc] initWithBase64EncodedString:base64Str options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    }
    // 将NSData转为UIImage
    UIImage *decodedImage = [UIImage imageWithData:decodedData];
    return decodedImage;
}

#pragma mark - 校验、比较、转换

/**
 *  去除空格字符
 */
- (NSString *)zz_trim:(ZZStringTrimmingType)type {
    
    switch (type) {
        case ZZStringTrimmingTypeDefault:
        case ZZStringTrimmingTypeWhiteSpace:
        {
            return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        case ZZStringTrimmingTypeWhiteSpaneAndNewline:
        {
            return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        case ZZStringTrimmingTypeAllSpace:
        {
            return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        case ZZStringTrimmingTypeNone:
        default:break;
    }
    return self;
}

/**
 *  是否包含相同的字符串（大小写敏感）
 */
- (BOOL)zz_containsStringMatchingCase:(NSString *)aString {
    
    NSRange range = [self rangeOfString:aString];
    return (range.length > 0);
}

/**
 *  是否包含相同的字符串（大小写不敏感）
 */
- (BOOL)zz_containsStringIgnoringCase:(NSString *)aString {
    
    NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
    return (range.length > 0);
}

/**
 *  是否包含Emoji
 */
- (BOOL)zz_containsEmoji {
    
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                              } else if (substring.length > 1) {
                                  const unichar ls = [substring characterAtIndex:1];
                                  if (ls == 0x20e3) {
                                      returnValue = YES;
                                  }
                              } else {
                                  if (0x2100 <= hs && hs <= 0x27ff) {
                                      returnValue = YES;
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      returnValue = YES;
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      returnValue = YES;
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      returnValue = YES;
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      returnValue = YES;
                                  }
                              }
                          }];
    return returnValue;
}

/**
 *  字符串是否相同（空格去除可控，大小写敏感）
 */
- (BOOL)zz_isEqual:(NSString *)aString type:(ZZStringTrimmingType)type {
    
    return [self zz_isEqual:aString type:type ignoringCase:NO];
}

/**
 *  字符串是否相同（空格不可去除，大小写敏感可控）
 */
- (BOOL)zz_isEqual:(NSString *)aString ignoringCase:(BOOL)ignoringCase {
    
    return [self zz_isEqual:aString type:ZZStringTrimmingTypeNone ignoringCase:ignoringCase];
}

/**
 *  字符串是否相同（空格去除可控，大小写敏感可控）
 */
- (BOOL)zz_isEqual:(NSString *)aString type:(ZZStringTrimmingType)type ignoringCase:(BOOL)ignoringCase {
    
    NSString *strSelf = [self zz_trim:type];
    NSString *strCompare = [aString zz_trim:type];
    if (ignoringCase) {
        return ([strSelf caseInsensitiveCompare:strCompare] == NSOrderedSame);
    }else{
        return [strSelf isEqualToString:strCompare];
    }
}

/**
 *  去除所有空格，是否为空
 */
- (BOOL)zz_isEmptyTrimmingAllSpace {
    
    NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string == nil || string.length == 0;
}

/**
 *  截取两段字符串之间的子字符串
 */
- (NSString *)zz_substringFromSting:(NSString *)fromString toString:(NSString *)toString {
    
    NSRange startRange = [self rangeOfString:fromString];
    NSRange endRange = [self rangeOfString:toString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
}

/**
 *  获取字符串Byte数（汉字2byte，英文1byte）
 */
- (NSUInteger)zz_bytesLength {
    
    int lenght = 0;
    for(int i=0; i< [self length]; i++) {
        int c = [self characterAtIndex:i];
        if( c > 0x4e00 && c < 0x9fff) {
            // 中文
            lenght += 2;
        }else {
            lenght += 1;
        }
    }
    return lenght;
}

/**
 *  首字母是否是英文字母
 */
- (BOOL)zz_isTopCharacterLetter {
    
    if ([self zz_isTopLowerCaseAlphabetic] || [self zz_isTopUpperCaseAlphabetic]) {
        return YES;
    }
    return NO;
}

/**
 *  首字母是否小写
 */
- (BOOL)zz_isTopLowerCaseAlphabetic {
    
    if ([self characterAtIndex:0] >= 'a' && [self characterAtIndex:0] <= 'z') {
        return YES;
    }
    return NO;
}

/**
 *  首字母是否大写
 */
- (BOOL)zz_isTopUpperCaseAlphabetic {
    
    if ([self characterAtIndex:0] >= 'A' && [self characterAtIndex:0] <= 'Z') {
        return YES;
    }
    return NO;
}

/**
 *  比较版本字符串大小，是否大于right
 */
- (BOOL)zz_greaterThan:(NSString *)right {
    
    if (right == nil) {
        return YES;
    }else if ([self isEqualToString:right]) {
        return NO;
    }else {
        NSArray *leftArr = [self componentsSeparatedByString:@"."];
        NSArray *rightArr = [right componentsSeparatedByString:@"."];
        int left = 0;
        int right = 0;
        if ([leftArr count] == [rightArr count]) {
            // 版本格式一致
            for (int i = 0; i < [leftArr count]; i++) {
                left += ([leftArr[i] intValue] * pow(10, ([leftArr count] - i)));
                right += ([rightArr[i] intValue] * pow(10, ([rightArr count] - i)));
            }
            
            if (left == right) {
                return NO;
            }else if (left < right) {
                return NO;
            }else {
                return YES;
            }
        }else if ([leftArr count] < [rightArr count]) {
            // 版本格式深度前者小于后者
            for (int i = 0; i < [leftArr count]; i++) {
                left += ([leftArr[i] intValue] * pow(10, ([leftArr count] - i)));
                right += ([rightArr[i] intValue] * pow(10, ([leftArr count] - i)));
            }
            if (left <= right) {
                return NO;
            }else {
                return YES;
            }
            
        }else{
            // 版本格式深度前者大于后者
            for (int i = 0; i < [rightArr count]; i++) {
                left += ([leftArr[i] intValue] * pow(10, ([rightArr count] - i)));
                right += ([rightArr[i] intValue] * pow(10, ([rightArr count] - i)));
            }
            if (left >= right) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return NO;
}

/**
 *  比较版本字符串大小，是否大于等于right
 */
- (BOOL)zz_greaterThanOrEqualTo:(NSString *)right {
    
    if (right == nil) {
        return YES;
    }else if ([self isEqualToString:right]) {
        return YES;
    }else {
        NSArray *leftArr = [self componentsSeparatedByString:@"."];
        NSArray *rightArr = [right componentsSeparatedByString:@"."];
        int left = 0;
        int right = 0;
        if ([leftArr count] == [rightArr count]) {
            // 版本格式一致
            for (int i = 0; i < [leftArr count]; i++) {
                left += ([leftArr[i] intValue] * pow(10, ([leftArr count] - i)));
                right += ([rightArr[i] intValue] * pow(10, ([rightArr count] - i)));
            }
            
            if (left == right) {
                return YES;
            }else if (left < right) {
                return NO;
            }else {
                return YES;
            }
        }else if ([leftArr count] < [rightArr count]) {
            // 版本格式深度前者小于后者
            for (int i = 0; i < [leftArr count]; i++) {
                left += ([leftArr[i] intValue] * pow(10, ([leftArr count] - i)));
                right += ([rightArr[i] intValue] * pow(10, ([leftArr count] - i)));
            }
            if (left <= right) {
                return NO;
            }else {
                return YES;
            }
            
        }else{
            // 版本格式深度前者大于后者
            for (int i = 0; i < [rightArr count]; i++) {
                left += ([leftArr[i] intValue] * pow(10, ([rightArr count] - i)));
                right += ([rightArr[i] intValue] * pow(10, ([rightArr count] - i)));
            }
            if (left >= right) {
                return YES;
            }else {
                return NO;
            }
        }
    }
    return YES;
}

/**
 *  比较版本字符串大小，是否小于right
 */
- (BOOL)zz_lessThan:(NSString *)right {
    
    return ![self zz_greaterThanOrEqualTo:right];
}

/**
 *  比较版本字符串大小，是否小于等于right
 */
- (BOOL)zz_lessThanOrEqualTo:(NSString *)right {
    
    return ![self zz_greaterThan:right];
}

/**
 *  中国固定电话
 */
- (BOOL)zz_validChineseLandLine {
    
    NSString *regex = @"^((\\+86)|(\\(\\+86\\)))?\\W?((((010|021|022|023|024|025|026|027|028|029|852)|(\\(010\\)|\\(021\\)|\\(022\\)|\\(023\\)|\\(024\\)|\\(025\\)|\\(026\\)|\\(027\\)|\\(028\\)|\\(029\\)|\\(852\\)))\\W\\d{8}|((0[3-9][1-9]{2})|(\\(0[3-9][1-9]{2}\\)))\\W\\d{7,8}))(\\W\\d{1,4})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (([phoneTest evaluateWithObject:self] == YES)) {
        return YES;
    }else{
        return NO;
    }
}

/**
 *  中国手机号码
 */
- (BOOL)zz_validChineseMobile {
    
    NSString *regex = @"^((\\+86)|(\\(\\+86\\)))?(((13[0-9]{1})|(15[0-9]{1})|(17[0-9]{1})|(18[0,5-9]{1}))+\\d{8})$";
    NSPredicate *mobileText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileText evaluateWithObject:self];
}

/**
 *  邮件合法性校验
 */
- (BOOL)zz_validEmail {
    
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([emailTest evaluateWithObject:self] == YES) {
        return YES;
    }else {
        return NO;
    }
}

/**
 *  用户名合法性校验,允许输入[X,Y]位字母、数字、下划线的组合
 */
- (BOOL)zz_validUserName:(NSUInteger)shortest longest:(NSUInteger)longest enableUnderLine:(BOOL)enableUnderLine enableNumber:(BOOL)enableNumber initialAlphabetic:(BOOL)initialAlphabetic {
    
    NSMutableString *regex = [[NSMutableString alloc] init];
    if (initialAlphabetic) {
        [regex appendString:@"^(?!((^[0-9]+$)|(^[_]+$)))"];
    }
    if (enableNumber && enableUnderLine) {
        [regex appendFormat:@"([a-zA-Z0-9_]{%d,%d})$", (int)shortest, (int)longest];
    }else if (enableNumber) {
        [regex appendFormat:@"([a-zA-Z0-9]{%d,%d})$", (int)shortest, (int)longest];
    }else if (enableUnderLine) {
        [regex appendFormat:@"([a-zA-Z_]{%d,%d})$", (int)shortest, (int)longest];
    }else{
        [regex appendFormat:@"([a-zA-Z]{%d,%d})$", (int)shortest, (int)longest];
    }
    NSPredicate *usernameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [usernameTest evaluateWithObject:self];
}

/**
 *  两次密码的合法性校验
 */
- (BOOL)zz_validPassword:(NSString *)password another:(NSString *)anotherPassword {
    
    if (password == nil || password.length == 0 || anotherPassword == nil || anotherPassword.length == 0) {
        return NO;
    }
    return [password isEqualToString:anotherPassword];
}

/**
 *  判断全汉字
 */
- (BOOL)zz_isChinese {
    
    if (self.length == 0) return NO;
    NSString *regex = @"[\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

/**
 *  判断全数字（正整数和小数）
 */
- (BOOL)zz_isNumeric {
    
    NSString *regex = @"^([1-9]\\d*|0)(\\.\\d{1,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

/**
 *  判断全字母
 */
- (BOOL)zz_isAlphabetic {
    
    if (self.length == 0) return NO;
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

/**
 *  判断仅输入字母或数字
 */
- (BOOL)zz_isAlphabeticOrNumeric {
    
    if (self.length == 0) return NO;
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self];
}

#pragma mark - 字符串尺寸、高度和宽度计算

/**
 *  计算限宽行高（字体，宽度）
 */
- (CGFloat)zz_height:(UIFont *)font renderWidth:(CGFloat)renderWidth enableCeil:(BOOL)enableCeil {
    
    CGFloat height = [self zz_size:font kern:0 space:0 linebreakmode:NSLineBreakByWordWrapping limitedlineHeight:0 renderSize:CGSizeMake(renderWidth, MAXFLOAT)].height;
    if (enableCeil) {
        return ceil(height);
    }
    return height;
}

/**
 *  计算单行宽度（字体）
 */
- (CGFloat)zz_width:(UIFont *)font enableCeil:(BOOL)enableCeil {
    
    CGFloat singleWidth = [self zz_size:font kern:0 space:0 linebreakmode:NSLineBreakByWordWrapping limitedlineHeight:0 renderSize:CGSizeMake(MAXFLOAT, 0)].width;
    if (enableCeil) {
        return ceil(singleWidth);
    }
    return singleWidth;
}

/**
 *  计算单行行高（字体）
 */
- (CGFloat)zz_height:(UIFont *)font enableCeil:(BOOL)enableCeil {
    
    CGFloat singleHeight = [self zz_size:font kern:0 space:0 linebreakmode:NSLineBreakByWordWrapping limitedlineHeight:0 renderSize:CGSizeMake(MAXFLOAT, 0)].height;
    if (enableCeil) {
        return ceil(singleHeight);
    }
    return  singleHeight;
}

/**
 *  计算限制显示行数（字体，字间距，行数，限制单行最大最小间距，渲染画布尺寸）
 */
- (CGFloat)zz_height:(UIFont *)font kern:(CGFloat)kern limitedlineHeight:(CGFloat)limitedlineHeight renderWidth:(CGFloat)renderWidth maxLineCount:(int)maxLineCount enableCeil:(BOOL)enableCeil {
    
    CGSize size = [self zz_size:font kern:kern space:0 linebreakmode:NSLineBreakByWordWrapping limitedlineHeight:limitedlineHeight renderSize:CGSizeMake(renderWidth, MAXFLOAT)];
    CGFloat maxHeight = maxLineCount * limitedlineHeight;
    if (enableCeil) {
        return size.height > maxHeight ? ceil(maxHeight) : ceil(size.height);
    }
    return size.height > maxHeight ? maxHeight : size.height;
}

/**
 *  计算字体渲染宽高（字体，字间距，行间距，换行模式，限制单行最大最小间距，渲染画布尺寸）
 */
- (CGSize)zz_size:(UIFont *)font kern:(CGFloat)kern space:(CGFloat)space linebreakmode:(NSLineBreakMode)linebreakmode limitedlineHeight:(CGFloat)limitedlineHeight renderSize:(CGSize)renderSize {
    
    return [self zz_size:font kern:kern space:space linebreakmode:linebreakmode maxLineHeight:limitedlineHeight minLineHeight:limitedlineHeight textAlignment:NSTextAlignmentLeft renderSize:renderSize];
}

/**
 *  计算字体渲染宽高（字体，字间距，行间距，换行模式，最大单行间距，最小单行间距，文字排版模式，渲染画布尺寸）
 */
- (CGSize)zz_size:(UIFont *)font kern:(CGFloat)kern space:(CGFloat)space linebreakmode:(NSLineBreakMode)linebreakmode maxLineHeight:(CGFloat)maxLineHeight minLineHeight:(CGFloat)minLineHeight textAlignment:(NSTextAlignment)textAlignment renderSize:(CGSize)renderSize {
    
    if (self.length == 0) {
        return CGSizeZero;
    } else if (font == nil || ![font isKindOfClass:[UIFont class]]) {
        return CGSizeZero;
    } else{
        // 字体
        NSMutableDictionary *attribute = [[NSMutableDictionary alloc] init];
        [attribute setObject:font forKey:NSFontAttributeName];
        // 行间距和换行模式
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        if (space > 0) {
            style.lineSpacing = space;
        }
        if (linebreakmode > 0) {
            style.lineBreakMode = linebreakmode;
        }
        if (minLineHeight > 0) {
            style.minimumLineHeight = minLineHeight;
        }
        if (maxLineHeight > 0) {
            style.maximumLineHeight = maxLineHeight;
        }
        style.alignment = textAlignment;
        [attribute setObject:style forKey:NSParagraphStyleAttributeName];
        // 字间距
        if (kern > 0) {
            [attribute setObject:@(kern) forKey:NSKernAttributeName];
        }
        // 尺寸
        CGSize size = [self boundingRectWithSize:renderSize
                                         options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil].size;
        return size;
    }
    return CGSizeZero;
}

#pragma mark - NSURL, NSURLRequest

/**
 *  NSString转NSURL
 */
- (NSURL *)zz_URL {
    return [NSURL URLWithString:self];
}

/**
 *  NSString转NSURLRequest
 */
- (NSURLRequest *)zz_URLRequest {
    return [NSURLRequest requestWithURL:[self zz_URL]];
}

#pragma mark - JSON字符串处理

/**
 *  JSON字符串转NSDictionary或NSArray
 */
- (id)zz_jsonToCocoaObject {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    return jsonObject;
}

#pragma mark - Cookie字符串处理

/**
 *  将单条Cookie字符串转成NSHTTPCookie对象
 *  Cookie的规范可以见相应的RFC文档
 *  http://tools.ietf.org/html/rfc6265
 */
- (NSHTTPCookie *)zz_cookie {
    NSDictionary *cookieProperties = [self zz_cookieProperties];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    return cookie;
}

/**
 *  Cookie字符串转NSDictionary
 */
- (NSDictionary *)zz_cookieToDictionary {
    NSMutableDictionary *cookieDict = [NSMutableDictionary dictionary];
    NSArray *cookieKeyValueStrings = [self componentsSeparatedByString:@";"];
    for (NSString *cookieKeyValueString in cookieKeyValueStrings) {
        //找出第一个"="号的位置
        NSRange separatorRange = [cookieKeyValueString rangeOfString:@"="];
        if (separatorRange.location != NSNotFound &&
            separatorRange.location > 0 &&
            separatorRange.location < ([cookieKeyValueString length] - 1)) {
            //以上条件确保"="前后都有内容，不至于key或者value为空
            NSRange keyRange = NSMakeRange(0, separatorRange.location);
            NSString *key = [cookieKeyValueString substringWithRange:keyRange];
            NSString *value = [cookieKeyValueString substringFromIndex:separatorRange.location + separatorRange.length];
            key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [cookieDict setObject:value forKey:key];
        }
    }
    return cookieDict;
}

/**
 *  获取 Cookie Properties
 */
- (NSDictionary *)zz_cookieProperties {
    NSDictionary *cookieDict = [self zz_cookieToDictionary];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    for (NSString *key in [cookieDict allKeys]) {
        NSString *value = [cookieDict objectForKey:key];
        NSString *uppercaseKey = [key uppercaseString];
        //主要是排除命名不规范的问题
        if ([uppercaseKey isEqualToString:@"DOMAIN"]) {
            if (![value hasPrefix:@"."] && ![value hasPrefix:@"www"]) {
                value = [NSString stringWithFormat:@".%@",value];
            }
            [cookieProperties setObject:value forKey:NSHTTPCookieDomain];
        }else if ([uppercaseKey isEqualToString:@"VERSION"]) {
            [cookieProperties setObject:value forKey:NSHTTPCookieVersion];
        }else if ([uppercaseKey isEqualToString:@"MAX-AGE"]||[uppercaseKey isEqualToString:@"MAXAGE"]) {
            [cookieProperties setObject:value forKey:NSHTTPCookieMaximumAge];
        }else if ([uppercaseKey isEqualToString:@"PATH"]) {
            [cookieProperties setObject:value forKey:NSHTTPCookiePath];
        }else if([uppercaseKey isEqualToString:@"ORIGINURL"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieOriginURL];
        }else if([uppercaseKey isEqualToString:@"PORT"]){
            [cookieProperties setObject:value forKey:NSHTTPCookiePort];
        }else if([uppercaseKey isEqualToString:@"SECURE"]||[uppercaseKey isEqualToString:@"ISSECURE"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieSecure];
        }else if([uppercaseKey isEqualToString:@"COMMENT"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieComment];
        }else if([uppercaseKey isEqualToString:@"COMMENTURL"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieCommentURL];
        }else if([uppercaseKey isEqualToString:@"EXPIRES"]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
            dateFormatter.dateFormat = @"EEE, dd-MMM-yyyy HH:mm:ss zzz";
            [cookieProperties setObject:[dateFormatter dateFromString:value] forKey:NSHTTPCookieExpires];
        }else if([uppercaseKey isEqualToString:@"DISCART"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieDiscard];
        }else if([uppercaseKey isEqualToString:@"NAME"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieName];
        }else if([uppercaseKey isEqualToString:@"VALUE"]){
            [cookieProperties setObject:value forKey:NSHTTPCookieValue];
        }else{
            [cookieProperties setObject:key forKey:NSHTTPCookieName];
            [cookieProperties setObject:value forKey:NSHTTPCookieValue];
        }
    }
    //由于cookieWithProperties:方法properties中不能没有NSHTTPCookiePath，所以这边需要确认下，如果没有则默认为@"/"
    if (![cookieProperties objectForKey:NSHTTPCookiePath]) {
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    }
    return cookieProperties;
}

#pragma mark - 哈希

/**
 *  字符串的MD5值
 */
- (NSString *)zz_md5 {
    const char *cStr = self.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *md5Str = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5Str appendFormat:@"%02x", result[i]];
    }
    return md5Str;
}

#pragma mark - UUID

/**
 *  UUID - IDFA
 */
+ (NSString *)zz_uuidIDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

/**
 *  UUID - IDFA Trimming Line
 */
+ (NSString *)zz_uuidIDFATrimmingLine {
    return [[self zz_uuidIDFA] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

/**
 *  UUID - IDFV
 */
+ (NSString *)zz_uuidIDFV {
    UIDevice *myDevice = [UIDevice currentDevice];
    NSString *deviceUDID = [[myDevice identifierForVendor] UUIDString];
    return deviceUDID;
}

/**
 *  UUID - IDFV Trimming Line
 */
+ (NSString *)zz_uuidIDFVTrimmingLine {
    return [[self zz_uuidIDFV] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

/**
 *  UUID - 随机UUID
 */
+ (NSString *)zz_uuidRandom {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

/**
 *  UUID - 随机UUID Trimming Line
 */
+ (NSString *)zz_uuidRandomTrimmingLine {
    return [[self zz_uuidRandom] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

/**
 *  UUID - 随机UUID + 时间戳TimeStamp
 */
+ (NSString *)zz_uuidRandomTimestamp {
    NSDate *dateNow = [NSDate date];
    long long now = (long long)[dateNow timeIntervalSince1970];
    return [NSString stringWithFormat:@"%@_%lld", [self zz_uuidRandom], now];
}

/**
 *  UUID - 随机UUID + 时间戳TimeStamp Trimming Line
 */
+ (NSString *)zz_uuidRandomTimestampTrimmingLine {
    return [[self zz_uuidRandomTimestamp] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

/**
 *  UUID - OpenUDID(iOS6后已废弃使用)
 */
+ (NSString *)zz_uuidOpenUDID {
    return [OpenUDID value];
}

@end
