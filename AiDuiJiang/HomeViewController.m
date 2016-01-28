//
//  HomeViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/20.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "HomeViewController.h"
#import "InfoViewController.h"
#import "SharedMapView.h"
#import "SettingsViewController.h"
#import "FriendListViewController.h"
#import "ChannelCreateViewController.h"

#define TAG_FACE_TO_FACE     1001
#define TAG_PUBLICK_NO       1002
#define TAG_BY_FRINED        1003

@implementation HomeViewController {
    
    MAMapView *mapView;
    
    MenuViewController *menuViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.title = @"爱对讲";
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setImage:[UIImage imageNamed:@"menu@2x.png"] forState:UIControlStateNormal];
    menuButton.frame = CGRectMake(0, 0, 21, 21);
    [menuButton addTarget:self action:@selector(onMenuClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    SlideNavigationController *slideController = [SlideNavigationController sharedInstance];
    menuViewController = (MenuViewController *) slideController.leftMenu;
    menuViewController.delegate = self;
    
    mapView = [[SharedMapView sharedInstance] mapView];
    [[SharedMapView sharedInstance] stashMapViewStatus];
    mapView.frame = self.view.bounds;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    mapView.showsUserLocation = YES;
    
    [self setupBottomView];
}

- (void)setupBottomView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 124.f, self.view.frame.size.width, 124.f)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"新建频道";
    label.textColor = [UIColor colorWithRed:179.f/255.f green:179.f/255.f blue:179.f/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:14.f];
    [label sizeToFit];
    CGSize size = label.frame.size;
    label.frame = CGRectMake(18.f, 10.f, size.width, size.height);
    [view addSubview:label];
    
    NSArray *titles = @[@"面对面", @"公共频道", @"通过车友"];
    NSArray *images1 = @[@"home_icon_mdm_n.png", @"home_icon_gg_n.png", @"home_icon_cy_n.png"];
    NSArray *images2 = @[@"home_icon_mdm_p.png", @"home_icon_gg_p.png", @"home_icon_cy_p.png"];
    for (NSInteger i = 0; i < titles.count; i++) {
        UIView *itemView = [self getButtonView:[titles objectAtIndex:i]
                                     withImage:[images1 objectAtIndex:i]
                                     andImage2:[images2 objectAtIndex:i]
                                            at:i];
        [view addSubview:itemView];
    }
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


@end
