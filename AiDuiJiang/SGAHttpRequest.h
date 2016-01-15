//
//  SGHttpRequest.h
//  HttpRequest
//
//  Created by hehe on 3/4/14.
//  Copyright (c) 2014 Sogou-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGAHttpRequest : NSObject<NSURLConnectionDataDelegate>

@property NSMutableData *resultData;
@property(nonatomic,strong) void (^httpSuccessBlock)(NSDictionary *result);
@property(nonatomic,strong) void (^httpFailBlock)(NSError *error);
/**
 *  网络请求
 *
 *  @param urlStr     baseUrlString
 *  @param params     字典类型的参数
 *  @param httpMethod GET或者POST方法
 *  @param block      回调block
 */
+ (void)sendRequestWithUrlStr:(NSString *)urlStr
                    paramters:(NSDictionary *)params
                   httpMethod:(NSString *)httpMethod
                  httpSuccess:(void (^)(NSDictionary *result))httpSuccess
                     httpFail:(void (^)(NSError *error))httpFail;


@end
