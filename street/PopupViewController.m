//
//  PopupViewController.m
//  street
//
//  Created by Graham Mosley on 3/25/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//

#import "PopupViewController.h"
#import "Article.h"
#import <WebKit/WebKit.h>

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
}
- (id)initWithArticle:(Article *)article {
    if (self = [super init]) {
        _article = article;
    }
    
    return self;
}

// a hacky way of getting the navigation controller to work. need to fix in the next iteration
- (void)dismiss {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    fontSize = 40;
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"BACK" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    [close setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"Effra" size:12.0], NSFontAttributeName,
                                        [UIColor blackColor], NSForegroundColorAttributeName,
                                        nil] 
                              forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:close];
    

    // this is used to keep track of the current y position of the content
    bottom = 0;
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:_article.image]];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
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

    NSMutableString* htmlToRender = [[_article articleContent] mutableCopy];
    htmlToRender = [NSMutableString stringWithFormat:@"<span id=toplevel style=\"font-family: %@; font-size: %i\">%@</span>", @"Helvetica Neue", fontSize, htmlToRender];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, bottom, self.view.frame.size.width, self.view.frame.size.height - bottom) configuration:config];
    
    
    [webview loadHTMLString:htmlToRender baseURL:NULL];
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL
                          URLWithString:@"https://www.facebook.com/FacebookDevelopers"];
    FBSDKShareButton *shareButton = [[FBSDKShareButton alloc] init];
    shareButton.shareContent = content;
    shareButton.center = CGPointMake(self.view.center.x - 30, self.view.center.y);
    
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [minusButton setBackgroundColor:[UIColor grayColor]];
    [minusButton setFrame:CGRectMake(self.view.center.x + 20, self.view.center.y - 15, 30, 30)];
    [minusButton setTitle:@"-" forState:UIControlStateNormal];
    [minusButton addTarget:self action:@selector(decreaseTextSize) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [plusButton setBackgroundColor:[UIColor grayColor]];
    [plusButton setFrame:CGRectMake(self.view.center.x + 55, self.view.center.y - 15, 30, 30)];
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
    [self.view addSubview:scrollView];
    
    // fix content size issue by adding observers for contentsize
    [webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)increaseTextSize {
    fontSize = MIN(fontSize + 10, 90);
    [self changeText];
}

- (void)decreaseTextSize {
    fontSize = MAX(fontSize - 10, 20);
    [self changeText];
}

- (void)changeText {
    NSString *js = [NSString stringWithFormat:@"document.getElementById(\"toplevel\").style.fontSize = %i", fontSize];
    [webview evaluateJavaScript:js completionHandler:NULL];
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
    if (object == webview.scrollView && [keyPath isEqual:@"contentSize"]) {
        CGSize size = scrollView.frame.size;
        [scrollView setContentSize: CGRectMake(0, 0, size.width, bottom + webview.scrollView.contentSize.height).size];
        [webview setFrame:CGRectMake(0, bottom, size.width, webview.scrollView.contentSize.height)];
        webview.scrollView.scrollEnabled = NO;
    }
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