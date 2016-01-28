//
//  MessageViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageItemCell.h"
#import "MessageItem.h"
#import "UIImageView+WebCache.h"
#import "UserInfo.h"
#import "AFHTTPSessionManager.h"
#import "UserAccoutManager.h"

static NSString* const cellIdentifier = @"cell_id";

@implementation MessageViewController {
    
    UITableView *msgTableView;
    
    MBProgressHUD *progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新的车友";
    
    msgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                 style:UITableViewStylePlain];
    msgTableView.backgroundColor = [UIColor whiteColor];
    [msgTableView setSeparatorColor:[UIColor colorWithRed:225.0f/255 green:225.0f/255 blue:225.0f/255 alpha:1]];
    msgTableView.delegate = self;
    msgTableView.dataSource = self;
    [self.view addSubview:msgTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray == nil ? 0 : self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[MessageItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    MessageItem *message = [self.dataArray objectAtIndex:indexPath.row];
    UserInfo *info = message.userInfo;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:info.avatar]
                      placeholderImage:[UIImage imageNamed:@"ic_nav.png"]];
    
    NSString *msg = message.msg;
    NSString *tip = [NSString stringWithFormat:@"%@请求添加我为好友", info.nickname];
    if (msg && msg.length > 0) {
        tip = [NSString stringWithFormat:@"%@%@", info.nickname, msg];
    }
    
    cell.textLabel.text = tip;
    cell.button.tag = indexPath.row;
    [cell.button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [progress removeFromSuperview];
    progress = nil;
}

- (void)onButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    MessageItem *message = [self.dataArray objectAtIndex:button.tag];
    
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    progress.delegate = self;
    [progress show:YES];
    
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    UserInfo *userInfo = [accoutManager getUserInfo];
    NSString *sgid = userInfo.sgid;
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    NSString *url = [NSString stringWithFormat:@"http://m.icall.sogou.com/friend/1.0/dealinvite.html?sgid=%@&t=%@&friendid=%@&act=%d", sgid, timestamp, message.userInfo.userid, 1];
    
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
                    [self.delegate onUserAccepted];
                }
                tips = @"好友添加成功!";
                [self showToast:tips];
                [self performSelector:@selector(onAccepted) withObject:nil afterDelay:1.0];
            } else {
                [self showToast:@"好友添加失败，请稍后再试!"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [progress hide:YES];
        [self showToast:@"好友添加失败，请稍后再试!"];
    }];
}

- (void)onAccepted {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showToast:(NSString *)tips {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tips;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [msgTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
@end
