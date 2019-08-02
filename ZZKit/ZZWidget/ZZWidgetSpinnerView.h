//
//  ZZWidgetSpinnerView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/8/2.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ZZWidgetSpinnerView

typedef NS_ENUM(NSInteger, ZZWidgetSpinnerRotationDirection) {
    ZZWidgetSpinnerRotationDirectionClockwise,
    ZZWidgetSpinnerRotationDirectionCounterClockwise
};

@interface ZZWidgetSpinnerView : UIView

/**
 *  @brief Which direction the spinner should spin. Defaults to clockwise.
 */
@property (nonatomic, assign) ZZWidgetSpinnerRotationDirection rotationDirection;

/**
 *  @brief When the spinner is not animating, the length of the arc to be drawn. This can
 *         be used to implement things like pull-to-refresh as seen in ZZSpinnerRefreshControl.
 */
@property (nonatomic, assign) CGFloat staticArcLength;

/**
 @brief When the arc is shrinking, how small it should get at a minimum in radians.
 */
@property (assign) CGFloat minimumArcLength;

/**
 *  @brief When the arc is growing, how large it should get at a maximum in radians
 */
@property (assign) CGFloat maximumArcLength;

/**
 *  @brief The width of the arc's line.
 */
@property (nonatomic) CGFloat lineWidth;

/**
 @brief How long in seconds it should take for the drawing to rotate 360 degrees.
 No easing function is applied to this duration, i.e. it is linear.
 */
@property (assign) CFTimeInterval rotationCycleDuration;

/**
 @brief How long in seconds it should take for a complete circle to be drawn
 or erased. An in-out easing function is applied to this duration.
 */
@property (assign) CFTimeInterval drawCycleDuration;

/**
 @brief The timing function that should be used for drawing the rail.
 */
@property (strong) CAMediaTimingFunction *drawTimingFunction;

/**
 @brief An array of UIColors that defines the colors the spinner will draw in
 and their order. The colors will loop back to the beginning when the
 cycle for the last color has been completed.
 */
@property (strong) NSArray<UIColor *> *colorSequence UI_APPEARANCE_SELECTOR;

/**
 @brief The color of the rail behind the spinner. Defaults to clear.
 */
@property (nonatomic) UIColor *backgroundRailColor;

/**
 @return YES if the spinner is animating, otherwise NO
 */
@property (readonly) BOOL isAnimating;

/**
 @brief Start animating.
 */
- (void)startAnimating;

/**
 @brief Stop animating and clear the drawing context.
 */
- (void)stopAnimating;

@end

#pragma mark - ZZWidgetSpinnerLoadingTimingFunction

@interface ZZWidgetSpinnerLoadingTimingFunction : NSObject

+ (CAMediaTimingFunction *)linear;
+ (CAMediaTimingFunction *)easeIn;
+ (CAMediaTimingFunction *)easeOut;
+ (CAMediaTimingFunction *)easeInOut;
+ (CAMediaTimingFunction *)sharpEaseInOut;

@end

#pragma mark - ZZWidgetSpinnerRefreshControl

@interface ZZWidgetSpinnerRefreshControl : NSObject

/**
 *  @brief The underlying loading spinner. Customize this spinner to achieve the desired effect.
 */
@property (readonly) ZZWidgetSpinnerView *loadingSpinner;

/**
 *  @brief Adds the refresh control to the associated table view controller.
 *  @param tableViewController The table view controller to attach the refresh control to.
 *  @param refreshBlock A block to be called when the table view controller triggers a refresh.
 */
- (void)addToTableViewController:(UITableViewController *)tableViewController refreshBlock:(void (^)(void))refreshBlock;

/**
 *  @brief Adds the refresh control to the associated table view controller.
 *  @param tableViewController The table view controller to attach the refresh control to.
 *  @param target The target to call the selector on when the refresh control is triggered.
 *  @param selector The selector to call.
 */
- (void)addToTableViewController:(UITableViewController *)tableViewController target:(id)target selector:(SEL)selector;

/**
 *  @brief Adds the refresh control to the associated scroll view.
 *  @param scrollView The scroll view to attach the refresh control to.
 *  @param refreshBlock A block to be called when the scroll view triggers a refresh.
 *  @warning The refreshControl property is only available on UIScrollView on iOS 10 and up.
 */
- (void)addToScrollView:(UIScrollView *)scrollView refreshBlock:(void (^)(void))refreshBlock;

/**
 *  @brief Adds the refresh control to the associated scroll view.
 *  @param scrollView The scroll view to attach the refresh control to.
 *  @param target The target to call the selector on when the refresh control is triggered.
 *  @param selector The selector to call.
 *  @warning The refreshControl property is only available on UIScrollView on iOS 10 and up.
 */
- (void)addToScrollView:(UIScrollView *)scrollView target:(id)target selector:(SEL)selector;

/**
 *  @brief Removes the refresh control from its partner object, whether that be a table view controller, a collection
 *         view controller, or a scroll view.
 */
- (void)removeFromPartnerObject;

/**
 *  @brief Begins refreshing. If the attached scroll view is scrolled to the top, animates the loading spinner
 *         into view.
 */
- (void)beginRefreshing;

/**
 *  @brief Ends refreshing.
 */
- (void)endRefreshing;

@end

NS_ASSUME_NONNULL_END
