//
//  HomeViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/20.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
#import "MenuViewController.h"
#import <AMapNaviKit/MAMapKit.h>
#import "InfoViewController.h"
#import "ChannelInfoChangeDelegate.h"

@interface HomeViewController : UIViewController <SlideNavigationControllerDelegate, SlideMeneDelegate,
MAMapViewDelegate, OnInfoChangeDelegate, ChannelInfoChangeDelegate>

@end
