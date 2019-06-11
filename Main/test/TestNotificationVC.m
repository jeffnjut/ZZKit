//
//  TestNotificationVC.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/10.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestNotificationVC.h"
#import "NSObject+ZZKit_Notification.h"
#import "TestKeyboardAccessoryView.h"
#import "UIControl+ZZKit_Keyboard.h"
#import "ZZEnumCompare.h"
#import "ZZMacro.h"

@interface TestNotificationVC ()

@property (nonatomic, copy) NSString *text;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation TestNotificationVC

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self zz_addObserverBlockForKeyPath:@"text" block:^(id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"1 oldValue : %@  newValue : %@", oldValue, newValue);
    }];
    
    [self zz_addObserverBlockForKeyPath:@"text" block:^(id  _Nonnull object, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"2 oldValue : %@  newValue : %@", oldValue, newValue);
    }];
    
    // [self zz_removeObserverBlockForKeyPath:@"text"];
    
    [self zz_removeAllObserverBlocks];
    
    self.text = @"A";
    self.text = @"B";
    
    [self zz_addNotificationBlockForName:@"Haha" block:^(NSNotification * _Nonnull notification) {
        NSLog(@"1 === %@", notification);
    }];
    
    [self zz_addNotificationBlockForName:@"Haha" block:^(NSNotification * _Nonnull notification) {
        NSLog(@"2 === %@", notification);
    }];
    
    [self zz_addNotificationBlockForName:@"zz" block:^(NSNotification * _Nonnull notification) {
        NSLog(@"zz === %@", notification);
    }];
    
    [self.view zz_addNotificationBlockForName:@"Haha" block:^(NSNotification * _Nonnull notification) {
        NSLog(@"3 === %@", notification);
    }];
    
    [self.view zz_addNotificationBlockForName:@"Haha" block:^(NSNotification * _Nonnull notification) {
        NSLog(@"4 === %@", notification);
    }];
    
    // [self zz_removeNotificationBlockForName:@"haha"];
    
    // [self zz_removeNotificationBlockForName:@"Haha"];
    
    [self zz_removeAllNotificationBlocks];
    
    [self.view zz_removeNotificationBlockForName:@"Haha"];
}

- (IBAction)_tapPostNotification:(id)sender {
    
    [self zz_postNotificationWithName:@"Haha" userInfo:@{@"name" : @"ffff"}];
}

- (IBAction)_tapPushKeyboard:(id)sender {
    
    [self.textField zz_createInputAccessory:^UIView * _Nonnull{
        
        TestKeyboardAccessoryView *view = [NSBundle.mainBundle loadNibNamed:@"TestKeyboardAccessoryView" owner:nil options:nil].lastObject;
        view.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 100.0);
        return view;
    }];
    // [self.textField becomeFirstResponder];
}

- (IBAction)_tapEnumTypeSetting:(id)sender {
    
    ZZEnumCompare *enumCompare = [[ZZEnumCompare alloc] init];
    [enumCompare zz_addType:0x0001];
    [enumCompare zz_addType:0x0100];
    [enumCompare zz_addType:0x0002];
    
    NSLog(@"%d", [enumCompare zz_hasType:0x0005]);
    NSLog(@"%d", [enumCompare zz_hasType:0x0001 | 0x0002]);
    NSLog(@"%d", [enumCompare zz_hasType:0x0004]);
    NSLog(@"%d", [enumCompare zz_hasType:0x0002]);
    NSLog(@"%d", [enumCompare zz_hasType:0x0101]);
    NSLog(@"%d", [enumCompare zz_hasType:0x0001]);
    
    [enumCompare zz_removeType:0x0002];
    NSLog(@"%d", [enumCompare zz_hasType:0x0001 | 0x0002]);
    
    NSLog(@"%d", [enumCompare zz_hasType:0x0001]);
    
    NSLog(@"%d", [enumCompare zz_hasType:0x0002]);
    
    [enumCompare zz_setType:0];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
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
