//
//  FMDBGlobalInfoService.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/21.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalInfoModel.h"

@interface FMDBGlobalInfoService : NSObject
+ (FMDBGlobalInfoService *)sharedService;
- (BOOL)insertGlobalInfo:(GlobalInfoModel *)globalInfo;
- (BOOL)deleteGlobalInfoByID:(NSNumber *)ID;
- (BOOL)updateGlobalInfo:(GlobalInfoModel *)globalInfo;
- (GlobalInfoModel *)getGlobalInfoByID:(NSNumber *)ID;
- (NSMutableArray *)getGlobalInfoGroup;

@end
