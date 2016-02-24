//
//  ChannelViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/10.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DestinationViewController.h"
#import "Channel.h"
#import "SendDataBackDelegate.h"
#import "MBProgressHUD.h"

@class SearchItem;

@protocol OnTargetSetProtocol <NSObject>

-(void)onTargetSet:(SearchItem *)item;

@end

@interface ChannelViewController : UIViewController<SendDataProtocol, CLLocationManagerDelegate, MBProgressHUDDelegate, SendDataBackDelegate>

@property (nonatomic, assign) id delegate;

@property (nonatomic, strong) Channel *channel;

@end
