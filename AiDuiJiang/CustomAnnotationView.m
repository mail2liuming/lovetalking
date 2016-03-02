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
        
        self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5f, 2.5f, 26.f, 26.f)];
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.avatarView.layer.borderWidth = 1.6f;
        self.avatarView.layer.cornerRadius = 13.f;
        [self addSubview:self.avatarView];
    }
    
    return self;
}

@end
