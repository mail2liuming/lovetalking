//
//  SearchItem.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/11.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AMapGeoPoint;

@interface SearchItem : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *district;

@property (nonatomic, strong) AMapGeoPoint *location;

@end
