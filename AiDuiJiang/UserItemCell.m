//
//  UserItemCell.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "UserItemCell.h"

@implementation UserItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:17.f];
        self.textLabel.textColor = [UIColor colorWithRed:75.f/255.f green:75.f/255.f blue:75.f/255.f alpha:1.f];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(18.f, (self.frame.size.height - 36.f) / 2.f, 36.f, 36.f);
    self.imageView.layer.cornerRadius = 18.f;
    self.imageView.layer.masksToBounds = YES;
    
    [self.textLabel sizeToFit];
    CGSize size = self.textLabel.frame.size;
    self.textLabel.frame = CGRectMake(18.f * 2 + 36.f, (self.frame.size.height - size.height) / 2.f, size.width, size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
