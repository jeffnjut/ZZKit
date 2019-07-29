//
//  ZZCityController.m
//  ZZKit
//
//  Created by Fu Jie on 2019/7/28.
//  Copyright © 2019 Jeff. All rights reserved.
//

#import "ZZCityController.h"
#import <Masonry/Masonry.h>
#import "UIViewController+ZZKit.h"
#import "ZZCityModel.h"

@interface ZZCityController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *cities;

@end

@implementation ZZCityController

- (NSArray *)cities {
    if (_cities == nil) {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"cncity" ofType:@"plist"];
        NSArray *cityGroupArray = [NSArray arrayWithContentsOfFile:filePath];
        // 所有字典对象转成模型对象
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (NSDictionary *dic in cityGroupArray) {
            // 声明一个空的CityGroup对象
            ZZCityModel *model = [[ZZCityModel alloc] init];
            // KVC绑定模型对象属性和字典key的关系
            [model setValuesForKeysWithDictionary:dic];
            [mutableArray addObject:model];
        }
        _cities = mutableArray;
    }
    return _cities;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [self.view addSubview:_tableView];
        __weak typeof(self) weakSelf = self;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.view);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
}

#pragma mark - UITableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.cities.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ZZCityModel *model = self.cities[section];
    return model.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    // Configure the cell...
    ZZCityModel *model = self.cities[indexPath.section];
    cell.textLabel.text = model.cities[indexPath.row];
    return cell;
}

//返回section的头部文本
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    ZZCityModel *model = self.cities[section];
    return model.title;
}

//返回tableViewIndex数组
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    //方式一
    //    NSMutableArray *titleMutablArray = [NSMutableArray array];
    //    for (TRCityGroup *cityGroup in self.cityGroupArray) {
    //        [titleMutablArray addObject:cityGroup.title];
    //    }
    //    return [titleMutablArray copy];
    //方式二
    return [self.cities valueForKeyPath:@"title"];
}

//选中那一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZZCityModel *model = self.cities[indexPath.section];
    NSString *cityName = model.cities[indexPath.row];
    // 回调Block
    _zzSelectCityBlock == nil ? : _zzSelectCityBlock(cityName);
    [self zz_dismiss];
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
