//
//  MessageItemCell.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "MessageItemCell.h"
#import "UIImage+Color.h"

@implementation MessageItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:17.f];
        self.textLabel.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitle:@"接受" forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        self.button.titleLabel.textColor = [UIColor whiteColor];
        [self.button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:54.f / 255 green:152.f / 255 blue:16.f / 255 alpha:1.f]] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:34.f / 255 green:130.f / 255 blue:0 alpha:1.f]] forState:UIControlStateHighlighted];
//        [button addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        self.button.layer.cornerRadius = 15.f;
        self.button.clipsToBounds = YES;
        [self addSubview:self.button];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.f, (self.frame.size.height - 36.f) / 2.f, 36.f, 36.f);
    self.imageView.layer.cornerRadius = 18.f;
    self.imageView.layer.masksToBounds = YES;
    
    [self.textLabel sizeToFit];
    CGSize size = self.textLabel.frame.size;
    self.textLabel.frame = CGRectMake(10.f * 2 + 36.f, (self.frame.size.height - size.height) / 2.f, size.width, size.height);
    
    self.button.frame = CGRectMake(self.frame.size.width - 10.f - 64.f, (self.frame.size.height - 30.f) / 2.f, 64.f, 30.f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
