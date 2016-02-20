//
//  ArticleViewController.m
//  street
//
//  Created by Graham Mosley on 2/20/16.
//  Copyright © 2016 Graham Mosley. All rights reserved.
//

#import "ArticleViewController.h"
#import <WebKit/WebKit.h>

@interface ArticleViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.34st.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    self.webview = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    
    [self.webview loadRequest:request];
    
    [self.view addSubview:self.webview];
    
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
