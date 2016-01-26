//
//  CityViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/26.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendDataBackDelegate.h"

@interface CityViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *cityData;

@property (nonatomic, assign) id<SendDataBackDelegate> delegate;

@end
