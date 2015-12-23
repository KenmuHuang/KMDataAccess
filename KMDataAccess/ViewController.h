//
//  ViewController.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/1.
//  Copyright (c) 2015年 Kenmu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (copy, nonatomic) NSArray *arrSampleName;

- (instancetype)initWithSampleNameArray:(NSArray *)arrSampleName;

@end

