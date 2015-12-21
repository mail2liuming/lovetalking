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

@implementation UserInfo

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.nickname forKey:NICKNAME];
    [encoder encodeObject:self.avatar forKey:AVATAR];
    [encoder encodeObject:self.gender forKey:GENDER];
    [encoder encodeObject:self.status forKey:STATUS];
    [encoder encodeObject:self.city forKey:CITY];
    [encoder encodeObject:self.province forKey:PROVINCE];
    [encoder encodeObject:self.smallAvtar forKey:SMALL_AVATAR];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super init])) {
        self.nickname = [decoder decodeObjectForKey:NICKNAME];
        self.avatar = [decoder decodeObjectForKey:AVATAR];
        self.gender = [decoder decodeObjectForKey:GENDER];
        self.status = [decoder decodeObjectForKey:STATUS];
        self.city = [decoder decodeObjectForKey:CITY];
        self.province = [decoder decodeObjectForKey:PROVINCE];
        self.smallAvtar = [decoder decodeObjectForKey:SMALL_AVATAR];
    }
    
    return self;
}

@end
