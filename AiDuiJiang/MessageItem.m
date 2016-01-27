//
//  MessageItem.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "MessageItem.h"

@implementation MessageItem

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.inviteId = [[dict objectForKey:@"invite_id"] integerValue];
        self.status = [[dict objectForKey:@"status"] integerValue];
        self.msg = [dict objectForKey:@"msg"];
        
        NSDictionary *userData = [dict objectForKey:@"user"];
        UserInfo *userInfo = [[UserInfo alloc] initWithDictionary:userData];
        self.userInfo = userInfo;
    }
    
    return self;
}

@end
