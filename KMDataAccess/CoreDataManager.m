//
//  CoreDataManager.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/22.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

- (instancetype)init {
    if (self = [super init]) {
        _context = [self createDBContext:kCoreDataDBName];
    }
    return self;
}

+ (CoreDataManager *)sharedManager {
    static CoreDataManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CoreDataManager new];
    });
    return manager;
}

-(NSManagedObjectContext *)createDBContext:(NSString *)databaseName {
    // 获取数据库保存路径，通常保存沙盒 Documents 目录下
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [directory stringByAppendingPathComponent:databaseName];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    // 打开「被管理对象模型」文件，参数为 nil 则打开包中所有模型文件并合并成一个
    NSManagedObjectModel *model=[NSManagedObjectModel mergedModelFromBundles:nil];
    // 创建「持久化存储协调器」
    NSPersistentStoreCoordinator *coordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    // 为「持久化存储协调器」添加 SQLite 类型的「持久化存储」
    NSError *error;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:fileURL
                                    options:nil
                                      error:&error];
    // 创建「被管理对象上下文」，并设置他的「持久化存储协调器」
    NSManagedObjectContext *context;
    if (!error) {
        NSLog(@"数据库打开成功");
        
        context = [NSManagedObjectContext new];
        context.persistentStoreCoordinator = coordinator;
    } else {
        NSLog(@"数据库打开失败，错误信息：%@", error.localizedDescription);
    }
    return context;
    
    /*
     // Persistent store types supported by Core Data:
     COREDATA_EXTERN NSString * const NSSQLiteStoreType NS_AVAILABLE(10_4, 3_0);
     COREDATA_EXTERN NSString * const NSXMLStoreType NS_AVAILABLE(10_4, NA);
     COREDATA_EXTERN NSString * const NSBinaryStoreType NS_AVAILABLE(10_4, 3_0);
     COREDATA_EXTERN NSString * const NSInMemoryStoreType NS_AVAILABLE(10_4, 3_0);
     */
}

@end
