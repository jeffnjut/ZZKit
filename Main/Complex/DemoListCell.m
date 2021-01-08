//
//  DemoListCell.m
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "DemoListCell.h"

@interface DemoListCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLb;

@end

@implementation DemoListCell

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
    DemoListCellDataSource *ds = zzData;
    self.contentView.backgroundColor = ds.color;
    self.titleLb.text = ds.title;
}

@end

@implementation DemoListCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzHeight = 200.0;
        self.color = [UIColor zz_randomColor];
    }
    return self;
}

@end
