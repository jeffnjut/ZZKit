//
//  TestMarkdownViewController.m
//  ZZKit
//
//  Created by Fu Jie on 2019/8/7.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestMarkdownViewController.h"
#import "ZZWidgetMDTextView.h"
#import "UIView+ZZKit.h"

@interface TestMarkdownViewController ()

@end

@implementation TestMarkdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *text = @"##大标题 32pt，底部间距 8pt\n###小标题 24pt，底部间距 8pt\n普通文字 24pt，底部间距 8pt换行高度 16pt\n普通文字 24pt，底部间距 8pt换行高度 16pt\n普通文字 24pt，底部间距 8pt换行高度 16pt\n#Markdown Editor\nThis is a simple markdown editor based on `YYTextView`.\n*********************************************\nIt\'s *italic* style.\nIt\'s also _italic_ style.\nIt\'s **bold** style.\nIt\'s ***italic and bold*** style.\nIt\'s __underline__ style.\nIt\'s ~~deleteline~~ style.\nHere is a link: [YYKit](https://github.com/ibireme/YYKit)";
    ZZWidgetMDTextView *mdView = [ZZWidgetMDTextView create:CGRectMake(10, 90, UIScreen.mainScreen.bounds.size.width - 20.0, 10)
                                                 edgeInsets:UIEdgeInsetsMake(30, 100, 30, 70)
                                                       text:text
                                                       font:[UIFont systemFontOfSize:14.0]
                                                      color:[UIColor blackColor]
                                             paragraphStyle:nil
                                             baselineOffset:@(6.0)
                                          attributedHeader2:nil
                                          attributedHeader3:nil
                                       attributedURLBrakets:nil
                                    attributedURLAnnotation:nil
                                           attributedURLRaw:nil
                                                      debug:YES
                                                   delegate:nil
                                                   urlBlock:^(NSURL * _Nonnull url) {
                                                       
                                                   }];
    [self.view addSubview:mdView];
    [mdView render];
    [mdView zz_borderWidth:1.0 boderColor:[UIColor blackColor]];
    [mdView.markdownTextView zz_borderWidth:2.0 boderColor:[UIColor redColor]];
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
