//
//  InfoEditViewController.m
//  AiDuiJiang
//
//  Created by 陈吉诗 on 16/1/26.
//  Copyright © 2016年 liu. All rights reserved.
//

#import "InfoEditViewController.h"

@implementation InfoEditViewController {
    
    UITextField *editField;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.titleName;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44.f, 44.f)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0f] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(onSaveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    CGFloat width = self.view.frame.size.width;
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 76.f, width, 0.6f);
    border.backgroundColor = [UIColor colorWithRed:230.f / 255 green:230.f / 255 blue:230.f / 255 alpha:1.0f].CGColor;
    
    UIView *view = [[UIView alloc] init];
    [view.layer addSublayer:border];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 64, width, 77.f);
    [self.view addSubview:view];
    
    editField = [[UITextField alloc] initWithFrame:CGRectMake(10, (77.f - 37.f) / 2.f, width - 2 * 10.f, 37)];
    
    editField.clearButtonMode = UITextFieldViewModeWhileEditing;
    editField.backgroundColor = [UIColor clearColor];
    editField.autocorrectionType = UITextAutocorrectionTypeNo;
    editField.textColor = [UIColor colorWithRed:109.f / 255 green:176.f / 255 blue:79.f / 255 alpha:1.f];
    editField.font = [UIFont systemFontOfSize:16.f];
    editField.text = self.placeholder;
    editField.returnKeyType = UIReturnKeySearch;
    editField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    editField.leftViewMode = UITextFieldViewModeAlways;
    editField.layer.borderWidth = 1;
    editField.layer.cornerRadius = 19.f;
    editField.layer.borderColor = [[UIColor colorWithRed:54.0f/255 green:152.0f/255 blue:14.0f/255 alpha:1.0f] CGColor];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15.f, 15.f)];
    paddingView.backgroundColor = [UIColor clearColor];
    editField.leftView = paddingView;
    
    [view addSubview:editField];
}

- (void)onSaveButtonClicked {
    NSString *content = editField.text;
    if (content == nil || content.length == 0) return;
    
    if (self.delegate) {
        NSDictionary *data = @{self.keyName : content};
        [self.delegate sendDataBack:data];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
