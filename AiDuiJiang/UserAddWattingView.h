//
//  UserAddWattingView.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/2/17.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupAddDelegate <NSObject>

- (void)onJoinButtonClicked;

@end

@interface UserAddWattingView : UIView

@property (nonatomic, assign) id<GroupAddDelegate> delegate;

- (void)setNumber:(NSMutableArray *)digits;

- (void)setUserList:(NSMutableArray *)userList;

@end
