//
//  FMDBManager.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/21.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBManager : NSObject

+ (FMDBManager *)sharedManager;
- (void)openDB:(NSString *)databaseName;
- (BOOL)executeNonQuery:(NSString *)sql withArgumentsInArray:(NSArray *)argumentsInArray;
- (NSArray *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)argumentsInArray withDateArgumentsInArray:(NSArray *)dateArgumentsInArray;

@end
