//
//  ZZWidgetMDTextView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/7.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZWidgetMDTextView.h"
#import <Masonry/Masonry.h>
#import "NSString+ZZKit.h"
#import "NSAttributedString+ZZKit.h"

#pragma mark - ZZTextParser

@interface ZZTextParser ()

@property (strong, nonatomic) NSMutableAttributedString *attributedString;

@end

@implementation ZZTextParser

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Default to the system body text style
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _zzAttributes = @{NSFontAttributeName : font , NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    }
    return self;
}

- (instancetype)initWithTextParsers:(NSArray *)textParsers
{
    self = [self init];
    if (self) {
        _zzTextParsers = textParsers;
    }
    return self;
}

- (instancetype)initWithTextPattern:(NSString *)textPattern processingBlock:(ZZTextParserProcessingBlock)processingBlock {
    
    self = [self init];
    if (self) {
        _zzProcessingBlock = processingBlock;
        _zzTextPattern = textPattern;
    }
    return self;
}

/**
 *  Creates a text parser that chains a collection of parser sequentially.
 */
+ (ZZTextParser *)zz_sequence:(nonnull NSArray *)textParsers {
    
    return [[self alloc] initWithTextParsers:textParsers];
}

/**
 *  Creates a text parser with the specified pattern and processing block.
 */
+ (ZZTextParser *)zz_textParserWithTextPattern:(nonnull NSString *)textPattern processingBlock:(nonnull ZZTextParserProcessingBlock)processingBlock {
    
    return [[self alloc] initWithTextPattern:textPattern processingBlock:processingBlock];
}

/**
 *  Creates a text parser with the specified opening and closing delimiters, as weel as the specified attributes.
 */
+ (ZZTextParser *)zz_textParserWithOpeningDelimiter:(nonnull NSString *)openingDelimiter closingDelimiter:(nonnull NSString *)closingDelimiter attributes:(nonnull NSDictionary *)attributes {
    
    return [self zz_textParserWithOpeningDelimiter:openingDelimiter closingDelimiter:closingDelimiter returnSpilit:@"" attributes:attributes];
}

/**
 *  Creates a text parser with the specified opening, closing delimiters and returnSpilit, as weel as the specified attributes.
 */
+ (ZZTextParser *)zz_textParserWithOpeningDelimiter:(nonnull NSString *)openingDelimiter closingDelimiter:(nonnull NSString *)closingDelimiter returnSpilit:(nonnull NSString *)returnSpilit attributes:(nonnull NSDictionary *)attributes {
    
    NSString *escapedOpeningDelimiter = [NSRegularExpression escapedPatternForString:openingDelimiter];
    NSString *escapedClosingDelimiter = [NSRegularExpression escapedPatternForString:closingDelimiter];
    NSString *pattern = [NSString stringWithFormat:@"(%@)(.+?)(%@)%@", escapedOpeningDelimiter, escapedClosingDelimiter,returnSpilit];
    
    ZZTextParserProcessingBlock processingBlock = ^ NSArray * (NSArray *results) {
        NSString *replacementString = [results objectAtIndex:2];
        return @[replacementString, attributes];
    };
    
    return [ZZTextParser zz_textParserWithTextPattern:pattern processingBlock:processingBlock];
}

/**
 *  Creates a text parser with the specified delimiters, as weel as the specified attributes.
 */
+ (ZZTextParser *)zz_textParserWithDelimiter:(NSString *)delimiter attributes:(NSDictionary *)attributes {
    
    return [ZZTextParser zz_textParserWithOpeningDelimiter:delimiter closingDelimiter:delimiter attributes:attributes];
}

/**
 *  根据String和文字段落属性描述字典返回NSAttributedString
 */
- (NSAttributedString *)zz_attributedStringFromString:(nonnull NSString *)string {

    _attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // The full range of the string
    NSUInteger length = [_attributedString length];
    NSRange range = NSMakeRange(0u, length);
    
    // Jeff : 增加Attributes
    if (self.zzAttributes) {
        __weak typeof(self) weakSelf = self;
        [self.zzAttributes enumerateKeysAndObjectsUsingBlock:^(NSAttributedStringKey  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [weakSelf.attributedString addAttribute:key value:obj range:range];
        }];
    }

    NSArray *textParsers = [self _flattenedTextParsers];
    if ([textParsers count] > 0) {
        for (ZZTextParser *textParser in textParsers) {
            [self _commitParser:textParser];
        }
    } else {
        [self _commitParser:self];
    }
    return [[NSAttributedString alloc] initWithAttributedString:_attributedString];
}

// Recursively flattens the `textParsers` array.
- (NSArray *)_flattenedTextParsers
{
    NSArray *textParsers = self.zzTextParsers;
    NSUInteger capacity = [textParsers count];
    NSMutableArray *flattenedTextParsers = [NSMutableArray arrayWithCapacity:capacity];
    
    for (ZZTextParser *textParser in textParsers) {
        if (textParser.zzTextParsers) {
            [flattenedTextParsers addObjectsFromArray:[textParser _flattenedTextParsers]];
        } else {
            [flattenedTextParsers addObject:textParser];
        }
    }
    
    return flattenedTextParsers;
}

// Apply the attributes returned by attributesBlock to the search pattern
- (void)_commitParser:(ZZTextParser *)textParser {
    
    __weak typeof(self) weakSelf = self;
    
    // The full range of the string
    NSUInteger length = [_attributedString length];
    NSRange range = NSMakeRange(0u, length);
    
    // The ranges (wraped as NSValue objects) of the matches
    NSMutableArray *values = [NSMutableArray array];
    
    // The replacement strings, each match's full text is replaced with this string
    NSMutableArray *replacementStrings = [NSMutableArray array];
    
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:textParser.zzTextPattern options:0 error:NULL];
    
    // Enumerate the matches,
    NSString *string = [_attributedString string];
    [regularExpression enumerateMatchesInString:string options:0 range:range usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSMutableArray *results = [NSMutableArray array];
        if (textParser.zzPattern == ZZTextParserPatternURLRaw) {
            NSRange range = [result rangeAtIndex:0];
            NSString *substring = [string substringWithRange:range];
            [results addObject:substring];
        }else {
            for (NSUInteger index = 0; index < result.numberOfRanges; ++index) {
                NSRange range = [result rangeAtIndex:index];
                NSString *substring = [string substringWithRange:range];
                [results addObject:substring];
            }
        }
        NSArray *components = textParser.zzProcessingBlock(results);
        NSString *replacementString = nil;
        switch (textParser.zzPattern) {
            case ZZTextParserPatternItalicBold:
            {
                if (weakSelf.zzMissAttributeItalicBold) {
                    return;
                }
                break;
            }
            case ZZTextParserPatternBold:
            {
                if (weakSelf.zzMissAttributeBold) {
                    return;
                }
                break;
            }
            case ZZTextParserPatternItalic:
            {
                if (weakSelf.zzMissAttributeItalic) {
                    return;
                }
                break;
            }
            case ZZTextParserPatternUnderlined:
            {
                break;
            }
            case ZZTextParserPatternMonospace:
            {
                break;
            }
            case ZZTextParserPatternHeader:
            {
                break;
            }
            case ZZTextParserPatternURLBrakets:
            {
                break;
            }
            case ZZTextParserPatternURLAnnotation:
            {
                break;
            }
            case ZZTextParserPatternURLRaw:
            {
                break;
            }
            default:
                break;
        }
        if (textParser.zzPattern == ZZTextParserPatternHeader) {
            replacementString = [NSString stringWithFormat:@"%@\n",[components firstObject]];
        }else {
            replacementString = [components firstObject];
        }
        NSDictionary *attributes = [components lastObject];
        if ([[attributes objectForKey:ZZShowOriginalTextKey] boolValue]) {
            return;
        }
        __block NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:replacementString attributes:attributes];
        
        // Jeff : 修改，原作者是将![attributes objectForKey:NSFontAttributeName]作为设置条件
        // --  原注解：Use the default font if one hasn't been specified
        // 当匹配的正则（命中MD语法的文本没有对应的Attributes。使用默认的通用的）
        if (attributes == nil) {
            // attributes未设置
            NSUInteger length = [attributedString length];
            NSRange range = NSMakeRange(0u, length);
            
            // Jeff : 增加Attributes
            if (self.zzAttributes) {
                [self.zzAttributes enumerateKeysAndObjectsUsingBlock:^(NSAttributedStringKey  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [attributedString addAttribute:key value:obj range:range];
                }];
            }
        }
        
        if (![attributes objectForKey:NSFontAttributeName] && [weakSelf.zzAttributes objectForKey:NSFontAttributeName] != nil) {
            // Jeff : attributes已设置，且当前指定了共通的，但attributes未指定NSFontAttributeName的情况下，使用共通的。
            [attributedString addAttribute:NSFontAttributeName value:[weakSelf.zzAttributes objectForKey:NSFontAttributeName] range:NSMakeRange(0u, attributedString.length)];
        }
        
        if (![attributes objectForKey:NSForegroundColorAttributeName] && [weakSelf.zzAttributes objectForKey:NSForegroundColorAttributeName] != nil) {
            // Jeff : attributes已设置，且当前指定了共通的，但attributes未指定NSForegroundColorAttributeName的情况下，使用共通的。
            [attributedString addAttribute:NSForegroundColorAttributeName value:[weakSelf.zzAttributes objectForKey:NSForegroundColorAttributeName] range:NSMakeRange(0u, attributedString.length)];
        }
        
        if (![attributes objectForKey:NSParagraphStyleAttributeName] && [weakSelf.zzAttributes objectForKey:NSParagraphStyleAttributeName] != nil) {
            // Jeff : attributes已设置，且当前指定了共通的，但attributes未指定NSParagraphStyleAttributeName的情况下，使用共通的。
            [attributedString addAttribute:NSParagraphStyleAttributeName value:[weakSelf.zzAttributes objectForKey:NSParagraphStyleAttributeName] range:NSMakeRange(0u, attributedString.length)];
        }
        
        if (![attributes objectForKey:NSBaselineOffsetAttributeName] && [weakSelf.zzAttributes objectForKey:NSBaselineOffsetAttributeName] != nil) {
            // Jeff : attributes已设置，且当前指定了共通的，但attributes未指定NSBaselineOffsetAttributeName的情况下，使用共通的。
            [attributedString addAttribute:NSBaselineOffsetAttributeName value:[weakSelf.zzAttributes objectForKey:NSBaselineOffsetAttributeName] range:NSMakeRange(0u, attributedString.length)];
        }
        
        // and save the rages of the full matches and the replacements
        [values addObject:[NSValue valueWithRange:result.range]];
        [replacementStrings addObject:attributedString];
    }];
    
    NSUInteger locationOffset = 0;
    
    // Iterate over the range values and replace those characters with the replacement string
    for (NSUInteger index = 0; index < [values count]; ++index) {
        // Unbox the range
        NSRange range = [[values objectAtIndex:index] rangeValue];
        
        // Apply the offset
        range.location += locationOffset;
        
        NSAttributedString *replacementString = [replacementStrings objectAtIndex:index];
        [_attributedString replaceCharactersInRange:range withAttributedString:replacementString];
        
        locationOffset = locationOffset - range.length + [replacementString length];
    }
}

@end

#pragma mark - ZZMarkdownParser

@interface ZZMarkdownParser ()

@property (nonatomic, strong) NSArray *markdownTextParsers;

@end

@implementation ZZMarkdownParser

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
           attributedHeader5:(nullable NSDictionary<NSAttributedStringKey, id> *)attributedHeader5 {
    
    ZZMarkdownParser *parser = [[ZZMarkdownParser alloc] init];
    parser.zzMissAttributeItalicBold = missParseItalicBold;
    parser.zzMissAttributeBold = missParseBold;
    parser.zzMissAttributeItalic = missParseItalic;
    // 支持的Patten
    parser.zzSupporttedPattern = supportPattern;
    // 通用的
    parser.zzAttributes = attributes;
    // Header Pattern 字体和段落属性设置
    parser.attributedHeader1 = attributedHeader1;
    parser.attributedHeader2 = attributedHeader2;
    parser.attributedHeader3 = attributedHeader3;
    parser.attributedHeader4 = attributedHeader4;
    parser.attributedHeader5 = attributedHeader5;
    // URL Pattern 字体和段落属性设置
    parser.attributedURLBrakets = attributedURLBrakets;
    // URL Annotation Pattern 字体和段落属性设置
    parser.attributedURLAnnotation = attributedURLAnnotation;
    // URL Raw Link 字体和段落属性设置
    parser.attributedURLRaw = attributedURLRaw;
    return parser;
}

/**
 *  重写zzTextParsers属性
 */
- (NSArray *)zzTextParsers {
    
    if (self.markdownTextParsers) {
        return self.markdownTextParsers;
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *textParsers = [NSMutableArray array];
    
    // Merge the client properties into the default ones and create the normal font
    UIFont *_font = [self.zzAttributes objectForKey:NSFontAttributeName] ? [self.zzAttributes objectForKey:NSFontAttributeName] : [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithName:_font.fontName size:_font.pointSize];
    UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:fontDescriptor.pointSize];
    
    // Italic Bold text: `***`
    if (self.zzSupporttedPattern & ZZTextParserPatternItalicBold) {
        
        UIFontDescriptor *italicBoldFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic | UIFontDescriptorTraitBold];
        UIFont *italicBoldFont = [UIFont fontWithDescriptor:italicBoldFontDescriptor size:fontDescriptor.pointSize];
        NSDictionary *italicBoldAttributes = @{NSFontAttributeName: italicBoldFont};
        // ZZTextParser *italicBoldMarkdownParser = [ZZTextParser textParserWithDelimiter:@"***" attributes:italicBoldAttributes];
        ZZTextParser *italicBoldMarkdownParser = [ZZTextParser zz_textParserWithOpeningDelimiter:@"***" closingDelimiter:@"***" returnSpilit:@"" attributes:italicBoldAttributes];
        italicBoldMarkdownParser.zzPattern = ZZTextParserPatternItalicBold;
        [textParsers addObject:italicBoldMarkdownParser];
    }
    
    // Bold text: `**`
    if (self.zzSupporttedPattern & ZZTextParserPatternBold) {
        
        UIFontDescriptor *boldFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
        UIFont *boldFont = [UIFont fontWithDescriptor:boldFontDescriptor size:fontDescriptor.pointSize];
        NSDictionary *boldAttributes = @{NSFontAttributeName: boldFont};
        // ZZTextParser *boldMarkdownParser = [ZZTextParser textParserWithDelimiter:@"**" attributes:boldAttributes];
        ZZTextParser *boldMarkdownParser = [ZZTextParser zz_textParserWithOpeningDelimiter:@"**" closingDelimiter:@"**" returnSpilit:@"" attributes:boldAttributes];
        boldMarkdownParser.zzPattern = ZZTextParserPatternBold;
        [textParsers addObject:boldMarkdownParser];
    }
    
    // Italic text: `*`
    if (self.zzSupporttedPattern & ZZTextParserPatternItalic) {
        
        UIFontDescriptor *italicFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
        UIFont *italicFont = [UIFont fontWithDescriptor:italicFontDescriptor size:fontDescriptor.pointSize];
        NSDictionary *italicAttributes = @{NSFontAttributeName: italicFont};
        // ZZTextParser *italicMarkdownParser = [ZZTextParser textParserWithDelimiter:@"*" attributes:italicAttributes];
        ZZTextParser *italicMarkdownParser = [ZZTextParser zz_textParserWithOpeningDelimiter:@"*" closingDelimiter:@"*" returnSpilit:@"" attributes:italicAttributes];
        italicMarkdownParser.zzPattern = ZZTextParserPatternItalic;
        [textParsers addObject:italicMarkdownParser];
    }
    
    // Underlined text: `_`
    if (self.zzSupporttedPattern & ZZTextParserPatternUnderlined) {
        
        NSDictionary *underlineAttributes = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
        ZZTextParser *underlineMarkdownParser = [ZZTextParser zz_textParserWithDelimiter:@"_" attributes:underlineAttributes];
        underlineMarkdownParser.zzPattern = ZZTextParserPatternUnderlined;
        [textParsers addObject:underlineMarkdownParser];
        // Monospace text: `\``
        // iOS only has two monospace fonts by default: Courier and AmericanTypewriter
        UIFont *monospaceFont = [UIFont fontWithName:@"Courier" size:font.pointSize];
        NSDictionary *monospaceAttributes = @{NSFontAttributeName: monospaceFont};
        
        ZZTextParser *monospaceMarkdownParser = [ZZTextParser zz_textParserWithDelimiter:@"`" attributes:monospaceAttributes];
        monospaceMarkdownParser.zzPattern = ZZTextParserPatternMonospace;
        [textParsers addObject:monospaceMarkdownParser];
    }
    
    // URLs: `<...>`
    if (self.zzSupporttedPattern & ZZTextParserPatternURLBrakets) {
        
        NSString *URLPattern = @"(<)(.+?)(>)";
        ZZTextParserProcessingBlock URLProcessingBlock = ^ NSArray * (NSArray *results) {
            NSString *URLString = [results objectAtIndex:2];
            NSDictionary *attributes = nil;
            if (weakSelf.attributedURLBrakets != nil) {
                attributes = [NSMutableDictionary dictionaryWithObject:URLString forKey:NSLinkAttributeName];
                [attributes setValuesForKeysWithDictionary:weakSelf.attributedURLBrakets];
            }else {
                attributes = @{NSLinkAttributeName: URLString};
            }
            return @[URLString, attributes];
        };
        
        ZZTextParser *URLMarkdownParser = [ZZTextParser zz_textParserWithTextPattern:URLPattern processingBlock:URLProcessingBlock];
        URLMarkdownParser.zzPattern = ZZTextParserPatternURLBrakets;
        [textParsers addObject:URLMarkdownParser];
    }
    
    // Headers: `#`, `##`, etc.
    if (self.zzSupporttedPattern & ZZTextParserPatternHeader) {
        
        NSString *headerPattern = @"(#+)( ?)(.+?)[\r\n]";
        ZZTextParserProcessingBlock headerProcessingBlock = ^ NSArray * (NSArray *results) {
            NSString *hashes = [results objectAtIndex:1];
            NSUInteger hashCount = [hashes length];
            NSString *headerString = [results objectAtIndex:3];
            // Jeff : 新增
            if (weakSelf.attributedHeader1 != nil ||
                weakSelf.attributedHeader2 != nil ||
                weakSelf.attributedHeader3 != nil ||
                weakSelf.attributedHeader4 != nil ||
                weakSelf.attributedHeader5 != nil) {
                switch (hashCount) {
                    case 1:
                    {
                        if (weakSelf.attributedHeader1 != nil) {
                            return @[headerString, weakSelf.attributedHeader1];
                        }else {
                            return @[headerString, @{ZZShowOriginalTextKey:@YES}];
                        }
                        break;
                    }
                    case 2:
                    {
                        if (weakSelf.attributedHeader2 != nil) {
                            return @[headerString, weakSelf.attributedHeader2];
                        }else if (weakSelf.attributedHeader1 == nil) {
                            return @[headerString, @{ZZShowOriginalTextKey:@YES}];
                        }
                        break;
                    }
                    case 3:
                    {
                        if (weakSelf.attributedHeader3 != nil) {
                            return @[headerString, weakSelf.attributedHeader3];
                        }else if (weakSelf.attributedHeader1 == nil && weakSelf.attributedHeader2 == nil) {
                            return @[headerString, @{ZZShowOriginalTextKey:@YES}];
                        }
                        break;
                    }
                    case 4:
                    {
                        if (weakSelf.attributedHeader4 != nil) {
                            return @[headerString, weakSelf.attributedHeader4];
                        }else if (weakSelf.attributedHeader1 == nil && weakSelf.attributedHeader2 == nil && weakSelf.attributedHeader3 == nil) {
                            return @[headerString, @{ZZShowOriginalTextKey:@YES}];
                        }
                        break;
                    }
                    case 5:
                    {
                        if (weakSelf.attributedHeader5 != nil) {
                            return @[headerString, weakSelf.attributedHeader5];
                        }else if (weakSelf.attributedHeader1 == nil && weakSelf.attributedHeader2 == nil && weakSelf.attributedHeader3 == nil && weakSelf.attributedHeader4 == nil) {
                            return @[headerString, @{ZZShowOriginalTextKey:@YES}];
                        }
                        break;
                    }
                }
                return @[headerString, @{}];
            }else{
                // Jeff : 原先作者
                UIFontDescriptor *boldFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
                CGFloat size = boldFontDescriptor.pointSize + 24 - 6 * MIN(hashCount, 4);
                UIFont *headerFont = [UIFont fontWithDescriptor:boldFontDescriptor size:size];
                CGFloat baselineOffset = 10.0 - MAX(hashCount, 4);
                NSDictionary *attributes = @{NSFontAttributeName: headerFont, NSBaselineOffsetAttributeName: @(baselineOffset)};
                return @[headerString, attributes];
            }
        };
        
        ZZTextParser *headerMarkdownParser = [ZZTextParser zz_textParserWithTextPattern:headerPattern processingBlock:headerProcessingBlock];
        headerMarkdownParser.zzPattern = ZZTextParserPatternHeader;
        [textParsers addObject:headerMarkdownParser];
    }
    
    // URLs: `[...](...)`
    if (self.zzSupporttedPattern & ZZTextParserPatternURLAnnotation) {
        
        NSString *URLPattern = @"(\\[)(.+?)(])(\\()(.+?)(\\))";
        ZZTextParserProcessingBlock URLProcessingBlock = ^ NSArray * (NSArray *results) {
            
            NSString *URLString = [results objectAtIndex:5];
            NSDictionary *attributes = nil;
            if (weakSelf.attributedURLAnnotation != nil) {
                attributes = [NSMutableDictionary dictionaryWithObject:URLString forKey:NSLinkAttributeName];
                [attributes setValuesForKeysWithDictionary:weakSelf.attributedURLAnnotation];
            }else {
                attributes = @{NSLinkAttributeName: URLString};
            }
            NSString *replacementString = [results objectAtIndex:2];
            return @[replacementString, attributes];
        };
        
        ZZTextParser *URLMarkdownParser = [ZZTextParser zz_textParserWithTextPattern:URLPattern processingBlock:URLProcessingBlock];
        URLMarkdownParser.zzPattern = ZZTextParserPatternURLAnnotation;
        [textParsers addObject:URLMarkdownParser];
    }
    
    // URLs: `http(s)`
    if (self.zzSupporttedPattern & ZZTextParserPatternURLRaw) {
        
        NSString *URLPattern = @"https?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
        ZZTextParserProcessingBlock URLProcessingBlock = ^ NSArray * (NSArray *results) {
            NSString *URLString = [results objectAtIndex:0];
            NSDictionary *attributes = nil;
            if (weakSelf.attributedURLRaw != nil) {
                attributes = [NSMutableDictionary dictionaryWithObject:URLString forKey:NSLinkAttributeName];
                [attributes setValuesForKeysWithDictionary:weakSelf.attributedURLRaw];
            }else {
                attributes = @{NSLinkAttributeName: URLString};
            }
            return @[URLString, attributes];
        };
        
        ZZTextParser *URLMarkdownParser = [ZZTextParser zz_textParserWithTextPattern:URLPattern processingBlock:URLProcessingBlock];
        URLMarkdownParser.zzPattern = ZZTextParserPatternURLRaw;
        [textParsers addObject:URLMarkdownParser];
    }
    
    self.markdownTextParsers = [NSArray arrayWithArray:textParsers];
    return self.markdownTextParsers;
}

@end

#pragma mark - ZZWidgetMDTextView

@interface ZZWidgetMDTextView() <UITextViewDelegate>

// UI
@property (nonatomic, strong) UITextView *markdownTextView;

// Markdown 解析器
@property (nonatomic, strong) ZZMarkdownParser *parser;

// Markdown 解析后文本
@property (nonatomic, strong) NSAttributedString *attributedText;

// Markdown 文本是否含有URL
@property (nonatomic, assign) BOOL hasURL;

// Markdown 文本渲染后高度
@property (nonatomic, assign) CGFloat height;

// 边界距离
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

// 重新计算高度回调
@property (nonatomic, weak) id<ZZWidgetMDTextViewDelegate> delegate;

// URL点击回调
@property (nonatomic, copy) void(^urlBlock)(NSURL *url);

@end

@implementation ZZWidgetMDTextView

- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (_markdownTextView != nil && fabs(self.markdownTextView.frame.size.height - self.frame.size.height) > 0.1) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.markdownTextView.frame.size.height + self.edgeInsets.top + self.edgeInsets.bottom);
        _markdownTextView.frame = CGRectMake(self.edgeInsets.left, self.edgeInsets.top, self.frame.size.width - self.edgeInsets.left - self.edgeInsets.right, self.frame.size.height - self.edgeInsets.top - self.edgeInsets.bottom);
        self.height = self.frame.size.height;
        if (self.delegate && [self.delegate respondsToSelector:@selector(zz_markDownResizeHeight:)]) {
            [self.delegate zz_markDownResizeHeight:self.height];
        }
    }
}

- (void)setText:(NSString *)text {
    
    _text = text;
    _hasURL = [text containsString:@"http://"] || [text containsString:@"https://"];
    _attributedText = [self.parser zz_attributedStringFromString:text];
    CGFloat h = [_attributedText zz_height:self.frame.size.width - _edgeInsets.left - _edgeInsets.right];
    self.height = h + _edgeInsets.top + _edgeInsets.bottom;
}

/**
 *  重新刷新
 */
- (void)render {
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.height);
    if (_markdownTextView == nil) {
        _markdownTextView = [[UITextView alloc] init];
        _markdownTextView.textContainerInset = UIEdgeInsetsZero;
        _markdownTextView.delegate = self;
        _markdownTextView.showsVerticalScrollIndicator = NO;
        _markdownTextView.showsHorizontalScrollIndicator = NO;
        _markdownTextView.scrollEnabled = NO;
        _markdownTextView.editable = self.editable;
        _markdownTextView.backgroundColor = self.backgroundColor;
        [self addSubview:_markdownTextView];
        _markdownTextView.frame = CGRectMake(self.edgeInsets.left, self.edgeInsets.top, self.bounds.size.width - self.edgeInsets.left - self.edgeInsets.right, self.bounds.size.height - self.edgeInsets.top - self.edgeInsets.bottom);
    }
    self.markdownTextView.attributedText = self.attributedText;
    [self.markdownTextView sizeToFit];
}

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
                      urlBlock:(nullable void(^)(NSURL *url))urlBlock {
    
    // 参数缺省检查
    
    // 一般通用文件段落式样
    NSMutableDictionary *_attributes = [[NSMutableDictionary alloc] init];
    if (font) {
        [_attributes setObject:font forKey:NSFontAttributeName];
    }else {
        [_attributes setObject:[UIFont systemFontOfSize:14]  forKey:NSFontAttributeName];
    }
    if (color) {
        [_attributes setObject:color forKey:NSForegroundColorAttributeName];
    }else {
        [_attributes setObject:@"#333333".zz_color forKey:NSForegroundColorAttributeName];
    }
    if (paragraphStyle) {
        [_attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    }else {
        NSMutableParagraphStyle *_paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        _paragraphStyle.minimumLineHeight = 24.0;
        _paragraphStyle.maximumLineHeight = 24.0;
        [_attributes setObject:_paragraphStyle forKey:NSParagraphStyleAttributeName];
    }
    if (baselineOffset) {
        [_attributes setObject:baselineOffset forKey:NSBaselineOffsetAttributeName];
    }else {
        [_attributes setObject:@(6.0) forKey:NSBaselineOffsetAttributeName];
    }
    if (debug) {
        [_attributes setObject:[[UIColor blueColor] colorWithAlphaComponent:0.5] forKey:NSBackgroundColorAttributeName];
    }
    
    // Header 2 文字段落式样
    if (attributedHeader2 == nil) {
        UIFont *fontHeader2 = nil;
        if (@available(iOS 8.2, *)) {
            fontHeader2 = [UIFont systemFontOfSize:18.0 weight:UIFontWeightBold];
        } else {
            fontHeader2 = [UIFont systemFontOfSize:18.0];
        }
        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle2.minimumLineHeight = 32.0;
        if (!debug) {
            attributedHeader2 = @{NSFontAttributeName : fontHeader2, NSForegroundColorAttributeName : @"#3C3C3C".zz_color, NSParagraphStyleAttributeName : paragraphStyle2, NSBaselineOffsetAttributeName : @(3.0)};
        }else {
            attributedHeader2 = @{NSFontAttributeName : fontHeader2, NSForegroundColorAttributeName : @"#3C3C3C".zz_color, NSParagraphStyleAttributeName : paragraphStyle2, NSBaselineOffsetAttributeName : @(3.0) , NSBackgroundColorAttributeName : [[UIColor greenColor] colorWithAlphaComponent:0.5]};
        }
    }
    
    // Header 3  文字段落式样
    if (attributedHeader3 == nil) {
        UIFont *fontHeader3 = nil;
        if (@available(iOS 8.2, *)) {
            fontHeader3 = [UIFont systemFontOfSize:16.0 weight:UIFontWeightBold];
        } else {
            fontHeader3 = [UIFont systemFontOfSize:16.0];
        }
        NSMutableParagraphStyle *paragraphStyle3 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle3.minimumLineHeight = 32.0;
        if (!debug) {
            attributedHeader3 = @{NSFontAttributeName : fontHeader3, NSForegroundColorAttributeName : @"#3C3C3C".zz_color, NSParagraphStyleAttributeName : paragraphStyle3, NSBaselineOffsetAttributeName : @(6.0)};
        }else {
            attributedHeader3 = @{NSFontAttributeName : fontHeader3, NSForegroundColorAttributeName : @"#3C3C3C".zz_color, NSParagraphStyleAttributeName : paragraphStyle3, NSBaselineOffsetAttributeName : @(6.0), NSBackgroundColorAttributeName : [[UIColor redColor] colorWithAlphaComponent:0.5]};
        }
    }
    
    // URL Brakets 文字段落式样
    if (attributedURLBrakets == nil) {
        attributedURLBrakets = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSUnderlineStyleAttributeName : @1, NSBaselineOffsetAttributeName : @(6.0)};
    }
    
    // URL Annotation 文字段落式样
    if (attributedURLAnnotation == nil) {
        attributedURLAnnotation = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSBaselineOffsetAttributeName : @(6.0)};
    }
    
    // URL Raw 文字段落式样
    if (attributedURLRaw == nil) {
        attributedURLRaw = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0], NSUnderlineStyleAttributeName : @1, NSBaselineOffsetAttributeName : @(6.0)};
    }
    
    return [ZZWidgetMDTextView create:frame
                      backgroundColor:[UIColor whiteColor]
                         parsePattern:ZZTextParserPatternFont | ZZTextParserPatternHeader | ZZTextParserPatternURLAnnotation | ZZTextParserPatternURLRaw
                           edgeInsets:edgeInsets
                                 text:text
                           attributes:_attributes
                    attributedHeader1:nil
                    attributedHeader2:attributedHeader2
                    attributedHeader3:attributedHeader3
                    attributedHeader4:nil
                    attributedHeader5:nil
                 attributedURLBrakets:attributedURLBrakets
              attributedURLAnnotation:attributedURLAnnotation
                     attributedURLRaw:attributedURLRaw
              missAttributeItalicBold:NO
                    missAttributeBold:NO
                  missAttributeItalic:NO
                             delegate:delegate
                             urlBlock:urlBlock];
}

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
                      delegate:(nullable  id<ZZWidgetMDTextViewDelegate>)delegate
                      urlBlock:(nullable void(^)(NSURL *url))urlBlock {
    
    ZZWidgetMDTextView *markdownView = [[ZZWidgetMDTextView alloc] initWithFrame:frame];
    markdownView.backgroundColor = backgroundColor;
    markdownView.parser = [ZZMarkdownParser create:parsePattern
                                        attributes:attributes
                               missParseItalicBold:missAttributeItalicBold
                                     missParseBold:missAttributeBold
                                   missParseItalic:missAttributeItalic
                              attributedURLBrakets:attributedURLBrakets
                           attributedURLAnnotation:attributedURLAnnotation
                                  attributedURLRaw:attributedURLRaw
                                 attributedHeader1:attributedHeader1
                                 attributedHeader2:attributedHeader2
                                 attributedHeader3:attributedHeader3
                                 attributedHeader4:attributedHeader4
                                 attributedHeader5:attributedHeader5];
    
    markdownView.edgeInsets = edgeInsets;
    markdownView.delegate = delegate;
    markdownView.urlBlock = urlBlock;
    markdownView.text = text;
    return markdownView;
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    self.urlBlock == nil ? : self.urlBlock(URL);
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction  API_AVAILABLE(ios(10.0)) {
    
    self.urlBlock == nil ? : self.urlBlock(URL);
    return NO;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
