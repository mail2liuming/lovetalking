//
//  RouteViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/11/30.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "RouteViewController.h"
#import "SharedMapView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NavPointAnnotation.h"

@interface RouteViewController ()

@end

@implementation RouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"路径规划";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    if (self.mapView == nil) {
        self.mapView = [[SharedMapView sharedInstance] mapView];
    }
    
    [[SharedMapView sharedInstance] stashMapViewStatus];
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    
    if (self.naviManager == nil) {
        _naviManager = [[AMapNaviManager alloc] init];
    }
    self.naviManager.delegate = self;
    
    if (self.iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    [self configMapView];
    
    [self routeCal];
}

- (void)configMapView
{
    [self.mapView setDelegate:self];
    self.mapView.frame = self.view.bounds;
    [self.view insertSubview:self.mapView atIndex:0];
    
    if (_calRouteSuccess)
    {
        [self.mapView addOverlay:_polyline];
    }
    
    if (self.annotations.count > 0)
    {
        [self.mapView addAnnotations:self.annotations];
    }
}

- (void)routeCal {
    NSArray *startPoints = @[_startPoint];
    NSArray *endPoints = @[_endPoint];
    
    [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
}

- (id)init {
    self = [super init];
    if (self) {
        _startPoint = [AMapNaviPoint locationWithLatitude:39.989614 longitude:116.481763];
        _endPoint   = [AMapNaviPoint locationWithLatitude:39.983456 longitude:116.315495];
        
        NavPointAnnotation *beginAnnotation = [[NavPointAnnotation alloc] init];
        
        [beginAnnotation setCoordinate:CLLocationCoordinate2DMake(_startPoint.latitude, _startPoint.longitude)];
        beginAnnotation.title        = @"起始点";
        beginAnnotation.navPointType = NavPointAnnotationStart;
        
        NavPointAnnotation *endAnnotation = [[NavPointAnnotation alloc] init];
        
        [endAnnotation setCoordinate:CLLocationCoordinate2DMake(_endPoint.latitude, _endPoint.longitude)];
        
        endAnnotation.title        = @"终点";
        endAnnotation.navPointType = NavPointAnnotationEnd;
        
        self.annotations = @[beginAnnotation, endAnnotation];
    }
    
    return self;
}

- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
    
    [[SharedMapView sharedInstance] popMapViewStatus];
}

- (void)showRouteWithNaviRoute:(AMapNaviRoute *)naviRoute {
    if (naviRoute == nil) {
        return;
    }
    
    if (_polyline) {
        [self.mapView removeOverlay:_polyline];
        self.polyline = nil;
    }
    
    NSUInteger coordianteCount = [naviRoute.routeCoordinates count];
    NSLog(@"%lu", (unsigned long)coordianteCount);
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [naviRoute.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    
    _polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [self.mapView addOverlay:_polyline];
}

- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error {
    NSLog(@"error:{%@}",error.localizedDescription);
}

- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController {
    NSLog(@"didPresentNaviViewController");
}

- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController {
    NSLog(@"didDismissNaviViewController");
}

- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager {
    [self showRouteWithNaviRoute:[[naviManager naviRoute] copy]];
    _calRouteSuccess = YES;
}

- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error {
    NSLog(@"onCalculateRouteFailure 算路失败");
}

- (void)naviManagerNeedRecalculateRouteForYaw:(AMapNaviManager *)naviManager {
    NSLog(@"NeedReCalculateRouteForYaw");
}

- (void)naviManager:(AMapNaviManager *)naviManager didStartNavi:(AMapNaviMode)naviMode {
    NSLog(@"didStartNavi");
}

- (void)naviManagerDidEndEmulatorNavi:(AMapNaviManager *)naviManager {
    NSLog(@"DidEndEmulatorNavi");
}

- (void)naviManagerOnArrivedDestination:(AMapNaviManager *)naviManager {
    NSLog(@"OnArrivedDestination");
}

- (void)naviManager:(AMapNaviManager *)naviManager onArrivedWayPoint:(int)wayPointIndex {
    NSLog(@"onArrivedWayPoint");
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviLocation:(AMapNaviLocation *)naviLocation {
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviInfo:(AMapNaviInfo *)naviInfo {
}

- (BOOL)naviManagerGetSoundPlayState:(AMapNaviManager *)naviManager {
    return 0;
}

- (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType {
    NSLog(@"playNaviSoundString:{%ld:%@}", (long)soundStringType, soundString);
    
    if (soundStringType == AMapNaviSoundTypePassedReminder) {
        //用系统自带的声音做简单例子，播放其他提示音需要另外配置
        AudioServicesPlaySystemSound(1009);
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [_iFlySpeechSynthesizer startSpeaking:soundString];
        });
    }
}

- (void)naviManagerDidUpdateTrafficStatuses:(AMapNaviManager *)naviManager {
    NSLog(@"DidUpdateTrafficStatuses");
}

- (void)onCompleted:(IFlySpeechError *)error {
    NSLog(@"Speak Error:{%d:%@}", error.errorCode, error.errorDesc);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
