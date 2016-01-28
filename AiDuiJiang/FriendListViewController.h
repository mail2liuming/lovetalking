//
//  FriendListViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageViewController.h"
#import "UserDetailsViewController.h"

@interface FriendListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, OnUserDeleteDelegate, OnUserAcceptDelegate>

@end
