//
//  TestHeaderView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/20.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "TestHeaderView.h"

@interface TestHeaderView()

@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation TestHeaderView

- (void)setZzData:(ZZTableViewHeaderFooterViewDataSource *)zzData {
    
    [super setZzData:zzData];
    self.label.text = [NSString stringWithFormat:@"%u", arc4random() % 1000];
}

@end


@implementation TestHeaderViewDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzHeight = 120.0;
    }
    return self;
}

@end
