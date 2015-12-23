//
//  RootTableView.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/1.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "RootTableView.h"

@implementation RootTableView

- (instancetype)initWithSampleNameArray:(NSArray *)arrSampleName frame:(CGRect)frame  cellConfigureBlock:(TableViewCellConfigureBlock) cellConfigureBlock didSelectRowBlock:(DidSelectRowBlock)didSelectRowBlock {
    if (self = [super init]) {
        _arrSampleName = arrSampleName;
        self.frame = frame;
        _cellConfigureBlock = [cellConfigureBlock copy];
        _didSelectRowBlock = [didSelectRowBlock copy];
        
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - TableView DataSource and Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"使用方式列表";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrSampleName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *sampleName = _arrSampleName[indexPath.row];
    cell.textLabel.text = sampleName;
    
    _cellConfigureBlock(cell, sampleName);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _didSelectRowBlock(indexPath.row);
}

@end
