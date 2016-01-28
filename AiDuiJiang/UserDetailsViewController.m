//
//  UserDetailsViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "AFHTTPSessionManager.h"
#import "UserAccoutManager.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Color.h"

#define TAG_CAR          1001
#define TAG_ROUTE        1002
#define TAG_FROM_SEARCH  233
#define TAG_FROM_LIST    234

@implementation UserDetailsViewController {
    
    MBProgressHUD *progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.userItemInfo.nickname;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"more@2x.png"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 21, 21);
    [rightButton addTarget:self action:@selector(onRightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    CGFloat width = self.view.frame.size.width;
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 99.4f, width, 0.6f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;

    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, width, 100.f)];
    [infoView.layer addSublayer:border];
    [self.view addSubview:infoView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(23.f, 25.f, 50.f, 50.f)];
    imageView.layer.cornerRadius = 25.f;
    imageView.layer.masksToBounds = YES;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.userItemInfo.avatar]
                 placeholderImage:[UIImage imageNamed:@"ic_nav.png"]];
    [infoView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.text = self.userItemInfo.nickname;
    nameLabel.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
    nameLabel.font = [UIFont systemFontOfSize:17.f];
    [nameLabel sizeToFit];
    CGSize size = nameLabel.frame.size;
    nameLabel.frame = CGRectMake(23.f * 2 + 50.f, 18.f, size.width, size.height);
    [infoView addSubview:nameLabel];
    
    UIImageView *sexIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.userItemInfo.gender == 1
                                                               ? @"male@2x.png" : @"femail@2x.png"]];
    sexIcon.frame = CGRectMake(nameLabel.frame.origin.x + size.width + 4, 20.f, 12.f, 17.f);
    [infoView addSubview:sexIcon];
    
    UILabel *talkNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    talkNumLabel.text = [NSString stringWithFormat:@"对讲号: %@", self.userItemInfo.userid];
    talkNumLabel.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
    talkNumLabel.font = [UIFont systemFontOfSize:13.f];
    [talkNumLabel sizeToFit];
    CGFloat h = talkNumLabel.frame.size.height;
    talkNumLabel.frame = CGRectMake(18.f + 50.f + 24.f, 90.f - h - 18.f, talkNumLabel.frame.size.width, h);
    [infoView addSubview:talkNumLabel];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 90.f + 64.f, self.view.frame.size.width, 20.f)];
    grayView.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1.0];
    [self.view addSubview:grayView];
    
    NSArray *titles = @[@"地区", @"个性签名", @"座驾", @"足迹"];
    NSString *city = self.userItemInfo.city;
    NSString *status = self.userItemInfo.status;
    NSArray *values = @[city && city.length > 0 ? [NSString stringWithFormat:@"%@, %@", self.userItemInfo.province, city] : @"未设置",
                        status && status.length > 0 ? status : @"未设置",
                        @"未设置", @"未设置"];
    for (NSInteger i = 0; i < titles.count; i++) {
        [self appendItemView:[titles objectAtIndex:i] withText:[values objectAtIndex:i] atIndex:i];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, self.view.frame.size.height - 54.f, width, 54.f);
    NSString *text = self.userInfoType == TAG_FROM_LIST ? @"开始对讲" : @"加好友";
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:62.f / 255.f green:193.f / 255.f blue:10.f / 255.f alpha:1.0f]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onButtonClicked {
    if (self.userInfoType == TAG_FROM_SEARCH) {
        [self addUser];
    }
}

- (void)addUser {
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    progress.delegate = self;
    [progress show:YES];
    
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    UserInfo *userInfo = [accoutManager getUserInfo];
    NSString *sgid = userInfo.sgid;
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    NSString *msg = [[NSString stringWithFormat:@"%@请求添加您为好友", userInfo.nickname] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:@"http://m.icall.sogou.com/friend/1.0/invite.html?sgid=%@&t=%@&friendid=%@&msg=%@", sgid, timestamp, self.userItemInfo.userid, msg];
    
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

- (void)showToast:(NSString *)tips
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tips;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [progress removeFromSuperview];
    progress = nil;
}

- (void)deleteUser {
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    progress.delegate = self;
    [progress show:YES];
    
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    UserInfo *userInfo = [accoutManager getUserInfo];
    NSString *sgid = userInfo.sgid;
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    
    NSString *url = [NSString stringWithFormat:@"http://m.icall.sogou.com/friend/1.0/del.html?sgid=%@&t=%@&friendid=%@", sgid, timestamp, self.userItemInfo.userid];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [progress hide:YES];
        
        if (responseObject) {
            NSInteger code = [[responseObject objectForKey:@"errno"] integerValue];
            NSString *tips;
            if (code == 0) {
                if (self.delegate) {
                    [self.delegate onUserDeleted];
                }
                tips = @"好友已删除";
                [self showToast:tips];
                [self performSelector:@selector(userDeleteFinished) withObject:nil afterDelay:1.0];
            } else {
                [self showToast:@"好友删除失败，请稍后再试!"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [progress hide:YES];
        [self showToast:@"好友删除失败，请稍后再试!"];
    }];
}

- (void)userDeleteFinished {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRightButtonClicked {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除车友?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        [self deleteUser];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)appendItemView:(NSString *)title withText:(NSString *)text atIndex:(NSInteger)i {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 120.f + 64.f + i * 55.f, self.view.frame.size.width, 55.f)];
    if (i == 2 || i == 3) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemClicked:)];
        [view addGestureRecognizer:singleTap];
        view.tag = i == 2 ? TAG_CAR : TAG_ROUTE;
    }
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 54.f, self.view.frame.size.width, 0.6f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    [view.layer addSublayer:border];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:17.f];
    [label sizeToFit];
    CGSize size = label.frame.size;
    label.frame = CGRectMake(18.f, (55.f - size.height) / 2, size.width, size.height);
    [view addSubview:label];
    
    if (i == 2 || i == 3) {
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go@2x.png"]];
        arrowView.frame = CGRectMake(self.view.frame.size.width - 14 - 15, (55.f - 14.f) / 2, 8.f, 14.f);
        [view addSubview:arrowView];
    }
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.text = text;
    textLabel.textColor = [UIColor colorWithRed:179.f/255.f green:179.f/255.f blue:179.f/255.f alpha:1.f];
    textLabel.font = [UIFont systemFontOfSize:14.f];
    [textLabel sizeToFit];
    size = textLabel.frame.size;
    textLabel.frame = CGRectMake(95.f, (55.f - size.height) / 2.f, size.width, size.height);
    [view addSubview:textLabel];
    
    [self.view addSubview:view];
}

- (void)onItemClicked:(id)sender {
    
}
@end
