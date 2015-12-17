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
#import "ChannelViewController.h"
#import "SearchItem.h"
#import "CustomAnnotationView.h"

@interface RouteViewController ()

@end

@implementation RouteViewController {
    
    MAPointAnnotation *startPoint;
    
    BOOL calRouteSuccess;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.points = [NSMutableArray array];
    
    calRouteSuccess = NO;
    
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
    
    self.naviViewController = [[AMapNaviViewController alloc] initWithMapView:self.mapView delegate:self];
    
    if (self.iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    [self configMapView];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"ic_nav.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(width - 10 - 60, height - 10 - 60, 60, 60);
    [button addTarget:self action:@selector(setDestination) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)setDestination {
    if (calRouteSuccess == NO) {
        ChannelViewController *controller = [[ChannelViewController alloc] init];
        controller.delegate = self;
        
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        [self.naviManager presentNaviViewController:self.naviViewController animated:YES];
    }
}

- (void)onTargetSet:(SearchItem *)item {
    MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(item.location.latitude, item.location.longitude);
    point.title = item.name;
    
    [self.points addObject:point];
    [self.mapView addAnnotations:self.points];
    
    NSArray *startPoints = @[[AMapNaviPoint locationWithLatitude:startPoint.coordinate.latitude longitude:startPoint.coordinate.longitude]];
    NSArray *endPoints = @[[AMapNaviPoint locationWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude]];
    
    [self.naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 6.f;
        polylineView.lineJoinType = kMALineJoinRound;
        polylineView.lineCapType = kMALineCapRound;
        [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"arrowTexture"]];
        
        return polylineView;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *reuseId = @"resuseIdentifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        }
        
        if ([annotation.title isEqualToString:@"start"]) {
            annotationView.imageView.image = [UIImage imageNamed:@"start_point.png"];
        } else {
            annotationView.imageView.image = [UIImage imageNamed:@"target.png"];
        }
        annotationView.canShowCallout = YES;
        annotationView.draggable = false;
        annotationView.centerOffset = CGPointMake(5.f, -10.f);
        
        return annotationView;
    }
    
    return nil;
}

- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self.iFlySpeechSynthesizer stopSpeaking];
    });
    [self.naviManager stopNavi];
    [self.naviManager dismissNaviViewControllerAnimated:YES];
}

- (void)configMapView
{
    [self.mapView setDelegate:self];
    self.mapView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.view insertSubview:self.mapView atIndex:0];
    
    self.mapView.showsUserLocation = YES;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        if (startPoint) {
            [self.mapView removeAnnotation:startPoint];
        }
        
        startPoint = [[MAPointAnnotation alloc] init];
        startPoint.coordinate = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        startPoint.title = @"start";
        
        [self.mapView addAnnotation:startPoint];
    }
}

- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
    
    [[SharedMapView sharedInstance] popMapViewStatus];
}

- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error {
}

- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController {
    [self.naviManager startEmulatorNavi];
}

- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController {
    [self configMapView];
}

- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager {
    calRouteSuccess = YES;
    
    AMapNaviRoute *route = [[naviManager naviRoute] copy];
    if (!route) return;
    
    if (_polyline) {
        [self.mapView removeOverlay:_polyline];
        self.polyline = nil;
    }
    
    NSUInteger coordianteCount = [route.routeCoordinates count];
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [route.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    
    _polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [self.mapView addOverlay:_polyline];
}

- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error {
}

- (void)naviManagerNeedRecalculateRouteForYaw:(AMapNaviManager *)naviManager {
}

- (void)naviManager:(AMapNaviManager *)naviManager didStartNavi:(AMapNaviMode)naviMode {
}

- (void)naviManagerDidEndEmulatorNavi:(AMapNaviManager *)naviManager {
}

- (void)naviManagerOnArrivedDestination:(AMapNaviManager *)naviManager {
}

- (void)naviManager:(AMapNaviManager *)naviManager onArrivedWayPoint:(int)wayPointIndex {
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviLocation:(AMapNaviLocation *)naviLocation {
}

- (void)naviManager:(AMapNaviManager *)naviManager didUpdateNaviInfo:(AMapNaviInfo *)naviInfo {
}

- (BOOL)naviManagerGetSoundPlayState:(AMapNaviManager *)naviManager {
    return 0;
}

- (void)naviManager:(AMapNaviManager *)naviManager playNaviSoundString:(NSString *)soundString soundStringType:(AMapNaviSoundType)soundStringType {
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
}

- (void)onCompleted:(IFlySpeechError *)error {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
