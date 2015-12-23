//
//  CoreDataGlobalInfoService.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/22.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "CoreDataGlobalInfoService.h"
#import "CoreDataManager.h"
#import "GlobalInfo.h"

static NSString *const kGlobalInfo = @"GlobalInfo";

@implementation CoreDataGlobalInfoService

+ (CoreDataGlobalInfoService *)sharedService {
    static CoreDataGlobalInfoService *service;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [CoreDataGlobalInfoService new];
        service.context = [CoreDataManager sharedManager].context;
    });
    return service;
}

- (BOOL)insertGlobalInfo:(GlobalInfoModel *)globalInfo {
    BOOL isSuccess = NO;
    
    // 可以使用 insertNewObjectForEntityForName: 方法创建多个实体，最终只需执行一次 save: 方法就会全提交到数据库了
    GlobalInfo *globalInfoEntity =
    [NSEntityDescription insertNewObjectForEntityForName:kGlobalInfo
                                  inManagedObjectContext:_context];
    globalInfoEntity.customID = globalInfo.ID;
    globalInfoEntity.avatarImageStr = globalInfo.avatarImageStr;
    globalInfoEntity.name = globalInfo.name;
    globalInfoEntity.text = globalInfo.text;
    globalInfoEntity.link = globalInfo.link;
    globalInfoEntity.createdAt = globalInfo.createdAt;
    NSError *error;
    isSuccess = [_context save:&error];
    if (!isSuccess) {
        NSLog(@"插入记录过程出现错误，错误信息：%@", error.localizedDescription);
    }
    return isSuccess;
}

- (BOOL)deleteGlobalInfoByID:(NSNumber *)ID {
    BOOL isSuccess = NO;
    
    GlobalInfo *globalInfoEntity = [self getGlobalInfoEntityByID:ID];
    if (globalInfoEntity) {
        NSError *error;
        [_context deleteObject:globalInfoEntity];
        isSuccess = [_context save:&error];
        if (!isSuccess) {
            NSLog(@"删除记录过程出现错误，错误信息：%@", error.localizedDescription);
        }
    }
    return isSuccess;
}

- (BOOL)updateGlobalInfo:(GlobalInfoModel *)globalInfo {
    BOOL isSuccess = NO;
    
    GlobalInfo *globalInfoEntity = [self getGlobalInfoEntityByID:globalInfo.ID];
    if (globalInfoEntity) {
        NSError *error;
        globalInfoEntity.avatarImageStr = globalInfo.avatarImageStr;
        globalInfoEntity.name = globalInfo.name;
        globalInfoEntity.text = globalInfo.text;
        globalInfoEntity.link = globalInfo.link;
        globalInfoEntity.createdAt = globalInfo.createdAt;
        isSuccess = [_context save:&error];
        if (!isSuccess) {
            NSLog(@"修改记录过程出现错误，错误信息：%@", error.localizedDescription);
        }
    }
    return isSuccess;
}

- (GlobalInfoModel *)getGlobalInfoByID:(NSNumber *)ID {
    GlobalInfoModel *globalInfo;
    
    GlobalInfo *globalInfoEntity = [self getGlobalInfoEntityByID:ID];
    if (globalInfoEntity) {
        globalInfo = [[GlobalInfoModel alloc]
                      initWithAvatarImageStr:globalInfoEntity.avatarImageStr
                      name:globalInfoEntity.name
                      text:globalInfoEntity.text
                      link:globalInfoEntity.link
                      createdAt:globalInfoEntity.createdAt
                      ID:globalInfoEntity.customID];
    }
    return globalInfo;
}

- (NSMutableArray *)getGlobalInfoGroup {
    NSMutableArray *mArrResult = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kGlobalInfo];
    //request.fetchLimit = 2; // 读取返回记录数限制
    //request.fetchOffset = 2; // 读取偏移量；默认值为0，表示不偏移；比如设置为2，表示前两条记录就不被读取了
    NSError *error;
    NSArray *arrResult = [_context executeFetchRequest:request
                                                 error:&error];
    if (!error) {
        for (GlobalInfo *globalInfoEntity in arrResult) {
            GlobalInfoModel *globalInfo = [[GlobalInfoModel alloc]
                                           initWithAvatarImageStr:globalInfoEntity.avatarImageStr
                                           name:globalInfoEntity.name
                                           text:globalInfoEntity.text
                                           link:globalInfoEntity.link
                                           createdAt:globalInfoEntity.createdAt
                                           ID:globalInfoEntity.customID];
            [mArrResult addObject:globalInfo];
        }
    } else {
        NSLog(@"查询记录过程出现错误，错误信息：%@", error.localizedDescription);
    }
    return mArrResult;
}

#pragma mark - Private Method
- (GlobalInfo *)getGlobalInfoEntityByID:(NSNumber *)ID {
    GlobalInfo *globalInfoEntity;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:kGlobalInfo];
    // 使用谓词查询是基于 Keypath 查询的，如果键是一个变量，格式化字符串时需要使用 %K 而不是 %@
    request.predicate = [NSPredicate predicateWithFormat:@"%K=%@", @"customID", ID];
    NSError *error;
    NSArray *arrResult = [_context executeFetchRequest:request
                                                 error:&error];
    if (!error) {
        globalInfoEntity = [arrResult firstObject];
    } else {
        NSLog(@"查询记录过程出现错误，错误信息：%@", error.localizedDescription);
    }
    return globalInfoEntity;
}

@end
