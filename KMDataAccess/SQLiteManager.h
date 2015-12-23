//
//  SQLiteManager.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/3.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteManager : NSObject
@property (assign, nonatomic) sqlite3 *database;

+ (SQLiteManager *)sharedManager;
- (void)openDB:(NSString *)databaseName;
- (BOOL)executeNonQuery:(NSString *)sql;
- (NSArray *)executeQuery:(NSString *)sql;

@end
