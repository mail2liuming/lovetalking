//
//  InfoViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/25.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "InfoViewController.h"
#import "UserInfo.h"
#import "UserAccoutManager.h"
#import "UIImageView+WebCache.h"
#import "InfoEditViewController.h"

#define AVATAR       100
#define NICKNAME     101
#define USERID       102
#define GENDER       103
#define DISTRICT     104
#define STATUS       105

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人资料";
    
    CGFloat width = self.view.frame.size.width;
    
    UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
    
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64.f, self.view.frame.size.width, 90.f)];
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 89.4f, self.view.frame.size.width, 0.6f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    [infoView.layer addSublayer:border];
    [self.view addSubview:infoView];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go@2x.png"]];
    arrowView.frame = CGRectMake(width - 15 - 8, (90.f - 14.f) / 2, 8.f, 14.f);
    [infoView addSubview:arrowView];
    
    UserInfo *info = [accoutManager getUserInfo];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 15.f - 8.f - 15.f - 50.f, 20.f, 50.f, 50.f)];
    imageView.layer.cornerRadius = 25.f;
    imageView.layer.masksToBounds = YES;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:info.avatar]
                 placeholderImage:[UIImage imageNamed:@"ic_nav.png"]];
    [infoView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.text = @"头像";
    nameLabel.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
    nameLabel.font = [UIFont systemFontOfSize:17.f];
    [nameLabel sizeToFit];
    nameLabel.frame = CGRectMake(18.f, 90.f / 2 - nameLabel.frame.size.height / 2.f, nameLabel.frame.size.width, nameLabel.frame.size.height);
    [infoView addSubview:nameLabel];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 64.f + 90.f, self.view.frame.size.width, 20.f)];
    grayView.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1.0];
    [self.view addSubview:grayView];
    
    NSArray *titles = [NSArray arrayWithObjects:@"昵称", @"对讲号", @"性别", @"地区", @"个性签名", nil];
    NSArray *texts = [NSArray arrayWithObjects:info.nickname ? info.nickname : @"未设置",
                      info.userid ? [NSString stringWithFormat:@"%@", info.userid] : @"未设置",
                      info.gender == 1 ? @"男" : @"女",
                      info.province ? info.province : @"未设置",
                      info.status ? info.status : @"未设置", nil];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        [self appendItemView:[titles objectAtIndex:i] withText:[texts objectAtIndex:i] atIndex:i];
    }
}

- (void)onItemClicked:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    NSLog(@"%ld", [tap view].tag);
    InfoEditViewController *viewController = [[InfoEditViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)appendItemView:(NSString *)title withText:(NSString *)text atIndex:(NSInteger)i {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 174.f + i * 55.f, self.view.frame.size.width, 55.f)];
    
    view.tag = NICKNAME + i;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemClicked:)];
    [view addGestureRecognizer:tap];
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 54.f, self.view.frame.size.width, 0.6f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    [view.layer addSublayer:border];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = title;
    label.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:17.f];
    [label sizeToFit];
    label.frame = CGRectMake(18.f, 55.f / 2 - label.frame.size.height / 2, label.frame.size.width, label.frame.size.height);
    [view addSubview:label];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_go@2x.png"]];
    arrowView.frame = CGRectMake(self.view.frame.size.width - 15 - 8, (55.f - 14.f) / 2, 8.f, 14.f);
    [view addSubview:arrowView];
    
    if (text) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.text = text;
        textLabel.textColor = [UIColor colorWithRed:179.f/255.f green:179.f/255.f blue:179.f/255.f alpha:1.f];
        textLabel.font = [UIFont systemFontOfSize:14.f];
        [textLabel sizeToFit];
        CGSize textSize = textLabel.frame.size;
        textLabel.frame = CGRectMake(self.view.frame.size.width - 15.f - 8.f - 15.f - textSize.width, 55.f / 2 - textSize.height / 2.f,
                                     textSize.width, textSize.height);
        [view addSubview:textLabel];
    }
    
    [self.view addSubview:view];
}

@end
