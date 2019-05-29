//
//  TestFontVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/5/29.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestFontVC.h"
#import "UIFont+ZZKit.h"

@interface TestFontVC ()

@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property (nonatomic, weak) IBOutlet UILabel *label3;

@end

@implementation TestFontVC

- (void)viewDidLoad {
    
    NSLog(@"%@,%@,%@,%@", UIFontSymbolicTrait, UIFontWeightTrait, UIFontWidthTrait, UIFontSlantTrait);
    
    [super viewDidLoad];
    
    NSArray* familys = [UIFont familyNames];
    
    for (int i = 0; i<[familys count]; i++) {
        
        NSString* family = [familys objectAtIndex:i];
        NSLog(@"\r\n\r\nFontfamily:%@\r\n=====",family);
        
        NSArray* fonts = [UIFont fontNamesForFamilyName:family];
        
        for (int j = 0; j<[fonts count]; j++) {
            
            NSLog(@"%@",[fonts objectAtIndex:j]);
        }
    }

    CGFloat fontSize = 28.0;
    
    // Do any additional setup after loading the view from its nib.
    self.label1.font = [UIFont fontWithName:@"Menlo-Regular" size:fontSize];
    
    UIFontDescriptor *descriptor = [UIFontDescriptor fontDescriptorWithName:@"Menlo-BoldItalic" size:fontSize];
    
    descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic | UIFontDescriptorTraitBold];
    
    self.label2.font = [UIFont fontWithDescriptor:descriptor size:0];
    
    descriptor = [UIFontDescriptor fontDescriptorWithName:@"PingFangSC-Semibold" matrix:CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0)];

    NSLog(@"%@", UIFontDescriptorTraitsAttribute);
    
    self.label3.font = [UIFont fontWithDescriptor:descriptor size:fontSize];
    
    descriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:@"PingFang TC",
                                                                      UIFontDescriptorSizeAttribute:@(fontSize),
                                                                      // UIFontDescriptorNameAttribute:@"PingFangTC-Regular",
                                                                      UIFontDescriptorTraitsAttribute:@{
                                                                              UIFontSymbolicTrait:@(UIFontDescriptorTraitItalic),
                                                                              UIFontWeightTrait:@(UIFontWeightUltraLight),
                                                                              UIFontWidthTrait:@(10.0),
                                                                              UIFontSlantTrait:@(0.2)
                                                                              }
                                                                      }];
    self.label3.font = [UIFont fontWithDescriptor:descriptor size:0];
    descriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:@"PingFang TC",
                                                                      UIFontDescriptorNameAttribute:@"PingFangTC-Regular",
                                                                      UIFontDescriptorSizeAttribute:@(fontSize),
                                                                      }];
    descriptor = [descriptor fontDescriptorWithFace:@"Bold"];
    self.label2.font = [UIFont fontWithDescriptor:descriptor size:0];
    self.label2.transform = CGAffineTransformMake(1, 0, tanf(-15 * (CGFloat)M_PI / 180), 1, 0, 0);
    
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
