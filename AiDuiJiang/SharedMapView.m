//
//  SharedMapView.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/11/30.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "SharedMapView.h"

@implementation SharedMapView

+ (instancetype)sharedInstance {
    
    static SharedMapView *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SharedMapView alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self == [super init]) {
        [self initProperties];
        [self createMapView];
    }
    
    return self;
}

- (void)initProperties {
    _internalStatusArray = [[NSMutableArray alloc] init];
}

- (void)createMapView {
    if (self.mapView == nil) {
        self.mapView = [[MAMapView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
}

- (void)stashMapViewStatus
{
    @synchronized (_internalStatusArray)
    {
        if (_internalStatusArray == nil)
        {
            return;
        }
        
        [_internalStatusArray addObject:[self.mapView getMapStatus]];
    }
}

- (void)popMapViewStatus
{
    @synchronized (_internalStatusArray)
    {
        if (_internalStatusArray == nil || ![_internalStatusArray count])
        {
            return;
        }
        
        [self.mapView setMapStatus:[_internalStatusArray lastObject] animated:NO];
        
        [_internalStatusArray removeLastObject];
    }
}


@end
