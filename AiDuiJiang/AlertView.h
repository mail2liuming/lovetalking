//
//  AlertView.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/3/3.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertViewDelegate <NSObject>

- (void)onConfirmed;

@end

@interface AlertView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) id<AlertViewDelegate> delegate;

- (void)setTitle:(NSString *)title withMessage:(NSString *)message;

@end
