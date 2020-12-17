//
//  TestCollectionViewCell.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/24.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestCollectionViewCell.h"

@interface TestCollectionViewCell()

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation TestCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setZzData:(__kindof ZZCollectionViewCellDataSource *)zzData {
    
    [super setZzData:zzData];
    TestCollectionViewCellDataSource *ds = zzData;
    self.backgroundColor = ds.backgroundColor;
    self.label.text = ds.text;
}

@end

@implementation TestCollectionViewCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzHeight = 200 + arc4random() % 200;
    }
    return self;
}

@end
