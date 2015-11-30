//
//  NavPointAnnotation.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/11/30.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <AMapNaviKit/AMapNaviKit.h>

typedef NS_ENUM(NSInteger, NavPointAnnotationType)
{
    NavPointAnnotationStart,
    NavPointAnnotationWay,
    NavPointAnnotationEnd
};

@interface NavPointAnnotation : MAPointAnnotation
@property (nonatomic, assign) NavPointAnnotationType navPointType;


@end
