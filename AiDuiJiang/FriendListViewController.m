//
//  FriendListViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "FriendListViewController.h"
#import "AddUserViewController.h"
#import "MessageViewController.h"
#import "UserAccoutManager.h"
#import "UserInfo.h"
#import "AFHTTPSessionManager.h"
#import "UserItemCell.h"
#import "UIImageView+WebCache.h"
#import "MessageItem.h"
#import "UserDetailsViewController.h"

static NSString* const cellIdentifier = @"cell_id";

@implementation FriendListViewController {
    
    UITableView *userTableView;
    
    NSMutableArray *dataArray;
    
    NSMutableArray *messageList;
    
    UILabel *countLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242.f / 255.f green:242.f / 255.f blue:242.f / 255.f alpha:1.0f];
    self.title = @"我的车友";
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44.f, 44.f)];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0f] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    messageList = [[NSMutableArray alloc] initWithCapacity:0];
    
    CGFloat width = self.view.frame.size.width;
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 76.4f, width, 0.6f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64.f, width, 77.f)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkMessage:)];
    [view addGestureRecognizer:singleTap];
    view.backgroundColor = [UIColor whiteColor];
    [view.layer addSublayer:border];
    [self.view addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_newfriends@2x.png"]];
    imageView.frame = CGRectMake(18.f, (77.f - 36.f) / 2.f, 36.f, 36.f);
    [view addSubview:imageView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    textLabel.text = @"新的车友";
    textLabel.font = [UIFont systemFontOfSize:17.f];
    textLabel.textColor = [UIColor colorWithRed:54.f / 255.0f green:152.f / 255.0f blue:14.0f / 255.0f alpha:1.0f];
    [textLabel sizeToFit];
    CGSize size = textLabel.frame.size;
    textLabel.frame = CGRectMake(18.f * 2 + 36.f, (77.f - size.height) / 2.f, size.width, size.height);
    [view addSubview:textLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go@2x.png"]];
    arrowView.frame = CGRectMake(self.view.frame.size.width - 14 - 8, (77.f - 14.f) / 2, 8.f, 14.f);
    [view addSubview:arrowView];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 8.f * 2 - 24.f - 14.f, (77.f - 24.f) / 2.f, 24.f, 24.f)];
    countLabel.backgroundColor = [UIColor colorWithRed:240.f / 255.0f green:8.0f / 255.f blue:68.f / 255.0f alpha:1.0f];
    countLabel.font = [UIFont systemFontOfSize:15.f];
    countLabel.textColor = [UIColor whiteColor];
    countLabel.layer.cornerRadius = 12.f;
    countLabel.layer.masksToBounds = YES;
    countLabel.hidden = YES;
    countLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:countLabel];
    
    CGFloat y = view.frame.origin.y + view.frame.size.height + 20;
    userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, width, self.view.frame.size.height - y)
                                                 style:UITableViewStylePlain];
    userTableView.backgroundColor = [UIColor whiteColor];
    [userTableView setSeparatorColor:[UIColor colorWithRed:225.0f/255 green:225.0f/255 blue:225.0f/255 alpha:1]];
    userTableView.delegate = self;
    userTableView.dataSource = self;
    [self.view addSubview:userTableView];
    
    [self requestFriendsMessage];
    [self requestUserList];
}

- (void)requestUserList {
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    UserInfo *userInfo = [accoutManager getUserInfo];
    NSString *sgid = userInfo.sgid;
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    
    NSString *url = [NSString stringWithFormat:@"http://m.icall.sogou.com/friend/1.0/myfriend.html?sgid=%@&t=%@", sgid, timestamp];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSDictionary *data = [dict objectForKey:@"data"];
            NSArray *array = [data objectForKey:@"list"];
            
            for (NSDictionary *item in array) {
                UserInfo *user = [[UserInfo alloc] initWithDictionary:item];
                [dataArray addObject:user];
            }
            [userTableView reloadData];
       }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)requestFriendsMessage {
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    UserInfo *userInfo = [accoutManager getUserInfo];
    NSString *sgid = userInfo.sgid;
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    
    NSString *url = [NSString stringWithFormat:@"http://m.icall.sogou.com/friend/1.0/myinvite.html?sgid=%@&t=%@", sgid, timestamp];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSArray *array = [dict objectForKey:@"data"];
            for (NSDictionary *item in array) {
                MessageItem *message = [[MessageItem alloc] initWithDictionary:item];
                [messageList addObject:message];
            }
            
            NSInteger count = [messageList count];
            if (count > 0) {
                countLabel.text = [NSString stringWithFormat:@"%ld", (long)count];
                countLabel.hidden = NO;
            } else {
                countLabel.hidden = YES;
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [userTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserDetailsViewController *viewController = [[UserDetailsViewController alloc] init];
    viewController.userItemInfo = [dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UserItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UserInfo *info = [dataArray objectAtIndex:indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:info.avatar]
                      placeholderImage:[UIImage imageNamed:@"ic_nav.png"]];
    cell.textLabel.text = info.nickname;
    
    return cell;
}

- (void)addFriends {
    AddUserViewController *viewController = [[AddUserViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)checkMessage:(id)sender {
    MessageViewController *viewController = [[MessageViewController alloc] init];
    viewController.dataArray = messageList;
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
