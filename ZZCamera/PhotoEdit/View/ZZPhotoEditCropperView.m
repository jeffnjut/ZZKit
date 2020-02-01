//
//  ZZPhotoEditCropperView.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZPhotoEditCropperView.h"
#import "ZZMacro.h"

@interface ZZPhotoEditCropperView ()

@property (nonatomic, weak) IBOutlet UIImageView *crop1to1ImageView;
@property (nonatomic, weak) IBOutlet UIImageView *crop3to4ImageView;
@property (nonatomic, weak) IBOutlet UIImageView *crop4to3ImageView;
@property (nonatomic, weak) IBOutlet UIImageView *crop4to5ImageView;
@property (nonatomic, weak) IBOutlet UIImageView *crop5to4ImageView;

@property (nonatomic, copy) void(^crop1to1)(void);
@property (nonatomic, copy) void(^crop3to4)(void);
@property (nonatomic, copy) void(^crop4to3)(void);
@property (nonatomic, copy) void(^crop4to5)(void);
@property (nonatomic, copy) void(^crop5to4)(void);

@end

@implementation ZZPhotoEditCropperView

+ (ZZPhotoEditCropperView *)create:(CGRect)frame editingBlock:(void(^)(BOOL inEditing))editingBlock crop1to1:(void(^)(void))crop1to1 crop3to4:(void(^)(void))crop3to4 crop4to3:(void(^)(void))crop4to3 crop4to5:(void(^)(void))crop4to5 crop5to4:(void(^)(void))crop5to4 okBlock:(void(^)(NSString *ratio))okBlock {
    
    ZZPhotoEditCropperView *view = ZZ_LOAD_NIB(@"ZZPhotoEditCropperView");
    view.frame = frame;
    view.editingBlock = editingBlock;
    view.okBlock = okBlock;
    view.crop1to1 = crop1to1;
    view.crop3to4 = crop3to4;
    view.crop4to3 = crop4to3;
    view.crop4to5 = crop4to5;
    view.crop5to4 = crop5to4;
    return view;
}

- (IBAction)_tap1_1:(id)sender {
    
    self.editingBlock == nil ? : self.editingBlock(YES);
    [self _setImageHighlighted:self.crop1to1ImageView];
    self.crop1to1 == nil ? : self.crop1to1();
}

- (IBAction)_tap3_4:(id)sender {
    
    self.editingBlock == nil ? : self.editingBlock(YES);
    [self _setImageHighlighted:self.crop3to4ImageView];
    self.crop3to4 == nil ? : self.crop3to4();
}

- (IBAction)_tap4_3:(id)sender {
    
    self.editingBlock == nil ? : self.editingBlock(YES);
    [self _setImageHighlighted:self.crop4to3ImageView];
    self.crop4to3 == nil ? : self.crop4to3();
}

- (IBAction)_tap4_5:(id)sender {
    
    self.editingBlock == nil ? : self.editingBlock(YES);
    [self _setImageHighlighted:self.crop4to5ImageView];
    self.crop4to5 == nil ? : self.crop4to5();
}

- (IBAction)_tap5_4:(id)sender {
    
    self.editingBlock == nil ? : self.editingBlock(YES);
    [self _setImageHighlighted:self.crop5to4ImageView];
    self.crop5to4 == nil ? : self.crop5to4();
}

- (IBAction)_tapBack:(id)sender {
    
    self.editingBlock == nil ? : self.editingBlock(NO);
    [self removeFromSuperview];
}

- (IBAction)_tapOK:(id)sender {

    self.editingBlock == nil ? : self.editingBlock(NO);
    if (self.okBlock) {
        NSString *ratio = nil;
        if (self.crop1to1ImageView.isHighlighted) {
            ratio = @"1:1";
        }else if (self.crop3to4ImageView.isHighlighted) {
            ratio = @"3:4";
        }else if (self.crop4to3ImageView.isHighlighted) {
            ratio = @"4:3";
        }else if (self.crop4to5ImageView.isHighlighted) {
            ratio = @"4:5";
        }else if (self.crop5to4ImageView.isHighlighted) {
            ratio = @"5:4";
        }
        self.okBlock(ratio);
    }
    [self removeFromSuperview];
}

- (void)_setImageHighlighted:(UIImageView *)imageView {
    
    if ([imageView isEqual:self.crop1to1ImageView]) {
        [self.crop1to1ImageView setHighlighted:YES];
    }else {
        [self.crop1to1ImageView setHighlighted:NO];
    }
    
    if ([imageView isEqual:self.crop3to4ImageView]) {
        [self.crop3to4ImageView setHighlighted:YES];
    }else {
        [self.crop3to4ImageView setHighlighted:NO];
    }
    
    if ([imageView isEqual:self.crop4to3ImageView]) {
        [self.crop4to3ImageView setHighlighted:YES];
    }else {
        [self.crop4to3ImageView setHighlighted:NO];
    }
    
    if ([imageView isEqual:self.crop4to5ImageView]) {
        [self.crop4to5ImageView setHighlighted:YES];
    }else {
        [self.crop4to5ImageView setHighlighted:NO];
    }
    
    if ([imageView isEqual:self.crop5to4ImageView]) {
        [self.crop5to4ImageView setHighlighted:YES];
    }else {
        [self.crop5to4ImageView setHighlighted:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
