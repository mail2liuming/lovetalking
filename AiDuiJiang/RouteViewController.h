//
//  RouteViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/11/30.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapNaviKit/MAMapKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

#import "iflyMSC/IFlySpeechError.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "ChannelViewController.h"
#import "Channel.h"
#import "ChannelInfoChangeDelegate.h"

@interface RouteViewController : UIViewController <MAMapViewDelegate, AMapNaviManagerDelegate,
IFlySpeechSynthesizerDelegate, AMapNaviViewControllerDelegate, ChannelInfoChangeDelegate, OnTargetSetProtocol>

@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (nonatomic, strong) NSArray *annotations;

@property (nonatomic, strong) MAPolyline *polyline;

@property (nonatomic, strong) NSMutableArray *points;

@property (nonatomic, strong) AMapNaviViewController *naviViewController;

@property (nonatomic, strong) Channel *channel;

@property (nonatomic, assign) id<ChannelInfoChangeDelegate> infoChangeDelegate;

@end
