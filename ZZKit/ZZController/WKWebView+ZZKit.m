//
//  WKWebView+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2020/3/31.
//  Copyright © 2020 wm. All rights reserved.
//

#import "WKWebView+ZZKit.h"
#import <objc/runtime.h>

static const char * const kInCapturing = "kInCapturing";
static const char * const kCompletBlock = "kCompletBlock";

@implementation WKWebView (ZZKit)

- (BOOL)inCapturing {
    
    return [objc_getAssociatedObject(self, kInCapturing) boolValue];
}

- (void)setInCapturing:(BOOL)inCaputuring {
    
    objc_setAssociatedObject(self, kInCapturing, @(inCaputuring), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void(^)(UIImage *image))completeBlock {
    
    return objc_getAssociatedObject(self, kCompletBlock);
}

- (void)setCompleteBlock:(nullable void(^)(UIImage *image))block {
    
    objc_setAssociatedObject(self, kCompletBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)zz_capture:(nullable void(^)(UIImage *image))block {
    
    if ([self inCapturing]) {
        return;
    }
    
    [self setCompleteBlock:block];
    
    UIView *screenshotsView = [self snapshotViewAfterScreenUpdates:YES];
    screenshotsView.frame = self.frame;
    [self.superview addSubview:screenshotsView];
    
    CGPoint currentOffset = self.scrollView.contentOffset;
    CGRect currentFrame = self.frame;
    UIView *currentSuperView = self.superview;
    NSUInteger currentIndex = [self.superview.subviews indexOfObject:self];
    
    UIView *containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self removeFromSuperview];
    [containerView addSubview:self];
    
    CGSize totalSize = self.scrollView.contentSize;
    NSInteger page = ceil(totalSize.height / containerView.bounds.size.height);
    
    self.scrollView.contentOffset = CGPointZero;
    self.frame = CGRectMake(0, 0, containerView.bounds.size.width, self.scrollView.contentSize.height);
    
    UIGraphicsBeginImageContextWithOptions(totalSize, YES, UIScreen.mainScreen.scale);
    __weak typeof(self) weakSelf = self;
    [self _drawContentPage:containerView webView:self index:0 maxIndex:page completion:^{
        
        UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [weakSelf removeFromSuperview];
        [currentSuperView insertSubview:weakSelf atIndex:currentIndex];
        weakSelf.frame = currentFrame;
        weakSelf.scrollView.contentOffset = currentOffset;
        
        [screenshotsView removeFromSuperview];
        
        [weakSelf setInCapturing:NO];
        
        void(^block)(UIImage *image) = [weakSelf completeBlock];
        if (block) {
            block(screenshotImage);
        }
    }];
}

- (void)_drawContentPage:(UIView *)targetView webView:(WKWebView *)webView index:(NSInteger)index maxIndex:(NSInteger)maxIndex completion:(dispatch_block_t)completion {
    
    CGRect splitFrame = CGRectMake(0, index * CGRectGetHeight(targetView.bounds), targetView.bounds.size.width, targetView.frame.size.height);
    CGRect myFrame = webView.frame;
    myFrame.origin.y = -(index * targetView.frame.size.height);
    webView.frame = myFrame;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [targetView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        
        if (index < maxIndex) {
            [self _drawContentPage:targetView webView:webView index:index + 1 maxIndex:maxIndex completion:completion];
        } else {
            completion();
        }
    });
}

@end
