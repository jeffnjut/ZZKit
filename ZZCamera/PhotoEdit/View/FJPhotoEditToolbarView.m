//
//  FJPhotoEditToolbarView.m
//  FJCamera
//
//  Created by Fu Jie on 2018/10/30.
//  Copyright © 2018 Fu Jie. All rights reserved.
//

#import "FJPhotoEditToolbarView.h"
#import "FJPhotoEditFilterView.h"
#import "FJPhotoEditCropperView.h"
#import "FJPhotoEditTuningView.h"

@interface FJPhotoEditToolbarView ()

@property (nonatomic, weak) IBOutlet UIView *filterView;
@property (nonatomic, weak) IBOutlet UIView *cropperView;
@property (nonatomic, weak) IBOutlet UIView *tuningView;
@property (nonatomic, weak) IBOutlet UIView *tagView;

@property (nonatomic, weak) IBOutlet UIImageView *filterImageView;
@property (nonatomic, weak) IBOutlet UIImageView *cropperImageView;
@property (nonatomic, weak) IBOutlet UIImageView *tuningImageView;
@property (nonatomic, weak) IBOutlet UIImageView *tagImageView;
@property (nonatomic, weak) IBOutlet UILabel *filterLabel;
@property (nonatomic, weak) IBOutlet UILabel *cropperLabel;
@property (nonatomic, weak) IBOutlet UILabel *tuningLabel;
@property (nonatomic, weak) IBOutlet UILabel *tagLabel;
@property (nonatomic, weak) IBOutlet UIButton *filterButton;
@property (nonatomic, weak) IBOutlet UIButton *cropperButton;
@property (nonatomic, weak) IBOutlet UIButton *tuningButton;
@property (nonatomic, weak) IBOutlet UIButton *tagButton;

@property (nonatomic, strong) FJPhotoEditFilterView *editFilterView;

@property (nonatomic, assign) NSUInteger index;

@end

@implementation FJPhotoEditToolbarView

- (void)dealloc {
    
}

- (FJPhotoEditFilterView *)editFilterView {
    
    if (_editFilterView == nil) {
        FJPhotoModel *currentPhotoModel = [FJPhotoManager shared].currentEditPhoto;
        ZZ_WEAK_SELF
        _editFilterView = [FJPhotoEditFilterView create:CGRectMake(0, 0, ZZDevice.zz_screenWidth, 118.0) filterImages:currentPhotoModel.filterThumbImages filterNames:[FJPhotoModel filterTitles] selectedIndex:(NSUInteger)currentPhotoModel.tuningObject.filterType selectedBlock:^(NSUInteger index) {
            static NSUInteger lastIndex = -1;
            if (lastIndex != index) {
                weakSelf.filterBlock == nil ? : weakSelf.filterBlock(index);
            }
            lastIndex = index;
        }];
        [self addSubview:_editFilterView];
    }
    return _editFilterView;
}

+ (FJPhotoEditToolbarView *)create:(FJPhotoEditMode)mode editingBlock:(void (^)(BOOL inEditing))editingBlock filterBlock:(void(^)(FJFilterType filterType))filterBlock cropBlock:(void (^)(NSString *ratio, BOOL confirm))cropBlock tuneBlock:(void(^)(FJTuningType type, float value, BOOL confirm))tuneBlock {
    
    FJPhotoEditToolbarView *view = ZZ_LOAD_NIB(@"FJPhotoEditToolbarView");
    view.frame = CGRectMake(0, 0, ZZDevice.zz_screenWidth, 167.0);
    view.editingBlock = editingBlock;
    view.filterBlock = filterBlock;
    view.cropBlock = cropBlock;
    view.tuneBlock = tuneBlock;
    [view _buildUI:mode];
    [view _setHighlighted:0];
    view.editFilterView.hidden = NO;
    return view;
}

- (NSUInteger)getIndex {
    
    return self.index;
}

- (void)refreshFilterToolbar {
    
    FJPhotoModel *currentPhotoModel = [FJPhotoManager shared].currentEditPhoto;
    [self.editFilterView updateFilterImages:currentPhotoModel.filterThumbImages];
    [self.editFilterView setSelectedIndex:currentPhotoModel.tuningObject.filterType scrollable:NO];
}

- (void)_buildUI:(FJPhotoEditMode)mode {
    
    
    int count = 0;
    if (mode & FJPhotoEditModeFilter) {
        count++;
    }
    if (mode & FJPhotoEditModeCropprer) {
        count++;
    }
    if (mode & FJPhotoEditModeTuning) {
        count++;
    }
    if (mode & FJPhotoEditModeTag) {
        count++;
    }
    CGFloat w = ZZDevice.zz_screenWidth / (CGFloat)count;
    if (mode & FJPhotoEditModeFilter) {
        self.filterView.hidden = NO;
        self.filterView.frame = CGRectMake(0, 0, w, 48.0);
        self.filterImageView.frame = CGRectMake(w / 2.0 - 12.0, 4.0, 24.0, 24.0);
        self.filterLabel.frame = CGRectMake(0, 31.0, w, 12.0);
        self.filterButton.frame = self.filterView.bounds;
    }else {
        self.filterView.hidden = YES;
    }
    if (mode & FJPhotoEditModeCropprer) {
        self.cropperView.hidden = NO;
        if (mode & FJPhotoEditModeFilter) {
            self.cropperView.frame = CGRectMake(w, 0, w, 48.0);
        }else {
            self.cropperView.frame = CGRectMake(0, 0, w, 48.0);
        }
        self.cropperImageView.frame = CGRectMake(w / 2.0 - 12.0, 4.0, 24.0, 24.0);
        self.cropperLabel.frame = CGRectMake(0, 31.0, w, 12.0);
        self.cropperButton.frame = self.filterView.bounds;
    }else {
        self.cropperView.hidden = YES;
    }
    if (mode & FJPhotoEditModeTuning) {
        self.tuningView.hidden = NO;
        if ((mode & FJPhotoEditModeFilter) && (mode & FJPhotoEditModeCropprer)) {
            self.tuningView.frame = CGRectMake(w * 2.0, 0, w, 48.0);
        }else if ((mode & FJPhotoEditModeFilter) || (mode & FJPhotoEditModeCropprer)) {
            self.tuningView.frame = CGRectMake(w, 0, w, 48.0);
        }else {
            self.tuningView.frame = CGRectMake(0, 0, w, 48.0);
        }
        self.tuningImageView.frame = CGRectMake(w / 2.0 - 12.0, 4.0, 24.0, 24.0);
        self.tuningLabel.frame = CGRectMake(0, 31.0, w, 12.0);
        self.tuningButton.frame = self.filterView.bounds;
    }else {
        self.tuningView.hidden = YES;
    }
    if (mode & FJPhotoEditModeTag) {
        self.tagView.hidden = NO;
        if ((mode & FJPhotoEditModeFilter) && (mode & FJPhotoEditModeCropprer) && (mode & FJPhotoEditModeTuning)) {
            self.tagView.frame = CGRectMake(w * 3.0, 0, w, 48.0);
        }else if (((mode & FJPhotoEditModeFilter) && (mode & FJPhotoEditModeCropprer)) ||
                  ((mode & FJPhotoEditModeCropprer) && (mode & FJPhotoEditModeTuning)) ||
                  ((mode & FJPhotoEditModeFilter) && (mode & FJPhotoEditModeTuning))) {
            self.tagView.frame = CGRectMake(w * 2.0, 0, w, 48.0);
        }else if ((mode & FJPhotoEditModeFilter) || (mode & FJPhotoEditModeCropprer) || (mode & FJPhotoEditModeTuning)) {
            self.tagView.frame = CGRectMake(w, 0, w, 48.0);
        }else {
            self.tagView.frame = CGRectMake(0, 0, w, 48.0);
        }
        self.tagImageView.frame = CGRectMake(w / 2.0 - 12.0, 4.0, 24.0, 24.0);
        self.tagLabel.frame = CGRectMake(0, 31.0, w, 12.0);
        self.tagButton.frame = self.filterView.bounds;
    }else {
        self.tagView.hidden = YES;
    }
    
}

- (IBAction)_tapFilter:(id)sender {
    
    self.editFilterView.hidden = NO;
    [self _setHighlighted:0];
    self.index = 0;
    [self refreshFilterToolbar];
}

- (IBAction)_tapCropper:(id)sender {
    
    _editFilterView.hidden = YES;
    [self _setHighlighted:1];
    self.index = 1;
    ZZ_WEAK_SELF
    FJPhotoEditCropperView *view = [FJPhotoEditCropperView create:self.bounds editingBlock:self.editingBlock crop1to1:^{
        weakSelf.cropBlock == nil ? : weakSelf.cropBlock(@"1:1", NO);
    } crop3to4:^{
        weakSelf.cropBlock == nil ? : weakSelf.cropBlock(@"3:4", NO);
    } crop4to3:^{
        weakSelf.cropBlock == nil ? : weakSelf.cropBlock(@"4:3", NO);
    } crop4to5:^{
        weakSelf.cropBlock == nil ? : weakSelf.cropBlock(@"4:5", NO);
    } crop5to4:^{
        weakSelf.cropBlock == nil ? : weakSelf.cropBlock(@"5:4", NO);
    } okBlock:^(NSString *ratio) {
        weakSelf.cropBlock == nil ? : weakSelf.cropBlock(ratio, YES);
    }];
    [self addSubview:view];
}

- (IBAction)_tapTuning:(id)sender {
    
    _editFilterView.hidden = YES;
    [self _setHighlighted:2];
    self.index = 2;
    FJPhotoEditTuningView *view = [FJPhotoEditTuningView create:self.bounds editingBlock:self.editingBlock tuneBlock:self.tuneBlock];
    [self addSubview:view];
}

- (IBAction)_tapTag:(id)sender {
    
    _editFilterView.hidden = YES;
    [self _setHighlighted:3];
    self.index = 3;
    self.tagBlock == nil ? : self.tagBlock();
}

- (void)_setHighlighted:(NSUInteger)index {
    
    switch (index) {
        case 0:
        {
            [self.filterImageView setHighlighted:YES];
            [self.cropperImageView setHighlighted:NO];
            [self.tuningImageView setHighlighted:NO];
            [self.tagImageView setHighlighted:NO];
            self.filterLabel.textColor = @"#FF7725".zz_color;
            self.cropperLabel.textColor = @"#4F4F53".zz_color;
            self.tuningLabel.textColor = @"#4F4F53".zz_color;
            self.tagLabel.textColor = @"#4F4F53".zz_color;
            break;
        }
        case 1:
        {
            [self.filterImageView setHighlighted:NO];
            [self.cropperImageView setHighlighted:YES];
            [self.tuningImageView setHighlighted:NO];
            [self.tagImageView setHighlighted:NO];
            self.filterLabel.textColor = @"#4F4F53".zz_color;
            self.cropperLabel.textColor = @"#FF7725".zz_color;
            self.tuningLabel.textColor = @"#4F4F53".zz_color;
            self.tagLabel.textColor = @"#4F4F53".zz_color;
            break;
        }
        case 2:
        {
            [self.filterImageView setHighlighted:NO];
            [self.cropperImageView setHighlighted:NO];
            [self.tuningImageView setHighlighted:YES];
            [self.tagImageView setHighlighted:NO];
            self.filterLabel.textColor = @"#4F4F53".zz_color;
            self.cropperLabel.textColor = @"#4F4F53".zz_color;
            self.tuningLabel.textColor = @"#FF7725".zz_color;
            self.tagLabel.textColor = @"#4F4F53".zz_color;
            break;
        }
        case 3:
        {
            [self.filterImageView setHighlighted:NO];
            [self.cropperImageView setHighlighted:NO];
            [self.tuningImageView setHighlighted:NO];
            [self.tagImageView setHighlighted:YES];
            self.filterLabel.textColor = @"#4F4F53".zz_color;
            self.cropperLabel.textColor = @"#4F4F53".zz_color;
            self.tuningLabel.textColor = @"#4F4F53".zz_color;
            self.tagLabel.textColor = @"#FF7725".zz_color;
            break;
        }
        default:
            break;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
