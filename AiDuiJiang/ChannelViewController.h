//
//  ChannelViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/10.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DestinationViewController.h"

@class SearchItem;

@protocol OnTargetSetProtocol <NSObject>

-(void)onTargetSet:(SearchItem *)item;

@end

@interface ChannelViewController : UIViewController<SendDataProtocol>

@property (nonatomic, assign) id delegate;

@end
