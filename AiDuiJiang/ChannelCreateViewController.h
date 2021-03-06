//
//  ChannelCreateViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/28.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "UserAddWattingView.h"
#import "ChannelInfoChangeDelegate.h"

@interface ChannelCreateViewController : UIViewController <CLLocationManagerDelegate, GroupAddDelegate, MBProgressHUDDelegate, ChannelInfoChangeDelegate>

@property (nonatomic, assign) id<ChannelInfoChangeDelegate> infoChangeDelegate;

@end
