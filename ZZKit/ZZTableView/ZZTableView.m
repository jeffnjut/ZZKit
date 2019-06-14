//
//  ZZTableView.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/14.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZTableView.h"
#import <Masonry/Masonry.h>

#pragma mark - ZZTableView类

@interface ZZTableView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation ZZTableView

#pragma mark - 初始化函数

+ (nonnull ZZTableView *)zz_quickAdd:(ZZTableViewCellEditingStyle)editingStyle backgroundColor:(nullable UIColor *)backgroundColor frame:(CGRect)frame makeConstraint:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock actionBlock:(ZZTableViewCellActionBlock)actionBlock {
    
    return nil;
}

#pragma mark - Property Setting & Getting

- (void)setZzTableViewCellEditingStyle:(ZZTableViewCellEditingStyle)zzTableViewCellEditingStyle {
    
}

- (void)setZzSeparatorStyle:(UITableViewCellSeparatorStyle)zzSeparatorStyle {
    self.separatorStyle = zzSeparatorStyle;
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSections {
    
    // TODO
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // TODO
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // TODO
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // TODO
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // TODO
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    // TODO
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // TODO
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO
    return YES;
}

/**
 * 删除风格:
 * UITableViewCellEditingStyleDelete （默认风格）  当tableView.editing=YES时，显示删除  /  当tableView.editing=NO时，隐藏删除，滑动出现  ||| 相应方法：commitEditingStyle
 
 * 插入风格:
 * UITableViewCellEditingStyleInsert  当tableView.editing=YES生效  ||| 相应方法：commitEditingStyle
 
 * 无风格:
 * UITableViewCellEditingStyleNone

 * 多组选中风格:
 * UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete  ||| 相应方法：didSelectRowAtIndexPath
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    /**
     *  ZZTableViewCellEditingStyleNone                     editing = YES, UITableViewCellEditingStyleNone
     *  ZZTableViewCellEditingStyleInsert                   editing = YES, UITableViewCellEditingStyleInsert
     *  ZZTableViewCellEditingStyleMove                     editing = YES, UITableViewCellEditingStyleNone
     *  ZZTableViewCellEditingStyleMultiSelect              editing = YES, UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete
     *  ZZTableViewCellEditingStyleDirectDelete
     *  ZZTableViewCellEditingStyleDirectDeleteConfirm      editing = YES, UITableViewCellEditingStyleDelete
     *  ZZTableViewCellEditingStyleSlidingDelete
     *  ZZTableViewCellEditingStyleSlidingDeleteConfirm
     *  ZZTableViewCellEditingStyleLongPressDelete
     *  ZZTableViewCellEditingStyleLongPressDeleteConfirm   editing = NO, UITableViewCellEditingStyleDelete
     */
    // TODO
    return 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // TODO
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // TODO
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    // TODO
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    // TODO
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    // TODO
    return 0;
}

#pragma mark - UIScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

#pragma mark - ZZTableSectionObject类

@implementation ZZTableSectionObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellDataSource = (NSMutableArray<ZZTableViewCellDataSource *> *)[[NSMutableArray alloc] init];
    }
    return self;
}

@end

#pragma mark - ZZTableViewCell类

@implementation ZZTableViewCell

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

@end

@implementation ZZTableViewCellDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.zzUsingCustomType = YES;
        self.zzHeight = 0;
    }
    return self;
}

@end

#pragma mark - ZZTableViewHeaderFooterView类

@implementation ZZTableViewHeaderFooterView

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end

@implementation ZZTableViewHeaderFooterViewDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.zzHeight = 0;
    }
    return self;
}

@end
