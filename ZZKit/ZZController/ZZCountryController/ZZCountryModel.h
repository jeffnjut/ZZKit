//
//  ZZCountryModel.h
//  ZZKit
//
//  Created by Fu Jie on 2019/6/26.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCountryModel : NSObject

@property (nonatomic, copy) NSString *abbr;
@property (nonatomic, copy) NSString *cn;
@property (nonatomic, copy) NSString *en;
@property (nonatomic, copy) NSString *phoneCode;

@end

@interface ZZCountryListModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *hots;
@property (nonatomic, strong) NSArray<NSString *> *enidxes;
@property (nonatomic, strong) NSArray<NSString *> *cnidxes;
@property (nonatomic, strong) NSArray<ZZCountryModel *> *countrys;

@end

NS_ASSUME_NONNULL_END
