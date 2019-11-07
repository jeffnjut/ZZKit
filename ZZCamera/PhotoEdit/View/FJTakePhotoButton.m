//
//  FJTakePhotoButton.m
//  FJCamera
//
//  Created by Fu Jie on 2018/12/24.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "FJTakePhotoButton.h"
#import <Masonry/Masonry.h>
#import "ZZMacro.h"
#import "ZZDevice.h"
#import "NSString+ZZKit.h"

@interface FJTakePhotoButton ()


@property (nonatomic, weak) IBOutlet UIView *takePhotoView;
@property (nonatomic, weak) IBOutlet UIImageView *takePhotoImageView;
@property (nonatomic, weak) IBOutlet UILabel *takePhotoTextLabel;
@property (nonatomic, weak) IBOutlet UIView *draftView;
@property (nonatomic, copy) void(^takePhotoBlock)(void);
@property (nonatomic, copy) void(^draftBlock)(void);

@end

@implementation FJTakePhotoButton

+ (FJTakePhotoButton *)createOn:(UIView *)view withDraft:(BOOL)withDraft draftBlock:(void(^)(void))draftBlock takePhotoBlock:(void(^)(void))takePhotoBlock {
    
    FJTakePhotoButton *button = ZZ_LOAD_NIB(@"FJTakePhotoButton");
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(view);
        if (ZZ_DEVICE_IS_IPHONE_X_ALL) {
            make.height.equalTo(@68.0);
        }else {
            make.height.equalTo(@48.0);
        }
    }];
    [button updateWithDraft:withDraft];
    button.draftBlock = draftBlock;
    button.takePhotoBlock = takePhotoBlock;
    return button;
}

- (void)updateWithDraft:(BOOL)withDraft {
    
    ZZ_WEAK_SELF
    if (withDraft) {
        self.draftView.hidden = NO;
        [self.takePhotoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(weakSelf);
            make.right.equalTo(weakSelf.draftView.mas_left);
        }];
        [self.draftView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(weakSelf);
            make.width.equalTo(weakSelf.takePhotoView.mas_width);
        }];
        [self.takePhotoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.takePhotoView.mas_centerX);
            make.top.equalTo(weakSelf.takePhotoView).offset(8.0);
            make.width.mas_equalTo(24.0);
            make.height.mas_equalTo(24.0);
        }];
        [self.takePhotoTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.takePhotoView.mas_centerX);
            make.top.equalTo(weakSelf.takePhotoImageView.mas_bottom).offset(3.0);
        }];
    }else {
        self.draftView.hidden = YES;
        [self.takePhotoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        [self.takePhotoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.mas_centerX).offset(-24);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.width.mas_equalTo(24.0);
            make.height.mas_equalTo(24.0);
        }];
        self.takePhotoTextLabel.font = [UIFont systemFontOfSize:14.0];
        self.takePhotoTextLabel.textColor = @"#FF7A00".zz_color;
        [self.takePhotoImageView setHighlighted:YES];
        [self.takePhotoTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.mas_centerX).offset(24);
            make.centerY.equalTo(weakSelf.mas_centerY);
        }];
    }
}

- (IBAction)_tap:(UIButton *)sender {
    
    if (sender.tag == 0) {
        self.takePhotoBlock == nil ? : self.takePhotoBlock();
    }else if (sender.tag == 1) {
        self.draftBlock == nil ? : self.draftBlock();
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
