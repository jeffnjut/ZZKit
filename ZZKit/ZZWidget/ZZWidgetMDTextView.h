//
//  ZZWidgetMDTextView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/8/7.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ZZShowOriginalTextKey @"ZZShowOriginalTextKey"

typedef NSArray * _Nonnull (^ZZTextParserProcessingBlock)(NSArray *results);

typedef NS_ENUM(NSUInteger, ZZTextParserPattern) {
    ZZTextParserPatternItalicBold    = 0x0001,  // Italic Bold Text `**`
    ZZTextParserPatternBold          = 0x0002,  // Bold text: `**`
    ZZTextParserPatternItalic        = 0x0004,  // Italic text: `*`
    ZZTextParserPatternUnderlined    = 0x0008,  // Underlined text: `_`
    ZZTextParserPatternMonospace     = 0x0010,  // Monospace text: `\``
    ZZTextParserPatternURLBrakets    = 0x0020,  // URLs: `<...>`
    ZZTextParserPatternHeader        = 0x0040,  // Headers: `#`, `##`, etc.
    ZZTextParserPatternURLAnnotation = 0x0080,  // URLs: `[...](...)`
    ZZTextParserPatternURLRaw        = 0x0100,  // URLs: http(s)
    ZZTextParserPatternFont          = ZZTextParserPatternItalicBold | ZZTextParserPatternBold | ZZTextParserPatternItalic,
    ZZTextParserPatternAll           = ZZTextParserPatternItalicBold | ZZTextParserPatternBold | ZZTextParserPatternItalic | ZZTextParserPatternUnderlined | ZZTextParserPatternMonospace | ZZTextParserPatternURLBrakets | ZZTextParserPatternHeader | ZZTextParserPatternURLAnnotation | ZZTextParserPatternURLRaw
};

#pragma mark - ZZTextParser

@interface ZZTextParser : NSObject

/** The text parsers that the text parser was created with by calling `sequence`. */
@property (copy, nonatomic, readonly, nullable) NSArray *zzTextParsers;

/** The text parser's pattern. */
@property (copy, nonatomic, readonly, nullable) NSString *zzTextPattern;

/** The text parser's processing block. */
@property (copy, nonatomic, readonly, nullable) ZZTextParserProcessingBlock zzProcessingBlock;

/** Jeff : Pattern类型 */
@property (assign, nonatomic) ZZTextParserPattern zzPattern;

/** Supported Pattern Type. */
@property (nonatomic, assign) ZZTextParserPattern zzSupporttedPattern;

/** Jeff : 描述文本的字典 */
@property (strong, nonatomic, nonnull) NSDictionary<NSAttributedStringKey, id> *zzAttributes;

@property (assign, nonatomic) BOOL zzMissAttributeItalicBold;

@property (assign, nonatomic) BOOL zzMissAttributeBold;

@property (assign, nonatomic) BOOL zzMissAttributeItalic;

/**
 *  Creates a text parser that chains a collection of parser sequentially.
 */
+ (ZZTextParser *)zz_sequence:(nonnull NSArray *)textParsers;

/**
 *  Creates a text parser with the specified pattern and processing block.
 */
+ (ZZTextParser *)zz_textParserWithTextPattern:(nonnull NSString *)textPattern processingBlock:(nonnull ZZTextParserProcessingBlock)processingBlock;

/**
 *  Creates a text parser with the specified opening and closing delimiters, as weel as the specified attributes.
 */
+ (ZZTextParser *)zz_textParserWithOpeningDelimiter:(nonnull NSString *)openingDelimiter closingDelimiter:(nonnull NSString *)closingDelimiter attributes:(nonnull NSDictionary *)attributes;

/**
 *  Creates a text parser with the specified opening, closing delimiters and returnSpilit, as weel as the specified attributes.
 */
+ (ZZTextParser *)zz_textParserWithOpeningDelimiter:(nonnull NSString *)openingDelimiter closingDelimiter:(nonnull NSString *)closingDelimiter returnSpilit:(nonnull NSString *)returnSpilit attributes:(nonnull NSDictionary *)attributes;

/**
 *  Creates a text parser with the specified delimiters, as weel as the specified attributes.
 */
+ (ZZTextParser *)zz_textParserWithDelimiter:(NSString *)delimiter attributes:(NSDictionary *)attributes;

/**
 *  根据String和文字段落属性描述字典返回NSAttributedString
 */
- (NSAttributedString *)zz_attributedStringFromString:(nonnull NSString *)string;

@end

#pragma mark - ZZMarkdownParser

/**
 * ZZMarkdownParser will take a plain text markdown string and produce an NSAttributedString.
 * The span elements bold (**), italic (*), underline (_), monospace (`) and link (<, >) are supported.
 * If given, the produced attributed string will use `self.fontName` and `self.fontSize`,
 * otherwise the system default font and body text size will be used.
 */
@interface ZZMarkdownParser : ZZTextParser

// 1号标题 Header
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *attributedHeader1;
// 2号标题 Header
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *attributedHeader2;
// 3号标题 Header
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *attributedHeader3;
// 4号标题 Header
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *attributedHeader4;
// 5号标题 Header
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *attributedHeader5;
// URLs With Brakets<https://www.xx.com>
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *attributedURLBrakets;
// URLs With Annotation[链接](https://www.xx.com)
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *attributedURLAnnotation;
// URLs Raw Link http(s)://www.xx.com
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *attributedURLRaw;

/**
 *  创建ZZTextParser
 */
+ (ZZMarkdownParser *)create:(ZZTextParserPattern)supportPattern
                  attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes
         missParseItalicBold:(BOOL)missParseItalicBold
               missParseBold:(BOOL)missParseBold
             missParseItalic:(BOOL)missParseItalic
        attributedURLBrakets:(nullable NSDictionary<NSAttributedStringKey, id> *)attributedURLBrakets
     attributedURLAnnotation:(nullable NSDictionary<NSAttributedStringKey, id> *)attributedURLAnnotation
            attributedURLRaw:(nullable NSDictionary<NSAttributedStringKey, id> *)attributedURLRaw
           attributedHeader1:(nullable NSDictionary<NSAttributedStringKey, id> *)attributedHeader1
           attributedHeader2:(nullable NSDictionary<NSAttributedStringKey, id> *)attributedHeader2
           attributedHeader3:(nullable NSDictionary<NSAttributedStringKey, id> *)attributedHeader3
           attributedHeader4:(nullable NSDictionary<NSAttributedStringKey, id> *)attributedHeader4
           attributedHeader5:(nullable NSDictionary<NSAttributedStringKey, id> *)attributedHeader5;

@end

#pragma mark - ZZWidgetMDTextView

@protocol ZZWidgetMDTextViewDelegate <NSObject>

@required
- (void)zz_markDownResizeHeight:(CGFloat)height;

@end

@interface ZZWidgetMDTextView : UIView

// UI
@property (nonatomic, strong, readonly) UITextView *markdownTextView;

// Text
@property (nonatomic, copy) NSString *text;

// 支持拷贝文案
@property (nonatomic, assign) BOOL editable;

/**
 *  重新刷新
 */
- (void)render;

/**
 *  创建ZZWidgetMDTextView(简单参数)
 */
+ (ZZWidgetMDTextView *)create:(CGRect)frame
                    edgeInsets:(UIEdgeInsets)edgeInsets
                          text:(nonnull NSString *)text
                          font:(nullable UIFont *)font
                         color:(nullable UIColor *)color
                paragraphStyle:(nullable NSMutableParagraphStyle *)paragraphStyle
                baselineOffset:(nullable NSNumber *)baselineOffset
             attributedHeader2:(nullable NSDictionary *)attributedHeader2
             attributedHeader3:(nullable NSDictionary *)attributedHeader3
          attributedURLBrakets:(nullable NSDictionary *)attributedURLBrakets
       attributedURLAnnotation:(nullable NSDictionary *)attributedURLAnnotation
              attributedURLRaw:(nullable NSDictionary *)attributedURLRaw
                         debug:(BOOL)debug
                      delegate:(nullable id<ZZWidgetMDTextViewDelegate>)delegate
                      urlBlock:(nullable void(^)(NSURL *url))urlBlock;

/**
 *  创建ZZWidgetMDTextView(完整参数)
 */
+ (ZZWidgetMDTextView *)create:(CGRect)frame
               backgroundColor:(nullable UIColor *)backgroundColor
                  parsePattern:(ZZTextParserPattern)parsePattern
                    edgeInsets:(UIEdgeInsets)edgeInsets
                          text:(nonnull NSString *)text
                    attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes
             attributedHeader1:(nullable NSDictionary *)attributedHeader1
             attributedHeader2:(nullable NSDictionary *)attributedHeader2
             attributedHeader3:(nullable NSDictionary *)attributedHeader3
             attributedHeader4:(nullable NSDictionary *)attributedHeader4
             attributedHeader5:(nullable NSDictionary *)attributedHeader5
          attributedURLBrakets:(nullable NSDictionary *)attributedURLBrakets
       attributedURLAnnotation:(nullable NSDictionary *)attributedURLAnnotation
              attributedURLRaw:(nullable NSDictionary *)attributedURLRaw
       missAttributeItalicBold:(BOOL)missAttributeItalicBold
             missAttributeBold:(BOOL)missAttributeBold
           missAttributeItalic:(BOOL)missAttributeItalic
                      delegate:(nullable id<ZZWidgetMDTextViewDelegate>)delegate
                      urlBlock:(nullable void(^)(NSURL *url))urlBlock;

@end

NS_ASSUME_NONNULL_END
