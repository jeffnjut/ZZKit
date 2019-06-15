//
//  TestCell.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/15.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestCell.h"

@interface TestCell()

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation TestCell

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
    TestCellDataSource *ds = zzData;
    self.label.text = ds.text;
}

- (IBAction)_tap:(id)sender {
    
    self.zzTapBlock == nil ? : self.zzTapBlock(self.zzData, self);
}

@end


@implementation TestCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzHeight = 80.0;
    }
    return self;
}

@end
