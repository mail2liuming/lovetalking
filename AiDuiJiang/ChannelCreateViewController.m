//
//  ChannelCreateViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/28.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "ChannelCreateViewController.h"
#import "UIImage+Color.h"

@implementation ChannelCreateViewController {
    
    UIView *numberView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"面对面建频道";
    self.view.backgroundColor = [UIColor colorWithRed:242.f / 255.f green:242.f / 255.f blue:242.f / 255.f alpha:1.0f];
    
    [self appendButtons];
    [self appendGrids];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"输入同一数字, 进入同一频道";
    label.font = [UIFont systemFontOfSize:17.f];
    label.textColor = [UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f];
    [label sizeToFit];
    CGSize size = label.frame.size;
    label.frame = CGRectMake((self.view.frame.size.width - size.width) / 2.f, 64.f + 77.f, size.width, size.height);
    [self.view addSubview:label];
    
    CGFloat groupWidth = 29.f * 4;
    CGFloat groupHeight = 29.f;
    UIView *circleGroupView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - groupWidth) / 2.f,
                                                                       label.frame.origin.y + size.height + 48.f, groupWidth, groupHeight)];
    
    CGFloat x, y = (29.f - 13.f) / 2.f;
    for (NSInteger i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"number@2x.png"]];
        x = i * 29.f + (29.f - 13.f) / 2.f;
        imageView.frame = CGRectMake(x, y, 13.f, 13.f);
        [circleGroupView addSubview:imageView];
    }
    
    [self.view addSubview:circleGroupView];
    
    numberView = [[UIView alloc] initWithFrame:circleGroupView.frame];
    [self.view addSubview:numberView];
    
    UIImageView *deleteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"del@2x.png"]];
    CGFloat width = self.view.frame.size.width / 3.f;
    deleteView.frame = CGRectMake(self.view.frame.size.width - width / 2.f - 17.f ,
                                  self.view.frame.size.height - 54.f / 2.f - 10.f, 34.f, 20.f);
    [self.view addSubview:deleteView];
}

- (void)onButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag;
    
    NSUInteger count = [[numberView subviews] count];
    if (count < 5) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [NSString stringWithFormat:@"%ld", (long) index];
        label.font = [UIFont systemFontOfSize:29.f];
        label.textColor = [UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f];
        label.tag = count + 1;
        [label sizeToFit];
        CGSize size = label.frame.size;
        label.frame = CGRectMake((29.f - size.width) / 2.f + (count - 1) * 29.f, (29.f - size.height) / 2.f, size.width, size.height);
        label.backgroundColor = [UIColor colorWithRed:242.f / 255.f green:242.f / 255.f blue:242.f / 255.f alpha:1.0f];
        [numberView addSubview:label];
    }
}

- (void)onDeleteClicked:(id)sender {
    NSUInteger count = [[numberView subviews] count];
    if (count == 0) return;
    
    UILabel *label = (UILabel *) [numberView viewWithTag:count];
    if (label) {
        [label removeFromSuperview];
    }
}

- (void)appendButtons {
    
    CGFloat width = self.view.frame.size.width / 3.f;
    CGFloat height = 54.f;
    
    CGFloat x, y;
    CGFloat offset = self.view.frame.size.height - 4 * height;
    for (NSInteger i = 0; i < 12; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:243.f / 255.f green:251.f / 255.f blue:232.f / 255.f alpha:1.0f]]
                          forState:UIControlStateHighlighted];
        NSString *index;
        NSInteger tag;
        if (i < 9) {
            index = [NSString stringWithFormat:@"%ld", (long)(i + 1)];
            tag = i + 1;
        } else if (i == 10) {
            index = @"0";
            tag = 0;
        } else {
            index = @"";
            tag = -1;
        }
        [button setTitle:index forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:22.f];
        button.tag = tag;
        if (i == 11) {
            [button addTarget:self action:@selector(onDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (i % 3 == 0) {
            x = 0;
        } else {
            x = width * (i % 3);
        }
        
        NSInteger row = (NSInteger) (i / 3.f);
        y = offset + row * height;
        button.frame = CGRectMake(x, y, width, height);
        [self.view addSubview:button];
    }
}

- (void)appendGrids {
    CGFloat width = self.view.frame.size.width / 3.f;
    CGFloat height = 54.f;

    CGFloat x = 0, y;
    CGFloat offset = self.view.frame.size.height - 4 * height;
    for (NSInteger i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [view setBackgroundColor:[UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f]];
        y = offset + i * height;
        view.frame = CGRectMake(x, y, self.view.frame.size.width, 0.5f);
        [self.view addSubview:view];
    }
    
    for (NSInteger i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [view setBackgroundColor:[UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f]];
        y = offset;
        x = width * (i + 1);
        view.frame = CGRectMake(x, y, 0.5f, 4 * height);
        [self.view addSubview:view];
    }
}

@end
