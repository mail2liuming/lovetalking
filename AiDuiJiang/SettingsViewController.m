//
//  SettingsViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "SettingsViewController.h"

#define TAG_FEEDBACK    100
#define TAG_PROTOCOL    101
#define TAG_GUIDE       102
#define TAG_UPDATE      103

@implementation SettingsViewController {
    
    CGFloat imageHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    
    imageHeight = self.view.frame.size.width * 438.f / 750.f;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_setting.png"]];
    imageView.frame = CGRectMake(0, 64.f, self.view.frame.size.width, imageHeight);
    [self.view addSubview:imageView];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height + imageView.frame.origin.y, self.view.frame.size.width, 20.f)];
    grayView.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1.0];
    [self.view addSubview:grayView];
    
    NSArray *titles = @[@"用户反馈", @"使用协议", @"新手引导", @"检查更新"];
    for (NSInteger i = 0; i < titles.count; i++) {
        [self appendItem:[titles objectAtIndex:i] atIndex:i];
    }
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    versionLabel.text = [NSString stringWithFormat:@"爱对讲-最靠谱的自驾游对讲机 %@版", version];
    versionLabel.font = [UIFont systemFontOfSize:12.f];
    versionLabel.textColor = [UIColor colorWithRed:215.f / 255.0f green:215.f / 255.0f blue:215.f / 255.0f alpha:1.0f];
    [versionLabel sizeToFit];
    CGSize size = versionLabel.frame.size;
    versionLabel.frame = CGRectMake((self.view.frame.size.width - size.width) / 2.f,
                                    self.view.frame.size.height - 20.f - size.height, size.width, size.height);
    [self.view addSubview:versionLabel];
}

- (void)appendItem:(NSString *)title atIndex:(NSInteger)i {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, imageHeight + 20.f + 64.f + i * 55.f, self.view.frame.size.width, 55.f)];
    
    view.tag = TAG_FEEDBACK + i;
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
    
    [self.view addSubview:view];
}

- (void)onItemClicked:(id)sender {
}

@end
