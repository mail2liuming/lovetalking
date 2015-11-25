//
//  DrawerLayout.m
//  AiDuiJiang
//
//  Created by liu on 15/11/22.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "DrawerLayout.h"

@interface DrawerLayout()

@property (nonatomic,readwrite) opened;
@property (nonatomic) CGFloat panGestureSideOffset;

@property (nonatomic,strong) UIView* backgroundview;
@property (nonatomic,strong) UIView* containerview;

@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic,strong) UITapGestureRecongnizer *tapGestureRecognizer;



@end



@implementation DrawerLayout

#pragma mark - init
-(instancetype) initWithParent:(UIView*) parent{
    self = [self initWithFrame : CGRectZero];
    self.parent = parent;
    return self;
}

-(instancetype) initWithFrame :(CGRect) frame{
    self = [super initWithFrame: frame];
    if(self){
        self.backgroundview.frame = frame;
        self.backgroundview.backgroundColor = [UIColor blackColor];
        self.backgroundview.alpha = 0;
        [self addSubview: self.backgroundview]
        
        self.containerview.frame = CGRectZero;
        self.containerview.backgroundColor = [UIColor whiteColor];
        [self addSubview: self.containerview]
        
        self.width = 200;
        self.panGestureSideOffset = 30;
    }
}

-(void) updateContainerViewPosition(){
    CGRect frame = [UIScreen mainScreen].frame;
    frame.width = self.width;
    frame.origin.x = -self.width;
    
    self.containerview.frame = frame;
}


#pragma mark - getter & setter
- (UIView*) backgroundview{
    if(!_backgroundview){
        _backgroundview = [[UIView alloc] init];
    }
    
    return _backgroundview;
}

- (UIView*) containerview{
    if(!_containerview){
        _containerview = [[UIView alloc]init];
    }
    return _containerview;
}

- (void) setWidth:(CGFloat)width{
    _width = width;
    [self setNeedsLayout];
    
    [self updateContainerViewPosition]
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
