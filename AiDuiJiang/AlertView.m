//
//  AlertView.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/3/3.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "AlertView.h"
#import "UIImage+Color.h"

#define TAG_BUTTON_CANCEL       100
#define TAG_BUTTON_CONFIRM      101

@implementation AlertView {
    
    CGFloat screenHeight;
    
    CGFloat viewHeight;
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat width = frame.size.width;
        screenHeight = frame.size.height;
        
        CALayer *border = [CALayer layer];
        border.frame = CGRectMake(0, 54.4f, width, 0.6f);
        border.backgroundColor = [UIColor colorWithRed:54.f / 255 green:152.f / 255 blue:14.f / 255 alpha:1.0f].CGColor;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 55.f)];
        self.titleLabel.font = [UIFont systemFontOfSize:19.f];
        self.titleLabel.textColor = [UIColor colorWithRed:54.f / 255.0f green:152.f / 255.0f blue:15.f / 255.f alpha:1.0f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.titleLabel.layer addSublayer:border];
        [self addSubview:self.titleLabel];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.messageLabel.font = [UIFont systemFontOfSize:16.f];
        self.messageLabel.textColor = [UIColor colorWithRed:75.f / 255 green:75.f / 255 blue:75.f / 255 alpha:1.0f];
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.numberOfLines = 0;
        [self.messageLabel sizeToFit];
        CGSize size = self.messageLabel.frame.size;

        self.messageLabel.frame = CGRectMake(15.f, 55.f + 27.f, width - 30.f, size.height * 2);
        [self addSubview:self.messageLabel];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:176.f / 255 green:176.f / 255 blue:176.f / 255 alpha:1.0f]]
                                     forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:157.f / 255 green:157.f / 255 blue:157.f / 255 alpha:1.0f]]
                                     forState:UIControlStateNormal];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        self.cancelButton.titleLabel.textColor = [UIColor whiteColor];
        self.cancelButton.tag = TAG_BUTTON_CANCEL;
        [self.cancelButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:54.f / 255 green:152.f / 255 blue:15.f / 255 alpha:1.0f]]
                                     forState:UIControlStateNormal];
        [self.confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:47.f / 255 green:134.f / 255 blue:12.f / 255 alpha:1.0f]]
                                     forState:UIControlStateNormal];
        [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        self.confirmButton.titleLabel.textColor = [UIColor whiteColor];
        self.confirmButton.tag = TAG_BUTTON_CONFIRM;
        [self.confirmButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.confirmButton];
    }
    
    return self;
}

- (void)onButtonClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == TAG_BUTTON_CONFIRM) {
        if (self.delegate) {
            [self.delegate onConfirmed];
        }
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, screenHeight - viewHeight, self.frame.size.width, viewHeight);
        self.frame = CGRectMake(0, screenHeight, self.frame.size.width, viewHeight);
    }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)setTitle:(NSString *)title withMessage:(NSString *)message {
    CGFloat width = self.frame.size.width;
    
    self.titleLabel.text = title;
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:message];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10.f;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, message.length)];
    self.messageLabel.attributedText = attributeString;
    [self.messageLabel sizeToFit];
    CGSize size = self.messageLabel.frame.size;
    
    self.messageLabel.frame = CGRectMake(15.f, 55.f + 27.f, self.frame.size.width - 30.f, size.height);
    
    CGFloat y = self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + 20.f;
    
    self.cancelButton.frame = CGRectMake(0, y, width / 2.f, 54.f);
    self.confirmButton.frame = CGRectMake(width / 2.f, y, width / 2.f, 54.f);
    
    CALayer *borderTop = [CALayer layer];
    borderTop.frame = CGRectMake(0, 0, width / 2.f, 1.f);
    borderTop.backgroundColor = [UIColor colorWithRed:211.f / 255 green:211.f / 255 blue:211.f / 255 alpha:1.0f].CGColor;
    [self.cancelButton.layer addSublayer:borderTop];
    
    CALayer *borderTop2 = [CALayer layer];
    borderTop2.frame = CGRectMake(0, 0, width / 2.f, 1.f);
    borderTop2.backgroundColor = [UIColor colorWithRed:62.f / 255 green:193.f / 255 blue:10.f / 255 alpha:1.0f].CGColor;
    [self.confirmButton.layer addSublayer:borderTop2];
    
    viewHeight = 55.f + 54.f + 27.f + 20.f + size.height;
    self.frame = CGRectMake(0, screenHeight, self.frame.size.width, viewHeight);
    
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(0, screenHeight, self.frame.size.width, viewHeight);
        self.frame = CGRectMake(0, screenHeight - viewHeight, self.frame.size.width, viewHeight);
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
