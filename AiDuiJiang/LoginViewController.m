//
//  LoginViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/18.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+Color.h"
#import "UserInfo.h"
#import "UserAccoutManager.h"
#import "MainViewController.h"
#import "AFHTTPSessionManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "SGAHttpRequest.h"
#import "HomeViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    
    TencentOAuth *tencentOAuth;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.view.frame.size.width;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic.png"]];
    imageView.frame = CGRectMake((width - 250) / 2.f, 20 + 90, 250.f, 250.f);
    [self.view addSubview:imageView];
    
    UIImageView *slogan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slogan.png"]];
    slogan.frame = CGRectMake((width - 243.5f) / 2.f, imageView.frame.origin.y + imageView.frame.size.height + 65.f, 243.5f, 23.f);
    [self.view addSubview:slogan];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((width - 190) / 2.f,
                                                                  slogan.frame.origin.y + slogan.frame.size.height + 20.f, 190, 45)];
    [button setTitle:@"QQ登录" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.f];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:54.f / 255 green:152.f / 255 blue:16.f / 255 alpha:1.f]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:34.f / 255 green:130.f / 255 blue:0 alpha:1.f]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 23.f;
    button.clipsToBounds = YES;
    [self.view addSubview:button];
}

- (void)login {
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105032109" andDelegate:self];
    NSArray *permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    [tencentOAuth authorize:permissions inSafari:NO];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    [self showAlertView:@"登陆失败" withText:cancelled ? @"用户取消登录" : @"登录失败，请稍后再试"];
}

- (void)showAlertView:(NSString *)title withText:(NSString *)text {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:text
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       //
                                   }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"确定"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   //
                               }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getUserInfoResponse:(APIResponse *)response {
    if (URLREQUEST_SUCCEED == response.retCode
        && kOpenSDKErrorSuccess == response.detailRetCode) {
        UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
        if ([accoutManager isLogin]) {
            UserInfo *info = [accoutManager getUserInfo];
            NSDictionary *dict = response.jsonResponse;
            NSLog(@"##result %@", response.jsonResponse);
            
            info.nickname = [dict objectForKey:@"nickname"];
            NSString *avatar = [dict objectForKey:@"figureurl_qq_2"];
            if (avatar == nil || avatar.length == 0) {
                avatar = [dict objectForKey:@"figureurl_qq_1"];
            }
            info.avatar = avatar;
            info.status = [dict objectForKey:@"msg"];
            info.city = [dict objectForKey:@"city"];
            info.province = [dict objectForKey:@"province"];
            info.smallAvtar = [dict objectForKey:@"figureurl"];
            
            [[UserAccoutManager sharedManager] setUserInfo:info];
            
            MainViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    } else {
        [self showAlertView:@"登录失败" withText:response.errorMsg];
    }
}

- (void)tencentDidLogin {
    NSString *token = tencentOAuth.accessToken;
    
    NSTimeInterval timeInterval = [tencentOAuth.expirationDate timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970] + 1;
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)timeInterval];
    NSString *instance_id = [self UUID];
    NSNumber *clientId = @2029;
    NSString *thirdAppid = @"1105032109";
    
    NSString *codeString=[NSString stringWithFormat:@"access_token=%@&client_id=%@&expires_in=%@&instance_id=%@&isthird=%@&openid=%@&%@",
                          token, clientId, timeSp, instance_id, @"1", tencentOAuth.openId, @"94959ebd6f3b2962cab5bd70f497d858"];
    NSString *code=[self md5:codeString];
    
    NSDictionary *params = @{
                             @"access_token": token,
                             @"client_id":clientId,
                             @"expires_in":timeSp,
                             @"instance_id":instance_id,
                             @"isthird":@1,
                             @"openid": tencentOAuth.openId,
                             @"third_appid":thirdAppid,
                             @"code":code};
    
    NSString *url = @"https://account.sogou.com/connect/sso/afterauth/qq";
    [SGAHttpRequest sendRequestWithUrlStr:url
                                paramters:params
                               httpMethod:@"POST"
                              httpSuccess:^(NSDictionary *result) {
                                  NSDictionary *data = [result objectForKey:@"data"];
                                  NSString *sgid;
                                  if (data) {
                                      UserInfo *info = [[UserInfo alloc] init];
                                      info.nickname = [data objectForKey:@"uniqname"];
                                      info.avatar = [data objectForKey:@"large_avatar"];
                                      NSInteger sex = [[data objectForKey:@"gender"] integerValue];
                                      info.gender = sex == 1 ? 0 : 1;
                                      info.smallAvtar = [data objectForKey:@"tiny_avatar"];
                                      info.sgid = [data objectForKey:@"sgid"];
                                      info.userid = [data objectForKey:@"userid"];
                                      info.middleAvatar = [data objectForKey:@"mid_avatar"];
                                      sgid = info.sgid;
                                      
                                      [[UserAccoutManager sharedManager] setUserInfo:info];
                                  }
                                  
                                  NSInteger status = [[result objectForKey:@"status"] integerValue];
                                  if (status != 0) {
                                      NSString *msg = [result objectForKey:@"statusText"];
                                      [self showAlertView:@"登录失败" withText:msg];
                                  } else {
                                      [self checkSgid:sgid];
                                  }
                              } httpFail:^(NSError *error) {
                                  [self showAlertView:@"登录失败" withText:@"网络出错，请稍后再试"];
                              }];
}

- (void)checkSgid:(NSString *)sgid {
    NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
    
    NSString *url = [NSString stringWithFormat:@"http://m.icall.sogou.com/user/1.0/verifysogouid.html?sgid=%@&t=%f", sgid, timeNow];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            NSInteger errorNo = [[responseObject objectForKey:@"errno"] integerValue];
            if (errorNo == 0) {
                UserAccoutManager *accountManager = [UserAccoutManager sharedManager];
                UserInfo *userInfo = [accountManager getUserInfo];
                
                NSDictionary *data = [responseObject objectForKey:@"data"];
                userInfo.userid = [data objectForKey:@"user_id"];
                [accountManager setUserInfo:userInfo];
                
                HomeViewController *viewController = [[HomeViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
            } else {
                [self showAlertView:@"登录失败" withText:@"登陆失败，搜狗账号验证不通过"];}
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showAlertView:@"登录失败" withText:@"网络出错，请稍后再试"];
    }];
}

- (NSString *)md5:(NSString *)originString {
    const char *cStr = [originString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    if (cStr) {
        CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
        return [[NSString stringWithFormat:
                 @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                 result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                 ] lowercaseString];
    }
    else {
        return nil;
    }
}

- (NSString *)UUID{
    NSString *identifierNumber;
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"UUID"]) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef uuidstring = CFUUIDCreateString(NULL, uuid);
        
        identifierNumber = [NSString stringWithFormat:@"%@",uuidstring];
        
        [[NSUserDefaults standardUserDefaults] setObject:identifierNumber forKey:@"UUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        CFRelease(uuidstring);
        CFRelease(uuid);
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
    
}

- (void)tencentDidNotNetWork {
    [self showAlertView:@"登录失败" withText:@"无网络联接"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
