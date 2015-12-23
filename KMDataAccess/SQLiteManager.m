//
//  SQLiteManager.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/3.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "SQLiteManager.h"

@implementation SQLiteManager

- (instancetype)init {
    if (self = [super init]) {
        [self openDB:kSQLiteDBName];
    }
    return self;
}

+ (SQLiteManager *)sharedManager {
    static SQLiteManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [SQLiteManager new];
    });
    return manager;
}

- (void)openDB:(NSString *)databaseName {
    // 获取数据库保存路径，通常保存沙盒 Documents 目录下
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [directory stringByAppendingPathComponent:databaseName];
    // 打开数据库；如果数据库存在就直接打开，否则进行数据库创建并打开（filePath 是 ObjC 语言的字符串，需要转化为 C 语言字符串）
    BOOL isSuccessToOpen = sqlite3_open(filePath.UTF8String, &_database) == SQLITE_OK;
    NSLog(@"数据库打开%@", isSuccessToOpen ? @"成功" : @"失败");
}

- (BOOL)executeNonQuery:(NSString *)sql {
    BOOL isSuccess = YES;
    char *error;
    // 单步执行sql语句；用于增删改
    if (sqlite3_exec(_database, sql.UTF8String, NULL, NULL, &error)) {
        isSuccess = NO;
        NSLog(@"执行sql语句过程中出现错误，错误信息：%s", error);
    }
    return isSuccess;
}

- (NSArray *)executeQuery:(NSString *)sql {
    NSMutableArray *mArrResult = [NSMutableArray array];
    
    sqlite3_stmt *stmt;
    // 检查语法正确性
    if (sqlite3_prepare_v2(_database, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        // 以游标的形式，逐行读取数据
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *mDicResult = [NSMutableDictionary dictionary];
            for (int i=0, columnCount=sqlite3_column_count(stmt); i<columnCount; i++) {
                // 获取列名
                const char *columnName = sqlite3_column_name(stmt, i);
                // 获取列值
                const char *columnText = (const char *)sqlite3_column_text(stmt, i);
                mDicResult[[NSString stringWithUTF8String:columnName]] = [NSString stringWithUTF8String:columnText];
            }
            [mArrResult addObject:mDicResult];
        }
    }
    
    // 释放句柄
    sqlite3_finalize(stmt);
    return mArrResult;
}

@end
