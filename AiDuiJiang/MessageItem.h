//
//  MessageItem.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

@interface MessageItem : NSObject

@property (nonatomic, assign) NSInteger inviteId;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) UserInfo *userInfo;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
