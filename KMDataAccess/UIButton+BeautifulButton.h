//
//  UIButton+BeautifulButton.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/5.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BeautifulButton)
/**
 *  根据按钮文字颜色，返回对应文字颜色的圆角按钮
 *
 *  @param tintColor 按钮文字颜色；nil 的话就为深灰色
 */
- (void)beautifulButton:(UIColor *)tintColor;

@end
