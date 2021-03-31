//
//  ZZSegmentView.h
//  ZZKit
//
//  Created by Fu Jie on 2021/1/5.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZSegmentView : UIScrollView

+ (ZZSegmentView *)create:(CGRect)frame
               fixedItems:(nullable NSNumber *)fixedItems
           fixedItemWidth:(nullable NSNumber *)fixedItemWidth
             fixedPadding:(nullable NSNumber *)fixedPadding
           normalTextFont:(nullable UIFont *)normalTextFont
          normalTextColor:(nullable UIColor *)normalTextColor
      highlightedTextFont:(nullable UIFont *)highlightedTextFont
     highlightedTextColor:(nullable UIColor *)highlightedTextColor
           indicatorColor:(nullable UIColor *)indicatorColor
                   titles:(nonnull NSArray *)titles
            selectedBlock:(void(^)(NSUInteger index))selectedBlock;

- (void)selectIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
