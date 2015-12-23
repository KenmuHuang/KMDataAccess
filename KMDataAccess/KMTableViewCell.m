//
//  KMTableViewCell.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/4.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "KMTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DateHelper.h"

static UIImage *placeholderImage;
static CGFloat widthOfLabel;

@implementation KMTableViewCell

- (void)awakeFromNib {
    // Initialization code
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        placeholderImage = [UIImage imageNamed:@"JSON"];
        widthOfLabel = [[UIScreen mainScreen] bounds].size.width - 100.0;
    });
    
    _imgVAvatarImage.layer.masksToBounds = YES;
    _imgVAvatarImage.layer.cornerRadius = 10.0;
    
    // 由于 xib 中对标签自适应宽度找不到合适的方式来控制，所以这里用代码编写；这里屏幕复用的 Cell 有几个，就会执行几次 awakeFromNib 方法
    _lblText = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 23.0, widthOfLabel, 42.0)];
    _lblText.numberOfLines = 2;
    _lblText.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:_lblText];
    [self sendSubviewToBack:_lblText]; // 把视图置于底层；避免遮住左右手势滑动出现的「实用按钮」
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAvatarImageStr:(NSString *)avatarImageStr {
    if (![_avatarImageStr isEqualToString:avatarImageStr]) {
        _avatarImageStr = [avatarImageStr copy];
        NSURL *avatarImageURL = [NSURL URLWithString:_avatarImageStr];
        // 图片缓存；使用 SDWebImage 框架：UIImageView+WebCache
        [_imgVAvatarImage sd_setImageWithURL:avatarImageURL
                            placeholderImage:placeholderImage];
    }
}

- (void)setName:(NSString *)name {
    _name = [name copy];
    _lblName.text = _name;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    _lblText.text = _text;
}

- (void)setCreatedAt:(NSDate *)createdAt {
    _createdAt = [createdAt copy];
    _lblCreatedAt.text = [DateHelper dateToString:_createdAt withFormat:nil];
}

- (void)setHaveLink:(BOOL)haveLink {
    _haveLink = haveLink;
    _imgVLink.hidden = !_haveLink;
}

@end
