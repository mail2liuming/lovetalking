//
//  DrawerContentView.m
//  AiDuiJiang
//
//  Created by liu on 15/11/29.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "DrawerContentView.h"

@interface DrawerContentView() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *logoutLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoutImage;
@property (weak, nonatomic) IBOutlet UITableView *menuList;


@end

@implementation DrawerContentView

-(void) awakeFromNib{
    
    self.menuList.backgroundColor = [UIColor clearColor];
    [self.menuList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DrawerMenuItem"];
    self.menuList.dataSource = self;
    self.menuList.delegate  = self;
    
    [self.menuList setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self.menuList setLayoutMargins:UIEdgeInsetsZero];
    [self.menuList setSeparatorInset:UIEdgeInsetsZero];
}

#pragma  mark -getter&setter

-(void) setHeaderIcon:(NSString *)headerIcon{
    _headerIcon = headerIcon;
    if(self.menuList){
        [self.menuList reloadData];
    }
}

-(void) setHeaderTitle:(NSString *)headerTitle{
    _headerTitle = headerTitle;
    if(self.menuList){
        [self.menuList reloadData];
    }}

-(void) setFooterIcon:(NSString *)footerIcon{
    _footerIcon = footerIcon;
    [self.logoutImage setImage:[UIImage imageNamed:_footerIcon]];
}

-(void) setFooterTitle:(NSString *)footerTitle{
    _footerTitle = footerTitle;
    [self.logoutLabel setText:_footerTitle];
}

-(void) setMenuConfig:(DrawerContentConfig *)menuConfig{
    _menuConfig = menuConfig;
    if(self.menuList){
        [self.menuList reloadData];
    }
}


#pragma  mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }
    else{
        if(self.menuConfig){
            return self.menuConfig.labelList.count;

        }
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 20;
    }
    
    return 0;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* view =  [[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    long section = indexPath.section;
    
    if(section == 0){
        return 80;
    }
    else{
        return 40;
    }
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DrawerMenuItem"];
    if( cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:@"DrawerMenuItem"];
        
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    
    long section = indexPath.section;
   
    
    if(section == 0){
        cell.imageView.layer.cornerRadius = [cell.imageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height/2;
        cell.imageView.layer.masksToBounds = YES;
        if(self.headerIcon){
            [cell.imageView setImage:[UIImage imageNamed:self.headerIcon]];
        }
        if(self.headerTitle){
           [cell.textLabel setText:self.headerTitle] ;
        }
    }
    else{
        cell.imageView.layer.cornerRadius = 0;
        cell.imageView.layer.masksToBounds = YES;
        long row = indexPath.row;
        
        if (self.menuConfig){
//            [cell.imageView setImage:[UIImage imageNamed:self.menuConfig.iconList[row]]];
            [cell.textLabel setText:self.menuConfig.labelList[row]];
        }
        
    }
    return cell;
    
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate){
        long section = indexPath.section;
        NSInteger row = indexPath.row;
        
        if(section == 0){
            [self.delegate onHeaderSelect];
        }
        else{
            [self.delegate onListItemSelect:row];
        }
    }
}

@end
