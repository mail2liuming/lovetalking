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

#define TAG_INFO_VIEW    1002
#define TAG_MY_CAR       1003
#define TAG_MY_ROUTE     1004
#define TAG_MY_FRIENDS   1005
#define TAG_SETTINGS     1006

@implementation MenuViewController {}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width - 60.f, self.view.frame.size.height);
    
    [self refreshUserInfo];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 90.f, self.view.frame.size.width, 20.f)];
    grayView.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1.0];
    [self.view addSubview:grayView];
    
    NSArray *images = [NSArray arrayWithObjects:@"icon_mycar@2x.png", @"icon_myfootprint@2x.png",
                       @"icon_friends@2x.png", @"icon_setting@2x.png", nil];
    NSArray *titles = [NSArray arrayWithObjects:@"我的座驾", @"我的足迹", @"我的车友", @"设置", nil];
    for (NSInteger i = 0; i < images.count; i++) {
        [self appendItemView:[images objectAtIndex:i] withTitle:[titles objectAtIndex:i] atIndex:i];
    }
}

- (void)onItemClicked:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger tag = [tap view].tag;
    
    if (self.delegate) [self.delegate onMenuClicked:tag];
}

- (void)refreshUserInfo {
    UIView *infoView = [self.view viewWithTag:TAG_INFO_VIEW];
    if (infoView) [infoView removeFromSuperview];
    
    infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90.f)];
    infoView.tag = TAG_INFO_VIEW;
    [self.view addSubview:infoView];
    
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    if ([accoutManager isLogin]) {
        UITapGestureRecognizer *infoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemClicked:)];
        [infoView addGestureRecognizer:infoTap];
        
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
        if (info.province) {
            address = [NSString stringWithFormat:@"%@, %@", info.province, info.city];
        }
        locationLabel.text = address;
        locationLabel.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
        locationLabel.font = [UIFont systemFontOfSize:14.f];
        [locationLabel sizeToFit];
        CGFloat h = locationLabel.frame.size.height;
        locationLabel.frame = CGRectMake(18.f + 50.f + 24.f, 90.f - h - 18.f, locationLabel.frame.size.width, h);
        [infoView addSubview:locationLabel];
        
        [self appendArrowTo:infoView withHeight:90.f];
    }
}

- (void)appendItemView:(NSString *)image withTitle:(NSString *)title atIndex:(NSInteger)i {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 110.f + i * 55.f, self.view.frame.size.width, 55.f)];
    view.tag = TAG_MY_CAR + i;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemClicked:)];
    [view addGestureRecognizer:singleTap];
    
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
    
    [self appendArrowTo:view withHeight:55.f];
    
    [self.view addSubview:view];
}

- (void)appendArrowTo:(UIView *)view withHeight:(CGFloat)h {
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go@2x.png"]];
    arrowView.frame = CGRectMake(self.view.frame.size.width - 15 - 8, (h - 14.f) / 2, 8.f, 14.f);
    [view addSubview:arrowView];
}

@end
