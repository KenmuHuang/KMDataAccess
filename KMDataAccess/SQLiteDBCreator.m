//
//  SQLiteDBCreator.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/3.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "SQLiteDBCreator.h"
#import "SQLiteManager.h"

@implementation SQLiteDBCreator

#pragma mark - Private Method
+ (void)createTable {
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE GlobalInfo(ID integer PRIMARY KEY AUTOINCREMENT, %@ text, %@ text, \"%@\" text, %@ text, %@ date)", kAvatarImageStr, kName, kText, kLink, kCreatedAt];
    [[SQLiteManager sharedManager] executeNonQuery:sql];
}

#pragma mark - Public Method
+ (void)createDB {
    // 使用偏好设置保存「是否已经初始化数据库表」的键值；避免重复创建
    NSString *const isInitializedTableStr = @"IsInitializedTableForSQLite";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:isInitializedTableStr]) {
        [self createTable];
        
        [userDefaults setBool:YES forKey:isInitializedTableStr];
    }
}

@end
