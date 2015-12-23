//
//  PasswordInputWindow.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/16.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  密码保护自定义窗口
 */
@interface PasswordInputWindow : UIWindow

+ (PasswordInputWindow *)sharedInstance;
- (void)show;
- (BOOL)isHaveLogined;
- (void)loginIn;
- (void)loginOut;

@end
