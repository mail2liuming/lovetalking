//
//  HomeViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/20.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController

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


@end
