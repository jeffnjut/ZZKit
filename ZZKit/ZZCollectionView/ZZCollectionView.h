//
//  ZZCollectionView.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/24.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZCollectionView, ZZCollectionSectionObject, ZZCollectionViewCell, ZZCollectionViewCellDataSource;

#pragma mark - 类型定义

// 定义Cell事件类型
typedef NS_ENUM(NSInteger, ZZCollectionViewCellAction) {
    ZZCollectionViewCellActionTapped,          // 点击Cell
    ZZCollectionViewCellActionCustomTapped,    // 点击Cell上自定义事件（按钮或其它部件的事件监听）
};

// 点击Cell Block定义
typedef void (^ZZCollectionViewCellActionBlock)(__weak ZZCollectionView * _Nonnull collectionView,
                                                NSInteger section,
                                                NSInteger row,
                                                ZZCollectionViewCellAction action,
                                                __kindof ZZCollectionViewCellDataSource * _Nullable cellData,
                                                __kindof ZZCollectionViewCell * _Nullable cell);

#pragma mark - ZZCollectionViewFlowLayoutDelegate

@protocol ZZCollectionViewFlowLayoutDelegate <NSObject>

@optional

// 行间距
- (CGFloat)zz_minimumLineSpacingForSectionAtIndex:(NSInteger)section;
// 列间距
- (CGFloat)zz_minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
// SectionInset
- (UIEdgeInsets)zz_contentInsetOfSectionAtIndex:(NSInteger)section;

@required

// Section的数量
- (NSInteger)zz_numberOfSection;
// Cell的大小
- (CGSize)zz_sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
// 每个Section对应的列数
- (NSInteger)zz_numberOfColumnInSectionAtIndex:(NSInteger)section;

@end

#pragma mark - ZZCollectionViewFlowLayout

@interface ZZCollectionViewFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<ZZCollectionViewFlowLayoutDelegate> zzFlowLayoutDelegate;

// 代替原生UICollectionView.contentInset属性
@property (nonatomic, assign) UIEdgeInsets zzContentInset;

@end

#pragma mark - ZZCollectionView

@interface ZZCollectionView : UICollectionView

// Cell 响应事件Block
@property (nonatomic, copy) ZZCollectionViewCellActionBlock zzActionBlock;

// FlowLayout
@property (nonatomic, strong, readonly) ZZCollectionViewFlowLayout *zzLayout;

/**
 *  创建ZZTableView的方法
 */
+ (nonnull ZZCollectionView *)zz_quickAdd:(nullable UIColor *)backgroundColor onView:(nullable UIView *)onView frame:(CGRect)frame registerCellsBlock:(nullable NSArray *(^)(void))registerCellsBlock constraintBlock:(nullable void(^)(UIView * _Nonnull superView, MASConstraintMaker * _Nonnull make))constraintBlock actionBlock:(ZZCollectionViewCellActionBlock)actionBlock;

/**
 *  一组安全的操作datasource的方法
 */
- (void)zz_addDataSource:(nonnull id)data;
- (void)zz_insertDataSource:(nonnull id)anObject atIndex:(NSUInteger)index;
- (void)zz_removeDataSource:(nonnull id)data;
- (void)zz_removeDataSourceObjectAtIndex:(NSInteger)index;
- (void)zz_removeFirstDataSource;
- (void)zz_removeLastDataSource;
- (void)zz_removeAllDataSource;
- (void)zz_replaceDataSourceAtIndex:(NSUInteger)index withObject:(nonnull id)data;
- (void)zz_exchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2;

/**
 *  CollectionView安全加载刷新Data
 */
- (void)zz_refresh;

@end

#pragma mark - ZZCollectionSectionObject

@interface ZZCollectionSectionObject : NSObject

@property (nonatomic, assign) NSInteger zzColumns;
@property (nonatomic, assign) UIEdgeInsets zzEdgeInsets;
@property (nonatomic, assign) CGFloat zzMinimumInteritemSpacing;
@property (nonatomic, assign) CGFloat zzMinimumLineSpacing;
@property (nonatomic, strong) NSMutableArray<ZZCollectionViewCellDataSource *> *zzCellDataSource;

@end

#pragma mark - ZZCollectionViewCell

@interface ZZCollectionViewCell : UICollectionViewCell

// 数据
@property (nonatomic, strong) __kindof ZZCollectionViewCellDataSource *zzData;

// 用户自定义点击Block
@property (nonatomic, copy) void(^zzTapBlock)(__kindof ZZCollectionViewCellDataSource * _Nonnull data, __kindof ZZCollectionViewCell * _Nonnull cell);

@end

#pragma mark - ZZCollectionViewCellDataSource

@interface ZZCollectionViewCellDataSource : NSObject

// 高度
@property (nonatomic, assign) CGSize zzSize;

@end

NS_ASSUME_NONNULL_END
