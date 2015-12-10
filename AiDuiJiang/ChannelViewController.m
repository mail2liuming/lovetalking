//
//  ChannelViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/10.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "ChannelViewController.h"

@interface ChannelViewController ()

@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1.0f];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    NSLog(@"id %@", [NSBundle mainBundle].bundleIdentifier);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"我的频道";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 199, self.view.frame.size.width, 1);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    [view.layer addSublayer:border];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];
    CGFloat y = view.frame.origin.y + view.frame.size.height + 20;
    container.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y);
    [self.view addSubview:container];
    
    UIView *nameView = [self viewWithTitle:@"频道名称" andName:@"未设置" atIndex:0];
    [container addSubview:nameView];
    
    UIView *destView = [self viewWithTitle:@"目的地" andName:@"未设置" atIndex:1];
    [container addSubview:destView];
}

- (UIView *)viewWithTitle:(NSString *)title andName:(NSString *)name atIndex:(NSUInteger) i {
    CALayer *border = [CALayer layer];
    CGFloat h = (i + 1) * 55.f;
    border.frame = CGRectMake(0, h - 1, self.view.frame.size.width, 1);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, i * 55, self.view.frame.size.width, 55)];
    [view.layer addSublayer:border];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55.f)];
    nameLabel.text = title;
    nameLabel.textColor = [UIColor colorWithRed:75.f/255 green:75.f/255 blue:75.f/255 alpha:1.f];
    nameLabel.font = [UIFont systemFontOfSize:17.f];
    [nameLabel sizeToFit];
    [view addSubview:nameLabel];
    
    return view;
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
