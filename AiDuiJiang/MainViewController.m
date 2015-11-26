//
//  MainViewController.m
//  AiDuiJiang
//
//  Created by liu on 15/11/22.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "MainViewController.h"
#import "DrawerLayout.h"



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

    // Do any additional setup after loading the view.
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
