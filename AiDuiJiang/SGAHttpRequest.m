//
//  SGHttpRequest.m
//  HttpRequest
//
//  Created by hehe on 3/4/14.
//  Copyright (c) 2014 Sogou-inc. All rights reserved.
//

#import "SGAHttpRequest.h"
#import "SGAPNSStringHelper.h"

@interface SGAHttpRequest (){
    
    NSString *sgid;
}

@end

// helper function: get the string form of any object
static NSString *toString(id object) {
	return [NSString stringWithFormat: @"%@", object];
}

// helper function: get the url encoded string form of any object
static NSString *urlEncode(id object) {
	NSString *string = toString(object);
	return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ];
}


@implementation SGAHttpRequest

+ (void)sendRequestWithUrlStr:(NSString *)urlStr
                    paramters:(NSDictionary *)params
                   httpMethod:(NSString *)httpMethod
                  httpSuccess:(void (^)(NSDictionary *))httpSuccess
                     httpFail:(void (^)(NSError *))httpFail
{
    SGAHttpRequest *httpRequestDelegate = [[SGAHttpRequest alloc]init];
    httpRequestDelegate.httpSuccessBlock = httpSuccess;
    httpRequestDelegate.httpFailBlock = httpFail;

    NSURL *url;
    NSURLConnection *conn;
    
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in params) {
        id value = [params objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", urlEncode(key), urlEncode(value)];
        [parts addObject: part];
    }
    
    if ([[httpMethod uppercaseString] isEqualToString:@"POST"]) {
        
        url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        
        NSString *urlEncodedString=[parts componentsJoinedByString: @"&"];
        NSData *postData =[urlEncodedString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postData];
        [request setHTTPMethod:@"POST"];
        // cinfo
        [request setValue: @"platform=ios" forHTTPHeaderField:@"cinfo"];
        conn = [[NSURLConnection alloc] initWithRequest:request delegate:httpRequestDelegate];
        
    }
    else if ([[httpMethod uppercaseString] isEqualToString:@"GET"]){
        
        NSString *query = [parts componentsJoinedByString:@"&"];
        NSString *requestStr=[NSString stringWithFormat:@"%@?%@", urlStr, query];
        url = [NSURL URLWithString:requestStr];
        NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url];
        [theRequest setValue: @"platform=ios" forHTTPHeaderField:@"cinfo"];
        conn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:httpRequestDelegate];
        
    }    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
//    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//    SGALog(@"HeaderFields:%@",[res allHeaderFields]);
//    SGALog(@"HttpStatusCode:%d",[res statusCode]);
    if(!self.resultData){
        self.resultData = [[NSMutableData alloc] init];
    }else{
        [self.resultData setLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

    [self.resultData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.resultData) {
        NSError *error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:self.resultData options:NSJSONReadingMutableLeaves error:&error];
        
        NSString *result = [[NSString alloc] initWithData:self.resultData  encoding:NSUTF8StringEncoding];
        
        if (resultDic) {
            if (self.httpSuccessBlock) {
                self.httpSuccessBlock(resultDic);
            }
        }else{
            if (self.httpFailBlock) {
                self.httpFailBlock(error);
            }
        }

    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    if (self.httpFailBlock) {
        self.httpFailBlock(error);
    }
}


#pragma mark -服务器端单项HTTPS 验证，iOS 客户端忽略证书验证。

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    

    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }else{
        [[challenge sender]cancelAuthenticationChallenge:challenge];
    }
    
}


@end
