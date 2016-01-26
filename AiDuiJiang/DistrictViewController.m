//
//  DistrictViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/26.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "DistrictViewController.h"
#import "CityViewController.h"

static NSString* const cellIdentifier = @"cell_id";

@implementation DistrictViewController {
    
    NSArray *provinces;
    
    UITableView *dataTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"地区";
    
    provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ProvincesAndCities.plist" ofType:nil]];
    
    dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                 style:UITableViewStylePlain];
    dataTableView.backgroundColor = [UIColor clearColor];
    [dataTableView setSeparatorColor:[UIColor colorWithRed:225.0f/255 green:225.0f/255 blue:225.0f/255 alpha:1]];
    dataTableView.delegate = self;
    dataTableView.dataSource = self;
    [self.view addSubview:dataTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return provinces.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = [provinces objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"State"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.textColor = [UIColor colorWithRed:75.f/255 green:75.f/255 blue:75.f/255 alpha:1.f];
    
    return cell;
}

- (void)sendDataBack:(NSDictionary *)dict {
    if (self.delegate) {
        [self.delegate sendDataBack:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [dataTableView deselectRowAtIndexPath:indexPath animated:NO];

    NSDictionary *dict = [provinces objectAtIndex:indexPath.row];
    CityViewController *viewController = [[CityViewController alloc] init];
    viewController.cityData = dict;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
