//
//  UserInfo.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/21.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, strong) NSString *gender;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *city;

@property (nonatomic, strong) NSString *province;

@property (nonatomic, strong) NSString *smallAvtar;

- (void)encodeWithCoder:(NSCoder *)encoder;

- (id)initWithCoder:(NSCoder *)decoder;

@end
