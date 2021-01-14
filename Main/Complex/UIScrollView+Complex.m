//
//  UIScrollView+Complex.m
//  ZZKit
//
//  Created by Fu Jie on 2021/1/13.
//  Copyright © 2021 Jeff. All rights reserved.
//

#import <objc/runtime.h>

static NSString *kShouldRecognizeSimultaneouslyWithGestureRecognizer = @"shouldRecognizeSimultaneouslyWithGestureRecognizer";

@interface UIScrollView (Complex) <UIGestureRecognizerDelegate>

@end

@implementation UIScrollView (Complex)

- (void)setShouldRecognizeSimultaneouslyWithGestureRecognizer:(NSNumber *)shouldRecognizeSimultaneouslyWithGestureRecognizer {
    
    objc_setAssociatedObject(self, &kShouldRecognizeSimultaneouslyWithGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)shouldRecognizeSimultaneouslyWithGestureRecognizer {
    
    NSNumber *ret = objc_getAssociatedObject(self, &kShouldRecognizeSimultaneouslyWithGestureRecognizer);
    if ([self isKindOfClass:[ZZTableView class]]) {
        return ret;
    }
    return ret;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return self.shouldRecognizeSimultaneouslyWithGestureRecognizer.boolValue;
}

@end
