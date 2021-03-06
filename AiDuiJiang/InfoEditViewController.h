//
//  InfoEditViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/26.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendDataBackDelegate.h"

@interface InfoEditViewController : UIViewController

@property (nonatomic, assign) id<SendDataBackDelegate> delegate;

@property (nonatomic, strong) NSString *titleName;

@property (nonatomic, strong) NSString *keyName;

@property (nonatomic, strong) NSString *placeholder;

@end
