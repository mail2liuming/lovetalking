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
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104953047" andDelegate:self];
    NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", nil];
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
        UserInfo *info = [[UserInfo alloc] init];
        
        NSDictionary *dict = response.jsonResponse;
        info.nickname = [dict objectForKey:@"nickname"];
        NSString *avatar = [dict objectForKey:@"figureurl_qq_2"];
        if (avatar == nil || avatar.length == 0) {
            avatar = [dict objectForKey:@"figureurl_qq_1"];
        }
        info.avatar = avatar;
        info.gender = [dict objectForKey:@"gender"];
        info.status = [dict objectForKey:@"msg"];
        info.city = [dict objectForKey:@"city"];
        info.province = [dict objectForKey:@"province"];
        info.smallAvtar = [dict objectForKey:@"figureurl"];
        
        [[UserAccoutManager sharedManager] setUserInfo:info];
        
        MainViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [self showAlertView:@"登录失败" withText:response.errorMsg];
    }
}

- (void)tencentDidLogin {
    NSString *token = tencentOAuth.accessToken;
    if (token && 0 != token) {
        [tencentOAuth getUserInfo];
    }
}

- (void)tencentDidNotNetWork {
    [self showAlertView:@"登录失败" withText:@"无网络联接"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
