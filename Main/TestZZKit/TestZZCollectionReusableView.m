//
//  TestZZCollectionReusableView.m
//  EZView
//
//  Created by Fu Jie on 2020/12/16.
//

#import "TestZZCollectionReusableView.h"

@implementation TestZZCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setZzData:(__kindof ZZCollectionReusableViewDataSource *)zzData {
    
    [super setZzData:zzData];
    TestZZCollectionReusableViewDataSource *ds = zzData;
    self.lbTitle.text = ds.txt;
}

- (IBAction)tap:(id)sender {
    
    self.zzTapBlock == nil ? : self.zzTapBlock(self);
}

@end

@implementation TestZZCollectionReusableViewDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.zzHeight = 80.0;
    }
    return self;
}

@end
