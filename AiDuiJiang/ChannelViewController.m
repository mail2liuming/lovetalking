//
//  ChannelViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/10.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "ChannelViewController.h"
#import "DestinationViewController.h"

@interface ChannelViewController ()

@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242.f / 255 green:242.f / 255 blue:242.f / 255 alpha:1.0f];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
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
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setName)];
    [nameView addGestureRecognizer:nameTap];
    [container addSubview:nameView];
    
    UIView *destView = [self viewWithTitle:@"目的地" andName:@"未设置" atIndex:1];
    UITapGestureRecognizer *destTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setDestination)];
    [destView addGestureRecognizer:destTap];
    [container addSubview:destView];
    
    CALayer *borderTop = [CALayer layer];
    borderTop.frame = CGRectMake(0, 0, width, 1.f);
    borderTop.backgroundColor = [UIColor colorWithRed:255.f / 255 green:149.f / 255 blue:78.f / 255 alpha:1.0f].CGColor;
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton.layer addSublayer:borderTop];
    [exitButton setTitle:@"退出频道" forState:UIControlStateNormal];
    exitButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitButton setBackgroundColor:[UIColor colorWithRed:235.f / 255 green:98.f / 255 blue:24.f / 255 alpha:1]];
    exitButton.frame = CGRectMake(0, height - 54.f, width, 54.f);
    [self.view addSubview:exitButton];
}

- (void)setName {
    NSLog(@"name taped");
}

- (void)setDestination {
    DestinationViewController *controller = [[DestinationViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIView *)viewWithTitle:(NSString *)title andName:(NSString *)name atIndex:(NSUInteger) i {
    CGFloat width = self.view.frame.size.width;
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 54.f, width, 1.f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, i * 55, width, 55)];
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
    nameLabel.text = name;
    nameLabel.textColor = [UIColor colorWithRed:179.f / 255 green:179.f / 255 blue:179.f / 255 alpha:1.f];
    nameLabel.font = [UIFont systemFontOfSize:14.f];
    [nameLabel sizeToFit];
    size = nameLabel.frame.size;
    nameLabel.frame = CGRectMake(width - 15 - 12 - 10 - size.width, (55.f - size.height) / 2.f, size.width, size.height);
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
