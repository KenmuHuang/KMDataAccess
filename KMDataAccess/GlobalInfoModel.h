//
//  GlobalInfoModel.h
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/4.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalInfoModel : NSObject <NSCoding>
@property (strong, nonatomic) NSNumber *ID; ///< ID编号
@property (copy, nonatomic) NSString *avatarImageStr; ///< 图标图片地址
@property (copy, nonatomic) NSString *name; ///< 标题名称
@property (copy, nonatomic) NSString *text; ///< 内容
@property (copy, nonatomic) NSString *link; ///< 链接地址
@property (strong, nonatomic) NSDate *createdAt; ///< 创建时间
@property (assign, nonatomic, getter=isHaveLink) BOOL haveLink; ///< 是否存在链接地址

- (GlobalInfoModel *)initWithDictionary:(NSDictionary *)dic;
- (GlobalInfoModel *)initWithAvatarImageStr:(NSString *)avatarImageStr name:(NSString *)name text:(NSString *)text link:(NSString *)link createdAt:(NSDate *)createdAt ID:(NSNumber *)ID;
@end