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
// #import <AdSupport/AdSupport.h>
#import "OpenUDID.h"
#import "NSArray+ZZKit.h"

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
    
    if ([self isKindOfClass:[NSString class]] && [self length] > 0) {
        if ([self characterAtIndex:0] == '#') {
            
            if ([self length] == 9) {
                
                NSString *colorHex = [self substringToIndex:7];
                NSString *alphaPercent = [self substringFromIndex:7];
                unsigned int alpha = 0;
                [[NSScanner scannerWithString:alphaPercent] scanHexInt:&alpha];
                return [UIColor zz_colorHexString:colorHex withAlpha:(float)alpha / 255.0];
            }else if ([self length] == 7) {
                return [UIColor zz_colorHexString:self];
            }else if ([self length] == 4) {
                return [UIColor zz_colorHexString:[NSString stringWithFormat:@"#%@%@%@%@%@%@",
                        [self substringWithRange:NSMakeRange(1, 1)],
                        [self substringWithRange:NSMakeRange(1, 1)],
                        [self substringWithRange:NSMakeRange(2, 1)],
                        [self substringWithRange:NSMakeRange(2, 1)],
                        [self substringWithRange:NSMakeRange(3, 1)],
                        [self substringWithRange:NSMakeRange(3, 1)]]];
            }
        }else{
            if ([self length] == 8) {
                NSString *colorHex = [NSString stringWithFormat:@"#%@",[self substringToIndex:6]];
                NSString *alphaPercent = [self substringFromIndex:6];
                unsigned int alpha = 0;
                [[NSScanner scannerWithString:alphaPercent] scanHexInt:&alpha];
                return [UIColor zz_colorHexString:colorHex withAlpha:(float)alpha / 255.0];
            }else if ([self length] == 6) {
                return [UIColor zz_colorHexString:[NSString stringWithFormat:@"#%@",self]];
            }
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
        
        image = [[NSBundle mainBundle] zz_image:self extension:nil];
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
    return [NSBundle zz_image:imageName extension:nil class:cls bunldeName:bundleName];
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

#pragma mark - 正则、谓词

/**
 * 正则判断
 */
- (BOOL)zz_predicate:(nonnull NSString *)regex {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL ret = NO;
    @try {
        ret = [predicate evaluateWithObject:self];
    } @catch (NSException *exception) {
        NSLog(@"Ex : %@", exception);
    } @finally {
        
    }
    return ret;
}

#pragma mark - URL

/**
 * URL Encode（URLQueryAllowedCharacterSet）
 */
- (NSString *)zz_url_encode {
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

/**
 * URL Encode（All）
 */
- (NSString *)zz_url_encode_all {
    
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[ ]"].invertedSet];
}

/**
 * URL Decode
 */
- (NSString *)zz_url_decode {
    
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)_encode {
    
    return [self _encode:NSUTF8StringEncoding];
}

- (NSString *)_encode:(NSStringEncoding)encoding {

    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                 (__bridge CFStringRef)self,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)_decode {
    
    return [self _decode:NSUTF8StringEncoding];
}

- (NSString *)_decode:(NSStringEncoding)encoding {
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                 (__bridge CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 CFStringConvertNSStringEncodingToEncoding(encoding));
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
        case ZZStringTrimmingTypeWhiteSpaceAndNewline:
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
        int i = 0;
        while (YES) {
            
            if ([leftArr zz_arrayObjectAtIndex:i] == nil && [rightArr zz_arrayObjectAtIndex:i] == nil) {
                break;
            }
            left = [[leftArr zz_arrayObjectAtIndex:i] intValue];
            right = [[rightArr zz_arrayObjectAtIndex:i] intValue];
            if (left > right) {
                return YES;
            }else if (left < right) {
                return NO;
            }
            i++;
        }
    }
    return NO;
}

/**
 *  比较版本字符串大小，是否大于等于right
 */
- (BOOL)zz_greaterThanOrEqualTo:(NSString *)right {
    
    return [self zz_greaterThan:right] || [self isEqualToString:right];
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
 *  判断字符串长度（字符串长度，汉字长度2，其他长度1）
 */
- (CGFloat)zz_stringLength{
    if (self.length == 0) {
        return  0;
    }
    CGFloat count = 0;
    for (int i= 0; i<self.length; i++) {
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        if ([str zz_isChinese]) {
            count += 2;
        }else{
            count += 1;
        }
    }
    return count;
}

/**
 *  截取字符串长度（字符串长度，汉字长度2，其他长度1）
 */
- (NSString *)zz_stringToIndex:(NSInteger )length{
    if (self.length == 0) {
        return @"";
    }
    CGFloat count = 0;
    NSString *resultString = @"";
    for (int i= 0; i<self.length; i++) {
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        if ([str zz_isChinese]) {
            count += 2;
        }else{
            count += 1;
        }
        if(count > length){
            break;
        }else{
            resultString = [NSString stringWithFormat:@"%@%@",resultString,str];
        }
    }
    return  resultString;
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


/**
 *  解析短链，转为字典
*/
- (NSMutableDictionary *)zz_URLToDictionary {
    
    NSString *validString = [[self componentsSeparatedByString:@"://"] lastObject];
    NSArray *keyValueStrings = [validString componentsSeparatedByString:@"/"];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (NSString *string in keyValueStrings) {
        NSArray *items = [string componentsSeparatedByString:@"="];
        
        if ([items count] >= 2) {
            NSString *key = [items objectAtIndex:0];
            NSString *value = [items objectAtIndex:1];
            if (key != nil && value != nil) {
                [dict setObject:value forKey:key];
            }
        }
    }
    return dict;
}

#pragma mark - JSON字符串处理

/**
 *  JSON字符串转NSDictionary或NSArray
 */
- (id)zz_jsonToCocoaObject {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers
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
    /*
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data zz_md5];
    */
}

#pragma mark - UUID

/**
 *  UUID - IDFA
 */
//+ (NSString *)zz_uuidIDFA {
//    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//}

/**
 *  UUID - IDFA Trimming Line
 */
//+ (NSString *)zz_uuidIDFATrimmingLine {
//    return [[self zz_uuidIDFA] stringByReplacingOccurrencesOfString:@"-" withString:@""];
//}

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

#pragma mark - Error

/**
 *  Error - 转Error
 */
- (NSError *)zz_error {
    
    return [NSError errorWithDomain:self code:-1 userInfo:nil];
}

#pragma mark - 计算

/**
 *  浮点数加法
 */
- (NSString *)zz_addFloat:(nullable NSString *)anotherStr {
    
    double v = [self doubleValue] + [anotherStr doubleValue];
    return [NSString zz_decimalString:v decimalPlaces:2];
}

/**
 *  浮点数小数点控制(TODO)
 */
+ (NSString *)zz_decimalString:(double)value decimalPlaces:(int)decimalPlaces {
    
    NSString *a = nil;
    a = [NSString stringWithFormat:@"%.2f", value];
    if ([a substringFromIndex:a.length - 1].intValue != 0) {
        return a;
    }
    a = [NSString stringWithFormat:@"%.1f", value];
    if ([a substringFromIndex:a.length - 1].intValue != 0) {
        return a;
    }
    return [NSString stringWithFormat:@"%d", (int)value];
    
}

static char *nickHeader[] = {"快乐的","冷静的","醉熏的","潇洒的","糊涂的","积极的","冷酷的","深情的","粗暴的","温柔的","可爱的","愉快的","义气的","认真的","威武的","帅气的","传统的","潇洒的","漂亮的","自然的","专一的","听话的","昏睡的","狂野的","等待的","搞怪的","幽默的","魁梧的","活泼的","开心的","高兴的","超帅的","留胡子的","坦率的","直率的","轻松的","痴情的","完美的","精明的","无聊的","有魅力的","丰富的","繁荣的","饱满的","炙热的","暴躁的","碧蓝的","俊逸的","英勇的","健忘的","故意的","无心的","土豪的","朴实的","兴奋的","幸福的","淡定的","不安的","阔达的","孤独的","独特的","疯狂的","时尚的","落后的","风趣的","忧伤的","大胆的","爱笑的","矮小的","健康的","合适的","玩命的","沉默的","斯文的","香蕉","苹果","鲤鱼","鳗鱼","任性的","细心的","粗心的","大意的","甜甜的","酷酷的","健壮的","英俊的","霸气的","阳光的","默默的","大力的","孝顺的","忧虑的","着急的","紧张的","善良的","凶狠的","害怕的","重要的","危机的","欢喜的","欣慰的","满意的","跳跃的","诚心的","称心的","如意的","怡然的","娇气的","无奈的","无语的","激动的","愤怒的","美好的","感动的","激情的","激昂的","震动的","虚拟的","超级的","寒冷的","精明的","明理的","犹豫的","忧郁的","寂寞的","奋斗的","勤奋的","现代的","过时的","稳重的","热情的","含蓄的","开放的","无辜的","多情的","纯真的","拉长的","热心的","从容的","体贴的","风中的","曾经的","追寻的","儒雅的","优雅的","开朗的","外向的","内向的","清爽的","文艺的","长情的","平常的","单身的","伶俐的","高大的","懦弱的","柔弱的","爱笑的","乐观的","耍酷的","酷炫的","神勇的","年轻的","唠叨的","瘦瘦的","无情的","包容的","顺心的","畅快的","舒适的","靓丽的","负责的","背后的","简单的","谦让的","彩色的","缥缈的","欢呼的","生动的","复杂的","慈祥的","仁爱的","魔幻的","虚幻的","淡然的","受伤的","雪白的","高高的","糟糕的","顺利的","闪闪的","羞涩的","缓慢的","迅速的","优秀的","聪明的","含糊的","俏皮的","淡淡的","坚强的","平淡的","欣喜的","能干的","灵巧的","友好的","机智的","机灵的","正直的","谨慎的","俭朴的","殷勤的","虚心的","辛勤的","自觉的","无私的","无限的","踏实的","老实的","现实的","可靠的","务实的","拼搏的","个性的","粗犷的","活力的","成就的","勤劳的","单纯的","落寞的","朴素的","悲凉的","忧心的","洁净的","清秀的","自由的","小巧的","单薄的","贪玩的","刻苦的","干净的","壮观的","和谐的","文静的","调皮的","害羞的","安详的","自信的","端庄的","坚定的","美满的","舒心的","温暖的","专注的","勤恳的","美丽的","腼腆的","优美的","甜美的","甜蜜的","整齐的","动人的","典雅的","尊敬的","舒服的","妩媚的","秀丽的","喜悦的","甜美的","彪壮的","强健的","大方的","俊秀的","聪慧的","迷人的","陶醉的","悦耳的","动听的","明亮的","结实的","魁梧的","标致的","清脆的","敏感的","光亮的","大气的","老迟到的","知性的","冷傲的","呆萌的","野性的","隐形的","笑点低的","微笑的","笨笨的","难过的","沉静的","火星上的","失眠的","安静的","纯情的","要减肥的","迷路的","烂漫的","哭泣的","贤惠的","苗条的","温婉的","发嗲的","会撒娇的","贪玩的","执着的","眯眯眼的","花痴的","想人陪的","眼睛大的","高贵的","傲娇的","心灵美的","爱撒娇的","细腻的","天真的","怕黑的","感性的","飘逸的","怕孤独的","忐忑的","高挑的","傻傻的","冷艳的","爱听歌的","还单身的","怕孤单的","懵懂的"};

static char *nickFoot[] = {"嚓茶","凉面","便当","毛豆","花生","可乐","灯泡","哈密瓜","野狼","背包","眼神","缘分","雪碧","人生","牛排","蚂蚁","飞鸟","灰狼","斑马","汉堡","悟空","巨人","绿茶","自行车","保温杯","大碗","墨镜","魔镜","煎饼","月饼","月亮","星星","芝麻","啤酒","玫瑰","大叔","小伙","哈密瓜","数据线","太阳","树叶","芹菜","黄蜂","蜜粉","蜜蜂","信封","西装","外套","裙子","大象","猫咪","母鸡","路灯","蓝天","白云","星月","彩虹","微笑","摩托","板栗","高山","大地","大树","电灯胆","砖头","楼房","水池","鸡翅","蜻蜓","红牛","咖啡","机器猫","枕头","大船","诺言","钢笔","刺猬","天空","飞机","大炮","冬天","洋葱","春天","夏天","秋天","冬日","航空","毛衣","豌豆","黑米","玉米","眼睛","老鼠","白羊","帅哥","美女","季节","鲜花","服饰","裙子","白开水","秀发","大山","火车","汽车","歌曲","舞蹈","老师","导师","方盒","大米","麦片","水杯","水壶","手套","鞋子","自行车","鼠标","手机","电脑","书本","奇迹","身影","香烟","夕阳","台灯","宝贝","未来","皮带","钥匙","心锁","故事","花瓣","滑板","画笔","画板","学姐","店员","电源","饼干","宝马","过客","大白","时光","石头","钻石","河马","犀牛","西牛","绿草","抽屉","柜子","往事","寒风","路人","橘子","耳机","鸵鸟","朋友","苗条","铅笔","钢笔","硬币","热狗","大侠","御姐","萝莉","毛巾","期待","盼望","白昼","黑夜","大门","黑裤","钢铁侠","哑铃","板凳","枫叶","荷花","乌龟","仙人掌","衬衫","大神","草丛","早晨","心情","茉莉","流沙","蜗牛","战斗机","冥王星","猎豹","棒球","篮球","乐曲","电话","网络","世界","中心","鱼","鸡","狗","老虎","鸭子","雨","羽毛","翅膀","外套","火","丝袜","书包","钢笔","冷风","八宝粥","烤鸡","大雁","音响","招牌","胡萝卜","冰棍","帽子","菠萝","蛋挞","香水","泥猴桃","吐司","溪流","黄豆","樱桃","小鸽子","小蝴蝶","爆米花","花卷","小鸭子","小海豚","日记本","小熊猫","小懒猪","小懒虫","荔枝","镜子","曲奇","金针菇","小松鼠","小虾米","酒窝","紫菜","金鱼","柚子","果汁","百褶裙","项链","帆布鞋","火龙果","奇异果","煎蛋","唇彩","小土豆","高跟鞋","戒指","雪糕","睫毛","铃铛","手链","香氛","红酒","月光","酸奶","银耳汤","咖啡豆","小蜜蜂","小蚂蚁","蜡烛","棉花糖","向日葵","水蜜桃","小蝴蝶","小刺猬","小丸子","指甲油","康乃馨","糖豆","薯片","口红","超短裙","乌冬面","冰淇淋","棒棒糖","长颈鹿","豆芽","发箍","发卡","发夹","发带","铃铛","小馒头","小笼包","小甜瓜","冬瓜","香菇","小兔子","含羞草","短靴","睫毛膏","小蘑菇","跳跳糖","小白菜","草莓","柠檬","月饼","百合","纸鹤","小天鹅","云朵","芒果","面包","海燕","小猫咪","龙猫","唇膏","鞋垫","羊","黑猫","白猫","万宝路","金毛","山水","音响","后来","生活","空气","笑容","明天","风景","音乐","岁月","文化","生气","身影","天气","空中","红色","书包","今年","汽车","早晨","道路","认识","精彩","中午","礼物","星星","习惯","树木","友谊","夜晚","意义","耳朵","门口","班级","人间","厨房","风雨","影响","过年","电话","黄色","种子","广场","清晨","根本","故乡","笑脸","水面","思想","伙伴","美景","照片","水果","彩虹","刚才","月光","先生","鲜花","灯光","爱心","光明","左右","角落","青蛙","电影","阳台","用心","动力","天地","花园","诗人","树林","雨伞","去年","少女","乡村","对手","上午","分别","活力","作用","古代","公主","力气","从前","作品","空间","黑夜","说明","青年","面包","往事","大小","女人","司机","中心","对面","心头","嘴角","家门","书本","雪人","男人","笑话","云朵","早饭","右手","水平"};

static char *nickLast[] = {"香喷喷","金灿灿","亮晶晶","静悄悄","亮闪闪","黑沉沉","沉甸甸","胖乎乎","水汪汪","笑哈哈","黑压压","气冲冲","绿油油","白茫茫","难为情","孤零零","急匆匆","火辣辣","兴冲冲","飘飘然","白皑皑","暖烘烘","红扑扑","齐刷刷","葡萄灰","懒洋洋","慢吞吞","凉飕飕","乱哄哄","差不多","明晃晃","黑糊糊","冷飕飕","空荡荡","麻麻亮","黑黝黝","黑魆魆","好端端","美滋滋","马拉松","慢悠悠","金闪闪","光秃秃","大舌头","多元化","稀巴烂","暖洋洋","橄榄绿","孩子气","一次性","高精尖","急性子","短平快","响当当","白花花","雄赳赳","乐陶陶","一系列","全天候","二把刀","一揽子","灰蒙蒙","大不了","呱呱叫","血淋淋","假惺惺","黑黢黢","乌溜溜","赤条条","蓝盈盈","团团转","乐滋滋","灰溜溜","空落落","怯生生","喜滋滋","靠得住","慢性子","气呼呼","多年生","亮堂堂","一年生","老大难","气鼓鼓","乱糟糟","笑呵呵","小儿科","玫瑰紫","闹哄哄","慢腾腾","一团糟","皱巴巴","死脑筋","直勾勾","鸭蛋青","臭烘烘","绿莹莹","香馥馥","吃得开","蔫儿坏","老掉牙","一连串","第一手","胖墩墩","汗津津","老鼻子","滴溜溜","绿茸茸","黑油油","密匝匝","二年生","辣乎乎","暖融融","喜冲冲","怒冲冲","雾茫茫","急巴巴","好容易","白蒙蒙","闹嚷嚷","划不来","矮墩墩","翠生生","气吁吁","白晃晃","吃不开","泪涟涟","紧巴巴","亮铮铮","甜津津","金晃晃","抠门儿","紧绷绷","光闪闪","雾沉沉","气哼哼","乱纷纷","够味儿","直瞪瞪","碧油油","可怜见","傻呵呵","光灿灿","亮光光","冷丝丝","合得着","乌油油","够劲儿","空洞洞","不名誉","硬撅撅","汗淋淋","厚墩墩","轻悠悠","冷森森","黑茫茫","潮乎乎","稀溜溜","尖溜溜","猴儿精","油汪汪","虎彪彪","一顺儿","虎生生","咸津津","喘吁吁","明闪闪","对味儿","毛烘烘","蔫呼呼","单个儿","邪门儿","鸭蛋圆","闷沉沉","高挑儿","离格儿","绕远儿","颤巍巍","笑吟吟","蔫不唧","乐呵呵","圆滚滚","眼巴巴","差点儿","圆鼓鼓","凶巴巴","酸溜溜","雾蒙蒙","不得已","顺时针","地毯式","清凌凌","玫瑰红","灰沉沉","逆时针","不成文","油乎乎","中溜儿","齆鼻儿","便携式","超一流","左性子","黑幽幽","一根筋","猴儿急","齉鼻儿","满当当","反季节","辣酥酥","起眼儿","出数儿","辣丝丝","肥䐛䐛","抱身儿","靠谱儿","左嗓子","是样儿","金煌煌","毛乎乎","绿生生","密密麻麻","可怜巴巴","密密匝匝","稀里哗啦","稀里糊涂","坑坑洼洼","胡子拉碴","疯疯癫癫","稀稀拉拉","满满当当","密密丛丛","小不点儿","急急巴巴","慢慢悠悠","花不棱登","慢慢吞吞","怪里怪气","滴里嘟噜","小心眼儿","花花搭搭","灰不溜丢","老八板儿","直心眼儿","滑不唧溜","实心眼儿","岗口儿甜","哩哩啰啰","不大离儿","哩哩啦啦","偏心眼儿","嘁里喀喳","忙忙叨叨","中不溜儿","油脂麻花"};


- (NSString *)_getNickHeader {
    
    return [NSString stringWithCString:nickHeader[arc4random() % (sizeof(nickHeader) / sizeof(nickHeader[0]))] encoding:NSUTF8StringEncoding];
}


- (NSString *)_getNickFoot {
    
    return [NSString stringWithCString:nickFoot[arc4random() % (sizeof(nickFoot) / sizeof(nickFoot[0]))] encoding:NSUTF8StringEncoding];
}

- (NSString *)_getNickLast {
    
    return [NSString stringWithCString:nickLast[arc4random() % (sizeof(nickLast) / sizeof(nickLast[0]))] encoding:NSUTF8StringEncoding];
}

/**
 * 随机生成用户昵称
 */
- (NSString *)zz_randomNickName {
    
    return [NSString stringWithFormat:@"%@%@%@%@", [self _getNickHeader], [self _getNickFoot], [self _getNickLast], self];
}


@end
