//
//  UserInfo.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/21.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "UserInfo.h"

#define NICKNAME     @"nickname"
#define AVATAR       @"avatar"
#define GENDER       @"gender"
#define STATUS       @"status"
#define CITY         @"city"
#define PROVINCE     @"province"
#define SMALL_AVATAR @"small_avatar"
#define SOGOU_ID     @"sgid"
#define USER_ID      @"user_id"
#define MID_AVARTAR  @"mid_avatar"

@implementation UserInfo

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.nickname forKey:NICKNAME];
    [encoder encodeObject:self.avatar forKey:AVATAR];
    [encoder encodeInteger:self.gender forKey:GENDER];
    [encoder encodeObject:self.status forKey:STATUS];
    [encoder encodeObject:self.city forKey:CITY];
    [encoder encodeObject:self.province forKey:PROVINCE];
    [encoder encodeObject:self.smallAvtar forKey:SMALL_AVATAR];
    [encoder encodeObject:self.sgid forKey:SOGOU_ID];
    [encoder encodeObject:self.userid forKey:USER_ID];
    [encoder encodeObject:self.middleAvatar forKey:MID_AVARTAR];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.nickname = [decoder decodeObjectForKey:NICKNAME];
        self.avatar = [decoder decodeObjectForKey:AVATAR];
        self.gender = [decoder decodeIntegerForKey:GENDER];
        self.status = [decoder decodeObjectForKey:STATUS];
        self.city = [decoder decodeObjectForKey:CITY];
        self.province = [decoder decodeObjectForKey:PROVINCE];
        self.smallAvtar = [decoder decodeObjectForKey:SMALL_AVATAR];
        self.sgid = [decoder decodeObjectForKey:SOGOU_ID];
        self.userid = [decoder decodeObjectForKey:USER_ID];
        self.middleAvatar = [decoder decodeObjectForKey:MID_AVARTAR];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.userid = [dict objectForKey:@"user_id"];
        self.nickname = [dict objectForKey:@"uniqname"];
        self.avatar = [dict objectForKey:@"avatarurl"];
        self.gender = [[dict objectForKey:@"gender"] integerValue];
        self.province = [dict objectForKey:@"province"];
        self.city = [dict objectForKey:@"city"];
        self.status = [dict objectForKey:@"subscribe"];
    }
    
    return self;
}

@end
