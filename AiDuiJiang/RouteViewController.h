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

@interface RouteViewController : UIViewController <MAMapViewDelegate, AMapNaviManagerDelegate,
IFlySpeechSynthesizerDelegate, AMapNaviViewControllerDelegate>

@property (nonatomic, weak) MAMapView *mapView;

@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (nonatomic, strong) AMapNaviPoint *startPoint;

@property (nonatomic, strong) AMapNaviPoint *endPoint;

@property (nonatomic, strong) NSArray *annotations;

@property (nonatomic, strong) MAPolyline *polyline;

@property (nonatomic) BOOL calRouteSuccess;

@end