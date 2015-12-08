//
//  DrawerContentView.h
//  AiDuiJiang
//
//  Created by liu on 15/11/29.
//  Copyright © 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerContentConfig.h"

@protocol DrawerContentViewDelegate <NSObject>

-(void) onHeaderSelect;
-(void) onFooterSelect;
-(void) onListItemSelect:(NSInteger) listIndex;

@end

@interface DrawerContentView : UIView

@property (nonatomic) NSString *headerTitle;
@property (nonatomic) NSString *headerIcon;

@property (nonatomic) NSString *footerTitle;
@property (nonatomic) NSString *footerIcon;

@property (nonatomic,strong) DrawerContentConfig * menuConfig;
@property (nonatomic,weak) id<DrawerContentViewDelegate> delegate;

@end
