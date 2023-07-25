//
//  ZZTableView+ZZKit.m
//  ZZKit
//
//  Created by Fu Jie on 2019/6/20.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZTableView+ZZKit.h"

@implementation ZZTableView (ZZKit)

// 获取CellDataSource对应的Cell
- (nullable __kindof ZZTableViewCell *)zz_cellForDataSource:(nullable __kindof ZZTableViewCellDataSource *)data {
    
    if (self.zzDataSource.count > 0) {
        id first = [self.zzDataSource objectAtIndex:0];
        if ([first isKindOfClass:[ZZTableViewCellDataSource class]]) {
            for (NSUInteger row = 0; row < self.zzDataSource.count; row++) {
                ZZTableViewCellDataSource *ds = [self.zzDataSource objectAtIndex:row];
                if (ds == data) {
                    return [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                }
            }
        }else if ([first isKindOfClass:[ZZTableSectionObject class]]) {
            
            for (NSUInteger section = 0; section < self.zzDataSource.count; section ++) {
                ZZTableSectionObject *sectionObject = [self.zzDataSource objectAtIndex:section];
                for (NSUInteger row = 0; row < sectionObject.zzCellDataSource.count; row++) {
                    ZZTableViewCellDataSource *ds = [sectionObject.zzCellDataSource objectAtIndex:row];
                    if (ds == data) {
                        return [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:row]];
                    }
                }
            }
        }
    }
    return nil;
}

// 根据DataSource的类型获得Cell （若存在多个，仅返回第一个cell）
- (nullable __kindof ZZTableViewCell *)zz_cellForClass:(id)cellClass {
    
    
    if (self.zzDataSource.count > 0) {
        id first = [self.zzDataSource objectAtIndex:0];
        if ([first isKindOfClass:[ZZTableViewCellDataSource class]]) {
            for (NSUInteger row = 0; row < self.zzDataSource.count; row++) {
                ZZTableViewCellDataSource *ds = [self.zzDataSource objectAtIndex:row];
                if ([ds isMemberOfClass:cellClass]) {
                    return [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                }
            }
        }else if ([first isKindOfClass:[ZZTableSectionObject class]]) {
            
            for (NSUInteger section = 0; section < self.zzDataSource.count; section ++) {
                ZZTableSectionObject *sectionObject = [self.zzDataSource objectAtIndex:section];
                for (NSUInteger row = 0; row < sectionObject.zzCellDataSource.count; row++) {
                    ZZTableViewCellDataSource *ds = [sectionObject.zzCellDataSource objectAtIndex:row];
                    if ([ds isMemberOfClass:cellClass]) {
                        return [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:row]];
                    }
                }
            }
        }
    }
    return nil;
}

@end
