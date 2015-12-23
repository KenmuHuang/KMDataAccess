//
//  RootTableView.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/1.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TableViewCellConfigureBlock)(UITableViewCell *cell, NSString *sampleName);
typedef void (^DidSelectRowBlock)(NSInteger row);

@interface RootTableView : UITableView <UITableViewDataSource, UITableViewDelegate>
@property (copy, nonatomic) NSArray *arrSampleName;
@property (copy, nonatomic) TableViewCellConfigureBlock cellConfigureBlock;
@property (copy, nonatomic) DidSelectRowBlock didSelectRowBlock;

- (instancetype)initWithSampleNameArray:(NSArray *)arrSampleName frame:(CGRect)frame  cellConfigureBlock:(TableViewCellConfigureBlock) cellConfigureBlock didSelectRowBlock:(DidSelectRowBlock)didSelectRowBlock;

@end