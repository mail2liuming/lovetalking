//
//  SendDataBackDelegate.h
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/26.
//  Copyright © 2016年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SendDataBackDelegate <NSObject>

- (void)sendDataBack:(NSDictionary *)dict;

@end
