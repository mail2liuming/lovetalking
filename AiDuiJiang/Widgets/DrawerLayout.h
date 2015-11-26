//
//  DrawerLayout.h
//  AiDuiJiang
//
//  Created by liu on 15/11/22.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawerDelegate <NSObject>

- (void) drawerDidOpen;
- (void) drawerDidclose;

@end

@interface DrawerLayout : UIView

@property (nonatomic,weak) id<DrawerDelegate> delegate;
@property (nonatomic,weak) UIView* parent;
@property (nonatomic,strong) UIView * contentview;

@property (nonatomic) CGFloat width;
@property (nonatomic,readonly) BOOL opened;

- (instancetype) initWithParent:(UIView*) parent;
- (void) open;
- (void) close;
- (void) toggle;

@end
