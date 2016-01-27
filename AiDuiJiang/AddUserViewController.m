//
//  AddUserViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "AddUserViewController.h"
#import "UserAccoutManager.h"
#import "AFHTTPSessionManager.h"
#import "UserInfo.h"

#define TAG_WECHAT    1001
#define TAG_QQ        1002
#define TAG_CONTACTS  1003

@implementation AddUserViewController {
    
    UITextField *searchField;
    MBProgressHUD *progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加车友";
    
    CGFloat width = self.view.frame.size.width;
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 76.4f, width, 0.6f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    
    UIView *view = [[UIView alloc] init];
    [view.layer addSublayer:border];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 64, width, 77.f);
    [self.view addSubview:view];
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, (77.f - 37.f) / 2.f, width - 2 * 10.f, 37)];
    
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.backgroundColor = [UIColor clearColor];
    searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchField.textColor = [UIColor colorWithRed:109.f / 255 green:176.f / 255 blue:79.f / 255 alpha:1.f];
    searchField.font = [UIFont systemFontOfSize:16.f];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.delegate = self;
    searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchField.leftView = [self getPaddingView];
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.layer.borderWidth = 1;
    searchField.layer.cornerRadius = 19.f;
    searchField.placeholder = @"请输入要添加车友的对讲号";
    searchField.layer.borderColor = [[UIColor colorWithRed:54.0f/255 green:152.0f/255 blue:14.0f/255 alpha:1.0f] CGColor];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 64.f + 77.f, width, 20.f)];
    grayView.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1.0];
    [self.view addSubview:grayView];
    
    [view addSubview:searchField];
    
    NSArray *images = @[@"icon_weixin@2x.png", @"icon_qq@2x.png", @"icon_mob@2x.png"];
    NSArray *titles = @[@"添加微信好友", @"添加QQ好友", @"添加手机联系人"];
    for (NSInteger i = 0; i < images.count; i++) {
        [self appendItemView:[images objectAtIndex:i] withTitle:[titles objectAtIndex:i] atIndex:i];
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [progress removeFromSuperview];
    progress = nil;
}

- (void)showToast:(NSString *)tips
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tips;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [searchField resignFirstResponder];
    
    NSString *key = searchField.text;
    if (!key && key.length == 0) {
        return NO;
    }
    
    [self addUser:key];
    return NO;
}

- (void)addUser:(NSString *)userId {
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    progress.delegate = self;
    [progress show:YES];
    
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    UserInfo *userInfo = [accoutManager getUserInfo];
    NSString *sgid = userInfo.sgid;
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    NSString *msg = [[NSString stringWithFormat:@"%@请求添加您为好友", userInfo.nickname] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:@"http://m.icall.sogou.com/friend/1.0/invite.html?sgid=%@&t=%@&friendid=%@&msg=%@", sgid, timestamp, userId, msg];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [progress hide:YES];
        
        if (responseObject) {
            NSInteger code = [[responseObject objectForKey:@"errno"] integerValue];
            NSString *tips;
            if (code == 0) {
                tips = @"已发送好友请求";
                [self showToast:tips];
                [self performSelector:@selector(finishAddUser) withObject:nil afterDelay:1.0];
            } else {
                tips = [responseObject objectForKey:@"errmsg"];
                [self showToast:tips];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [progress hide:YES];
        [self showToast:@"好友添加失败，请稍后再试!"];
    }];
}

- (void)finishAddUser {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)appendItemView:(NSString *)image withTitle:(NSString *)title atIndex:(NSInteger)i {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64.f + 77.f + 20.f + i * 55.f, self.view.frame.size.width, 55.f)];
    view.tag = TAG_WECHAT + i;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemClicked:)];
    [view addGestureRecognizer:singleTap];
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 54.f, self.view.frame.size.width, 0.6f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    [view.layer addSublayer:border];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    imageView.frame = CGRectMake(18.f, 19.f / 2, 36.f, 36.f);
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:17.f];
    [label sizeToFit];
    label.frame = CGRectMake(18.f + 36.f + 18.f, 55.f / 2 - label.frame.size.height / 2, label.frame.size.width, label.frame.size.height);
    [view addSubview:label];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go@2x.png"]];
    arrowView.frame = CGRectMake(self.view.frame.size.width - 15 - 8, (55.f - 14.f) / 2, 8.f, 14.f);
    [view addSubview:arrowView];
    
    [self.view addSubview:view];
}

- (void)onItemClicked:(id)sender {
}

- (UIView *)getPaddingView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20.f + 20.f, 37.f)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_search.png"]];
    imageView.frame = CGRectMake(10, (37.f - 20.f) / 2, 20.f, 20.f);
    [view addSubview:imageView];
    
    return view;
}

@end
