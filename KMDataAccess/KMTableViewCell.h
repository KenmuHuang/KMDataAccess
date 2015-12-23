//
//  KMTableViewCell.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/4.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface KMTableViewCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgVAvatarImage;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblCreatedAt;
@property (strong, nonatomic) IBOutlet UIImageView *imgVLink;

@property (strong, nonatomic) UILabel *lblText;
@property (copy, nonatomic) NSString *avatarImageStr;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *createdAt;
@property (assign, nonatomic, getter=isHaveLink) BOOL haveLink;

@end
