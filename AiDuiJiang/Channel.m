//
//  Channel.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/2/22.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "Channel.h"

@implementation Channel

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.cid = [dict objectForKey:@"cid"];
        self.name = [dict objectForKey:@"name"];
        self.creator = [dict objectForKey:@"creator"];
        self.desc = [dict objectForKey:@"target_des"];
        self.loc = [dict objectForKey:@"target_loc"];
        self.followers = [[dict objectForKey:@"follow_user"] integerValue];
        self.icons = [dict objectForKey:@"icons"];
    }
    
    return self;
}

@end
