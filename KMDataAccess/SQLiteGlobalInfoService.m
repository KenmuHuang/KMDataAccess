//
//  SQLiteGlobalInfoService.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/4.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "SQLiteGlobalInfoService.h"
#import "SQLiteManager.h"
#import "SQLiteDBCreator.h"

@implementation SQLiteGlobalInfoService

+ (SQLiteGlobalInfoService *)sharedService {
    static SQLiteGlobalInfoService *service;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [SQLiteGlobalInfoService new];
        
        [SQLiteDBCreator createDB];
    });
    return service;
}

- (BOOL)insertGlobalInfo:(GlobalInfoModel *)globalInfo {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO GlobalInfo(%@, %@, %@, %@, %@) VALUES('%@','%@','%@','%@','%@')",
                     kAvatarImageStr, kName, kText, kLink, kCreatedAt,
                     globalInfo.avatarImageStr, globalInfo.name, globalInfo.text, globalInfo.link, globalInfo.createdAt];
    return [[SQLiteManager sharedManager] executeNonQuery:sql];
}

- (BOOL)deleteGlobalInfoByID:(NSNumber *)ID {
    NSString *sql =
    [NSString stringWithFormat:@"DELETE FROM GlobalInfo WHERE %@='%ld'", kID,
     (long)[ID integerValue]];
    return [[SQLiteManager sharedManager] executeNonQuery:sql];
}

- (BOOL)updateGlobalInfo:(GlobalInfoModel *)globalInfo {
    NSString *sql = [NSString stringWithFormat:@"UPDATE GlobalInfo SET %@='%@', %@='%@', %@='%@', %@='%@', %@='%@' WHERE %@='%ld'",
                     kAvatarImageStr, globalInfo.avatarImageStr,
                     kName, globalInfo.name,
                     kText, globalInfo.text,
                     kLink, globalInfo.link,
                     kCreatedAt, globalInfo.createdAt,
                     kID, (long)[globalInfo.ID integerValue]];
    return [[SQLiteManager sharedManager] executeNonQuery:sql];
}

- (GlobalInfoModel *)getGlobalInfoByID:(NSNumber *)ID {
    GlobalInfoModel *globalInfo;
    NSString *sql =
    [NSString stringWithFormat:
     @"SELECT %@, %@, %@, %@, %@ FROM GlobalInfo WHERE %@='%ld'",
     kAvatarImageStr, kName, kText, kLink, kCreatedAt, kID,
     (long)[ID integerValue]];
    NSArray *arrResult = [[SQLiteManager sharedManager] executeQuery:sql];
    if (arrResult && arrResult.count > 0) {
        globalInfo = [[GlobalInfoModel alloc] initWithDictionary:arrResult[0]];
    }
    return globalInfo;
}

- (NSMutableArray *)getGlobalInfoGroup {
    NSMutableArray *mArrResult = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *sql = [NSString
                     stringWithFormat:@"SELECT %@, %@, %@, %@, %@, %@ FROM GlobalInfo", kID,
                     kAvatarImageStr, kName, kText, kLink, kCreatedAt];
    NSArray *arrResult = [[SQLiteManager sharedManager] executeQuery:sql];
    if (arrResult && arrResult.count > 0) {
        for (NSDictionary *dicResult in arrResult) {
            [mArrResult
             addObject:[[GlobalInfoModel alloc] initWithDictionary:dicResult]];
        }
    }
    return mArrResult;
}

@end
