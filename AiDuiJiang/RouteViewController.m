//
//  RouteViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/11/30.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "RouteViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ChannelViewController.h"
#import "SearchItem.h"
#import "CustomAnnotationView.h"
#import <CoreLocation/CoreLocation.h>
#import "UserAccoutManager.h"
#import "UserInfo.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPSessionManager.h"
#import "Utils.h"
#import "ChannelDetails.h"
#import "AlertView.h"

@interface RouteViewController ()

@end

@implementation RouteViewController {
    
    IFlySpeechSynthesizer *iFlySpeechSynthesizer;
    
    MAPointAnnotation *startPoint;    
    
    BOOL calRouteSuccess;
    
    MAMapView *routeMapView;
    
    AMapNaviViewController *naviViewController;
    
    AMapNaviManager *routeNaviManager;
    
    MAPolyline *polyline;
    
    BOOL startCalRoute;
    
    NSMutableArray *routePoints;
    
    ChannelDetails *channelDetails;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    routePoints = [NSMutableArray array];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"icon_user.png"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 21, 21);
    [rightButton addTarget:self action:@selector(onRightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    calRouteSuccess = NO;
    startCalRoute = NO;
    
    startPoint = [[MAPointAnnotation alloc] init];
    
    routeMapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:routeMapView];
    
    if (routeNaviManager == nil) {
        routeNaviManager = [[AMapNaviManager alloc] init];
        routeNaviManager.delegate = self;
    }
    
    naviViewController = [[AMapNaviViewController alloc] initWithDelegate:self];
    
    if (iFlySpeechSynthesizer == nil) {
        iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        iFlySpeechSynthesizer.delegate = self;
    }
    
    [self configMapView];
    [self setVoiceView];
    
    UIButton *navButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 12.f - 60.f, self.view.frame.size.height - 200.f - 60.f - 12.f, 60.f, 60.f)];
    [navButton setBackgroundImage:[UIImage imageNamed:@"ic_nav.png"] forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(setDestination) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navButton];
    
    [self request];
}

- (void)request {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.channelId, @"cid", nil];
    NSString *url = [[Utils sharedUtils] getUrl:@"http://m.icall.sogou.com/channel/1.0/detail.html?" params:params];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            channelDetails = [[ChannelDetails alloc] initWithDict:[responseObject objectForKey:@"data"]];
            self.title = [NSString stringWithFormat:@"%@（%ld人）", channelDetails.name, channelDetails.followers];
            
            NSString *loc = channelDetails.loc;
            if (loc == nil || loc.length == 0) {
                AlertView *alertView = [[AlertView alloc] initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.height)];
                alertView.delegate = self;
                [alertView setTitle:@"请设置目的地" withMessage:@"现在就设置好目的地吧，在旅途中开心地和小伙伴一起用爱对讲随时沟通"];
                
                [self.view addSubview:alertView];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)onConfirmed {
    [self onRightButtonClicked];
}

- (void)onChannelInfoChanged {
    if (self.infoChangeDelegate) {
        [self.infoChangeDelegate onChannelInfoChanged];
    }
}

- (void)onRightButtonClicked {
    ChannelViewController *controller = [[ChannelViewController alloc] init];
    controller.channelId = self.channelId;
    controller.channelTilte = [NSString stringWithFormat:@"%@（%ld人）", channelDetails.name, (long)channelDetails.followers];
    controller.delegate = self;
    controller.infoChangeDelegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setVoiceView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200.f, self.view.frame.size.width, 200.f)];
    view.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.77f];
    [self.view addSubview:view];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 108.f) / 2.f, (200 - 108.f) / 2.f, 108.f, 108.f)];
    [button setBackgroundImage:[UIImage imageNamed:@"voice_n@2x.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"voice_p@2x.png"] forState:UIControlStateHighlighted];
    [view addSubview:button];
}

- (void)setDestination {
    if (calRouteSuccess == NO) {
        [self onRightButtonClicked];
    } else {
        [routeNaviManager presentNaviViewController:naviViewController animated:YES];
    }
}

- (void)onTargetSet:(SearchItem *)item {
    [self startCalculateRoute:item.location.latitude withLng:item.location.longitude];
    [self onChannelInfoChanged];
}

- (void)onExitChannel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startCalculateRoute:(CGFloat)lat withLng:(CGFloat)lng {
    startCalRoute = YES;
    
    MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(lat, lng);
    point.title = @"end";
    
    [routePoints removeAllObjects];
    [routePoints addObject:point];
    [routeMapView addAnnotations:routePoints];
    
    NSArray *startPoints = @[[AMapNaviPoint locationWithLatitude:startPoint.coordinate.latitude longitude:startPoint.coordinate.longitude]];
    NSArray *endPoints = @[[AMapNaviPoint locationWithLatitude:point.coordinate.latitude longitude:point.coordinate.longitude]];
    
    [routeNaviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
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

- (void)configMapView {
    routeMapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656);
    routeMapView.delegate = self;
    routeMapView.showsUserLocation = YES;
    routeMapView.mapType = MAMapTypeStandard;
    routeMapView.frame = self.view.bounds;
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
            UserAccoutManager *accoutManager = [UserAccoutManager sharedManager];
            UserInfo *userInfo = [accoutManager getUserInfo];
            NSString *avatarUrl = userInfo.avatar;
            if (avatarUrl && avatarUrl.length > 0) {
                [annotationView.avatarView sd_setImageWithURL:[NSURL URLWithString:avatarUrl]];
            }

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
        [iFlySpeechSynthesizer stopSpeaking];
    });
    [routeNaviManager stopNavi];
    [routeNaviManager dismissNaviViewControllerAnimated:YES];
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (updatingLocation) {
        if (startPoint) {
            [routeMapView removeAnnotation:startPoint];
        }
        
        startPoint.coordinate = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
        startPoint.title = @"start";
        
        [routeMapView addAnnotation:startPoint];
        
        if (channelDetails) {
            NSString *loc = channelDetails.loc;
            if (calRouteSuccess == NO && startCalRoute == NO &&
                loc && loc.length > 0) {
                NSArray *latlng = [loc componentsSeparatedByString:@","];
                CGFloat targetLat = [[latlng objectAtIndex:0] floatValue];
                CGFloat targetLng = [[latlng objectAtIndex:1] floatValue];
                [self startCalculateRoute:targetLat withLng:targetLng];
            }
        }
    }
}

- (void)clearMapView {
    routeMapView.showsUserLocation = NO;
    [routeMapView removeAnnotations:routeMapView.annotations];
    [routeMapView removeOverlays:routeMapView.overlays];
    routeMapView.delegate = nil;
}

- (void)naviManager:(AMapNaviManager *)naviManager error:(NSError *)error {
}

- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController {
    [naviManager startEmulatorNavi];
}

- (void)naviManager:(AMapNaviManager *)naviManager didDismissNaviViewController:(UIViewController *)naviViewController {
    [self configMapView];
}

- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager {
    calRouteSuccess = YES;
    startCalRoute = NO;
    
    AMapNaviRoute *route = [[naviManager naviRoute] copy];
    if (!route) return;
    
    if (polyline) {
        [routeMapView removeOverlay:polyline];
        polyline = nil;
    }
    
    NSUInteger coordianteCount = [route.routeCoordinates count];
    CLLocationCoordinate2D coordinates[coordianteCount];
    for (int i = 0; i < coordianteCount; i++)
    {
        AMapNaviPoint *aCoordinate = [route.routeCoordinates objectAtIndex:i];
        coordinates[i] = CLLocationCoordinate2DMake(aCoordinate.latitude, aCoordinate.longitude);
    }
    
    polyline = [MAPolyline polylineWithCoordinates:coordinates count:coordianteCount];
    [routeMapView addOverlay:polyline];
}

- (void)naviManager:(AMapNaviManager *)naviManager onCalculateRouteFailure:(NSError *)error {
    startCalRoute = NO;
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
            [iFlySpeechSynthesizer startSpeaking:soundString];
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
