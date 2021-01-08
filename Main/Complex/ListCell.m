//
//  ListCell.m
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "ListCell.h"
#import "UIColor+ZZKit.h"

@implementation ListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setZzData:(__kindof ZZTableViewCellDataSource *)zzData {
    
    [super setZzData:zzData];
    self.contentView.backgroundColor = [UIColor  zz_randomColor];
}

@end

@implementation ListCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzHeight = 200.0;
    }
    return self;
}

@end
