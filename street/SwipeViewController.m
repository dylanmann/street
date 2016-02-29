//
//  iCarouselExampleViewController.m
//  iCarouselExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 Charcoal Design. All rights reserved.
//

#import "SwipeViewController.h"
#import "Article.h"
#import <WebKit/WebKit.h>

@interface SwipeViewController () <SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic) IBOutlet SwipeView* swipeView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) WKWebView *webview;
@property (nonatomic) WKWebView *webview2;

@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@end


@implementation SwipeViewController

- (void)awakeFromNib
{
    //set up data
    //your swipeView should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    self.items = [NSMutableArray array];
    for (int i = 0; i < 2; i++)
    {
        [_items addObject:@(i)];
    }

}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    _swipeView.delegate = nil;
    _swipeView.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
    //configure swipeView
    _swipeView.pagingEnabled = YES;
    
    NSURL *articleURL = [NSURL URLWithString:@"http://www.34st.com/article/2016/02/paul-is-alive"];
    Article *a = [[Article alloc] initWithURL:articleURL];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    _webview = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    [_webview loadHTMLString:a.articleHTML baseURL:NULL];
    
    WKWebViewConfiguration *config2 = [[WKWebViewConfiguration alloc] init];
    _webview2 = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    [_webview2 loadHTMLString:a.articleHTML baseURL:NULL];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return [_items count];
}

- (void)viewDidAppear:(BOOL)animated { [super viewDidAppear:animated];
    //delay until next runloop cycle
    dispatch_async(dispatch_get_main_queue(), ^{ [self.swipeView reloadItemAtIndex:0]; });
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSLog(@"ASDFADS loading");
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        
        label.frame = CGRectMake(0,view.frame.size.height-300,320,300);
        label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
//        [view addSubview:label];
        if (index == 0)
            [view addSubview:_webview];
        else
            [view addSubview:_webview2];
        
//        

//        self.webview = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
//        
//            // Render the parsed HTML in a WKView
//            [self.webview loadHTMLString:stuffToRender baseURL:NULL];
//        
//            [self.view addSubview:self.webview];

        
        
        //http://www.34st.com/article/2016/02/penns-most-eligible-bachelorettes
        //http://www.34st.com/article/2016/02/how-to-get-on-the-ivy-league-snap-story
        //http://www.34st.com/article/2016/02/see-and-be-scene
        //http://www.34st.com/article/2016/02/its-snowing-men
        //http://www.34st.com/article/2016/02/food-boy-shrimp-scampi
        
        
        //    NSString *articleHTML = [NSString stringWithContentsOfURL:articleURL encoding:NSUTF8StringEncoding error:NULL];
        //
        //    // Use Ono to parse the document for the article-text HTML
        //    ONOXMLDocument* document = [ONOXMLDocument HTMLDocumentWithString:articleHTML encoding:NSUTF8StringEncoding error:NULL];
        //
        //    // Add every article-text div to a string
        //    NSMutableString *stuffToRender = [[NSMutableString alloc] init];
        //    [document enumerateElementsWithXPath:@"//div[@class=\"article-text\"]" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        //        [stuffToRender appendString: [element description]];
        //    }];
        //
        //    // Create a webview from the parsed HTML
        //    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        //    self.webview = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
        //
        //    // Render the parsed HTML in a WKView
        //    [self.webview loadHTMLString:stuffToRender baseURL:NULL];
        //
        //    [self.view addSubview:self.webview];
        //
        //    // clearly this will all go into it's own class
        //
        //    // all articles can be scraped from this URL
        //    NSURL *articlesURL = [NSURL URLWithString:@"http://www.34st.com/section/essentials"];
        //    NSString *articlesHTML = [NSString stringWithContentsOfURL:articlesURL encoding:NSUTF8StringEncoding error:NULL];
        //
        //    ONOXMLDocument* articlesDoc = [ONOXMLDocument HTMLDocumentWithString:articlesHTML encoding:NSUTF8StringEncoding error:NULL];
        //
        //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //    dateFormatter.dateFormat = @"MM/dd/yy hh:mma";
        //    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        //
        //    // for each article, parse information
        //    NSString *articlesXPath = @"//article[@class = 'standard hidden-xs']/div[@class = 'media']";
        //    [articlesDoc enumerateElementsWithXPath:articlesXPath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        //        NSString *aTitle = [element firstChildWithXPath:@"./div/h4/a"].stringValue;
        //        NSString *aURL = [element firstChildWithXPath:@"./div/h4/a/@href"].stringValue;
        //
        //        NSString *aDateString = [element firstChildWithXPath:@"./div/aside/p/span[2]"].stringValue;
        //        NSString *aAuthorWithoutTrim = [element firstChildWithXPath:@"./div/aside/p/span[1]"].stringValue;
        //
        //        NSString *aAuthor = [aAuthorWithoutTrim stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //
        //        NSString *aAbstract = [element firstChildWithXPath:@"./div/p[not(contains(@class, \" \"))]"].stringValue;
        //
        //        NSString *aImage = [element firstChildWithXPath:@"./a/div/img/@src"].stringValue;
        //
        //        NSDate *aDate = [dateFormatter dateFromString:aDateString];
        //
        //        NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n\n", aTitle, aURL, aAuthor, aDate, aImage, aAbstract);
        //
        //
        //    }];
        //
        //other helpful stuff we used in testing
        //NSURL *url = [NSURL URLWithString:@"http://www.34st.com"];
        //NSURLRequest *request = [NSURLRequest requestWithURL:url];
        //[self.webview loadRequest:request];
    }
    else
    {
        //get a reference to the label in the recycled view
        label = (UILabel *)[view viewWithTag:0];
    }

    //set background color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    view.backgroundColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"roundup.png"]]];
    
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    //label.text = [_items[index] stringValue];
    label.text = @"ESSENTIALS \n The Roundup \n 2.22.16";
    
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}

@end
