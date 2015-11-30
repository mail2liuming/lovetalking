//
//  SharedMapView.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/11/30.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapNaviKit/MAMapKit.h>

@interface SharedMapView : NSObject {
    
    NSMutableArray *_internalStatusArray;
}

@property (nonatomic, readwrite) MAMapView *mapView;

+ (instancetype)sharedInstance;

- (void)stashMapViewStatus;

- (void)popMapViewStatus;

@end
