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
#import "ArticleData.h"
#import <WebKit/WebKit.h>

@interface ArticlePageViewController () <UIPageViewControllerDataSource>

@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *screenTitle;

@end

@implementation ArticlePageViewController

int static startIndex = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    
    ArticleViewController *start = [self viewControllerAtIndex: startIndex];
    [self syncTitle: startIndex];
    
    [self.pageViewController setViewControllers:@[start] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    NSLog(@"start page view load");

    //for menu control
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
    
}

+ (void) changeStartIndex: (int) index {
    startIndex = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    ArticleViewController *avc = (ArticleViewController *)viewController;
    
   [self syncTitle: avc.index];

    if ((avc.index == 0) || (avc.index == NSNotFound)) {
        return nil;
    }

    return [self viewControllerAtIndex:avc.index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    ArticleViewController *avc = (ArticleViewController *)viewController;
    
    [self syncTitle: avc.index];

    //Assumes 11 sections
    if ((avc.index == 11) || (avc.index == NSNotFound)) {
        return nil;
    }

    return [self viewControllerAtIndex:avc.index + 1];
}

- (void)syncTitle:(int) index {
    
    NSLog(@"changing title %d", index);
    
    if (index == 0) {
        [_screenTitle setTitle:@"Highbrow" forState:UIControlStateNormal];
    } else if (index == 1) {
        [_screenTitle setTitle:@"Word on the Street" forState:UIControlStateNormal];
    } else if (index == 2) {
        [_screenTitle setTitle:@"Ego" forState:UIControlStateNormal];
    }
    
}

- (ArticleViewController *)viewControllerAtIndex:(int) index {

    NSLog(@"PLS");
    
    CGFloat bottom = 0;
    
    ArticleViewController *avc = [[ArticleViewController alloc] init];
    avc.index = index;

    bottom += self.view.frame.size.height / 2;
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:30];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.frame = CGRectMake(0,self.view.frame.size.height/2,320,150);
    bottom += 300;
    NSURL *articleURL;
    NSString *section;
    
    //TODO: Also some issues with how the button's title changes. dumb fix for now.
    //Issue is because afterVC and beforeVC also call this method
    
    if (index == 0) {
        section = @"highbrow";
    } else if (index == 1) {
        section = @"word-on-the-street";
    } else if (index == 2) {
        section = @"ego";
    }
    
    _screenTitle.titleLabel.numberOfLines = 1;
    _screenTitle.titleLabel.adjustsFontSizeToFitWidth = YES;
    _screenTitle.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    ArticleData* articleData = [ArticleData sharedInstance];
    NSArray *articlesInSection = [articleData articlesForSection:section];
    
    //TODO: eventually will not be initializing article text and html in this place
    
    Article *a = (Article *) articlesInSection[0];
    
    label.text = a.title;
    NSURL *imageUrl = a.image;
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);

    articleURL = a.url;
    a = [[Article alloc] initWithURL:articleURL];

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
    
//     UIView *small = [[UIView alloc] initWithFrame:self.view.bounds];
//     [small addSubview:imageview];
//     [small addSubview:label];
//    
//     [avc.view addSubview:small];
    
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
