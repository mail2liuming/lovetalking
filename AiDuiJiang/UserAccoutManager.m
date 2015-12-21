//
//  UserAccoutManager.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/21.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "UserAccoutManager.h"
#import "UserInfo.h"

static UserAccoutManager *sharedInstance = nil;

@implementation UserAccoutManager


- (id)init {
    if ((self = [super init])) {
        [self loadUserInfoFromFile];
    }
    
    return self;
}

+ (id)sharedManager {
    return sharedInstance;
}

- (BOOL)isLogin {
    return [self.dict count] > 0;
}

- (UserInfo *)getUserInfo {
    return [self.dict objectForKey:@"user"];
}

- (void)setUserInfo:(UserInfo *)userInfo {
    [self.dict setObject:userInfo forKey:@"user"];
    [self saveUserInfoToFile];
}

+ (void)initialize {
    if (sharedInstance == nil) {
        sharedInstance = [[self alloc] init];
    }
}

- (void)saveUserInfoToFile {
    [NSKeyedArchiver archiveRootObject:self.dict toFile:[self getSavePath]];
}

- (void)loadUserInfoFromFile {
    self.dict = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getSavePath]];
    if (![self.dict isKindOfClass:[NSMutableDictionary class]]) {
        self.dict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
}

- (NSString *)getSavePath {
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"account.plist"];
}

@end
