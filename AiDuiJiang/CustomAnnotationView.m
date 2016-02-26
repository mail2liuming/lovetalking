//
//  CustomAnnotationView.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/14.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.bounds = CGRectMake(0.f, 0.f, 41.f, 41.f);       
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 41.f, 41.f)];
        [self addSubview:self.imageView];
    }
    
    return self;
}

@end
