//
//  MainViewController.m
//  AiDuiJiang
//
//  Created by liu on 15/11/22.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "MainViewController.h"
#import "DrawerLayout.h"

#import "DrawerContentView.h"
#import "DrawerContentConfig.h"
#import "UIView+Extend.h"
#import "UIImageView+WebCache.h"
#import "RouteViewController.h"
#import "UserAccoutManager.h"
#import "UserInfo.h"

@interface MainViewController () <DrawerContentViewDelegate>

@property (nonatomic,strong) DrawerLayout* drawer;
@property (nonatomic,strong) DrawerContentView * drawerContent;
@property (nonatomic,strong) DrawerContentConfig* drawerMenuConfig;

@end

@implementation MainViewController

- (IBAction)openDrawer:(id)sender {
    [self.drawer toggle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.view addSubview: self.drawer];
    
       
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

- (DrawerLayout*)drawer{
    if(!_drawer){
        _drawer = [[DrawerLayout alloc] initWithParent:self.navigationController.view ];
        _drawer.contentview = self.drawerContent;
    }
    
    return _drawer;
}

- (DrawerContentView*)drawerContent{
    if(!_drawerContent){
        _drawerContent = [UIView loadFromNibWithName:@"DrawerContent"];
        NSLog(@"add content");
        _drawerContent.delegate = self;
        _drawerContent.headerTitle = @"Loading";
        _drawerContent.footerTitle = @"退出登录";
        _drawerContent.menuConfig = [[DrawerContentConfig alloc]init];
    }
    
    return _drawerContent;
}

-(void) onHeaderSelect{
    NSLog(@"onHeaderSelect");
    [self.drawer close];
}
-(void) onFooterSelect{
    [self.drawer close];
}
-(void) onListItemSelect:(NSInteger)listIndex{
    NSLog(@"onListItemSelect %ld",(long)listIndex);
    switch (listIndex) {
        case 0:
            [self performSegueWithIdentifier:@"show_friends_vc" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"show_setting_vc" sender:self];
            break;
        default:
            break;
    }
    
    [self.drawer close];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //TODO
}


@end
