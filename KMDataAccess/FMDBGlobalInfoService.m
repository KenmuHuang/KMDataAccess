//
//  FMDBGlobalInfoService.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/21.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "FMDBGlobalInfoService.h"
#import "FMDBManager.h"
#import "FMDBDBCreator.h"

@implementation FMDBGlobalInfoService

+ (FMDBGlobalInfoService *)sharedService {
    static FMDBGlobalInfoService *service;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [FMDBGlobalInfoService new];
        
        [FMDBDBCreator createDB];
    });
    return service;
}

- (BOOL)insertGlobalInfo:(GlobalInfoModel *)globalInfo {
    NSArray *arrArgument = @[
                             globalInfo.avatarImageStr,
                             globalInfo.name,
                             globalInfo.text,
                             globalInfo.link,
                             globalInfo.createdAt
                             ];
    NSString *sql = [NSString
                     stringWithFormat:
                     @"INSERT INTO GlobalInfo(%@, %@, %@, %@, %@) VALUES(?, ?, ?, ?, ?)",
                     kAvatarImageStr, kName, kText, kLink, kCreatedAt];
    return [[FMDBManager sharedManager] executeNonQuery:sql
                                   withArgumentsInArray:arrArgument];
}

- (BOOL)deleteGlobalInfoByID:(NSNumber *)ID {
    NSString *sql =
    [NSString stringWithFormat:@"DELETE FROM GlobalInfo WHERE %@=?", kID];
    return [[FMDBManager sharedManager] executeNonQuery:sql
                                   withArgumentsInArray:@[ ID ]];
}

- (BOOL)updateGlobalInfo:(GlobalInfoModel *)globalInfo {
    NSArray *arrArgument = @[
                             globalInfo.avatarImageStr,
                             globalInfo.name,
                             globalInfo.text,
                             globalInfo.link,
                             globalInfo.createdAt,
                             globalInfo.ID
                             ];
    NSString *sql = [NSString
                     stringWithFormat:
                     @"UPDATE GlobalInfo SET %@=?, %@=?, %@=?, %@=?, %@=? WHERE %@=?",
                     kAvatarImageStr, kName, kText, kLink, kCreatedAt, kID];
    return [[FMDBManager sharedManager] executeNonQuery:sql
                                   withArgumentsInArray:arrArgument];
}

- (GlobalInfoModel *)getGlobalInfoByID:(NSNumber *)ID {
    GlobalInfoModel *globalInfo;
    NSString *sql = [NSString
                     stringWithFormat:@"SELECT %@, %@, %@, %@, %@ FROM GlobalInfo WHERE %@=?",
                     kAvatarImageStr, kName, kText, kLink, kCreatedAt, kID];
    NSArray *arrResult = [[FMDBManager sharedManager] executeQuery:sql
                                              withArgumentsInArray:@[ ID ]
                                          withDateArgumentsInArray:@[ kCreatedAt ]];
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
    NSArray *arrResult =
    [[FMDBManager sharedManager] executeQuery:sql
                         withArgumentsInArray:nil
                     withDateArgumentsInArray:@[ kCreatedAt ]];
    if (arrResult && arrResult.count > 0) {
        for (NSDictionary *dicResult in arrResult) {
            [mArrResult
             addObject:[[GlobalInfoModel alloc] initWithDictionary:dicResult]];
        }
    }
    return mArrResult;
}

@end
