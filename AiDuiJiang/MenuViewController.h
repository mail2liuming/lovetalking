//
//  MenuViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/21.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideMeneDelegate <NSObject>

@required

- (void)onMenuClicked:(NSUInteger)index;

@end

@interface MenuViewController : UIViewController

@property (assign, nonatomic) id<SlideMeneDelegate> delegate;

@end
