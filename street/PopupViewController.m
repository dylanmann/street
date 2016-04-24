//
//  PopupViewController.m
//  street
//
//  Created by Graham Mosley on 3/25/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Responsible for actually displaying the article when a thumbnail is pressed

#import "PopupViewController.h"
#import "Article.h"
#import <WebKit/WebKit.h>
#import <Social/Social.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface PopupViewController ()

@property (nonatomic, strong) Article *article;

@end

@implementation PopupViewController

{
    int fontSize;
    WKWebView *webview;
    UIScrollView *scrollView;
    CGFloat bottom;
    NSMutableDictionary *sizes;
    BOOL manual;
    UIImage *image;
}
- (id)initWithArticle:(Article *)article {
    if (self = [super init]) {
        _article = article;
    }
    
    return self;
}

- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    fontSize = 40;
    
    //create and set the action of the close button
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    [close setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Effra" size:12.0], NSFontAttributeName,
                                        [UIColor blackColor], NSForegroundColorAttributeName,
                                        nil] 
                              forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:close];
    

    // this is used to keep track of the current y position of the content
    bottom = 0;
    
    // used for memoization of contentsizes for the webview so that recalculation is unnecessary
    sizes = [NSMutableDictionary dictionary];
    manual = FALSE;
    
    //set up and load the article text, image, and title
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_article.image]];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height/2);
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    
    bottom += self.view.frame.size.height / 2;
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Effra" size:24];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.frame = CGRectMake(0, bottom, self.view.frame.size.width, 100);
    [label setText:[_article.title uppercaseString]];
    bottom += 100;
    
    UILabel *title = [[UILabel alloc] init];
    title.text = label.text;
    title.font = [UIFont fontWithName:@"Effra" size:24];
    [title sizeToFit];
    
    title.numberOfLines = 1;
    title.adjustsFontSizeToFitWidth=YES;
    title.lineBreakMode = NSLineBreakByClipping;
    
    [self.navigationItem setTitleView:title];

    // html head tags to disable zooming, and also a span to enable fontsize changes.
    NSMutableString* htmlToRender = [[_article articleContent] mutableCopy];
    htmlToRender = [NSMutableString stringWithFormat:@"<head <meta name=\"viewport\" content=\"user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi\" /><span id=toplevel style=\"font-family: %@; font-size: %i\">%@</span>", @"Helvetica Neue", fontSize, htmlToRender];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    webview = [[WKWebView alloc] initWithFrame:CGRectMake(10, bottom, self.view.frame.size.width - 20, self.view.frame.size.height - bottom) configuration:config];
    
    [webview loadHTMLString:htmlToRender baseURL:NULL];
    webview.navigationDelegate = self;
    webview.allowsBackForwardNavigationGestures = false;;
    
    
    //set up Facebook share link
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = _article.url;
    FBSDKShareButton *shareButton = [[FBSDKShareButton alloc] init];
    shareButton.shareContent = content;
    shareButton.center = CGPointMake(self.view.center.x - 83, self.view.center.y);
    
    //set up Twitter share link
    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterButton addTarget:self action:@selector(shareToTwitter) forControlEvents:UIControlEventTouchUpInside];
    [twitterButton setFrame:CGRectMake(self.view.center.x, self.view.center.y - 12, 85, 34)];
    [twitterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [twitterButton setImage:[UIImage imageNamed:@"tweet_button"] forState:UIControlStateNormal];
    twitterButton.center = CGPointMake(self.view.center.x, self.view.center.y);
    
    //set up ability to change font size
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [minusButton setBackgroundColor:[UIColor colorWithRed:41.0/255.0 green:150.0/255.0 blue:178.0/255.0 alpha:1]];
    [minusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [minusButton setFrame:CGRectMake(self.view.center.x + 48, self.view.center.y - 15, 30, 30)];
    [minusButton setTitle:@"-" forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(decreaseTextSize) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [plusButton setBackgroundColor:[UIColor colorWithRed:41.0/255.0 green:150.0/255.0 blue:178.0/255.0 alpha:1]];
    [plusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [plusButton setFrame:CGRectMake(self.view.center.x + 82, self.view.center.y - 15, 30, 30)];
    [plusButton setTitle:@"+" forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(increaseTextSize) forControlEvents:UIControlEventTouchUpInside];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView addSubview:imageview];
    [scrollView addSubview:label];
    [scrollView addSubview:shareButton];
    [scrollView addSubview:webview];
    [scrollView setContentSize:CGRectMake(0, 0, self.view.frame.size.width, bottom).size];
    
    [scrollView addSubview:minusButton];
    [scrollView addSubview:plusButton];
    [scrollView addSubview:twitterButton];

    [self.view addSubview:scrollView];
    
    scrollView.maximumZoomScale = 1.0;
    scrollView.minimumZoomScale = 1.0;
    webview.scrollView.maximumZoomScale = 1.0;
    webview.scrollView.minimumZoomScale = 1.0;
    
    // fix content size issue by adding observers for contentsize
    [webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)increaseTextSize {
    NSValue *correctSize = [NSValue valueWithCGSize:scrollView.contentSize];
    [sizes setObject:correctSize forKey: [NSNumber numberWithInt:fontSize]];
    fontSize = MIN(fontSize + 10, 90);
    [self changeText];
}

- (void)decreaseTextSize {
    NSValue *correctSize = [NSValue valueWithCGSize:scrollView.contentSize];
    [sizes setObject:correctSize forKey: [NSNumber numberWithInt:fontSize]];
    fontSize = MAX(fontSize - 10, 40);
    [self changeText];
}

- (void)changeText {
    manual = FALSE;
    NSString *js = [NSString stringWithFormat:@"document.getElementById(\"toplevel\").style.fontSize = %i", fontSize];
    [webview evaluateJavaScript:js completionHandler:NULL];
    
    NSValue *correctSize = [sizes objectForKey: [NSNumber numberWithInt:fontSize]];
    if (correctSize != nil)
    {
        manual = TRUE;
        [scrollView setContentSize:[correctSize CGSizeValue]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == webview.scrollView && [keyPath isEqual:@"contentSize"] && !manual) {
        CGSize size = scrollView.frame.size;
        [scrollView setContentSize: CGRectMake(0, 0, size.width, bottom + webview.scrollView.contentSize.height).size];
        [webview setFrame:CGRectMake(0, bottom, size.width, webview.scrollView.contentSize.height)];
        webview.scrollView.scrollEnabled = NO;
    }
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
       // TODO: add random stuff (e.g. title, image, etc.) associated with the article
        PopupViewController *vc = [[PopupViewController alloc] initWithArticle:article];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
        
    //only open in Safari if link is clicked and is not from 34st
    } else if (navigationAction.navigationType == 0) {
        [[UIApplication sharedApplication] openURL: url];
    }
    
     decisionHandler(WKNavigationActionPolicyCancel);
}

-(void)shareToTwitter {
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:[NSString stringWithFormat:@"Check out %@ at 34st.com!", _article.title]];
    [tweetSheet addURL: _article.url];
    [tweetSheet addImage: image];
    [self presentViewController:tweetSheet animated:YES completion:nil];
}

- (void)dealloc
{
    [webview.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
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