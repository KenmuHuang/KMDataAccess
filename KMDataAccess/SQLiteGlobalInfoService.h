//
//  SQLiteGlobalInfoService.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/4.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalInfoModel.h"

@interface SQLiteGlobalInfoService : NSObject
+ (SQLiteGlobalInfoService *)sharedService;
- (BOOL)insertGlobalInfo:(GlobalInfoModel *)globalInfo;
- (BOOL)deleteGlobalInfoByID:(NSNumber *)ID;
- (BOOL)updateGlobalInfo:(GlobalInfoModel *)globalInfo;
- (GlobalInfoModel *)getGlobalInfoByID:(NSNumber *)ID;
- (NSMutableArray *)getGlobalInfoGroup;

@end
