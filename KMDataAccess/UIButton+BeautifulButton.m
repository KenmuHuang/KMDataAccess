//
//  UIButton+BeautifulButton.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/5.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "UIButton+BeautifulButton.h"

@implementation UIButton (BeautifulButton)

- (void)beautifulButton:(UIColor *)tintColor {
    self.tintColor = tintColor ?: [UIColor darkGrayColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10.0;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1.0;
}

@end
