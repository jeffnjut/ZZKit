//
//  TestZZCollectionReusableView.h
//  EZView
//
//  Created by Fu Jie on 2020/12/16.
//

#import <UIKit/UIKit.h>
#import "ZZCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestZZCollectionReusableView : ZZCollectionReusableView

@property (nonatomic, weak) IBOutlet UILabel *lbTitle;

@end

@interface TestZZCollectionReusableViewDataSource : ZZCollectionReusableViewDataSource

@property (nonatomic, copy) NSString *txt;

@end

NS_ASSUME_NONNULL_END
