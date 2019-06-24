//
//  TestHeadCollectionViewCell.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/24.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestHeadCollectionViewCell.h"

@implementation TestHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
        self.zzSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 88.0);
    }
    return self;
}

@end
