//
//  GlobalInfo+CoreDataProperties.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/23.
//  Copyright © 2015年 Kenmu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GlobalInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GlobalInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *avatarImageStr;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSNumber *customID;

@end

NS_ASSUME_NONNULL_END
