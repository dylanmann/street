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
#import <AFNetworking/UIImageView+AFNetworking.h>

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
    
    fontSize = 20;
    
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
    UIImageView *imageview = [[UIImageView alloc] init];
    [imageview setImageWithURL:_article.image];
    
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

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    webview = [[WKWebView alloc] initWithFrame:CGRectMake(10, bottom, self.view.frame.size.width - 20, self.view.frame.size.height - bottom) configuration:config];
    
    
    webview.navigationDelegate = self;
    webview.allowsBackForwardNavigationGestures = false;;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // html head tags to disable zooming, and also a span to enable fontsize changes.
        NSMutableString* htmlToRender = [[_article articleContent] mutableCopy];
        
        NSString *htmlImmutable = [htmlToRender stringByReplacingOccurrencesOfString:@"f.jpg" withString:@"t.jpg"];
        htmlImmutable = [htmlImmutable stringByReplacingOccurrencesOfString:@"f.JPG" withString:@"t.JPG"];
        
        NSString *yourString = htmlImmutable;
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"width: \\d+px;" options:NSRegularExpressionCaseInsensitive error:&error];
        NSString *modifiedString = [regex stringByReplacingMatchesInString:yourString options:0 range:NSMakeRange(0, [yourString length]) withTemplate:@"width: 100%;"];
        
        htmlToRender = [NSMutableString stringWithFormat:@"<head> <meta name=\"viewport\" content=\"user-scalable=no, initial-scale=1, maximum-scale=1, minimum-scale=1, width=device-width, height=device-height, target-densitydpi=device-dpi\" </head><span id=toplevel style=\"font-family: %@; font-size: %i\"><body>%@</body></span>", @"Helvetica Neue", fontSize, modifiedString];
        
        [webview loadHTMLString:htmlToRender baseURL:NULL];

    });
    
    //set up Facebook share link
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton addTarget:self action:@selector(shareToFacebook) forControlEvents:UIControlEventTouchUpInside];
    [facebookButton setFrame:CGRectMake(self.view.center.x, self.view.center.y - 12, 85, 34)];
    [facebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [facebookButton setImage:[UIImage imageNamed:@"facebook_button"] forState:UIControlStateNormal];
    facebookButton.center = CGPointMake(self.view.center.x - 90, self.view.center.y);
    
    //set up Twitter share link
    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterButton addTarget:self action:@selector(shareToTwitter) forControlEvents:UIControlEventTouchUpInside];
    [twitterButton setFrame:CGRectMake(self.view.center.x, self.view.center.y - 12, 85, 34)];
    [twitterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [twitterButton setImage:[UIImage imageNamed:@"tweet_button"] forState:UIControlStateNormal];
    twitterButton.center = CGPointMake(self.view.center.x, self.view.center.y);
    
    //set up ability to change font size
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [minusButton setBackgroundColor:[UIColor colorWithRed:56.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1]];
    [minusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [minusButton setFrame:CGRectMake(self.view.center.x + 48, self.view.center.y - 15, 30, 30)];
    [minusButton setTitle:@"A" forState:UIControlStateNormal];
    minusButton.titleLabel.font = [UIFont systemFontOfSize:12 weight:0.45];
    [minusButton addTarget:self action:@selector(decreaseTextSize) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [plusButton setBackgroundColor:[UIColor colorWithRed:56.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1]];
    [plusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [plusButton setFrame:CGRectMake(self.view.center.x + 82, self.view.center.y - 15, 30, 30)];
    [plusButton setTitle:@"A" forState:UIControlStateNormal];
    plusButton.titleLabel.font = [UIFont systemFontOfSize:27 weight:0.5];
    [plusButton addTarget:self action:@selector(increaseTextSize) forControlEvents:UIControlEventTouchUpInside];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView addSubview:imageview];
    [scrollView addSubview:label];
    [scrollView addSubview:webview];
    [scrollView setContentSize:CGRectMake(0, 0, self.view.frame.size.width, bottom).size];
    
    [scrollView addSubview:minusButton];
    [scrollView addSubview:plusButton];
    [scrollView addSubview:facebookButton];
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
    fontSize = MIN(fontSize + 10, 40);
    [self changeText];
}

- (void)decreaseTextSize {
    NSValue *correctSize = [NSValue valueWithCGSize:scrollView.contentSize];
    [sizes setObject:correctSize forKey: [NSNumber numberWithInt:fontSize]];
    fontSize = MAX(fontSize - 10, 20);
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

-(void)shareToFacebook {
    NSString *facebookShareURLString = [NSString stringWithFormat:@"https://www.facebook.com/sharer/sharer.php?u=%@", [_article.url absoluteString]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebookShareURLString]];
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