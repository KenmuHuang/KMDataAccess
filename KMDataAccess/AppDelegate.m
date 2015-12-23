//
//  AppDelegate.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/1.
//  Copyright (c) 2015年 Kenmu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PasswordInputWindow.h"
#import "DateHelper.h"

@interface AppDelegate () {
    NSDate *_dateOfEnterBackground;
}

- (void)beginBackgroundUpdateTask;
- (void)longtimeToHandleSomething;
- (void)endBackgroundUpdateTask;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ViewController *viewController = [[ViewController alloc]
                                      initWithSampleNameArray:@[ kTitleOfPList,
                                                                 kTitleOfPreference,
                                                                 kTitleOfNSKeyedArchiver,
                                                                 kTitleOfKeychain,
                                                                 kTitleOfSQLite,
                                                                 kTitleOfCoreData,
                                                                 kTitleOfFMDB ]];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    _window.rootViewController = _navigationController;
    [_window makeKeyAndVisible];
    
    [[PasswordInputWindow sharedInstance] show];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self beginBackgroundUpdateTask];
    [self longtimeToHandleSomething];
    [self endBackgroundUpdateTask];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSDate *localeDate = [DateHelper localeDate];
    // 这里设置为5秒用于测试；实际上合理场景应该是60 ＊ 5 ＝ 5分钟或者更长时间
    _dateOfEnterBackground = [_dateOfEnterBackground dateByAddingTimeInterval:1 * 5];
    
    PasswordInputWindow *passwordInputWindow = [PasswordInputWindow sharedInstance];
    // 规定的一段时间没操作，就自动注销登录
    if ([localeDate compare:_dateOfEnterBackground] == NSOrderedDescending) {
        [passwordInputWindow loginOut];
    }
    
    if (![passwordInputWindow isHaveLogined]) {
        [passwordInputWindow show];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - backgroundTask
- (void)beginBackgroundUpdateTask {
    _backgroundTaskIdentifier = [kApplication beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)longtimeToHandleSomething {
    _dateOfEnterBackground = [DateHelper localeDate];
    
    NSLog(@"默认情况下，当 App 被按 Home 键退出进入后台挂起前，应用仅有最多5秒时间做一些保存或清理资源的工作。");
    NSLog(@"beginBackgroundTaskWithExpirationHandler 方法让 App 最多有10分钟时间在后台长久运行。这个时间可以用来清理本地缓存、发送统计数据等工作。");
    
//    for (NSInteger i=0; i<1000; i++) {
//        sleep(1);
//        NSLog(@"后台长久运行做一些事情%ld", (long)i);
//    }
}

- (void)endBackgroundUpdateTask {
    [kApplication endBackgroundTask:_backgroundTaskIdentifier];
    _backgroundTaskIdentifier = UIBackgroundTaskInvalid;
}

@end
