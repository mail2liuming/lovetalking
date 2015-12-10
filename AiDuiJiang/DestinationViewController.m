//
//  DestinationViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 15/12/10.
//  Copyright © 2015年 liu. All rights reserved.
//

#import "DestinationViewController.h"

@interface DestinationViewController ()

@end

@implementation DestinationViewController {
    AMapSearchAPI *search;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"目的地";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    CGFloat width = self.view.frame.size.width;
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 76.f, width, 1);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    
    UIView *view = [[UIView alloc] init];
    [view.layer addSublayer:border];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 64, width, 77.f);
    [self.view addSubview:view];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, (77.f - 37.f) / 2.f, width - 2 * 10.f, 37)];
    
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = [UIColor clearColor];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.textColor = [UIColor colorWithRed:109.f / 255 green:176.f / 255 blue:79.f / 255 alpha:1.f];
    textField.font = [UIFont systemFontOfSize:16.f];
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.leftView = [self getPaddingView];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 19.f;
    textField.placeholder = @"请输入关键字";
    textField.layer.borderColor = [[UIColor colorWithRed:54.0f/255 green:152.0f/255 blue:14.0f/255 alpha:1.0f] CGColor];
    
    [view addSubview:textField];
    
    [AMapSearchServices sharedServices].apiKey = @"4363c3b646260c230109ff20b2a0ccac";
    
    search = [[AMapSearchAPI alloc] init];
    search.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length == 0) {
        return YES;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = newString;
    NSLog(@"here");
    
    [search AMapInputTipsSearch:tips];
    
    return YES;
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    if (response.tips.count == 0) return;
    
    NSLog(@"******* count %d *******", response.tips.count);
    for (AMapTip *p in response.tips) {
        NSLog(@"uid %@, name %@, adcode %@, district %@", p.uid, p.name, p.adcode, p.district);
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"should return");
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
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
