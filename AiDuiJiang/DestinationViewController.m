//
//  DestinationViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/10.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "DestinationViewController.h"
#import "SearchItem.h"

static NSString* const cellIdentifier = @"cell_id";

@interface DestinationViewController ()

@end

@implementation DestinationViewController {
    AMapSearchAPI *search;
    
    NSMutableArray *dataArray;
    
    UITableView *dataTableView;
    
    UITextField *searchField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.title = @"目的地";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = self.view.frame.size.width;
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 76.f, width, 1);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    
    UIView *view = [[UIView alloc] init];
    [view.layer addSublayer:border];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 64, width, 77.f);
    [self.view addSubview:view];
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, (77.f - 37.f) / 2.f, width - 2 * 10.f, 37)];
    
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.backgroundColor = [UIColor clearColor];
    searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchField.textColor = [UIColor colorWithRed:109.f / 255 green:176.f / 255 blue:79.f / 255 alpha:1.f];
    searchField.font = [UIFont systemFontOfSize:16.f];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.delegate = self;
    searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchField.leftView = [self getPaddingView];
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.layer.borderWidth = 1;
    searchField.layer.cornerRadius = 19.f;
    searchField.placeholder = @"请输入关键字";
    searchField.layer.borderColor = [[UIColor colorWithRed:54.0f/255 green:152.0f/255 blue:14.0f/255 alpha:1.0f] CGColor];
    
    [view addSubview:searchField];
    
    [AMapSearchServices sharedServices].apiKey = @"4363c3b646260c230109ff20b2a0ccac";
    
    search = [[AMapSearchAPI alloc] init];
    search.delegate = self;
    
    CGFloat y = view.frame.origin.y + view.frame.size.height + 1.f;
    dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, width, self.view.frame.size.height - y)
                                                 style:UITableViewStylePlain];
    dataTableView.backgroundColor = [UIColor clearColor];
    [dataTableView setSeparatorColor:[UIColor colorWithRed:225.0f/255 green:225.0f/255 blue:225.0f/255 alpha:1]];
    dataTableView.delegate = self;
    dataTableView.dataSource = self;
    [self.view addSubview:dataTableView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length == 0) {
        return YES;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = newString;
    
    [search AMapInputTipsSearch:tips];
    
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchItem *item = [dataArray objectAtIndex:indexPath.row];
    
    [dataTableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.delegate) {
        [self.delegate searchResult:item];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    SearchItem *item = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", item.name, item.district];
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    cell.textLabel.textColor = [UIColor colorWithRed:75.f/255 green:75.f/255 blue:75.f/255 alpha:1.f];
    
    return cell;
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }
    
    for (AMapPOI *poi in response.pois) {
        SearchItem *item = [[SearchItem alloc] init];
        item.name = poi.name;
        item.district = poi.district;
        item.location = poi.location;
        
        [dataArray addObject:item];
    }
    
    [dataTableView reloadData];
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    if (response.tips.count == 0) return;
    
    [dataArray removeAllObjects];
    for (AMapTip *tip in response.tips) {
        SearchItem *item = [[SearchItem alloc] init];
        item.name = tip.name;
        item.district = tip.district;
        item.location = tip.location;
        
        [dataArray addObject:item];
    }
    [dataTableView reloadData];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [searchField resignFirstResponder];

    NSString *key = searchField.text;
    if (!key && key.length == 0) {
        return NO;
    }
    
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = key;
    request.requireExtension = YES;
    [search AMapPOIKeywordsSearch:request];
    
    return NO;
}

- (UIView *)getPaddingView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20.f + 20.f, 37.f)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_search.png"]];
    imageView.frame = CGRectMake(10, (37.f - 20.f) / 2, 20.f, 20.f);
    [view addSubview:imageView];
    
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
