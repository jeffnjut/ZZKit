//
//  DemoHowtoCell.m
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "DemoHowtoCell.h"

@implementation DemoHowtoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation DemoHowtoCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzHeight = 150.0;
    }
    return self;
}

@end
