//
//  SearchViewController.m
//  street
//
//  Created by Dylan Mann on 4/25/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Uses code from Jason Hoffman
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

// This is the View Controller that handles search within the app and is shown whenever the search button is pressed from the home page
@implementation SearchViewController

//method called when close button is clicked
- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

// method called when view controller is presented
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //intialize navigationController bar as teal with proper format=
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:56.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
    
    // create close button
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    [close setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont fontWithName:@"Effra" size:12.0], NSFontAttributeName,
                                   [UIColor whiteColor], NSForegroundColorAttributeName,
                                   nil]
                         forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:close];
    
    // initialize title for menu bar
    UILabel *title = [[UILabel alloc] init];
    title.text = @"SEARCH";
    title.font = [UIFont fontWithName:@"Effra" size:24];
    title.textColor = [UIColor whiteColor];
    [title sizeToFit];
    title.numberOfLines = 1;
    title.adjustsFontSizeToFitWidth=YES;
    title.lineBreakMode = NSLineBreakByClipping;
    [self.navigationItem setTitleView:title];
    
    // 34st teal/turquise color
    [self.view setBackgroundColor: [UIColor colorWithRed:56.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1]];
    
    // script for loading google custom search in the view
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
    
    // formatted and tagged html to provide optimal user viewing experience.
    NSString *htmlToRender = [NSString stringWithFormat: @"<head> <meta name=\"viewport\" content=\"user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi\" </head><span id=toplevel style=\"font-family: %@; font-size: 20\"><body><div>%@</div></body></span>", @"Helvetica Neue", script];
    
    //initializing the webview which forms the base for the view controller
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width - 10, self.view.frame.size.height - 5) configuration:config];
    [webview.scrollView setContentSize:self.view.frame.size];
    webview.scrollView.scrollEnabled = NO;
    webview.navigationDelegate = self;
    [webview loadHTMLString:htmlToRender baseURL:NULL];
    webview.allowsBackForwardNavigationGestures = false;
    
    [self.view addSubview:webview];
}

// method called when user clicks on a link
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = navigationAction.request.URL;
    
    // if navigation is not a link clicked, allow
    if (navigationAction.navigationType != WKNavigationTypeLinkActivated) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    // if the url is from 34st.com, allow the navigation and load in a PopupViewController
    if ([url.host isEqualToString:@"www.34st.com"]) {
        Article* article  = [[[Article alloc] init] initWithURL: url];
        PopupViewController *vc = [[PopupViewController alloc] initWithArticle:article];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }
    // otherwise load request (it takes you to a google search result and redirects, allowing didRecieveServerRedirect to activate
    [webView loadRequest:navigationAction.request];
    decisionHandler(WKNavigationActionPolicyAllow);
}

// called when google redirects the webview back to 34st.com after getting analytics
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    // initialize PopupViewController
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

