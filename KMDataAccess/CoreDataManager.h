//
//  CoreDataManager.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/22.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject
@property (strong, nonatomic) NSManagedObjectContext *context;

+ (CoreDataManager *)sharedManager;
-(NSManagedObjectContext *)createDBContext:(NSString *)databaseName;

@end
