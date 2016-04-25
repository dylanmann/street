//
//  SearchViewController.m
//  street
//
//  Created by Jenny Chen on 4/25/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Uses code from Jason Hoffman
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

//TODO: NEEDS A BACK BUTTON SO CAN EXIT SEARCH

@implementation SearchViewController

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    [close setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont fontWithName:@"Effra" size:12.0], NSFontAttributeName,
                                   [UIColor blackColor], NSForegroundColorAttributeName,
                                   nil]
                         forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:close];
    
    [self.view setBackgroundColor: [UIColor colorWithRed:56.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1]];
    
    NSString *script = @"<script>\
    (function() {\
        var cx = '012007667445641334091:4gqr8mbajym';\
        var gcse = document.createElement('script');\
        gcse.type = 'text/javascript';\
        gcse.async = true;\
        gcse.src = 'https://www.google.com/cse/cse.js?cx=' + cx;\
        var s = document.getElementsByTagName('script')[0];\
        s.parentNode.insertBefore(gcse, s);\
    })();\
    </script>\
    <gcse:search></gcse:search>";
    
    NSString *htmlToRender = [NSString stringWithFormat: @"<head> <meta name=\"viewport\" content=\"user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi\" </head><span id=toplevel style=\"font-family: %@; font-size: 20\"><body><div>%@</div></body></span>", @"Helvetica Neue", script];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height) configuration:config];
    webview.navigationDelegate = self;
    [webview loadHTMLString:htmlToRender baseURL:NULL];
    webview.allowsBackForwardNavigationGestures = false;
    
    [self.view addSubview:webview];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler

{
    NSURL *url = navigationAction.request.URL;
    
    if (navigationAction.navigationType != 0) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    if ([url.host isEqualToString:@"www.34st.com"]) {
        Article* article  = [[[Article alloc] init] initWithURL: url];
        PopupViewController *vc = [[PopupViewController alloc] initWithArticle:article];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    
        //   only open in Safari if link is clicked and is not from 34st
    } else if (navigationAction.navigationType == 0) {
            [webView loadRequest:navigationAction.request];
    }

    [webView loadRequest:navigationAction.request];
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    Article* article  = [[[Article alloc] init] initWithURL: webView.URL];
    PopupViewController *vc = [[PopupViewController alloc] initWithArticle:article];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSMutableArray *newViewControllers = [NSMutableArray array];
    
    // preserve the root view controller
    [newViewControllers addObject:[viewControllers objectAtIndex:0]];
    // add the new view controller
    [newViewControllers addObject:vc];
    // animatedly change the navigation stack
    [self.navigationController setViewControllers:newViewControllers animated:YES];
}
@end

