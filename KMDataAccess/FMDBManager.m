//
//  FMDBManager.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/21.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "FMDBManager.h"
#import "FMDatabase.h"

@implementation FMDBManager {
    FMDatabase *_database;
}

- (instancetype)init {
    if (self = [super init]) {
        [self openDB:kFMDBDBName];
    }
    return self;
}

+ (FMDBManager *)sharedManager {
    static FMDBManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FMDBManager new];
    });
    return manager;
}

- (void)openDB:(NSString *)databaseName {
    // 获取数据库保存路径，通常保存沙盒 Documents 目录下
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [directory stringByAppendingPathComponent:databaseName];
    // 打开数据库；如果数据库存在就直接打开，否则进行数据库创建并打开
    _database = [FMDatabase databaseWithPath:filePath];
    NSLog(@"数据库打开%@", [_database open] ? @"成功" : @"失败");
}

- (BOOL)executeNonQuery:(NSString *)sql withArgumentsInArray:(NSArray *)argumentsInArray {
    BOOL isSuccess = [_database executeUpdate:sql withArgumentsInArray:argumentsInArray];
    
    if (!isSuccess) {
        NSLog(@"执行sql语句过程中出现错误");
    }
    return isSuccess;
}

- (NSArray *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)argumentsInArray withDateArgumentsInArray:(NSArray *)dateArgumentsInArray {
    NSMutableArray *mArrResult = [NSMutableArray array];
    FMResultSet *resultSet = [_database executeQuery:sql withArgumentsInArray:argumentsInArray];
    while (resultSet.next) {
        NSMutableDictionary *mDicResult = [NSMutableDictionary dictionary];
        for (int i=0, columnCount=resultSet.columnCount; i<columnCount; i++) {
            NSString *columnName = [resultSet columnNameForIndex:i];
            // 对时间类型数据进行合适的转换
            if ([dateArgumentsInArray indexOfObject:columnName] != NSNotFound) {
                mDicResult[columnName] = [resultSet dateForColumnIndex:i];
            } else {
               mDicResult[columnName] = [resultSet stringForColumnIndex:i];
            }
        }
        [mArrResult addObject:mDicResult];
    }
    return mArrResult;
    
    /*
     一系列用于列数据转换的方法：
     
     intForColumn:
     longForColumn:
     longLongIntForColumn:
     boolForColumn:
     doubleForColumn:
     stringForColumn:
     dateForColumn:
     dataForColumn:
     dataNoCopyForColumn:
     UTF8StringForColumnName:
     objectForColumnName:
     */
}

@end
