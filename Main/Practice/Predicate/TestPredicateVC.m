//
//  TestPredicateVC.m
//  ZZKit
//
//  Created by Fu Jie on 2020/3/19.
//  Copyright © 2020 Jeff. All rights reserved.
//

#import "TestPredicateVC.h"
#import "NSString+ZZKit.h"

@interface TestPredicateVC ()

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation TestPredicateVC

- (NSArray *) dataSource {
    
    return @[
        @[@"非负整数",ZZ_PREDICATE_NON_NEGATIVE_INTEGER],
        @[@"非正整数",ZZ_PREDICATE_NON_POSITIVE_INTEGER],
        @[@"正整数",ZZ_PREDICATE_POSITIVE_INTEGER],
        @[@"负整数",ZZ_PREDICATE_NEGATIVE_INTEGER],
        @[@"整数",ZZ_PREDICATE_INTEGER],
        @[@"非负浮点数",ZZ_PREDICATE_NON_NEGATIVE_FLOAT],
        @[@"非正浮点数",ZZ_PREDICATE_NON_POSITIVE_FLOAT],
        @[@"正浮点数",ZZ_PREDICATE_POSITIVE_FLOAT],
        @[@"负浮点数",ZZ_PREDICATE_NEGATIVE_FLOAT],
        @[@"浮点数",ZZ_PREDICATE_FLOAT],
        @[@"26英文字符组成的字符串(不敏感大小写)",ZZ_PREDICATE_26_LETTER_IGNORE_CASE],
        @[@"26英文字符组成的字符串(大写)",ZZ_PREDICATE_26_LETTER_UPPER_CASE],
        @[@"26英文字符组成的字符串(小写)",ZZ_PREDICATE_26_LETTER_LOWER_CASE],
        @[@"26英文字符和数字组成的字符串(不敏感大小写)",ZZ_PREDICATE_26_LETTER_AND_NUMBER],
        @[@"26英文字符、数字和下划线组成的字符串(不敏感大小写)",ZZ_PREDICATE_26_LETTER_AND_NUMBER_AND_LINE],
        @[@"数字",ZZ_PREDICATE_NUMBER],
        @[@"N位数字",ZZ_PREDICATE_NUMBER_BY_LENGTH(6)],
        @[@"至少N位数组",ZZ_PREDICATE_NUMBER_BY_LEAST_LENGTH(6)],
        @[@"最多N位数组",ZZ_PREDICATE_NUMBER_BY_MOST_LENGTH(6)],
        @[@"[M,N]位数组",ZZ_PREDICATE_NUMBER_RANGE(6, 10)],
        @[@"邮箱",ZZ_PREDICATE_EMAIL],
        @[@"电话（包括座机和手机）",ZZ_PREDICATE_PHONE],
        @[@"国内座机电话",ZZ_PREDICATE_FIX_LINE],
        @[@"IP",ZZ_PREDICATE_IP],
        @[@"中文汉字",ZZ_PREDICATE_CHINESE_TEXT],
        @[@"双字节（包括汉字）",ZZ_PREDICATE_DOUBLE_BYTE_TEXT],
        @[@"空行",ZZ_PREDICATE_BLANK],
        @[@"URL",ZZ_PREDICATE_URL],
        @[@"时间格式：年-月-日",ZZ_PREDICATE_YEAR_MONTH_DAY_WITH_HYPEN],
        @[@"时间格式：月/日/年",ZZ_PREDICATE_YEAR_MONTH_DAY_WITH_SLASH],
        @[@"HTML SYNTAX（包含）",ZZ_PREDICATE_HTML_SYNTAX],
        @[@"QQ",ZZ_PREDICATE_QQ],
        @[@"Special Characters",ZZ_PREDICATE_SPECIAL_CHARACTERS],
        @[@"中国车牌",ZZ_PREDICATE_CAR_PLATE_NUMBER],
        @[@"身份证",ZZ_PREDICATE_ID_CARD],
        @[@"银行卡",ZZ_PREDICATE_BANK_CARD],
        @[@"用户名（字母开头，允许5-16字节，允许字母数字下划线）",ZZ_PREDICATE_USERNAME],
        @[@"昵称",ZZ_PREDICATE_NICKNAME],
        @[@"密码（以字母开头，长度在6~30 之间，只能包含字符、数字和下划线）",ZZ_PREDICATE_PASSWORD]
    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.textView.text zz_predicate:ZZ_PREDICATE_HTML_SYNTAX];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
