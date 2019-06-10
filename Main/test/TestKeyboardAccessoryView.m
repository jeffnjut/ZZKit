//
//  TestKeyboardAccessoryView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/10.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestKeyboardAccessoryView.h"
#import "UIImage+ZZKit.h"

@interface TestKeyboardAccessoryView ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation TestKeyboardAccessoryView

- (IBAction)_tapAddWord:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"test"];
    if (self.textField.text.length == 0) {
        self.imageView.image = image;
        return;
    }
    image = [image zz_imageWaterMarkWithText:self.textField.text textPoint:CGPointMake(5, 5) attribute:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:48.0 weight:UIFontWeightHeavy]}];
    self.imageView.image = image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
