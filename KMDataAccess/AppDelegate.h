//
//  AppDelegate.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/1.
//  Copyright (c) 2015年 Kenmu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

