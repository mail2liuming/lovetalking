//
// Created by Deng Hua on 13-11-11.
// Copyright (c) 2013 Sogou.com. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface SGAPNSStringHelper : NSObject


/**
 * 对输入的字符串进行MD5计算方法。
 */

+(NSString *)md5:(NSString *)originString;

/**
 * 解析URL参数的工具方法。
 */

+ (NSDictionary *)parseURLParams:(NSString *)query;


+ (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params;


+ (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle;

@end