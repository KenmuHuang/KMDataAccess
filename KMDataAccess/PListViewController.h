//
//  PListViewController.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/18.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnWriteTo;
@property (weak, nonatomic) IBOutlet UIButton *btnReadFrom;
@property (weak, nonatomic) IBOutlet UITextView *txtVDetailInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgVDetailInfo;

@end
