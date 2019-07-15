//
//  TestHeadCollectionViewCell.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/24.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestHeadCollectionViewCell.h"
#import "UIView+ZZKit_Blocks.h"
#import "ZZMacro.h"

@interface TestHeadCollectionViewCell()

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation TestHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    ZZ_WEAK_SELF
    [self.label zz_tapBlock:^(UITapGestureRecognizer * _Nonnull tapGesture, __kindof UIView * _Nonnull sender) {
        
        weakSelf.zzTapBlock(weakSelf.zzData, weakSelf);
        
    }];
}

- (void)setZzData:(__kindof ZZCollectionViewCellDataSource *)zzData {
    
    [super setZzData:zzData];
    self.backgroundColor = [UIColor blackColor];
}

@end

@implementation TestHeadCollectionViewCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 188.0);
    }
    return self;
}

@end
