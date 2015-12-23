//
//  CoreDataGlobalInfoService.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/22.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GlobalInfoModel.h" // 为了 KMAddRecordViewController 和 KMTableView 统一格式管理，这里引入 GlobalInfoModel（特殊情况特殊处理），一般情况不需要这样做，因为实际上在 CoreData 中已经生成了 GlobalInfo 实体映射来方便我们操作数据库了

@interface CoreDataGlobalInfoService : NSObject
@property (strong, nonatomic) NSManagedObjectContext *context;

+ (CoreDataGlobalInfoService *)sharedService;
- (BOOL)insertGlobalInfo:(GlobalInfoModel *)globalInfo;
- (BOOL)deleteGlobalInfoByID:(NSNumber *)ID;
- (BOOL)updateGlobalInfo:(GlobalInfoModel *)globalInfo;
- (GlobalInfoModel *)getGlobalInfoByID:(NSNumber *)ID;
- (NSMutableArray *)getGlobalInfoGroup;

@end
