//
//  KMTableView.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/21.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "KMTableView.h"

static NSString *const cellIdentifier = @"cellIdentifier";

@implementation KMTableView {
    UILabel *_lblEmptyDataMsg;
}

- (instancetype)initWithGlobalInfoArray:(NSMutableArray *)mArrGlobalInfo frame:(CGRect)frame cellConfigureBlock:(TableViewCellConfigureBlock) cellConfigureBlock didSelectRowBlock:(DidSelectRowBlock)didSelectRowBlock didModifyRowBlock:(DidModifyRowBlock)didModifyRowBlock didDelectRowBlock:(DidDelectRowBlock)didDelectRowBlock{
    if (self = [super init]) {
        _mArrGlobalInfo = mArrGlobalInfo;
        self.frame = frame;
        _cellConfigureBlock = [cellConfigureBlock copy];
        _didSelectRowBlock = [didSelectRowBlock copy];
        _didModifyRowBlock = [didModifyRowBlock copy];
        _didDelectRowBlock = [didDelectRowBlock copy];
        
        [self tableViewLayout];
    }
    return self;
}

- (void)tableViewLayout {
    // 设置边距，解决单元格分割线默认偏移像素过多的问题
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero]; // 设置单元格（上左下右）内边距
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero]; // 设置单元格（上左下右）外边距
    }
    
    // 注册可复用的单元格
    UINib *nib = [UINib nibWithNibName:@"KMTableViewCell" bundle:nil];
    [self registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    self.dataSource = self;
    self.delegate = self;
    
    // 空数据时，显示的提示内容
    _lblEmptyDataMsg = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 50.0)];
    CGPoint newPoint = self.center;
    newPoint.y -= 60.0;
    _lblEmptyDataMsg.center = newPoint;
    _lblEmptyDataMsg.text = @"点击「＋」按钮添加全球新闻信息";
    _lblEmptyDataMsg.textColor = [UIColor grayColor];
    _lblEmptyDataMsg.textAlignment = NSTextAlignmentCenter;
    _lblEmptyDataMsg.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:_lblEmptyDataMsg];
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"修改"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

#pragma mark - TableView DataSource and Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"全球新闻信息列表";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = _mArrGlobalInfo.count;
    _lblEmptyDataMsg.hidden = count > 0;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[KMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    GlobalInfoModel *globalInfo = _mArrGlobalInfo[indexPath.row];
    cell.tag = [globalInfo.ID integerValue]; // 存储 ID 用于「修改」和「删除」记录操作
    cell.avatarImageStr = globalInfo.avatarImageStr;
    cell.name = globalInfo.name;
    cell.text = globalInfo.text;
    cell.createdAt = globalInfo.createdAt;
    cell.haveLink = globalInfo.haveLink;
    
    _cellConfigureBlock(cell, globalInfo);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    _didSelectRowBlock(row, _mArrGlobalInfo[row]);
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSNumber *ID = @(cell.tag);
    switch (index) {
        case 0: {
            NSLog(@"点击了修改按钮");
            _didModifyRowBlock(ID);
            break;
        }
        case 1: {
            NSLog(@"点击了删除按钮");
            _didDelectRowBlock(ID);
            
            NSIndexPath *cellIndexPath = [self indexPathForCell:cell];
            [_mArrGlobalInfo removeObjectAtIndex:cellIndexPath.row];
            [self deleteRowsAtIndexPaths:@[ cellIndexPath ]
                        withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES; // 设置是否隐藏其他行的「实用按钮」，即不同时出现多行的「实用按钮」；默认值为NO
}

@end
