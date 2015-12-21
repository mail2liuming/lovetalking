//
//  UserAccoutManager.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/21.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo;

@interface UserAccoutManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *dict;

+ (id)sharedManager;

- (BOOL)isLogin;

- (UserInfo *)getUserInfo;

- (void)setUserInfo:(UserInfo *)userInfo;

@end
