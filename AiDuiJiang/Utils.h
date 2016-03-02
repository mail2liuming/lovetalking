//
//  Utils.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/3/2.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (id)sharedUtils;

- (NSString *)getUrl:(NSString *)url params:(NSMutableDictionary *)params;

@end
