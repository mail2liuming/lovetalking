//
//  MainViewController.m
//  AiDuiJiang
//
//  Created by liu on 15/11/22.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "MainViewController.h"
#import "DrawerLayout.h"
#import "RouteViewController.h"


@interface MainViewController ()

@property (nonatomic,strong) DrawerLayout* drawer;

@end

@implementation MainViewController

- (IBAction)openDrawer:(id)sender {
    [self.drawer toggle];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.drawer = [[DrawerLayout alloc] initWithParent:self.navigationController.view ];
    [self.navigationController.view addSubview:self.drawer];
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mapButton.frame = CGRectMake(self.view.frame.size.width / 2 - 50, 100, 80, 44);
    [mapButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mapButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [mapButton setTitle:@"导航" forState:UIControlStateNormal];
    
    mapButton.titleLabel.font = [UIFont systemFontOfSize:18.f];
    [mapButton addTarget:self action:@selector(navigation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapButton];
}

- (void)navigation:(id)sender {
    RouteViewController *viewController = [[RouteViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
