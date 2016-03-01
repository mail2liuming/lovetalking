//
//  UserTableViewCell.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/3/1.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:17.f];
        self.textLabel.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
        
        self.button = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.button setBackgroundImage:[UIImage imageNamed:@"btn_unclick@2x.png"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"btn_click@2x.png"] forState:UIControlStateHighlighted];
        [self addSubview:self.button];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat h = self.frame.size.height;
    
    self.button.frame = CGRectMake(18.f, (h - 15.f) / 2.f, 15.f, 15.f);
    
    self.imageView.frame = CGRectMake(18.f + 15.f + 18.f, (h - 36.f) / 2.f, 36.f, 36.f);
    self.imageView.layer.cornerRadius = 18.f;
    self.imageView.layer.masksToBounds = YES;
    
    [self.textLabel sizeToFit];
    CGSize size = self.textLabel.frame.size;
    self.textLabel.frame = CGRectMake(18.f + 15.f + 18.f + 36.f + 18.f, (h - size.height) / 2.f, size.width, size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
