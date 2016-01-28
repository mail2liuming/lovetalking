//
//  MessageViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol OnUserAcceptDelegate <NSObject>

- (void)onUserAccepted;

@end

@interface MessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) id<OnUserAcceptDelegate> delegate;

@end
