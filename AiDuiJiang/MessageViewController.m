//
//  MessageViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/27.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageItemCell.h"
#import "MessageItem.h"
#import "UIImageView+WebCache.h"
#import "UserInfo.h"

static NSString* const cellIdentifier = @"cell_id";

@implementation MessageViewController {
    
    UITableView *msgTableView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新的车友";
    
    msgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                 style:UITableViewStylePlain];
    msgTableView.backgroundColor = [UIColor whiteColor];
    [msgTableView setSeparatorColor:[UIColor colorWithRed:225.0f/255 green:225.0f/255 blue:225.0f/255 alpha:1]];
    msgTableView.delegate = self;
    msgTableView.dataSource = self;
    [self.view addSubview:msgTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray == nil ? 0 : self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[MessageItemCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    MessageItem *message = [self.dataArray objectAtIndex:indexPath.row];
    UserInfo *info = message.userInfo;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:info.avatar]
                      placeholderImage:[UIImage imageNamed:@"ic_nav.png"]];
    
    NSString *msg = message.msg;
    NSString *tip = [NSString stringWithFormat:@"%@请求添加我为好友", info.nickname];
    if (msg && msg.length > 0) {
        tip = [NSString stringWithFormat:@"%@%@", info.nickname, msg];
    }
    
    cell.textLabel.text = tip;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [msgTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
