//
//  InfoViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/25.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendDataBackDelegate.h"

@protocol OnInfoChangeDelegate <NSObject>

- (void)onInfoChange;

@end

@interface InfoViewController : UIViewController <SendDataBackDelegate>

@property (nonatomic, assign) id<OnInfoChangeDelegate> delegate;

@end
