//
//  DrawerLayout.m
//  AiDuiJiang
//  TODO: Support open from right
//
//  Created by liu on 15/11/22.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "DrawerLayout.h"

@interface DrawerLayout() <UIGestureRecognizerDelegate>

@property (nonatomic,readwrite) BOOL opened;
@property (nonatomic) CGFloat panGestureSideOffset;

@property (nonatomic,strong) UIView* backgroundview;
@property (nonatomic,strong) UIView* containerview;

@property (nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic,strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic) CGPoint dragPoint;
@end



@implementation DrawerLayout

const static float ANIMATION_DURATION = 0.2f;
const static float PAN_SIDE_OFFSET = 30;
const static float BACKGROUND_ALPHA = .5f;
const static  int VELOCITY_THRETHHOLD_FOR_SWIPING = 800;

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
        [self addSubview: self.backgroundview];
        
        self.containerview.frame = CGRectZero;
        self.containerview.backgroundColor = [UIColor whiteColor];
        [self addSubview: self.containerview];
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        self.width = 2 * bounds.size.width/3;
        self.panGestureSideOffset = 30;
        
        [self.backgroundview addGestureRecognizer:self.tapGestureRecognizer];
    }
    return self;
}

-(void) updateContainerViewPosition{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.width = self.width;
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

- (UIPanGestureRecognizer*) panGestureRecognizer{
    if(!_panGestureRecognizer){
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDetected:)];
        _panGestureRecognizer.delegate = self;
    }
    
    return _panGestureRecognizer;
}

- (UITapGestureRecognizer*) tapGestureRecognizer{
    if(!_tapGestureRecognizer){
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetected:)];
        
    }
    return _tapGestureRecognizer;
}

- (void) setWidth:(CGFloat)width{
    _width = width;
    [self setNeedsLayout];
    
    [self updateContainerViewPosition];
}

-(void) setParent:(UIView *)parent{
    _parent = parent;
    [_parent addGestureRecognizer:self.panGestureRecognizer];
}

#pragma mark - private
- (void) moveToLocation :(CGFloat)location{
    CGRect frame = self.containerview.frame;
    frame.origin.x = location;
    self.containerview.frame = frame;
    
    float radio = (self.width + location)/self.width;
    float alpha = BACKGROUND_ALPHA*radio;
    self.backgroundview.alpha = alpha;
}

- (void) panDetected:(UIPanGestureRecognizer*) sender{
    CGPoint trans = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        self.dragPoint = trans;
        if(!self.opened){
            [self prepareShow];
        }
    }
    else if(sender.state == UIGestureRecognizerStateChanged){
        static CGFloat lastLocation = 0;
        CGFloat distance = trans.x - self.dragPoint.x;
        lastLocation = self.containerview.frame.origin.x;
        CGFloat newLocation = lastLocation;
        newLocation += distance;
        if(newLocation >= -self.width && newLocation <=0){
            [self moveToLocation:newLocation];
        }
        self.dragPoint = trans;
    }
    else if(sender.state == UIGestureRecognizerStateEnded){
        CGFloat currentX = self.containerview.frame.origin.x;
        CGPoint velocity = [sender velocityInView:self.superview];
        CGFloat velocityX = velocity.x;
        CGFloat duration = ANIMATION_DURATION;
        
        if(fabs(velocityX) > VELOCITY_THRETHHOLD_FOR_SWIPING){
            if(velocityX > 0){
                duration = fabs(currentX)/fabs(velocityX);
                [self openWithDuration:duration];
            }
            else{
                duration = (self.width + currentX)/fabs(velocityX);
                [self closeWithDuration:duration];
            }
        }else{
            duration = [self animationDuration:currentX];
            
            if(fabs(currentX) < self.width/2){
                [self openWithDuration:ANIMATION_DURATION];
            }
            else{
                [self closeWithDuration:ANIMATION_DURATION];
            }
        }
        self.dragPoint = CGPointZero;
    }
}

-(CGFloat) animationDuration :(CGFloat)location{
    return ANIMATION_DURATION * ((self.width + location)/self.width);
}

- (void) tapDetected:(UITapGestureRecognizer*) sender{
    if(self.opened){
        [self close];
    }
}

- (void) prepareShow{
    CGRect frame = [UIScreen mainScreen].bounds;
    self.frame = frame;
    self.backgroundview.frame = frame;
}

-(void) finishOpen{
    self.opened = true;
    if ([self.delegate respondsToSelector:@selector(drawerDidOpen)]){
        [self.delegate drawerDidOpen];
    }
}

-(void) finishClose{
    self.opened = false;
    self.frame = CGRectZero;
    self.backgroundview.frame = CGRectZero;
    
    if([self.delegate respondsToSelector:@selector(drawerDidclose)]){
        [self.delegate drawerDidclose];
    }
}

- (void) openWithDuration:(CGFloat)duration{
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        CGRect frame = self.containerview.frame;
        frame.origin.x = 0;
        self.containerview.frame = frame;
        self.backgroundview.alpha = BACKGROUND_ALPHA;
        
        
    } completion:^(BOOL finished) {
        [self finishOpen];
    }];
}

- (void) closeWithDuration:(CGFloat) duration{
    [UIView animateWithDuration:duration
                          delay:(0)
                        options:(UIViewAnimationOptionCurveEaseIn)
                     animations:^{
                         CGRect frame = self.containerview.frame;
                         frame.origin.x = -self.width;
                         self.containerview.frame = frame;
                         self.backgroundview.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self finishClose];
                     }];

}

#pragma mark -public 

-(void) open{
    [self prepareShow];
    [self openWithDuration:ANIMATION_DURATION];
}

-(void) close{
    [self closeWithDuration:ANIMATION_DURATION];
}

-(void) toggle{
    if(!self.opened){
        [self open];
    }
    else{
        [self close];
    }
}


- (void) setContentview:(UIView *)contentView
{
    [self.containerview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //contentView.frame = CGRectMake(0, 0, self.containerView.bounds.size.width, self.containerView.bounds.size.height);
    [self.containerview addSubview:contentView];
    _contentview = contentView;
    _contentview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerview addConstraint:[NSLayoutConstraint constraintWithItem:_contentview
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerview
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0 constant:0]];
    [self.containerview addConstraint:[NSLayoutConstraint constraintWithItem:_contentview
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerview
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0 constant:0]];
    [self.containerview addConstraint:[NSLayoutConstraint constraintWithItem:_contentview
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerview
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0 constant:0]];
    [self.containerview addConstraint:[NSLayoutConstraint constraintWithItem:_contentview
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.containerview
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:0]];
    
    NSLog(@"add into container");
}

#pragma  - UIGestureRecognizerDelegate
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self.superview];
    if(self.opened){
        if(point.x <= self.superview.bounds.size.width){
            return YES;
        }
    }
    else{
        if(point.x <= PAN_SIDE_OFFSET){
            return YES;
        }
    }
    
    return NO;
}



@end
