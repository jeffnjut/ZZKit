//
//  InnerScrollCell.m
//  ZZKit
//
//  Created by Fu Jie on 2021/1/7.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import "InnerScrollCell.h"
#import "ZZSegmentView.h"
#import "ListVC.h"
#import "ZZDevice.h"
#import "NSArray+ZZKit.h"

@interface InnerScrollCell() <UIScrollViewDelegate>

@property (nonatomic, strong) ZZSegmentView *segmentView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation InnerScrollCell

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
    InnerScrollCellDataSource *ds = zzData;
    if (_segmentView == nil || _scrollView == nil) {
        _segmentView = [ZZSegmentView create:CGRectMake(0, 9.0, ZZDevice.zz_screenWidth, 32.0)
                                  fixedItems:@(ds.titles.count)
                              fixedItemWidth:nil
                                fixedPadding:nil
                              normalTextFont:[UIFont systemFontOfSize:12.0]
                             normalTextColor:UIColor.blackColor
                         highlightedTextFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium]
                        highlightedTextColor:UIColor.blackColor
                              indicatorColor:nil
                                      titles:ds.titles
                               selectedBlock:^(NSString * _Nonnull selectedTitle) {
        }];
        [self.contentView addSubview:_segmentView];

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, ZZDevice.zz_screenWidth, ds.zzHeight - 50)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        
        for (int i = 0; i < ds.titles.count; i++) {
            NSString *title = [ds.titles zz_arrayObjectAtIndex:i];
            ListVC *vc = [[ListVC alloc] init];
            vc.id = title;
            [_scrollView addSubview:vc.view];
            vc.view.frame = CGRectMake(_scrollView.frame.size.width * i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        }
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * ds.titles.count, _scrollView.frame.size.height);
    }
}

@end

@implementation InnerScrollCellDataSource

@end
