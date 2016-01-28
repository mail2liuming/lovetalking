//
//  UserDetailsViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "MBProgressHUD.h"

@protocol OnUserDeleteDelegate <NSObject>

- (void)onUserDeleted;

@end

@interface UserDetailsViewController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic, strong) UserInfo *userItemInfo;

@property (nonatomic, assign) id<OnUserDeleteDelegate> delegate;

@property (nonatomic, assign) NSInteger userInfoType;

@end
