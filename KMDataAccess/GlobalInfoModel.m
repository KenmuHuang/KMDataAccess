//
//  GlobalInfoModel.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/10/4.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "GlobalInfoModel.h"
#import "DateHelper.h"

@implementation GlobalInfoModel

- (GlobalInfoModel *)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        // 这种方式在有 NSDate 数据类型的属性时，赋值操作的属性值都为字符串类型（不推荐在这种情况下使用），可以根据 NSLog(@"%@", [date class]); 看到是否是正确格式的 NSDate 数据类型
        //[self setValuesForKeysWithDictionary:dic];
        
        // http://stackoverflow.com/questions/14233153/nsdateformatter-stringfromdate-datefromstring-both-returning-nil
        id createdAt = dic[kCreatedAt];
        if (![createdAt isKindOfClass:[NSDate class]]) {
            createdAt = [DateHelper dateFromString:createdAt
                                        withFormat:@"yyyy-MM-dd HH:mm:ss z"];
        }
        
        // 推荐使用自己构造的方式
        return [self initWithAvatarImageStr:dic[kAvatarImageStr]
                                       name:dic[kName]
                                       text:dic[kText]
                                       link:dic[kLink]
                                  createdAt:createdAt
                                         ID:dic[kID]];
    }
    return self;
}

- (GlobalInfoModel *)initWithAvatarImageStr:(NSString *)avatarImageStr name:(NSString *)name text:(NSString *)text link:(NSString *)link createdAt:(NSDate *)createdAt ID:(NSNumber *)ID {
    if (self = [super init]) {
        _ID = ID;
        _avatarImageStr = avatarImageStr;
        _name = name;
        _text = text;
        _link = link;
        _createdAt = createdAt;
        _haveLink = _link.length > 0;
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    // 归档
    [aCoder encodeObject:_ID forKey:kID];
    [aCoder encodeObject:_avatarImageStr forKey:kAvatarImageStr];
    [aCoder encodeObject:_name forKey:kName];
    [aCoder encodeObject:_text forKey:kText];
    [aCoder encodeObject:_link forKey:kLink];
    [aCoder encodeObject:_createdAt forKey:kCreatedAt];
    [aCoder encodeBool:_haveLink forKey:kHaveLink];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        // 解档
        _ID = [aDecoder decodeObjectForKey:kID];
        _avatarImageStr = [aDecoder decodeObjectForKey:kAvatarImageStr];
        _name = [aDecoder decodeObjectForKey:kName];
        _text = [aDecoder decodeObjectForKey:kText];
        _link = [aDecoder decodeObjectForKey:kLink];
        _createdAt = [aDecoder decodeObjectForKey:kCreatedAt];
        _haveLink = [aDecoder decodeBoolForKey:kHaveLink];
    }
    return self;
}

@end
