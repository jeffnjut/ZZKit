//
//  ZZPhotoDraftHistoryViewController.m
//  ZZCamera
//
//  Created by Fu Jie on 2019/1/16.
//  Copyright © 2019 Fu Jie. All rights reserved.
//

#import "ZZPhotoDraftHistoryViewController.h"
#import "NSString+ZZKit.h"
#import "ZZPhotoDraftCell.h"
#import "NSObject+Camera_Popup.h"
#import "ZZPhotoDraftBottomView.h"
#import "ZZMacro.h"
#import "ZZDevice.h"
#import "UIView+ZZKit_HUD.h"
#import "UIViewController+ZZKit.h"

@interface LeftButton : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@end

@implementation LeftButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        self.imageView.image = @"LeftButton.ic_back".zz_image;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:self.label];
        self.label.text = @"取消";
        self.label.font = [UIFont systemFontOfSize:14.0];
        self.label.textColor = @"#FF7A00".zz_color;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.hidden = YES;
        self.button = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:self.button];
    }
    return self;
}

- (void)setTag:(NSInteger)tag {
    
    [super setTag:tag];
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (tag) {
            case 0:
            {
                self.imageView.hidden = NO;
                self.label.hidden = YES;
            }
                break;
            case 1:
            {
                self.imageView.hidden = YES;
                self.label.hidden = NO;
            }
                break;
            default:
                break;
        }
    });
}

@end

@interface RightButton : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;

@end

@implementation RightButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
        self.imageView.image = @"RightButton.ic_operation_more".zz_image;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:self.label];
        self.label.hidden = YES;
        self.label.text = @"全选";
        self.label.textColor = @"#979797".zz_color;
        self.label.font = [UIFont systemFontOfSize:14.0];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.button = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:self.button];
    }
    return self;
}

- (void)setTag:(NSInteger)tag {
    
    [super setTag:tag];
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (tag) {
            case 0:
            {
                self.imageView.hidden = NO;
                self.label.hidden = YES;
                self.label.textColor = @"#979797".zz_color;
            }
                break;
            case 1:
            {
                self.imageView.hidden = YES;
                self.label.hidden = NO;
                self.label.textColor = @"#979797".zz_color;
                break;
            }
            case 2:
            {
                self.imageView.hidden = YES;
                self.label.hidden = NO;
                self.label.textColor = @"#FF7A00".zz_color;
            }
                break;
            default:
                break;
        }
    });
}

@end

@interface ZZPhotoDraftHistoryViewController ()

@property (nonatomic, strong) ZZTableView *tableView;
@property (nonatomic, strong) LeftButton *leftButton;
@property (nonatomic, strong) RightButton *rightButton;
@property (nonatomic, strong) ZZPhotoDraftBottomView *bottomView;

@end

@implementation ZZPhotoDraftHistoryViewController

- (void)dealloc {
    NSLog(@"Dealloc - ZZPhotoDraftHistoryViewController");
}

- (LeftButton *)leftButton {
    
    if (_leftButton == nil) {
        _leftButton = [[LeftButton alloc] initWithFrame:CGRectMake(0, 0, 48.0, 48.0)];
    }
    return _leftButton;
}

- (RightButton *)rightButton {
    
    if (_rightButton == nil) {
        _rightButton = [[RightButton alloc] initWithFrame:CGRectMake(0, 0, 48.0, 48.0)];
    }
    return _rightButton;
}

- (ZZPhotoDraftBottomView *)bottomView {
    
    if (_bottomView == nil) {
        _bottomView = ZZ_LOAD_NIB(@"ZZPhotoDraftBottomView");
        [self.view addSubview:_bottomView];
        ZZ_WEAK_SELF
        CGFloat h = 48.0 + (ZZ_DEVICE_IS_IPHONE_X_ALL ? 20.0 : 0);
        _bottomView.frame = CGRectMake(0, self.view.frame.size.height - h, self.view.frame.size.width, h);
        _bottomView.deleteBlock = ^{
            for (ZZPhotoDraftCellDataSource *ds in weakSelf.tableView.zzDataSource) {
                if (ds.selected == YES) {
                    [ZZPhotoManager.shared removeDraft:ds.data];
                }
            }
            [weakSelf _loadAndRender];
            weakSelf.rightButton.tag = 0;
            weakSelf.leftButton.tag = 0;
            weakSelf.bottomView.hidden = YES;
            if (weakSelf.tableView.zzDataSource.count == 0) {
                [weakSelf.view zz_toast:@"草稿箱已经全部清空了"];
                [weakSelf zz_dismiss];
            }
        };
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _buildUI];
    [self _loadAndRender];
}

- (void)_buildUI {
    
    ZZ_WEAK_SELF
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self zz_navigationBarHidden:NO];
    [self zz_navigationBarStyle:[UIColor whiteColor] translucent:NO bottomLineColor:@"#F5F5F5".zz_color];
    [self zz_navigationRemoveLeftBarButtons];
    [self zz_navigationAddLeftBarCustomView:self.leftButton action:nil];
    [self.leftButton.button addTarget:self action:@selector(_leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self zz_navigationAddRightBarCustomView:self.rightButton action:nil];
    [self.rightButton.button addTarget:self action:@selector(_rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self zz_navigationBarTitle:@"草稿箱"];
    
    if (self.tableView == nil) {
        self.tableView = [ZZTableView zz_quickAdd:ZZTableViewCellEditingStyleSlidingDelete backgroundColor:[UIColor whiteColor] onView:self.view frame:CGRectZero constraintBlock:^(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make) {
            make.edges.equalTo(superView);
        } actionBlock:^(ZZTableView *__weak  _Nonnull tableView, NSInteger section, NSInteger row, ZZTableViewCellAction action, __kindof ZZTableViewCellDataSource * _Nullable cellData, __kindof ZZTableViewCell * _Nullable cell, __kindof ZZTableViewHeaderFooterViewDataSource * _Nullable headerFooterData, __kindof ZZTableViewHeaderFooterView * _Nullable headerFooterView) {
            if (action == ZZTableViewCellActionTapped) {
                if ([cellData isKindOfClass:[ZZPhotoDraftCellDataSource class]]) {
                    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
                        ZZPhotoDraftCellDataSource *ds = cellData;
                        ZZPhotoManager.shared.config.userSelectDraftBlock == nil ? : ZZPhotoManager.shared.config.userSelectDraftBlock(ds.data, ds.pictureRemoved);
                    }];
                }
            }else if (action == ZZTableViewCellActionDelete) {
                if ([cellData isKindOfClass:[ZZPhotoDraftCellDataSource class]]) {
                    ZZPhotoDraftCellDataSource *ds = cellData;
                    [ZZPhotoManager.shared removeDraft:ds.data];
                    if (weakSelf.tableView.zzDataSource.count == 0) {
                        [weakSelf.view zz_toast:@"草稿箱已经全部清空了"];
                        [weakSelf zz_dismiss];
                    }
                }
            }else if (action == ZZTableViewCellActionCustomTapped) {
                if ([cellData isKindOfClass:[ZZPhotoDraftCellDataSource class]]) {
                    ZZPhotoDraftCellDataSource *ds = cellData;
                    if (ds.action == 0) {
                        // Check
                        for (ZZPhotoDraftCellDataSource *ds in weakSelf.tableView.zzDataSource) {
                            if (ds.selected == NO) {
                                weakSelf.rightButton.tag = 1;
                                return;
                            }
                        }
                        weakSelf.rightButton.tag = 2;
                    }else if (ds.action == 1) {
                        // 长按
                        weakSelf.leftButton.tag = 1;
                        weakSelf.rightButton.tag = 1;
                        weakSelf.bottomView.hidden = NO;
                        weakSelf.tableView.contentInset = UIEdgeInsetsMake(0, 0, 24.0, 0);
                        for (ZZPhotoDraftCellDataSource *ds in weakSelf.tableView.zzDataSource) {
                            ds.editable = YES;
                            if ([ds isEqual:cellData]) {
                                ds.selected = YES;
                            }else {
                                ds.selected = NO;
                            }
                        }
                        [weakSelf.tableView zz_refresh];
                    }
                }
            }
        }];
    }
}

- (void)_leftButtonAction {
    
    if (self.leftButton.tag == 0) {
        // 点击返回
        [self zz_dismiss];
    }else if (self.leftButton.tag == 1) {
        // 点击取消
        for (ZZPhotoDraftCellDataSource *ds in self.tableView.zzDataSource) {
            ds.editable = NO;
        }
        [self.tableView zz_refresh];
        self.leftButton.tag = 0;
        self.rightButton.tag = 0;
        self.bottomView.hidden = YES;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)_rightButtonAction {
    
    ZZ_WEAK_SELF
    if (self.rightButton.tag == 0) {
        // 点击更多
        [NSObject popupDraftEditTool:^{
            weakSelf.rightButton.tag = 1;
            weakSelf.leftButton.tag = 1;
            for (ZZPhotoDraftCellDataSource *ds in weakSelf.tableView.zzDataSource) {
                ds.editable = YES;
                ds.selected = NO;
            }
            [weakSelf.tableView zz_refresh];
            weakSelf.bottomView.hidden = NO;
            weakSelf.tableView.contentInset = UIEdgeInsetsMake(0, 0, 24.0, 0);
        }];
    }else if (self.rightButton.tag == 1) {
        // 点击全选（灰 未选）
        weakSelf.rightButton.tag = 2;
        for (ZZPhotoDraftCellDataSource *ds in weakSelf.tableView.zzDataSource) {
            ds.editable = YES;
            ds.selected = YES;
        }
        [weakSelf.tableView zz_refresh];
    }else if (self.rightButton.tag == 2) {
        // 点击全选（橙 已选）
        weakSelf.rightButton.tag = 1;
        for (ZZPhotoDraftCellDataSource *ds in weakSelf.tableView.zzDataSource) {
            ds.editable = YES;
            ds.selected = NO;
        }
        [weakSelf.tableView zz_refresh];
    }
}

- (void)_loadAndRender {
    
    [self.tableView.zzDataSource removeAllObjects];
    ZZDraftList *listModel = [ZZPhotoManager.shared loadDraftCache:self.uid];
    ZZ_WEAK_SELF
    [listModel.drafts enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(ZZDraft * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZZPhotoDraftCellDataSource *ds = [[ZZPhotoDraftCellDataSource alloc] init];
        ds.data = obj;
        [weakSelf.tableView zz_addDataSource:ds];
    }];
    [self.tableView zz_refresh];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
