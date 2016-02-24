//
//  ChannelDetails.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/2/24.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelDetails : NSObject

@property (nonatomic, strong) NSString *cid;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *creator;

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) NSString *loc;

@property (nonatomic, assign) NSInteger followers;

@property (nonatomic, strong) NSMutableArray *userList;

- (id)initWithDict:(NSDictionary *)dict;

@end
