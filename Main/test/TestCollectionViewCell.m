//
//  TestCollectionViewCell.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/24.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestCollectionViewCell.h"

@interface TestCollectionViewCell()

@property (nonatomic, weak) IBOutlet UIView *backgroundView;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation TestCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setZzData:(__kindof ZZCollectionViewCellDataSource *)zzData {
    
    [super setZzData:zzData];
    // ZZCollectionViewCellDataSource *ds = zzData;
    self.backgroundColor = [UIColor colorWithRed:(arc4random() % 255 / 255.0) green:(arc4random() % 255 / 255.0) blue:(arc4random() % 255 / 255.0) alpha:1.0];
    self.label.text = [NSString stringWithFormat:@"%u", arc4random() % 10000];
}

@end

@implementation TestCollectionViewCellDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 200 + arc4random() % 100);
    }
    return self;
}

@end
