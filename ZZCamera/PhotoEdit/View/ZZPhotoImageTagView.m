//
//  ZZPhotoImageTagView.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/5.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZPhotoImageTagView.h"
#import "ZZMacro.h"
#import "UIView+ZZKit.h"
#import "NSString+ZZKit.h"
#import "ZZPhotoImageTagPointView.h"

#define ZZPhotoImageTagViewHeight (24.0)
#define ZZPhotoImageTagViewWidthExceptText (68.0)

@interface ZZPhotoImageTagView ()

@property (nonatomic, weak) IBOutlet UIView *tagBackgroundView;
@property (nonatomic, weak) IBOutlet UIImageView *tagImageView;
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet ZZPhotoImageTagPointView *tagPointLeftView;
@property (nonatomic, weak) IBOutlet ZZPhotoImageTagPointView *tagPointRightView;
@property (nonatomic, weak) IBOutlet UIView *tagLineLeftView;
@property (nonatomic, weak) IBOutlet UIView *tagLineRightView;
@property (nonatomic, weak) IBOutlet UIButton *reverseButton;
@property (nonatomic, strong) ZZPhotoTag *model;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, copy) void(^tapBlock)(ZZPhotoImageTagView *photoImageTagView);
@property (nonatomic, copy) void(^movingBlock)(UIGestureRecognizerState state, CGPoint point, ZZPhotoImageTagView *imageTagView);

@end

@implementation ZZPhotoImageTagView

-(void)dealloc {
    
}

// 创建ZZPhotoImageTagView
+ (ZZPhotoImageTagView *)create:(CGPoint)point containerSize:(CGSize)containerSize model:(ZZPhotoTag *)model fixEdge:(BOOL)fixEdge autoChangeDirection:(BOOL)autoChangeDirection tapBlock:(void(^)(__weak ZZPhotoImageTagView *photoImageTagView))tapBlock movingBlock:(void(^)(UIGestureRecognizerState state, CGPoint point, ZZPhotoImageTagView *imageTagView))movingBlock {
    
    return [self create:point containerSize:containerSize model:model scale:1.0 fixEdge:fixEdge autoChangeDirection:autoChangeDirection tapBlock:tapBlock movingBlock:movingBlock];
}

// 创建ZZPhotoImageTagView（Scale）
+ (ZZPhotoImageTagView *)create:(CGPoint)point containerSize:(CGSize)containerSize model:(ZZPhotoTag *)model scale:(CGFloat)scale fixEdge:(BOOL)fixEdge autoChangeDirection:(BOOL)autoChangeDirection tapBlock:(void(^)(__weak ZZPhotoImageTagView *photoImageTagView))tapBlock movingBlock:(void(^)(UIGestureRecognizerState state, CGPoint point, ZZPhotoImageTagView *imageTagView))movingBlock {
    
    ZZPhotoImageTagView *view = ZZ_LOAD_NIB(@"ZZPhotoImageTagView");
    view.model = model;
    view.textLabel.text = model.name;
    view.tapBlock = tapBlock;
    view.movingBlock = movingBlock;
    CGFloat w = [ZZPhotoImageTagView getPhotoImageTagViewWidth:model.name];
    if (model.v.intValue == 0) {
        // 以矩形的左上点为point
    }else if (model.v.intValue == 1) {
        // 以Ripple圆点为中心点
        if (model.direction == 0) {
            point.x -= 4.0;
            point.y -= 12.0;
        }else {
            point.x -= ZZPhotoImageTagViewWidthExceptText + w - 4.0;
            point.y -= 12.0;
        }
    }
    view.frame = CGRectMake(point.x, point.y, w + ZZPhotoImageTagViewWidthExceptText, ZZPhotoImageTagViewHeight);
    [view.tagBackgroundView zz_cornerRadius:2.0];
    switch (model.type) {
        case ZZPhotoTagTypeTopic:
        {
            // 话题
            if (model.status.intValue == 0) {
                view.tagImageView.image = @"ic_logo_tag_topic".zz_image;
            }else {
                view.textLabelConstraint.constant = 8.0;
                view.tagImageView.image = nil;
            }
            break;
        }
        case ZZPhotoTagTypeStore:
        {
            // 品牌
            view.tagImageView.image = @"ic_logo_tag_brand".zz_image;
            break;
        }
        case ZZPhotoTagTypeRMB:
        {
            // 人民币
            view.tagImageView.image = @"ic_logo_tag_rmb".zz_image;
            break;
        }
        case ZZPhotoTagTypeUSdollar:
        {
            // 美元
            view.tagImageView.image = @"ic_logo_tag_dollar".zz_image;
            break;
        }
        case ZZPhotoTagTypeEurodollar:
        {
            // 欧元
            view.tagImageView.image = @"ic_logo_tag_euro".zz_image;
            break;
        }
        default:
            break;
    }
    
    if (fixEdge) {

        // 版本0
        if ([model.v intValue] == 0) {
            // 左测右测外溢
            if (view.frame.origin.x < 0) {
                view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            }else if (view.frame.origin.x + view.bounds.size.width > containerSize.width) {
                view.frame = CGRectMake(containerSize.width - view.bounds.size.width, view.frame.origin.y, view.bounds.size.width, view.bounds.size.height);
            }
            // 上测下测外溢
            if (view.frame.origin.y < 0) {
                view.frame = CGRectMake(view.frame.origin.x, 0, view.bounds.size.width, view.bounds.size.height);
            }else if (view.frame.origin.y + view.bounds.size.height > containerSize.height) {
                view.frame = CGRectMake(view.frame.origin.x, containerSize.height - view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
            }
            // 调整后的xPercent、yPercent
            model.xPercent = view.frame.origin.x / containerSize.width;
            model.yPercent = view.frame.origin.y / containerSize.height;
        }
        // 版本1
        else if ([model.v intValue] == 1) {

            if (autoChangeDirection) {
               
                if (view.frame.origin.x < 0) {
                    
                    if (model.direction == 1 && view.frame.origin.x + view.bounds.size.width < containerSize.width / 2.0) {
                        // 左测外溢，Rillpe在右侧，调整方向，向右移动
                        model.direction = 0;
                        view.center = CGPointMake(view.center.x + (view.frame.size.width - 8.0), view.center.y);
                        
                        // 调整后的xPercent
                        model.xPercent = (view.frame.origin.x + 4.0) / containerSize.width;
                    }
                }else if (view.frame.origin.x + view.bounds.size.width > containerSize.width) {
                    
                    if (model.direction == 0 && view.frame.origin.x > containerSize.width / 2.0) {
                        // 右测外溢，Rillpe在左侧，调整方向，向左移动
                        model.direction = 1;
                        view.center = CGPointMake(view.center.x - (view.frame.size.width - 8.0), view.center.y);
                        
                        // 调整后的xPercent
                        model.xPercent = (view.frame.origin.x + view.frame.size.width - 4.0) / containerSize.width;
                    }
                }
                
                // 上测下测外溢
                if (view.frame.origin.y < 0 || view.frame.origin.y + view.bounds.size.height > containerSize.height) {
                    if (view.frame.origin.y < 0) {
                        view.frame = CGRectMake(view.frame.origin.x, 0, view.bounds.size.width, view.bounds.size.height);
                    }else {
                        view.frame = CGRectMake(view.frame.origin.x, containerSize.height - view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
                    }
                    // 调整后的yPercent
                    model.yPercent = (view.frame.origin.y + 12.0) / containerSize.height;
                }
            }else {
                // 左测右测外溢
                if (view.frame.origin.x < 0 || view.frame.origin.x + view.bounds.size.width > containerSize.width) {
                    if (view.frame.origin.x < 0) {
                        view.frame = CGRectMake(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                    }else {
                        view.frame = CGRectMake(containerSize.width - view.bounds.size.width, view.frame.origin.y, view.bounds.size.width, view.bounds.size.height);
                    }
                    if (model.direction == 0) {
                        // 调整后的xPercent
                        model.xPercent = (view.frame.origin.x + 4.0) / containerSize.width;
                    }else {
                        // 调整后的xPercent
                        model.xPercent = (view.frame.origin.x + view.frame.size.width - 4.0) / containerSize.width;
                    }
                }
                // 上测下测外溢
                if (view.frame.origin.y < 0 || view.frame.origin.y + view.bounds.size.height > containerSize.height) {
                    if (view.frame.origin.y < 0) {
                        view.frame = CGRectMake(view.frame.origin.x, 0, view.bounds.size.width, view.bounds.size.height);
                    }else {
                        view.frame = CGRectMake(view.frame.origin.x, containerSize.height - view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
                    }
                    // 调整后的yPercent
                    model.yPercent = (view.frame.origin.y + 12.0) / containerSize.height;
                }
            }
        }
        // 调整后的frame
        model.adjustedFrame = view.frame;
    }
    
    if (model.direction == 0) {
        [view.tagPointRightView stopAnimation];
        view.tagPointRightView.hidden = YES;
        view.tagLineRightView.hidden = YES;
        view.tagPointLeftView.hidden = NO;
        view.tagLineLeftView.hidden = NO;
        [view.tagPointLeftView startAnimation];
    }else {
        [view.tagPointLeftView stopAnimation];
        view.tagPointLeftView.hidden = YES;
        view.tagLineLeftView.hidden = YES;
        view.tagPointRightView.hidden = NO;
        view.tagLineRightView.hidden = NO;
        [view.tagPointRightView startAnimation];
    }
    
    // 圆角修饰
    [view.tagBackgroundView zz_cornerRadius:12.0 borderWidth:1.0 boderColor:[UIColor whiteColor]];
    
    if (model.isHint == YES) {
        
        [view setUserInteractionEnabled:NO];
        [view.reverseButton setHidden:YES];
    }else {
        
        if (movingBlock != nil) {
            [view addGestureRecognizer:view.panGesture];
            [view.reverseButton setHidden:NO];
        }else {
            [view.reverseButton setHidden:YES];
        }
        
        if (tapBlock != nil) {
            [view addGestureRecognizer:view.tapGesture];
        }
    }
    return view;
}

- (UIPanGestureRecognizer *)panGesture {
    
    if (_panGesture == nil) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panAction:)];
    }
    return _panGesture;
}

- (UITapGestureRecognizer *)tapGesture {
    
    if (_tapGesture == nil) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapAction:)];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.numberOfTouchesRequired = 1;
    }
    return _tapGesture;
}

- (void)_panAction:(UIPanGestureRecognizer *)panGesture {
    
    UIGestureRecognizerState state = panGesture.state;
    CGPoint locationPoint = [panGesture locationInView:panGesture.view.superview.superview.superview];
    CGPoint point = [panGesture translationInView:panGesture.view];
    BOOL isContain = CGRectContainsRect(self.superview.bounds, self.frame);
    if (isContain) {
        self.center = CGPointMake(self.center.x + point.x, self.center.y + point.y);
    }else {
        // 超出(包括贴边)情况
        CGSize supSize = self.superview.frame.size;
        if (CGRectGetMinY(self.frame) < 0) {
            // 靠上
            self.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width, self.frame.size.height);
        }else if (CGRectGetMinX(self.frame) < 0) {
            // 靠左
            self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        }else if (CGRectGetMaxY(self.frame) > supSize.height) {
            // 靠下
            self.frame = CGRectMake(self.frame.origin.x, self.superview.bounds.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        }else if (CGRectGetMaxX(self.frame) > supSize.width) {
            // 靠右
            self.frame = CGRectMake(self.superview.bounds.size.width - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        }
    }
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
    if (self.model.v.intValue == 0) {
        
        self.model.xPercent = self.frame.origin.x / self.superview.bounds.size.width;
        self.model.yPercent = self.frame.origin.y / self.superview.bounds.size.height;
    }else if (self.model.v.intValue == 1) {
        
        if (self.model.direction == 0) {
            self.model.xPercent = (self.frame.origin.x + 4.0) / self.superview.bounds.size.width;
        }else {
            self.model.xPercent = (self.frame.origin.x + self.frame.size.width - 4.0) / self.superview.bounds.size.width;
        }
        self.model.yPercent = (self.frame.origin.y + 12.0) / self.superview.bounds.size.height;
    }
    self.movingBlock == nil ? : self.movingBlock(state, locationPoint, self);
}

- (void)_tapAction:(UITapGestureRecognizer *)tapGesture {
    
    self.tapBlock == nil ? : self.tapBlock(self);
}

- (IBAction)_tapReverse:(UIButton *)button {
    
    [self reverseDirection];
    self.tapBlock == nil ? : self.tapBlock(self);
}

- (void)reverseDirection {
    
    if (self.model.direction == 0) {
        self.model.direction = 1;
        [self.tagPointLeftView stopAnimation];
        self.tagPointLeftView.hidden = YES;
        self.tagLineLeftView.hidden = YES;
        self.tagPointRightView.hidden = NO;
        self.tagLineRightView.hidden = NO;
        [self.tagPointRightView startAnimation];
    }else if (self.model.direction == 1) {
        self.model.direction = 0;
        [self.tagPointRightView stopAnimation];
        self.tagPointRightView.hidden = YES;
        self.tagLineRightView.hidden = YES;
        self.tagPointLeftView.hidden = NO;
        self.tagLineLeftView.hidden = NO;
        [self.tagPointLeftView startAnimation];
    }
}

- (ZZPhotoTag *)getTagModel {
    
    return self.model;
}

// 根据文件计算ImageTagView的宽度
+ (CGFloat)getPhotoImageTagViewWidth:(NSString *)text {
    
    CGFloat w = 0;
    if (@available(iOS 8.2, *)) {
        w = [text zz_width:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium] enableCeil:YES];
    } else {
        w = [text zz_width:[UIFont systemFontOfSize:12.0] enableCeil:YES] + 0.2 * text.length;
    }
    return w;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
