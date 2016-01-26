//
//  CityViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/26.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "CityViewController.h"
static NSString* const cellIdentifier = @"cell_id";

@implementation CityViewController {
    
    NSArray *cities;
    
    UITableView *cityTableView;
    
    NSString *province;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    cities = [self.cityData objectForKey:@"Cities"];
    
    province = [self.cityData objectForKey:@"State"];
    self.title = province;
    
    cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                                                 style:UITableViewStylePlain];
    cityTableView.backgroundColor = [UIColor clearColor];
    [cityTableView setSeparatorColor:[UIColor colorWithRed:225.0f/255 green:225.0f/255 blue:225.0f/255 alpha:1]];
    cityTableView.delegate = self;
    cityTableView.dataSource = self;
    [self.view addSubview:cityTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return cities.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dict = [cities objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"city"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.textColor = [UIColor colorWithRed:75.f/255 green:75.f/255 blue:75.f/255 alpha:1.f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [cityTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.delegate) {
        NSDictionary *dict = [cities objectAtIndex:indexPath.row];
        NSString *city = [dict objectForKey:@"city"];
        
        if ([province isEqualToString:@"直辖市"] || [province isEqualToString:@"特别行政区"]) {
            province = city;
        }
        NSString *value = [NSString stringWithFormat:@"%@-%@", province, city];
        NSDictionary *data = @{@"district" : value};
        [self.delegate sendDataBack:data];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
