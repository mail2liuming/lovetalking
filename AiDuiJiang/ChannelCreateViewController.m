//
//  ChannelCreateViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/28.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "ChannelCreateViewController.h"
#import "UIImage+Color.h"
#import "UserAccoutManager.h"
#import "UserInfo.h"
#import "AFHTTPSessionManager.h"
#import "RouteViewController.h"
#import "Utils.h"

@implementation ChannelCreateViewController {
    
    UIView *numberView;
    
    CLLocationManager *locationManager;
    
    double lat, lng;
    
    MBProgressHUD *progress;
    
    NSString *channelCode;
    
    NSMutableArray *codeArray;
    
    NSString *channelKey;
    
    NSMutableArray *userList;
    
    UserAddWattingView *wattingView;
    
    NSTimer *timerTask;
    
    NSMutableArray *waitList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"面对面建频道";
    self.view.backgroundColor = [UIColor colorWithRed:242.f / 255.f green:242.f / 255.f blue:242.f / 255.f alpha:1.0f];
    
    codeArray = [[NSMutableArray alloc] initWithCapacity:0];
    userList = [[NSMutableArray alloc] initWithCapacity:0];
    waitList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self appendButtons];
    [self appendGrids];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"输入同一数字, 进入同一频道";
    label.font = [UIFont systemFontOfSize:17.f];
    label.textColor = [UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f];
    [label sizeToFit];
    CGSize size = label.frame.size;
    label.frame = CGRectMake((self.view.frame.size.width - size.width) / 2.f, 64.f + 77.f, size.width, size.height);
    [self.view addSubview:label];
    
    CGFloat groupWidth = 29.f * 4;
    CGFloat groupHeight = 29.f;
    UIView *circleGroupView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - groupWidth) / 2.f,
                                                                       label.frame.origin.y + size.height + 48.f, groupWidth, groupHeight)];
    
    CGFloat x, y = (29.f - 13.f) / 2.f;
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number@2x.png"]];
        x = i * 29.f + (29.f - 13.f) / 2.f;
        imageView.frame = CGRectMake(x, y, 13.f, 13.f);
        [circleGroupView addSubview:imageView];
    }
    
    [self.view addSubview:circleGroupView];
    
    numberView = [[UIView alloc] initWithFrame:circleGroupView.frame];
    [self.view addSubview:numberView];
    
    UIImageView *deleteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"del@2x.png"]];
    CGFloat width = self.view.frame.size.width / 3.f;
    deleteView.frame = CGRectMake(self.view.frame.size.width - width / 2.f - 17.f ,
                                  self.view.frame.size.height - 54.f / 2.f - 10.f, 34.f, 20.f);
    [self.view addSubview:deleteView];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 50;
    
    [locationManager startUpdatingLocation];
}

- (void)updateUserList {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:channelKey, @"key", nil];
    NSString *url = [[Utils sharedUtils] getUrl:@"http://m.icall.sogou.com/channel/1.0/faceuser.html?" params:params];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[responseObject objectForKey:@"errno"] integerValue];
            if (code == 0) {
                [waitList removeAllObjects];
                
                NSArray *array = [responseObject objectForKey:@"data"];
                for (NSDictionary *user in array) {
                    UserInfo *userInfo = [[UserInfo alloc] initWithDictionary:user];
                    [waitList addObject:userInfo];
                }
                
                if (waitList.count > 0) {
                    [wattingView setUserList:waitList];
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)pushupWattingView {
    wattingView = [[UserAddWattingView alloc] initWithFrame:CGRectMake(0, numberView.frame.origin.y - 64.f - 44.f, self.view.frame.size.width, self.view.frame.size.height)];
    wattingView.delegate = self;
    [wattingView setNumber:codeArray];
    [wattingView setUserList:userList];
    [self.view addSubview:wattingView];

    [UIView animateWithDuration:2.f animations:^{
        wattingView.frame = CGRectMake(0, numberView.frame.origin.y - 64.f - 44.f, self.view.frame.size.width, self.view.frame.size.height);
        wattingView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
    timerTask = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateUserList) userInfo:nil repeats:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    if (location) {
        lat = location.coordinate.latitude;
        lng = location.coordinate.longitude;
    }
}

- (void)onJoinButtonClicked {
    [self showProgress];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:channelKey, @"key", nil];
    NSString *url = [[Utils sharedUtils] getUrl:@"http://m.icall.sogou.com/channel/1.0/enterface.html?" params:params];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        progress.hidden = YES;
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[responseObject objectForKey:@"errno"] integerValue];
            if (code == 0) {
                if (self.infoChangeDelegate) {
                    [self.infoChangeDelegate onChannelInfoChanged];
                }
                NSDictionary *data = [responseObject objectForKey:@"data"];
                NSString *channelId = [data objectForKey:@"cid"];
                RouteViewController *viewController = [[RouteViewController alloc] init];
                viewController.channelId = channelId;
                [self.navigationController pushViewController:viewController animated:YES];
            } else {
                [self showToast:@"进群失败，请稍后再试"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        progress.hidden = YES;
        [self showToast:@"进群失败，请稍后再试"];
    }];
}

- (void)showProgress {
    progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress];
    progress.delegate = self;
    [progress show:YES];
}

- (void)createChannel {
    [self showProgress];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSNumber numberWithDouble:lat] stringValue] , @"lat",
                                   [[NSNumber numberWithDouble:lng] stringValue], @"lng", channelCode, @"code", nil];
    NSString *url = [[Utils sharedUtils] getUrl:@"http://m.icall.sogou.com/channel/1.0/face2face.html?" params:params];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [progress hide:YES];
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSInteger code = [[responseObject objectForKey:@"errno"] integerValue];
            if (code == 0) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                channelKey = [data objectForKey:@"key"];
                NSArray *array = [data objectForKey:@"user_list"];
                for (NSDictionary *dict in array) {
                    UserInfo *user = [[UserInfo alloc] initWithDictionary:dict];
                    [userList addObject:user];
                }
                
                [self pushupWattingView];
            } else {
                [self showToast:@"频道创建失败，请稍后再试"];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [progress hide:YES];
        [self showToast:@"频道创建失败，请稍后再试"];
    }];
}

- (void)showToast:(NSString *)tips {
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (locationManager) {
        [locationManager stopUpdatingLocation];
        locationManager = nil;
    }
    
    if (timerTask) {
        [timerTask invalidate];
        timerTask = nil;
    }
}

- (void)onButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag;
    
    NSUInteger count = [[numberView subviews] count];
    if (count < 4) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [NSString stringWithFormat:@"%ld", (long) index];
        label.font = [UIFont systemFontOfSize:29.f];
        label.textColor = [UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f];
        label.tag = count + 1;
        [label sizeToFit];
        CGSize size = label.frame.size;
        label.frame = CGRectMake((29.f - size.width) / 2.f + count * 29.f, (29.f - size.height) / 2.f, size.width, size.height);
        label.backgroundColor = [UIColor colorWithRed:242.f / 255.f green:242.f / 255.f blue:242.f / 255.f alpha:1.0f];
        [numberView addSubview:label];
        [codeArray addObject:[NSNumber numberWithInteger:index]];
        
        count = [[numberView subviews] count];
        if (count == 4) {
            channelCode = [[codeArray valueForKey:@"description"] componentsJoinedByString:@""];
            [self createChannel];
        }
    }
}

- (void)onDeleteClicked:(id)sender {
    NSUInteger count = [[numberView subviews] count];
    if (count == 0) return;
    
    UILabel *label = (UILabel *) [numberView viewWithTag:count];
    if (label) {
        [label removeFromSuperview];
        [codeArray removeLastObject];
    }
}

- (void)appendButtons {
    
    CGFloat width = self.view.frame.size.width / 3.f;
    CGFloat height = 54.f;
    
    CGFloat x, y;
    CGFloat offset = self.view.frame.size.height - 4 * height;
    for (NSInteger i = 0; i < 12; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:243.f / 255.f green:251.f / 255.f blue:232.f / 255.f alpha:1.0f]]
                          forState:UIControlStateHighlighted];
        NSString *index;
        NSInteger tag;
        if (i < 9) {
            index = [NSString stringWithFormat:@"%ld", (long)(i + 1)];
            tag = i + 1;
        } else if (i == 10) {
            index = @"0";
            tag = 0;
        } else {
            index = @"";
            tag = -1;
        }
        [button setTitle:index forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:22.f];
        button.tag = tag;
        
        if (i != 9) {
            if (i == 11) {
                [button addTarget:self action:@selector(onDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        if (i % 3 == 0) {
            x = 0;
        } else {
            x = width * (i % 3);
        }
        
        NSInteger row = (NSInteger) (i / 3.f);
        y = offset + row * height;
        button.frame = CGRectMake(x, y, width, height);
        [self.view addSubview:button];
    }
}

- (void)appendGrids {
    CGFloat width = self.view.frame.size.width / 3.f;
    CGFloat height = 54.f;

    CGFloat x = 0, y;
    CGFloat offset = self.view.frame.size.height - 4 * height;
    for (NSInteger i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [view setBackgroundColor:[UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f]];
        y = offset + i * height;
        view.frame = CGRectMake(x, y, self.view.frame.size.width, 0.5f);
        [self.view addSubview:view];
    }
    
    for (NSInteger i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [view setBackgroundColor:[UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f]];
        y = offset;
        x = width * (i + 1);
        view.frame = CGRectMake(x, y, 0.5f, 4 * height);
        [self.view addSubview:view];
    }
}

@end
