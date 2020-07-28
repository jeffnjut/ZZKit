//
//  ZZCameraView.m
//  ZZCamera
//
//  Created by Fu Jie on 2018/11/19.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "ZZCameraView.h"
#import "ZZTakePhotoView.h"
#import "ZZMediaObject.h"
#import "NSString+ZZKit.h"
#import "UIView+ZZKit.h"
#import "UIView+ZZKit_HUD.h"
#import "ZZMacro.h"

@interface ZZCameraView()

// 1：拍照 2：视频
@property (nonatomic, assign) ZZCaptureType captureType;
@property (nonatomic, strong) ZZVideoPreview *previewView;
@property (nonatomic, strong) ZZTakePhotoView *takeView;
@property (nonatomic, strong) UIView *topView;      // 上面的bar
@property (nonatomic, strong) UIView *bottomView;   // 下面的bar
@property (nonatomic, strong) UIView *focusView;    // 聚焦动画view
@property (nonatomic, strong) UIView *exposureView; // 曝光动画view

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *torchBtn;
@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIImageView *previewImageView;
@property (nonatomic, strong) UILabel *mediaCountLabel;

@property (nonatomic, assign) NSUInteger currentMediaCount;

@end

@implementation ZZCameraView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        NSAssert(NO, @"ZZCameraView Init 异常");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSAssert(NO, @"ZZCameraView Init 异常");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame config:(ZZCaptureConfig *)config {
    
    // NSAssert(frame.size.height > 164 || frame.size.width > 374, @"相机视图的高不小于164，宽不小于375");
    self = [super initWithFrame:frame];
    if (self) {
        _captureType = ZZCaptureTypePhoto;
        [self _buildUI:config];
    }
    return self;
}

- (UIView *)topView {
    
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.zzWidth, self.config.topBarHeight)];
        _topView.backgroundColor = self.config.topBarTintColor;
    }
    return _topView;
}

- (UIView *)bottomView {
    
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.zzHeight - self.config.bottomBarHeight, self.zzWidth, self.config.bottomBarHeight)];
        _bottomView.backgroundColor = self.config.bottomBarTintColor;
    }
    return _bottomView;
}

- (UIView *)focusView {
    
    if (_focusView == nil) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.config.focusSideLength, self.config.focusSideLength)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderColor = self.config.focusBorderColor.CGColor;
        _focusView.layer.borderWidth = self.config.focusBorderWidth;
        _focusView.hidden = YES;
    }
    return _focusView;
}

- (UIView *)exposureView {
    
    if (_exposureView == nil) {
        _exposureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.config.exposureSideLength, self.config.exposureSideLength)];
        _exposureView.backgroundColor = [UIColor clearColor];
        _exposureView.layer.borderColor = self.config.exposureBorderColor.CGColor;
        _exposureView.layer.borderWidth = self.config.exposureBorderWidth;
        _exposureView.hidden = YES;
    }
    return _exposureView;
}

- (UISlider *)slider {
    
    if (_slider == nil) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue = 0;
        _slider.maximumValue = 1;
        _slider.maximumTrackTintColor = self.config.zoomIndicatorMaximumTrackTintColor;
        _slider.minimumTrackTintColor = self.config.zoomIndicatorMinimumTrackTintColor;
        _slider.thumbTintColor = self.config.zoomIndicatorThumbTintColor;
        _slider.alpha = 0.0;
    }
    return _slider;
}

#pragma mark - Public
- (void)changeTorch:(BOOL)on {
    
    _torchBtn.selected = on;
}

- (void)changeFlash:(BOOL)on {
    
    _flashBtn.selected = on;
}

- (void)updateMedias:(NSMutableArray *)medias {
    
    self.currentMediaCount = medias.count;
    
    __block UIImage *image = nil;
    __block NSString *text = nil;
    if (medias.count > 0) {
        ZZMediaObject *media = [medias lastObject];
        if (media.image) {
            image = media.image;
        }else if (media.imageData) {
            image = [UIImage imageWithData:media.imageData];
        }
        text = [NSString stringWithFormat:@"(%d/%d)", (int)medias.count, (int)self.config.maxMediaCount];
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.previewImageView.image = image;
        weakSelf.mediaCountLabel.text = text;
    });
    
    /*
    if (medias.count >= self.config.maxMediaCount) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.takeView setUserInteractionEnabled:NO];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.takeView setUserInteractionEnabled:YES];
        });
    }*/
}

#pragma mark - Private
- (void)_buildUI:(ZZCaptureConfig *)config {
    
    __weak typeof(self) weakSelf = self;
    if (config == nil) {
        self.config = [[ZZCaptureConfig alloc] init];
    }else {
        self.config = config;
    }
    
    if (self.config.capturePreviewFullScreen) {
        self.previewView = [[ZZVideoPreview alloc] initWithFrame:CGRectMake(0, 0, self.zzWidth, self.zzHeight)];
    }else {
        self.previewView = [[ZZVideoPreview alloc] initWithFrame:CGRectMake(0, self.config.topBarHeight, self.zzWidth, self.zzHeight - self.config.topBarHeight - self.config.bottomBarHeight)];
    }    
    [self addSubview:self.previewView];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    if (self.config.enableManualTapFocusAndExposure) {
        [self.previewView addSubview:self.focusView];
        [self.previewView addSubview:self.exposureView];
    }
    if (self.config.enableZoom && self.config.enableZoomIndicator) {
        [self.previewView addSubview:self.slider];
    }
    // ----------------------- 手势
    if (self.config.enableManualTapFocusAndExposure) {
        // 点击-->聚焦
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapAction:)];
        [self.previewView addGestureRecognizer:tap];
        // 双击-->曝光
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.previewView addGestureRecognizer:doubleTap];
        [tap requireGestureRecognizerToFail:doubleTap];
    }
    
    if (self.config.enableZoom) {
        // 捏合-->缩放
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action: @selector(_pinchAction:)];
        [self.previewView addGestureRecognizer:pinch];
        if (self.config.enableZoomIndicator) {
            // 缩放 UI 条
            self.slider.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.slider.frame = CGRectMake(self.zzWidth - self.config.zoomIndicatorOffsetRight, self.config.zoomIndicatorOffsetTop, self.config.zoomIndicatorWidth, self.config.zoomIndicatorHeight);
        }
    }

    // Bottom Bar
    if (self.config.widgetUsingImageBottomView) {
        
        UILabel *labelHint = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bottomView.zzWidth, self.config.hintHeight)];
        NSString *hint = nil;
        int type = 0;
        if (self.config.captureType == ZZCaptureTypeAll) {
            hint = @"轻触拍照，长按摄像";
            type = 3;
        }else if (self.config.captureType == ZZCaptureTypePhoto) {
            hint = @"轻触拍照";
            type = 1;
        }else if (self.config.captureType == ZZCaptureTypeVidio) {
            hint = @"长按摄像";
            type = 2;
        }
        labelHint.text = hint;
        labelHint.textAlignment = NSTextAlignmentCenter;
        labelHint.textColor = [UIColor whiteColor];
        labelHint.font = [UIFont systemFontOfSize:14.0];
        [self.bottomView addSubview:labelHint];
       
        ZZTakePhotoView *takeView = [ZZTakePhotoView create:CGRectMake((self.bottomView.zzWidth - self.config.takeViewSize.width) / 2.0, (self.bottomView.zzHeight - self.config.takeViewSize.height) / 2.0, self.config.takeViewSize.width, self.config.takeViewSize.height) takeButtonSize:self.config.takeButtonSize strokeColor:self.config.takeButtonStrokeColor strokeWidth:self.config.takeButtonStrokeWidth longTapPressDuration:self.config.takeButtonLongTapPressDuration circleDuration:self.config.takeButtonCircleDuration type:type tapBlock:^{
            if (weakSelf.currentMediaCount >= weakSelf.config.maxMediaCount) {
                if (weakSelf.config.enableWarningOverMaxMediaCount) {
                    [weakSelf zz_toast:@"已超过图片最大数量" toastType:ZZToastTypeWarning];
                }
                return;
            }
            // 拍照
            if ([weakSelf.delegate respondsToSelector:@selector(takePhotoAction:)]) {
                [weakSelf.delegate takePhotoAction:weakSelf];
            }
            
        } longPressBlock:^(BOOL begin) {
            if (weakSelf.currentMediaCount >= weakSelf.config.maxMediaCount) {
                if (weakSelf.config.enableWarningOverMaxMediaCount) {
                    if (begin) {
                        [weakSelf zz_toast:@"已超过视频最大数量" toastType:ZZToastTypeWarning];
                    }
                }
                return;
            }
            // 拍摄
            if (begin) {
                if ([weakSelf.delegate respondsToSelector:@selector(startRecordVideoAction:)]) {
                    [weakSelf.delegate startRecordVideoAction:weakSelf];
                }
            }else {
                if ([weakSelf.delegate respondsToSelector:@selector(stopRecordVideoAction:)]) {
                    [weakSelf.delegate stopRecordVideoAction:weakSelf];
                }
            }
        }];
        [self.bottomView addSubview:takeView];
        self.takeView = takeView;
    }else {
        // 拍照
        UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [photoButton setTitle:@"拍照" forState:UIControlStateNormal];
        [photoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [photoButton addTarget:self action:@selector(_takePicture:) forControlEvents:UIControlEventTouchUpInside];
        photoButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        photoButton.frame = CGRectMake(self.bottomView.bounds.size.width / 2.0 - 30.0, self.bottomView.bounds.size.height / 2.0 - 30.0, 60.0, 60.0);
        [self.bottomView addSubview:photoButton];
        _photoBtn = photoButton;
        
        // 照片类型
        UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [typeButton setTitle:@"照片" forState:UIControlStateNormal];
        [typeButton setTitle:@"视频" forState:UIControlStateSelected];
        [typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [typeButton addTarget:self action:@selector(_changeType:) forControlEvents:UIControlEventTouchUpInside];
        typeButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        typeButton.frame = CGRectMake(self.bottomView.bounds.size.width - 100.0, self.bottomView.bounds.size.height / 2.0 - 20.0, 80.0, 40.0);
        [self.bottomView addSubview:typeButton];
    }
    
    if (self.config.enablePreviewAll) {
        self.previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0, self.bottomView.bounds.size.height / 2.0 - 30.0, 60.0, 60.0)];
        self.previewImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.previewImageView.layer.masksToBounds = YES;
        [self.bottomView addSubview:self.previewImageView];
        self.mediaCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.previewImageView.frame.origin.x + self.previewImageView.frame.size.width, self.bottomView.bounds.size.height / 2.0 - 10.0, 48.0, 20.0)];
        self.mediaCountLabel.font = [UIFont systemFontOfSize:14.0];
        self.mediaCountLabel.textColor = [UIColor whiteColor];
        self.mediaCountLabel.textAlignment = NSTextAlignmentCenter;
        [self.bottomView addSubview:self.mediaCountLabel];
        UIButton *previewButton = [[UIButton alloc] initWithFrame:CGRectMake(self.previewImageView.frame.origin.x - 10.0, self.previewImageView.frame.origin.y - 10.0, self.previewImageView.bounds.size.width + self.self.mediaCountLabel.bounds.size.width + 20.0, self.previewImageView.bounds.size.height + 20.0)];
        [self.bottomView addSubview:previewButton];
        [previewButton addTarget:self action:@selector(_tapPreview) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bottomView.bounds.size.width - 80.0, self.bottomView.bounds.size.height / 2.0 - 30.0, 60.0, 60.0)];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton setTitle:@"完成" forState:UIControlStateHighlighted];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        doneButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [doneButton addTarget:self action:@selector(_tapDone) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:doneButton];
    }
    
    // Top Bar
    int w = 0;
    if (self.config.enableSwitch) {
        w++;
    }
    if (self.config.enableLightSupplement) {
        w++;
    }
    if (self.config.enableFlashLight) {
        w++;
    }
    if (self.config.enableAutoFocusAndExposure) {
        w++;
    }
    // 取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(_cancel:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
    cancelButton.frame = CGRectMake(0, 0, self.topView.zzWidth / 5.0, self.topView.bounds.size.height);
    [self.topView addSubview:cancelButton];
    
    // 转换前后摄像头
    UIButton *switchCameraButton = nil;
    if (self.config.enableSwitch) {
        switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [switchCameraButton addTarget:self action:@selector(_switchCameraClick:) forControlEvents:UIControlEventTouchUpInside];
        switchCameraButton.frame = CGRectMake(cancelButton.zzWidth, 0, (self.topView.zzWidth - cancelButton.zzWidth) / (float)w , self.topView.zzHeight);
        [self.topView addSubview:switchCameraButton];
        if (self.config.widgetUsingImageTopView) {
            [switchCameraButton setImage:@"ZZCameraView.ic_switch".zz_image forState:UIControlStateNormal];
        }else {
            [switchCameraButton setTitle:@"转换" forState:UIControlStateNormal];
            [switchCameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            switchCameraButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        }
    }
    
    // 补光
    UIButton *lightButton = nil;
    if (self.config.enableLightSupplement) {
        lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [lightButton addTarget:self action:@selector(_torchClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = CGRectZero;
        if (switchCameraButton != nil ) {
            frame = CGRectMake(switchCameraButton.frame.origin.x + switchCameraButton.frame.size.width, 0, (self.topView.zzWidth - cancelButton.zzWidth) / (float)w, self.topView.zzHeight);
        }else {
            frame = CGRectMake(cancelButton.zzWidth, 0, (self.topView.zzWidth - cancelButton.zzWidth) / (float)w , self.topView.zzHeight);
        }
        lightButton.frame = frame;
        [self.topView addSubview:lightButton];
        _torchBtn = lightButton;
        if (self.config.widgetUsingImageTopView) {
            [lightButton setImage:@"ZZCameraView.ic_torch_off".zz_image forState:UIControlStateNormal];
            [lightButton setImage:@"ZZCameraView.ic_torch_on".zz_image forState:UIControlStateSelected];
        }else {
            [lightButton setTitle:@"补光" forState:UIControlStateNormal];
            [lightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [lightButton setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
            lightButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        }
    }
    
    // 闪光灯
    UIButton *flashButton = nil;
    if (self.config.enableFlashLight) {
        flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [flashButton addTarget:self action:@selector(_flashClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = CGRectZero;
        if (lightButton != nil ) {
            frame = CGRectMake(lightButton.frame.origin.x + lightButton.frame.size.width, 0, (self.topView.zzWidth - cancelButton.zzWidth) / (float)w, self.topView.zzHeight);
        }else if (switchCameraButton != nil ) {
            frame = CGRectMake(switchCameraButton.frame.origin.x + switchCameraButton.frame.size.width, 0, (self.topView.zzWidth - cancelButton.zzWidth) / (float)w, self.topView.zzHeight);
        }else {
            frame = CGRectMake(cancelButton.zzWidth, 0, (self.topView.zzWidth - cancelButton.zzWidth) / (float)w , self.topView.zzHeight);
        }
        flashButton.frame = frame;
        [self.topView addSubview:flashButton];
        _flashBtn = flashButton;
        if (self.config.widgetUsingImageTopView) {
            [flashButton setImage:@"ZZCameraView.ic_light_off".zz_image forState:UIControlStateNormal];
            [flashButton setImage:@"ZZCameraView.ic_light_on".zz_image forState:UIControlStateSelected];
        }else {
            [flashButton setTitle:@"闪光灯" forState:UIControlStateNormal];
            [flashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [flashButton setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
            flashButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        }
    }
    
    // 重置对焦、曝光
    UIButton *focusAndExposureButton = nil;
    if (self.config.enableAutoFocusAndExposure) {
        focusAndExposureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [focusAndExposureButton addTarget:self action:@selector(_focusAndExposureClick:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = CGRectZero;
        if (flashButton != nil ) {
            frame = CGRectMake(flashButton.frame.origin.x + flashButton.frame.size.width, 0, (self.topView.zzWidth - cancelButton.zzWidth) / (float)w, self.topView.zzHeight);
        }else if (lightButton != nil ) {
            frame = CGRectMake(lightButton.frame.origin.x + lightButton.frame.size.width, 0, (self.topView.zzWidth - cancelButton.zzWidth) / (float)w, self.topView.zzHeight);
        }else if (switchCameraButton != nil ) {
            frame = CGRectMake(switchCameraButton.frame.origin.x + switchCameraButton.frame.size.width, 0, (self.topView.zzWidth - cancelButton.zzWidth) / (float)w, self.topView.zzHeight);
        }else {
            frame = CGRectMake(cancelButton.zzWidth, 0, (self.topView.zzWidth - cancelButton.zzWidth) / (float)w , self.topView.zzHeight);
        }
        focusAndExposureButton.frame = frame;
        [self.topView addSubview:focusAndExposureButton];
        if (self.config.widgetUsingImageTopView) {
            [focusAndExposureButton setImage:@"ZZCameraView.ic_auto_focus_exposure".zz_image forState:UIControlStateNormal];
        }else {
            [focusAndExposureButton setTitle:@"自动聚焦/曝光" forState:UIControlStateNormal];
            [focusAndExposureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            focusAndExposureButton.titleLabel.font = [UIFont systemFontOfSize:14.0 - w];
        }
    }
}

- (void)_tapDone {
    
    if ([_delegate respondsToSelector:@selector(doneAction:)]) {
        [_delegate doneAction:self];
    }
}

- (void)_tapPreview {
    
    if ([_delegate respondsToSelector:@selector(previewAction:)]) {
        [_delegate previewAction:self];
    }
}

- (void)_pinchAction:(UIPinchGestureRecognizer *)pinch {
    
    ZZ_WEAK_SELF
    if ([_delegate respondsToSelector:@selector(zoomAction:factor:)]) {
        if (pinch.state == UIGestureRecognizerStateBegan) {
            [UIView animateWithDuration:0.1 animations:^{
                weakSelf.slider.alpha = 1;
            }];
        } else if (pinch.state == UIGestureRecognizerStateChanged) {
            if (pinch.velocity > 0) {
                weakSelf.slider.value += pinch.velocity / 100;
            } else {
                weakSelf.slider.value += pinch.velocity / 20;
            }
            [weakSelf.delegate zoomAction:weakSelf factor:powf(5, weakSelf.slider.value)];
        } else {
            [UIView animateWithDuration:0.1 animations:^{
                weakSelf.slider.alpha = 0.0;
            }];
        }
    }
}

// 聚焦
- (void)_tapAction:(UIGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(focusAction:point:handle:)]) {
        CGPoint point = [tap locationInView:self.previewView];
        [self _runFocusAnimation:self.focusView point:point];
        ZZ_WEAK_SELF
        [_delegate focusAction:self point:[self.previewView captureDevicePointForPoint:point] handle:^(NSError *error) {
            if (error) [weakSelf zz_toast:error.domain toastType:ZZToastTypeError];
        }];
    }
}

// 曝光
- (void)_doubleTapAction:(UIGestureRecognizer *)tap {
    
    if ([_delegate respondsToSelector:@selector(exposAction:point:handle:)]) {
        CGPoint point = [tap locationInView:self.previewView];
        [self _runFocusAnimation:self.exposureView point:point];
        ZZ_WEAK_SELF
        [_delegate exposAction:self point:[self.previewView captureDevicePointForPoint:point] handle:^(NSError *error) {
            if (error) [weakSelf zz_toast:error.domain toastType:ZZToastTypeError];
        }];
    }
}

// 自动聚焦和曝光
- (void)_focusAndExposureClick:(UIButton *)button {
    
    if ([_delegate respondsToSelector:@selector(autoFocusAndExposureAction:handle:)]) {
        [self _runResetAnimation];
        ZZ_WEAK_SELF
        [_delegate autoFocusAndExposureAction:self handle:^(NSError *error) {
            if (error) [weakSelf zz_toast:error.domain toastType:ZZToastTypeError];
        }];
    }
}

// 拍照、视频
- (void)_takePicture:(UIButton *)btn {
    
    if (self.captureType == ZZCaptureTypePhoto) {
        if ([_delegate respondsToSelector:@selector(takePhotoAction:)]) {
            [_delegate takePhotoAction:self];
        }
    } else if(self.captureType == ZZCaptureTypeVidio) {
        if (btn.selected == YES) {
            // 结束
            btn.selected = NO;
            [_photoBtn setTitle:@"开始" forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(stopRecordVideoAction:)]) {
                [_delegate stopRecordVideoAction:self];
            }
        } else {
            // 开始
            btn.selected = YES;
            [_photoBtn setTitle:@"结束" forState:UIControlStateNormal];
            if ([_delegate respondsToSelector:@selector(startRecordVideoAction:)]) {
                [_delegate startRecordVideoAction:self];
            }
        }
    }
}

// 取消
- (void)_cancel:(UIButton *)btn {
    
    if ([_delegate respondsToSelector:@selector(cancelAction:)]) {
        [_delegate cancelAction:self];
    }
}

// 转换拍摄类型
- (void)_changeType:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    if (self.captureType == ZZCaptureTypePhoto) {
        self.captureType = ZZCaptureTypeVidio;
        [_photoBtn setTitle:@"开始" forState:UIControlStateNormal];
    }else if (self.captureType == ZZCaptureTypeVidio) {
        self.captureType = ZZCaptureTypePhoto;
        [_photoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    }
}

// 转换摄像头
- (void)_switchCameraClick:(UIButton *)btn {
    
    if ([_delegate respondsToSelector:@selector(swicthCameraAction:handle:)]) {
        ZZ_WEAK_SELF
        [_delegate swicthCameraAction:self handle:^(NSError *error) {
            if (error) [weakSelf zz_toast:error.domain toastType:ZZToastTypeError];
        }];
    }
}

// 手电筒
- (void)_torchClick:(UIButton *)btn {
    
    if ([_delegate respondsToSelector:@selector(torchLightAction:handle:)]) {
        ZZ_WEAK_SELF
        [_delegate torchLightAction:self handle:^(NSError *error) {
            if (error) {
                [weakSelf zz_toast:error.domain toastType:ZZToastTypeError];
            } else {
                weakSelf.flashBtn.selected = NO;
                weakSelf.torchBtn.selected = !weakSelf.torchBtn.selected;
            }
        }];
    }
}

// 闪光灯
- (void)_flashClick:(UIButton *)btn {
    
    if ([_delegate respondsToSelector:@selector(flashLightAction:handle:)]) {
        ZZ_WEAK_SELF
        [_delegate flashLightAction:self handle:^(NSError *error) {
            if (error) {
                [weakSelf zz_toast:error.domain toastType:ZZToastTypeError];
            } else {
                weakSelf.flashBtn.selected = !weakSelf.flashBtn.selected;
                weakSelf.torchBtn.selected = NO;
            }
        }];
    }
}

#pragma mark - Private methods
// 聚焦、曝光动画
- (void)_runFocusAnimation:(UIView *)view point:(CGPoint)point {
    
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    } completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            view.hidden = YES;
            view.transform = CGAffineTransformIdentity;
        });
    }];
}

// 自动聚焦、曝光动画
- (void)_runResetAnimation {
    
    self.focusView.center = CGPointMake(self.previewView.zzWidth / 2.0, self.previewView.zzHeight / 2.0);
    self.exposureView.center = CGPointMake(self.previewView.zzWidth / 2.0, self.previewView.zzHeight / 2.0);
    self.exposureView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    self.focusView.hidden = NO;
    self.focusView.hidden = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.focusView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        weakSelf.exposureView.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1.0);
    } completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            weakSelf.focusView.hidden = YES;
            weakSelf.exposureView.hidden = YES;
            weakSelf.focusView.transform = CGAffineTransformIdentity;
            weakSelf.exposureView.transform = CGAffineTransformIdentity;
        });
    }];
}

@end
