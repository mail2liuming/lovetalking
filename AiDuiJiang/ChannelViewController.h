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
#import "ChannelInfoChangeDelegate.h"
#import "AddListViewController.h"

@class SearchItem;

@protocol OnTargetSetProtocol <NSObject>

-(void)onTargetSet:(SearchItem *)item;

@end

@interface ChannelViewController : UIViewController<SendDataProtocol, MBProgressHUDDelegate, SendDataBackDelegate, UserAddedDelegate>

@property (nonatomic, assign) id<OnTargetSetProtocol> delegate;

@property (nonatomic, strong) Channel *channel;

@property (nonatomic, assign) id<ChannelInfoChangeDelegate> infoChangeDelegate;



@end
