//
//  Utils.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/3/2.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "Utils.h"
#import "UserAccoutManager.h"
#import "UserInfo.h"

@implementation Utils

+ (id)sharedUtils {
    static Utils *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        //
    }
    
    return self;
}

- (NSString *)getUrl:(NSString *)url params:(NSMutableDictionary *)params {
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    UserInfo *userInfo = [accoutManager getUserInfo];
    NSString *sgid = userInfo.sgid;
    NSNumber *timeNumber = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    NSString *timestamp = [NSString stringWithFormat:@"%llu", [timeNumber longLongValue]];
    
    if (params == nil) {
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sgid, @"sgid", timestamp, @"t", nil];
    } else {
        [params setValue:sgid forKey:@"sgid"];
        [params setValue:timestamp forKey:@"t"];
    }
    
    NSString *paramsText = @"";
    for (NSString *key in params) {
        NSString *value = [params objectForKey:key];
        paramsText = [paramsText stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value]];
    }
    
    paramsText = [paramsText substringFromIndex:1];
    
    url = [url stringByAppendingString:paramsText];
    
    return url;
}

@end
