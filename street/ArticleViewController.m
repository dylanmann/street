//
//  ArticleViewController.m
//  street
//
//  Created by Graham Mosley on 2/20/16.
//  Copyright © 2016 Graham Mosley. All rights reserved.
//

#import "ArticleViewController.h"
#import <WebKit/WebKit.h>

#import "Ono.h"

@interface ArticleViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create a NSLURL that points to an article and grab the HTML
    NSURL *articleURL = [NSURL URLWithString:@"http://www.34st.com/article/2016/02/paul-is-alive"];
    NSString *articleHTML = [NSString stringWithContentsOfURL:articleURL encoding:NSUTF8StringEncoding error:NULL];
    
    // Use Ono to parse the document for the article-text HTML
    ONOXMLDocument* document = [ONOXMLDocument HTMLDocumentWithString:articleHTML encoding:NSUTF8StringEncoding error:NULL];
    
    // Add every article-text div to a string
    NSMutableString *stuffToRender = [[NSMutableString alloc] init];
    [document enumerateElementsWithXPath:@"//div[@class=\"article-text\"]" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        [stuffToRender appendString: [element description]];
    }];
    
    // Create a webview from the parsed HTML
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    self.webview = [[WKWebView alloc] initWithFrame:self.view.frame configuration:config];
    
    // Render the parsed HTML in a WKView
    [self.webview loadHTMLString:stuffToRender baseURL:NULL];
    
    [self.view addSubview:self.webview];
    
    // clearly this will all go into it's own class
    
    // all articles can be scraped from this URL
    NSURL *articlesURL = [NSURL URLWithString:@"http://www.34st.com/section/essentials"];
    NSString *articlesHTML = [NSString stringWithContentsOfURL:articlesURL encoding:NSUTF8StringEncoding error:NULL];
    
    ONOXMLDocument* articlesDoc = [ONOXMLDocument HTMLDocumentWithString:articlesHTML encoding:NSUTF8StringEncoding error:NULL];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yy hh:mma";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    // for each article, parse information
    NSString *articlesXPath = @"//article[@class = 'standard hidden-xs']/div[@class = 'media']";
    [articlesDoc enumerateElementsWithXPath:articlesXPath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSString *aTitle = [element firstChildWithXPath:@"./div/h4/a"].stringValue;
        NSString *aURL = [element firstChildWithXPath:@"./div/h4/a/@href"].stringValue;
        
        NSString *aDateString = [element firstChildWithXPath:@"./div/aside/p/span[2]"].stringValue;
        NSString *aAuthorWithoutTrim = [element firstChildWithXPath:@"./div/aside/p/span[1]"].stringValue;
        
        NSString *aAuthor = [aAuthorWithoutTrim stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *aAbstract = [element firstChildWithXPath:@"./div/p[not(contains(@class, \" \"))]"].stringValue;
        
        NSString *aImage = [element firstChildWithXPath:@"./a/div/img/@src"].stringValue;
        
        NSDate *aDate = [dateFormatter dateFromString:aDateString];
        
        NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n\n", aTitle, aURL, aAuthor, aDate, aImage, aAbstract);
        
        
    }];

    //other helpful stuff we used in testing
    //NSURL *url = [NSURL URLWithString:@"http://www.34st.com"];
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //[self.webview loadRequest:request];
    
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
