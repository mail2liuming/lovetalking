//
//  MenuViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/21.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "MenuViewController.h"
#import "UserAccoutManager.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    if ([accoutManager isLogin]) {
        UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90.f)];
        [self.view addSubview:infoView];
        
        UserInfo *info = [accoutManager getUserInfo];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(18.f, 20.f, 50.f, 50.f)];
        imageView.layer.cornerRadius = 25.f;
        imageView.layer.masksToBounds = YES;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:info.avatar]
                     placeholderImage:[UIImage imageNamed:@"ic_nav.png"]];
        [infoView addSubview:imageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.text = info.nickname;
        nameLabel.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
        nameLabel.font = [UIFont systemFontOfSize:17.f];
        [nameLabel sizeToFit];
        nameLabel.frame = CGRectMake(18.f + 50.f + 24.f, 18.f, nameLabel.frame.size.width, nameLabel.frame.size.height);
        [infoView addSubview:nameLabel];
        
        UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        NSString *address = @"未设置";
        if (info.city) {
            address = info.city;
        }
        locationLabel.text = address;
        locationLabel.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
        locationLabel.font = [UIFont systemFontOfSize:14.f];
        [locationLabel sizeToFit];
        CGFloat h = locationLabel.frame.size.height;
        locationLabel.frame = CGRectMake(18.f + 50.f + 24.f, 90.f - h - 18.f, locationLabel.frame.size.width, h);
        [infoView addSubview:locationLabel];
    }
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 90.f, self.view.frame.size.width, 20.f)];
    grayView.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1.0];
    [self.view addSubview:grayView];
    
    NSArray *images = [NSArray arrayWithObjects:@"icon_mycar@2x.png", @"icon_myfootprint@2x.png",
                       @"icon_friends@2x.png", @"icon_setting@2x.png", nil];
    NSArray *titles = [NSArray arrayWithObjects:@"我的座驾", @"我的足迹", @"我的车友", @"设置", nil];
    for (NSUInteger i = 0; i < images.count; i++) {
        [self appendItemView:[images objectAtIndex:i] withTitle:[titles objectAtIndex:i] atIndex:i];
    }
}

- (void)appendItemView:(NSString *)image withTitle:(NSString *)title atIndex:(NSUInteger)i {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 110.f + i * 55.f, self.view.frame.size.width, 55.f)];
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 54.f, self.view.frame.size.width, 0.6f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    [view.layer addSublayer:border];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    imageView.frame = CGRectMake(18.f, 19.f / 2, 36.f, 36.f);
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:17.f];
    [label sizeToFit];
    label.frame = CGRectMake(18.f + 36.f + 18.f, 55.f / 2 - label.frame.size.height / 2, label.frame.size.width, label.frame.size.height);
    [view addSubview:label];
    
    [self.view addSubview:view];
}

@end
