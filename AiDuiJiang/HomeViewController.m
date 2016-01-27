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
}

- (void)onMenuClicked:(NSUInteger)index {
    if (index == 1002) {
        [self updateInfo];
    } else {
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
