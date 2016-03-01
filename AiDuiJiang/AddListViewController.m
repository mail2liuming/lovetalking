//
//  AddListViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/2/29.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "AddListViewController.h"
#import "UserTableViewCell.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"
#import "UserAccoutManager.h"
#import "AFHTTPSessionManager.h"

static NSString* const cellIdentifier = @"cell_id";


@interface AddListViewController ()

@end

@implementation AddListViewController {
    
    NSMutableArray *userList;
    
    NSMutableSet *userIdSet;
    
    MBProgressHUD *progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1.0f];
    self.title = @"发起对讲";
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44.f, 44.f)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0f] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    userList = [[NSMutableArray alloc] initWithCapacity:0];
    userIdSet = [[NSMutableSet alloc] initWithCapacity:0];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:225.0f/255 green:225.0f/255 blue:225.0f/255 alpha:1]];
    
    [self request];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [progress removeFromSuperview];
    progress = nil;
}

- (void)inviteUser {
    [self showProgress];
    
    NSString *userIds = @"";
    for (NSString *userId in userIdSet) {
        userIds = [userIds stringByAppendingString:[NSString stringWithFormat:@"%@,", userId]];
    }
    
    userIds = [userIds substringToIndex:[userIds length] - 1];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.channelId, @"cid", userIds, @"users", nil];
    NSString *url = [self getUrl:@"http://m.icall.sogou.com/channel/1.0/invite.html?" withParams:params];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        progress.hidden = YES;
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[responseObject objectForKey:@"errno"] integerValue];
            if (code == 0) {
                if (self.delegate) {
                    [self.delegate onUserAdded];
                }
                [self showToast:@"添加成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showToast:@"添加失败，请稍后再试"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        progress.hidden = YES;
        [self showToast:@"添加失败，请稍后再试"];
    }];
}

- (void)showProgress {
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    progress.delegate = self;
    [progress show:YES];
}

- (void)showToast:(NSString *)tips {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tips;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)onRightButtonClicked:(id)sender {
    NSInteger count = [userIdSet count];
    if (count == 0) {
        [self showToast:@"请选择好友"];
        return;
    }
    
    [self inviteUser];
}

- (void)request {
    NSString *url = [self getUrl:@"http://m.icall.sogou.com/friend/1.0/myfriend.html?" withParams:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            [userList removeAllObjects];
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSDictionary *data = [dict objectForKey:@"data"];
            NSArray *array = [data objectForKey:@"list"];
            
            for (NSDictionary *item in array) {
                UserInfo *user = [[UserInfo alloc] initWithDictionary:item];
                [userList addObject:user];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [userList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    UserTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    cell.button.highlighted = !cell.button.highlighted;
    
    UserInfo *userInfo = [userList objectAtIndex:indexPath.row];
    NSString *userId = userInfo.userid;
    if ([userIdSet containsObject:userId]) {
        [userIdSet removeObject:userId];
    } else {
        [userIdSet addObject:userId];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UserInfo *info = [userList objectAtIndex:indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:info.avatar]
                      placeholderImage:[UIImage imageNamed:@"ic_nav.png"]];
    cell.textLabel.text = info.nickname;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSString *)getUrl:(NSString *)url withParams:(NSMutableDictionary *)params {
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    UserInfo *userInfo = [accoutManager getUserInfo];
    NSString *sgid = userInfo.sgid;
    NSNumber *timeNumber = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    NSString *timestamp = [NSString stringWithFormat:@"%llu", [timeNumber longLongValue]];
    
    if (params == nil) {
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sgid, @"sgid", timestamp, @"t", nil];
    } else {
        [params setValue:sgid forKey:@"sgid"];
        [params setValue:timestamp forKey:@"t"];
    }
    
    NSString *paramsText = @"";
    for (NSString *key in params) {
        NSString *value = [params objectForKey:key];
        paramsText = [paramsText stringByAppendingString:[NSString stringWithFormat:@"&%@=%@", key, value]];
    }
    
    paramsText = [paramsText substringFromIndex:1];
    
    url = [url stringByAppendingString:paramsText];
    
    return url;
}

@end
