//
//  HomeViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/20.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "HomeViewController.h"
#import "InfoViewController.h"
#import "SettingsViewController.h"
#import "FriendListViewController.h"
#import "ChannelCreateViewController.h"
#import "UserAccoutManager.h"
#import "AFHTTPSessionManager.h"
#import "Channel.h"
#import "UIImageView+WebCache.h"
#import "RouteViewController.h"
#import "Utils.h"

#define TAG_FACE_TO_FACE     1001
#define TAG_PUBLICK_NO       1002
#define TAG_BY_FRINED        1003

@implementation HomeViewController {
    
    MenuViewController *menuViewController;
    
    NSMutableArray *channelList;
    
    UIView *bottomView;
    
    UIView *channelView;
    
    MAMapView *navMapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"爱对讲";
    
    channelList = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"menu@2x.png"] forState:UIControlStateNormal];
    menuButton.frame = CGRectMake(0, 0, 21, 21);
    [menuButton addTarget:self action:@selector(onMenuClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    SlideNavigationController *slideController = [SlideNavigationController sharedInstance];
    menuViewController = (MenuViewController *) slideController.leftMenu;
    menuViewController.delegate = self;
    
    channelView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:channelView];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 124.f, self.view.frame.size.width, 124.f)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"新建频道";
    label.textColor = [UIColor colorWithRed:179.f/255.f green:179.f/255.f blue:179.f/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:14.f];
    [label sizeToFit];
    CGSize size = label.frame.size;
    label.frame = CGRectMake(18.f, 10.f, size.width, size.height);
    [bottomView addSubview:label];
    
    NSArray *titles = @[@"面对面", @"公共频道", @"通过车友"];
    NSArray *images1 = @[@"home_icon_mdm_n.png", @"home_icon_gg_n.png", @"home_icon_cy_n.png"];
    NSArray *images2 = @[@"home_icon_mdm_p.png", @"home_icon_gg_p.png", @"home_icon_cy_p.png"];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIView *itemView = [self getButtonView:[titles objectAtIndex:i]
                                     withImage:[images1 objectAtIndex:i]
                                     andImage2:[images2 objectAtIndex:i]
                                            at:i];
        [bottomView addSubview:itemView];
    }
    
    [self requestChannel];
    
    navMapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    navMapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    navMapView.delegate = self;
    navMapView.showsUserLocation = YES;
    navMapView.mapType = MAMapTypeStandard;
    
    [self.view insertSubview:navMapView atIndex:0];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
    }
}

- (void)requestChannel {
    NSString *url = [[Utils sharedUtils] getUrl:@"http://m.icall.sogou.com/user/1.0/channel.html?" params:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            [channelList removeAllObjects];
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSArray *array = [dict objectForKey:@"data"];
            
            for (NSDictionary *item in array) {
                Channel *channel = [[Channel alloc] initWithDictionary:item];
                [channelList addObject:channel];
            }
            
            if (channelList.count > 0) {
                [self setupChannelList];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (UIView *)getButtonView:(NSString *)title withImage:(NSString *)image andImage2:(NSString *)image2 at:(NSInteger)index {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.font = [UIFont systemFontOfSize:17.f];
    label.textColor = [UIColor colorWithRed:54.f / 255.0f green:152.f / 255.0f blue:14.0f / 255.0f alpha:1.0f];
    [label sizeToFit];
    CGSize size = label.frame.size;
    
    CGFloat w = self.view.frame.size.width / 3.f;
    CGFloat h = 45.f + 8.f + size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(index * w, 40.f, w, h)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = TAG_FACE_TO_FACE + index;
    button.frame = CGRectMake((w - 52.f) / 2, 0, 52.f, 45.f);
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:image2] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    label.frame = CGRectMake((w - size.width) / 2.f, button.frame.origin.y + button.frame.size.height + 8.f, size.width, size.height);
    [view addSubview:label];
    
    return view;
}

- (void)onButtonClicked:(id)sender {
    ChannelCreateViewController *viewController = [[ChannelCreateViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)onMenuClicked:(NSUInteger)index {
    if (index == 1002) {
        [self updateInfo];
    }
    
    if (index == 1005) {
        FriendListViewController *viewController = [[FriendListViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if (index == 1006) {
        SettingsViewController *viewController = [[SettingsViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)onMenuClicked {
    SlideNavigationController *slideController = [SlideNavigationController sharedInstance];
    if ([slideController isMenuOpen]) {
        [slideController closeMenuWithCompletion:nil];
    } else {
        [slideController openMenuWithCompletion:nil];
    }
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

- (void)updateInfo {
    InfoViewController *viewController = [[InfoViewController alloc] init];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)onInfoChange {
    [menuViewController refreshUserInfo];
}

- (void)setupChannelList {
    for (UIView *subview in channelView.subviews) {
        [subview removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"最近使用频道";
    label.textColor = [UIColor colorWithRed:179.f/255.f green:179.f/255.f blue:179.f/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:14.f];
    [label sizeToFit];
    CGSize size = label.frame.size;
    label.frame = CGRectMake(2.f, 2.f, size.width, size.height);
    
    NSInteger count = channelList.count;
    
    CGFloat height = 76.f * count + 8.f + 6.f + 2.f + size.height;
    
    channelView.frame = CGRectMake(8.f, self.view.frame.size.height - 124.f - height + 8.f,
                                   self.view.frame.size.width - 16.f, height);
    channelView.layer.cornerRadius = 4.f;
    channelView.layer.borderWidth = 0.6f;
    channelView.layer.borderColor = [[UIColor colorWithRed:221.f / 255.f green:221.f / 255.f blue:221.f / 255.f alpha:1.0f] CGColor];
    channelView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.76f];
    [channelView addSubview:label];
    
    for (NSInteger i = 0; i < count; i++) {
        UIView *itemView = [self getChannelView:[channelList objectAtIndex:i] atIndex:i withOffset:2 + size.height + 6];
        [channelView addSubview:itemView];
    }
}

- (UIView *)getChannelView:(Channel *)channel atIndex:(NSInteger)index withOffset:(CGFloat)offset {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, index * 76.f + offset, self.view.frame.size.width, 76.f)];
    view.tag = index;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onChannelClicked:)];
    [view addGestureRecognizer:singleTap];
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 75.4f, self.view.frame.size.width, 0.6f);
    border.backgroundColor = [UIColor colorWithRed:221.f / 255 green:221.f / 255 blue:221.f / 255 alpha:1.0f].CGColor;
    [view.layer addSublayer:border];
    
    NSMutableArray *icons = channel.icons;
    if (icons && icons.count > 0) {
        UIView *circleView = [self getAvatarView:icons];
        [view addSubview:circleView];
    }
    
    NSString *name = [NSString stringWithFormat:@"%@（%ld人）", channel.name, (long)channel.followers];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = name;
    label.font = [UIFont systemFontOfSize:17.f];
    label.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
    [label sizeToFit];
    CGSize size = label.frame.size;
    label.frame = CGRectMake(48.f + 8.f + 8.f, (76.f - size.height) / 2.f, size.width, size.height);
    [view addSubview:label];
    
    return view;
}

- (void)onChannelInfoChanged {
    [self requestChannel];
}

- (UIView *)getAvatarView:(NSMutableArray *)icons {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(8.f, (76.f - 49.f) / 2.f, 49.f, 49.f)];
    view.layer.cornerRadius = 24.5f;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor colorWithRed:233.f / 255.f green:233.f / 255.f blue:233.f / 255.f alpha:1.0f];
    
    NSInteger count = icons.count;
    if (count > 0) {
        CGFloat x, y;

        for (NSInteger i = 0; i < count; i++) {
            x = i % 2 == 0 ? 4 : 25.f;
            y = i / 2 == 0 ? 4 : 25.f;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 21.f, 21.f)];
            imageView.layer.cornerRadius = 10.f;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
            imageView.layer.borderWidth = 2.f;
            [imageView sd_setImageWithURL:[NSURL URLWithString:[icons objectAtIndex:i]] placeholderImage:nil];
            [view addSubview:imageView];
        }
    }
    
    return view;
}

- (void)onChannelClicked:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger index = [tap view].tag;
    Channel *channel = [channelList objectAtIndex:index];
    
    RouteViewController *viewController = [[RouteViewController alloc] init];
    viewController.channel = channel;
    viewController.infoChangeDelegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
