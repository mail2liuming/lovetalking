//
//  UserAddWattingView.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/2/17.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "UserAddWattingView.h"
#import "UIImage+Color.h"
#import "UserInfo.h"
#import "UIImageView+AFNetworking.h"

@implementation UserAddWattingView {
    
    UIView *numberView;
    
    UIView *userGroupView;
    
    CGFloat itemHeight;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:242.f / 255.f green:242.f / 255.f blue:242.f / 255.f alpha:1.0f];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"输入同一数字, 进入同一频道";
        label.font = [UIFont systemFontOfSize:17.f];
        label.textColor = [UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f];
        [label sizeToFit];
        CGSize size = label.frame.size;
        
        CGFloat groupWidth = 29.f * 4;
        CGFloat groupHeight = 29.f;
        
        numberView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - groupWidth) / 2.f,
                                                              64.f + 44.f, groupWidth, groupHeight)];
        [self addSubview:numberView];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tipLabel.text = @"这些朋友也将进入群聊";
        tipLabel.font = [UIFont systemFontOfSize:14.f];
        tipLabel.textColor = [UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f];
        [tipLabel sizeToFit];
        size = tipLabel.frame.size;
        tipLabel.frame = CGRectMake((self.frame.size.width - size.width) / 2.f, numberView.frame.size.height + numberView.frame.origin.y + 18.f, size.width, size.height);
        [self addSubview:tipLabel];
        
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, tipLabel.frame.origin.y + size.height + 24.f, self.frame.size.width, 0.5f)];
        divider.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f];
        [self addSubview:divider];
        CGFloat offset = divider.frame.origin.y + divider.frame.size.height;
        
        CALayer *border = [CALayer layer];
        border.frame = CGRectMake(0, 0, self.frame.size.width, 1.0f);
        border.backgroundColor = [UIColor colorWithRed:62.f / 255 green:193.f / 255 blue:10.f / 255 alpha:1.0f].CGColor;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, self.frame.size.height - 54.f, self.frame.size.width, 54.f);
        NSString *text = @"进入该群";
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:62.f / 255.f green:193.f / 255.f blue:10.f / 255.f alpha:1.0f]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button.layer addSublayer:border];
        [self addSubview:button];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.text = @"正";
        nameLabel.font = [UIFont systemFontOfSize:14.f];
        [nameLabel sizeToFit];
        size = nameLabel.frame.size;
        itemHeight = 36.f + 8.f + size.height;
        
        CGFloat space = (self.frame.size.width - 2 * 24.f - 5 * 50) / (5 - 1);

        userGroupView = [[UIView alloc] initWithFrame:CGRectMake(24.f, offset + 24.f, self.frame.size.width - 2 * 24.f, 2 * itemHeight + space)];
        [self addSubview:userGroupView];
    }
    
    return self;
}

- (void)setUserList:(NSMutableArray *)userList {
    /** clear all views first **/
    for (UIView *subView in userGroupView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSInteger count = userList.count + 1;
    if (count > 10) count = 10;
    
    NSInteger col = 5;
    CGFloat width = 50.f;
    CGFloat space = (self.frame.size.width - 2 * 24.f - col * width) / (col - 1);
    NSInteger row = count / col;
    if (count % 5 > 0) row += 1;
    
    CGFloat x, y;
    for (NSInteger i = 0; i < row; i++) {
        for (NSInteger j = 0; j < (i == row - 1 ? count - (row - 1) * col : col); j++) {
            NSInteger index = i * col + j;
            x = j * width + space * j;
            y = i * itemHeight + space * i;
            
            if (index == count - 1) {
                UIView *itemView = [self getAnimateView];
                itemView.frame = CGRectMake(x, y, 50.f, itemHeight);
                [userGroupView addSubview:itemView];
            } else {
                UIView *itemView = [self getItemView:[userList objectAtIndex:index]];
                itemView.frame = CGRectMake(x, y, 50.f, itemHeight);
                [userGroupView addSubview:itemView];
            }
        }
    }
}

- (void)onButtonClicked:(id)sender {
    if (self.delegate) {
        [self.delegate onJoinButtonClicked];
    }
}

- (UIView *)getItemView:(UserInfo *)userInfo {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((50.f - 36.f) / 2.f, 0, 36.f, 36.f)];
    imageView.layer.cornerRadius = 18.f;
    imageView.layer.masksToBounds = YES;
    [imageView setImageWithURL:[NSURL URLWithString:userInfo.avatar] placeholderImage:[UIImage imageNamed:@"ic_nav.png"]];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = userInfo.nickname;
    label.textColor = [UIColor colorWithRed:179.f/255.f green:179.f/255.f blue:179.f/255.f alpha:1.f];
    label.font = [UIFont systemFontOfSize:14.f];
    [label sizeToFit];
    CGSize size = label.frame.size;
    label.frame = CGRectMake((50.f - size.width) / 2.f, 36.f + 8.f, size.width, size.height);
    [view addSubview:label];
    
    return view;
}

- (UIView *)getAnimateView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIView *animateView = [[UIView alloc] initWithFrame:CGRectMake((50.f - 36.f) / 2.f, 0, 36.f, 36.f)];
    animateView.layer.cornerRadius = 18.f;
    animateView.layer.masksToBounds = YES;
    animateView.layer.borderColor = [UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f].CGColor;
    animateView.layer.borderWidth = 1.f;
    [view addSubview:animateView];
    
    [UIView animateWithDuration:2.0 delay:0.1 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        animateView.alpha = 0;
        animateView.alpha = 1;
        
    } completion:nil];
    
    return view;
}

- (void)setNumber:(NSMutableArray *)digits {
    for (NSInteger i = 0; i < digits.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [NSString stringWithFormat:@"%@", [digits objectAtIndex:i]];
        label.font = [UIFont systemFontOfSize:29.f];
        label.textColor = [UIColor colorWithRed:54.f / 255.f green:152.f / 255.f blue:15.f / 255.f alpha:1.0f];
        [label sizeToFit];
        CGSize size = label.frame.size;
        label.frame = CGRectMake((29.f - size.width) / 2.f + i * 29.f, (29.f - size.height) / 2.f, size.width, size.height);
        label.backgroundColor = [UIColor colorWithRed:242.f / 255.f green:242.f / 255.f blue:242.f / 255.f alpha:1.0f];
        [numberView addSubview:label];
    }
}


@end
