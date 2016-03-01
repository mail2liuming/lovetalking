//
//  AddListViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/2/29.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@protocol UserAddedDelegate <NSObject>

- (void)onUserAdded;

@end


@interface AddListViewController : UITableViewController <UITableViewDataSource, MBProgressHUDDelegate, UITableViewDelegate>

@property (nonatomic, strong) NSString *channelId;

@property (nonatomic, assign) id<UserAddedDelegate> delegate;


@end
