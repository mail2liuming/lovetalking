//
//  ChannelDetails.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/2/24.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "ChannelDetails.h"
#import "UserInfo.h"

@implementation ChannelDetails

- (id)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.cid = [dict objectForKey:@"cid"];
        self.name = [dict objectForKey:@"name"];
        self.creator = [dict objectForKey:@"creator"];
        self.desc = [dict objectForKey:@"target_des"];
        self.loc = [dict objectForKey:@"target_loc"];
        self.followers = [[dict objectForKey:@"follow_user"] integerValue];
        
        self.userList = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray *array = [dict objectForKey:@"user_list"];
        for (NSDictionary *item in array) {
            UserInfo *info = [[UserInfo alloc] initWithDictionary:item];
            [self.userList addObject:info];
        }
    }
    
    return self;
}

@end
