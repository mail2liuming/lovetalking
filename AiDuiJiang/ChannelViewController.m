//
//  ChannelViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/10.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "ChannelViewController.h"
#import "DestinationViewController.h"
#import "SearchItem.h"
#import "UserAccoutManager.h"
#import "UserInfo.h"
#import "AFHTTPSessionManager.h"
#import "ChannelDetails.h"
#import "UIImageView+WebCache.h"
#import "InfoEditViewController.h"

#define TAG_NAME        100
#define TAG_DESTINATION 101
#define TAG_DEST_LABEL  102
#define TAG_NAME_LABEL  103

@interface ChannelViewController ()

@end

@implementation ChannelViewController {
    ChannelDetails *channelDetails;
    
    UIView *userGroupView;
    
    UIView *itemGroupView;
    
    NSMutableArray *userList;
    
    MBProgressHUD *progress;
    
    CLLocationManager *locationManager;
    
    SearchItem *searchItem;
    
    double lat, lng;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1.0f];
    self.title = [NSString stringWithFormat:@"%@（%ld人）", self.channel.name, (long)self.channel.followers];
    
    userGroupView = [[UIView alloc] initWithFrame:CGRectZero];
    userGroupView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:userGroupView];
    
    itemGroupView = [[UIView alloc] initWithFrame:CGRectZero];
    itemGroupView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:itemGroupView];
    
    CALayer *borderTop = [CALayer layer];
    borderTop.frame = CGRectMake(0, 0, self.view.frame.size.width, 1.f);
    borderTop.backgroundColor = [UIColor colorWithRed:255.f / 255 green:149.f / 255 blue:78.f / 255 alpha:1.0f].CGColor;
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton.layer addSublayer:borderTop];
    [exitButton setTitle:@"退出频道" forState:UIControlStateNormal];
    exitButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitButton setBackgroundColor:[UIColor colorWithRed:235.f / 255 green:98.f / 255 blue:24.f / 255 alpha:1]];
    exitButton.frame = CGRectMake(0, self.view.frame.size.height - 54.f, self.view.frame.size.width, 54.f);
    [self.view addSubview:exitButton];
    
    userList = [[NSMutableArray alloc] initWithCapacity:0];
    [self request];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 50;
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    if (location) {
        lat = location.coordinate.latitude;
        lng = location.coordinate.longitude;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (nil == locationManager) {
        [locationManager stopUpdatingLocation];
        locationManager = nil;
    }
}

- (void)request {
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    UserInfo *userInfo = [accoutManager getUserInfo];
    NSString *sgid = userInfo.sgid;
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    
    NSString *url = [NSString stringWithFormat:@"http://m.icall.sogou.com/channel/1.0/detail.html?sgid=%@&t=%@&cid=%@", sgid, timestamp, self.channel.cid];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            [userList removeAllObjects];
            
            channelDetails = [[ChannelDetails alloc] initWithDict:[responseObject objectForKey:@"data"]];
            NSMutableArray *array = channelDetails.userList;
            for (UserInfo *info in array) {
                [userList addObject:info];
            }
            
            UserInfo *addInfo = [[UserInfo alloc] init];
            addInfo.userid = @"add";
            [userList addObject:addInfo];
            
            UserInfo *deleteInfo = [[UserInfo alloc] init];
            deleteInfo.userid = @"delete";
            [userList addObject:deleteInfo];
            
            [self setupView];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [progress removeFromSuperview];
    progress = nil;
}

- (void)showToast:(NSString *)tips {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = tips;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)setChannelName:(NSString *)name {
    [self showProgress];
    
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    UserInfo *userInfo = [accoutManager getUserInfo];
    NSString *sgid = userInfo.sgid;
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    
    NSString *url = [NSString stringWithFormat:@"http://m.icall.sogou.com/channel/1.0/name.html?sgid=%@&t=%@&cid=%@&name=%@",
                     sgid, timestamp, self.channel.cid, [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[responseObject objectForKey:@"errno"] integerValue];
            [progress hide:YES];

            [self showToast:code == 0 ? @"修改成功" : @"修改失败，请稍后再试"];
            
            if (code == 0 && self.infoChangeDelegate) {
                [self.infoChangeDelegate onChannelInfoChanged];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [progress hide:YES];
        [self showToast:@"修改失败，请稍后再试"];
    }];
}

- (void)setDestination:(NSString *)destination {
    [self showProgress];
    
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    UserInfo *userInfo = [accoutManager getUserInfo];
    NSString *sgid = userInfo.sgid;
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
    
    NSString *loc = [NSString stringWithFormat:@"%f,%f", lat, lng];
    NSString *url = [NSString stringWithFormat:@"http://m.icall.sogou.com/channel/1.0/location.html?sgid=%@&t=%@&cid=%@&des=%@&loc=%@",
                     sgid, timestamp, self.channel.cid, [destination stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], loc];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[responseObject objectForKey:@"errno"] integerValue];
            [progress hide:YES];
            
            [self showToast:code == 0 ? @"修改成功" : @"修改失败，请稍后再试"];
            
            if (self.delegate) {
                [self.delegate onTargetSet:searchItem];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [progress hide:YES];
        [self showToast:@"修改失败，请稍后再试"];
        
        if (self.delegate) {
            [self.delegate onTargetSet:searchItem];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)showProgress {
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    progress.delegate = self;
    [progress show:YES];
}

- (void)setupView {
    NSInteger count = userList.count;
    
    NSInteger columns = 4;
    NSInteger row = count / columns;
    if (count % columns != 0) {
        row += 1;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"测试";
    label.font = [UIFont systemFontOfSize:14.f];
    [label sizeToFit];
    CGSize size = label.frame.size;
    
    CGFloat width = self.view.frame.size.width / columns;
    CGFloat height = 37.f + 15.f + size.height + 30.f;
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, height * row + 25 - 0.5f, self.view.frame.size.width, 0.5f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    
    userGroupView.frame = CGRectMake(0, 64.f, self.view.frame.size.width, height * row + 25.f);
    [userGroupView.layer addSublayer:border];
    
    for (UIView *subView in userGroupView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat x, y;
    for (NSInteger i = 0; i < row; i++) {
        for (NSInteger j = 0; j < (i == row - 1 ? count - (row - 1) * columns : columns); j++) {
            x = j * width;
            y = i * height;
            NSInteger index = i * columns + j;
            UIView *cellView = [self getCellView:[userList objectAtIndex:index]];
            cellView.frame = CGRectMake(x, y, width, height);
            [userGroupView addSubview:cellView];
        }
    }
    
    y = userGroupView.frame.origin.y + userGroupView.frame.size.height + 20;
    itemGroupView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y);
    for (UIView *subView in itemGroupView.subviews) {
        [subView removeFromSuperview];
    }
    
    
    NSString *channelName = channelDetails.name;
    if (channelName == nil || channelName.length == 0) {
        channelName = @"未设置";
    }
    UIView *nameView = [self viewWithTitle:@"频道名称" andName:channelName withTag:TAG_NAME];
    [itemGroupView addSubview:nameView];
    
    NSString *dest = channelDetails.desc;
    if (dest == nil || dest.length == 0) {
        dest = @"未设置";
    }
    UIView *destView = [self viewWithTitle:@"目的地" andName:dest withTag:TAG_DESTINATION];
    [itemGroupView addSubview:destView];
}

- (void)searchResult:(SearchItem *)item {
    searchItem = item;
    UILabel *label = (UILabel *) [itemGroupView viewWithTag:TAG_DEST_LABEL];
    label.text = item.name;
    
    CGFloat width = self.view.frame.size.width;
    [label sizeToFit];
    CGSize size = label.frame.size;
    label.frame = CGRectMake(width - 15 - 12 - 10 - size.width, (55.f - size.height) / 2.f, size.width, size.height);
    
    [self setDestination:item.name];
}

- (void)sendDataBack:(NSDictionary *)dict {
    NSString *name = [dict objectForKey:@"key"];
    UILabel *label = (UILabel *) [itemGroupView viewWithTag:TAG_NAME_LABEL];
    label.text = name;
    
    CGFloat width = self.view.frame.size.width;
    [label sizeToFit];
    CGSize size = label.frame.size;
    label.frame = CGRectMake(width - 15 - 12 - 10 - size.width, (55.f - size.height) / 2.f, size.width, size.height);
    
    [self setChannelName:name];
}

- (void)onItemClicked:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger tag = [tap view].tag;
    
    if (tag == TAG_DESTINATION) {
        DestinationViewController *controller = [[DestinationViewController alloc] init];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    if (tag == TAG_NAME) {
        InfoEditViewController *viewController = [[InfoEditViewController alloc] init];
        viewController.delegate = self;
        viewController.titleName = @"设置频道名称";
        viewController.keyName = @"key";
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (UIView *)viewWithTitle:(NSString *)title andName:(NSString *)name withTag:(NSInteger)tag {
    CGFloat width = self.view.frame.size.width;
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 54.5f, width, 0.5f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, tag == TAG_NAME ? 0 : 55, width, 55)];
    view.tag = tag;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemClicked:)];
    [view addGestureRecognizer:singleTap];
    [view.layer addSublayer:border];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 55.f)];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor colorWithRed:75.f/255 green:75.f/255 blue:75.f/255 alpha:1.f];
    titleLabel.font = [UIFont systemFontOfSize:17.f];
    [titleLabel sizeToFit];
    CGSize size = titleLabel.frame.size;
    titleLabel.frame = CGRectMake(18.f, (55.f - size.height) / 2.f, size.width, size.height);
    [view addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_indicator.png"]];
    imageView.frame = CGRectMake(width - 15 - 12, (55.f - 20.f) / 2.f, 12, 20);
    [view addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.tag = tag == TAG_NAME ? TAG_NAME_LABEL : TAG_DEST_LABEL;
    nameLabel.text = name;
    nameLabel.textColor = [UIColor colorWithRed:179.f / 255 green:179.f / 255 blue:179.f / 255 alpha:1.f];
    nameLabel.font = [UIFont systemFontOfSize:14.f];
    [nameLabel sizeToFit];
    size = nameLabel.frame.size;
    nameLabel.frame = CGRectMake(width - 15 - 12 - 10 - size.width, (55.f - size.height) / 2.f, size.width, size.height);
    [view addSubview:nameLabel];
    
    return view;
}

- (UIView *)getCellView:(UserInfo *)info {
    CGFloat width = self.view.frame.size.width / 4.f;
    UIView *view = [[UIView alloc] init];
    
    NSString *userName = info.nickname;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 37) / 2.f, 30.f, 37.f, 37.f)];
    imageView.layer.cornerRadius = 37.f / 2;
    imageView.layer.masksToBounds = YES;
    [view addSubview:imageView];

    NSString *userId = [NSString stringWithFormat:@"%@", info.userid];
    if ([userId isEqualToString:@"add"]) {
        imageView.image = [UIImage imageNamed:@"icon_manage_add.png"];
        userName = @"";
    } else if ([userId isEqualToString:@"delete"]) {
        imageView.image = [UIImage imageNamed:@"icon_manage_delete.png"];
        userName = @"";
    } else {
        [imageView sd_setImageWithURL:[NSURL URLWithString:info.avatar] placeholderImage:nil];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"icon_delete_btn.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width - 10.f, imageView.frame.origin.y - 5.f, 17.f, 17.f);
        [view addSubview:button];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = userName;
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor colorWithRed:75.f / 255.f green:75.f / 255.f blue:75.f / 255.f alpha:1.0f];
    [label sizeToFit];
    CGSize size = label.frame.size;
    label.frame = CGRectMake((width - size.width) / 2.f, imageView.frame.size.height + imageView.frame.origin.y + 15.f, size.width, size.height);
    [view addSubview:label];
    
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
