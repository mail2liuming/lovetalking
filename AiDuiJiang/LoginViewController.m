//
//  LoginViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/18.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+Color.h"

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
}

- (void)tencentDidLogin {
    NSLog(@"login success");
}

- (void)tencentDidNotNetWork {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
