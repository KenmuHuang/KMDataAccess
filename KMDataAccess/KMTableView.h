//
//  KMTableView.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/21.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMTableViewCell.h"
#import "GlobalInfoModel.h"

typedef void (^TableViewCellConfigureBlock)(KMTableViewCell *cell, GlobalInfoModel *globalInfo);
typedef void (^DidSelectRowBlock)(NSInteger row, GlobalInfoModel *globalInfo);
typedef void (^DidModifyRowBlock)(NSNumber *ID);
typedef void (^DidDelectRowBlock)(NSNumber *ID);

@interface KMTableView : UITableView <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
@property (strong, nonatomic) NSMutableArray *mArrGlobalInfo; // 这里不能用 copy，必须用 strong，因为 copy 的话会复制出不可变数组，删除操作会出错；我们这里是需要可变数组的
@property (copy, nonatomic) TableViewCellConfigureBlock cellConfigureBlock;
@property (copy, nonatomic) DidSelectRowBlock didSelectRowBlock;
@property (copy, nonatomic) DidModifyRowBlock didModifyRowBlock;
@property (copy, nonatomic) DidDelectRowBlock didDelectRowBlock;

- (instancetype)initWithGlobalInfoArray:(NSMutableArray *)mArrGlobalInfo frame:(CGRect)frame cellConfigureBlock:(TableViewCellConfigureBlock) cellConfigureBlock didSelectRowBlock:(DidSelectRowBlock)didSelectRowBlock didModifyRowBlock:(DidModifyRowBlock)didModifyRowBlock didDelectRowBlock:(DidDelectRowBlock)didDelectRowBlock;

@end
