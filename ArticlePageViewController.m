//
//  ArticlePageViewController.m
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//

#import "ArticlePageViewController.h"
#import "ArticleViewController.h"
#import "Article.h"
#import <WebKit/WebKit.h>

@interface ArticlePageViewController () <UIPageViewControllerDataSource>

@property (nonatomic) UIPageViewController *pageViewController;

@end

@implementation ArticlePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    
    ArticleViewController *start = [self viewControllerAtIndex:0];
    
    [self.pageViewController setViewControllers:@[start] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    NSLog(@"start page view load");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    ArticleViewController *avc = (ArticleViewController *)viewController;
    if (avc.index == 1) {
        return [self viewControllerAtIndex:0];
    } else {
        return nil;
    }
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    ArticleViewController *avc = (ArticleViewController *)viewController;
    if (avc.index == 1) {
        return nil;
    } else {
        return [self viewControllerAtIndex:1];
    }
}

- (ArticleViewController *)viewControllerAtIndex:(int) index {

    CGFloat bottom = 0;
    
    ArticleViewController *avc = [[ArticleViewController alloc] init];
    avc.index = index;
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roundup.png"]];
    imageview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
    
    bottom += self.view.frame.size.height / 2;
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:50];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.frame = CGRectMake(0,self.view.frame.size.height-300,320,300);
    bottom += 300;
    NSURL *articleURL;
    
    if (index == 0) {
        label.text = @"ESSENTIALS \n The Roundup \n 2.22.16";
        articleURL = [NSURL URLWithString:@"http://www.34st.com/article/2016/02/round-up-02-25-16"];
    } else {
        label.text = @"Quiz: Which Member of the Beatles are You?";
        articleURL = [NSURL URLWithString:@"http://www.34st.com/article/2016/02/paul-is-alive"];
    }
    Article *a = [[Article alloc] initWithURL:articleURL];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, bottom, self.view.frame.size.width, 500) configuration:config];
    [webview loadHTMLString:a.articleHTML baseURL:NULL];
    bottom += webview.bounds.size.height;
    
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [sv addSubview:imageview];
    [sv addSubview:label];
    [sv addSubview:webview];
    [sv setContentSize:CGRectMake(0, 0, self.view.frame.size.width, bottom).size];
    
    [avc.view addSubview:sv];
    
    return avc;
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
