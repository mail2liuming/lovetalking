//
//  DestinationViewController.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/10.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@class SearchItem;

@protocol SendDataProtocol <NSObject>

-(void)sendDataBack:(SearchItem *)item;

@end

@interface DestinationViewController : UIViewController <UITextFieldDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id delegate;

@end
