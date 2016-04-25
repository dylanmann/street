//
//  ArticlePageViewController.m
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Responsible for carousel display; main screen allowing user to scroll through sections and articles

#import "ArticlePageViewController.h"
#import "ArticleViewController.h"
#import "Article.h"
#import "ArticleData.h"
#import <WebKit/WebKit.h>
#import "ThumbnailView.h"
#import "PopupViewController.h"
#import "MainArticleView.h"

@interface ArticlePageViewController () <UIPageViewControllerDataSource>

@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *screenTitle;

@end

@implementation ArticlePageViewController

int static startIndex = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 375, 603);
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:56.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;

    ArticleViewController *start = [self viewControllerAtIndex: startIndex];
    
    [self syncTitle: startIndex];
    
    [self.pageViewController setViewControllers:@[start] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    //handles the menu opening
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

//load the articleViewController before the current one
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    ArticleViewController *avc = (ArticleViewController *)viewController;
    
    [self syncTitle: avc.index];

    if ((avc.index == 0) || (avc.index == NSNotFound)) {
        return nil;
    }

    return [self viewControllerAtIndex:avc.index - 1];
}

//load the articleViewController after the current one
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    ArticleViewController *avc = (ArticleViewController *)viewController;
    
    [self syncTitle: avc.index];

    //Assumes 11 sections
    if ((avc.index == 11) || (avc.index == NSNotFound)) {
        return nil;
    }

    return [self viewControllerAtIndex:avc.index + 1];
}

//sync the title button to the current index we are on
- (void)syncTitle:(int) index {
    
    NSString *title = [ArticleData sharedInstance].sectionNames[index];
    title = [[title uppercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    
    [_screenTitle setTitle:title forState:UIControlStateNormal];
    
}

//load the view of the current index we are on
- (ArticleViewController *)viewControllerAtIndex:(int) index {
    
    CGFloat bottom = 0;
    
    ArticleViewController *avc = [[ArticleViewController alloc] init];
    avc.index = index;

    bottom += self.view.frame.size.height / 2;
    
    NSString *section;

    //pull the articles for a particular section
    section = [ArticleData sharedInstance].sectionNames[index];
    
    _screenTitle.titleLabel.numberOfLines = 1;
    _screenTitle.titleLabel.adjustsFontSizeToFitWidth = YES;
    _screenTitle.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    ArticleData* articleData = [ArticleData sharedInstance];
    NSArray *articlesInSection = [articleData articlesForSection:section];

    Article *a = (Article *) articlesInSection[0];

    MainArticleView *mainArticleView = [[MainArticleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 3 * self.view.frame.size.height/4) title:a.title image:a.image];
    mainArticleView.article = a;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentArticle:)];
    [mainArticleView addGestureRecognizer:tap];
    
    //create the thumbnail scroll bar with related articles
    UIScrollView *scrollBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 3 * self.view.frame.size.height/4, self.view.frame.size.width, self.view.frame.size.height/4)];
    
    scrollBar.pagingEnabled = YES;
    [scrollBar setContentSize:CGSizeMake(self.view.frame.size.width * MIN(6, ([articlesInSection count] - 1)) / 2, self.view.frame.size.height / 4)];

    for (int i = 1; i < MIN([articlesInSection count], 7); i++) {
        Article *article = articlesInSection[i];
        
        int offset = (i - 1) * self.view.frame.size.width / 2;
        ThumbnailView *thumbnail = [[ThumbnailView alloc] initWithFrame:CGRectMake(offset, 0, self.view.frame.size.width/2, self.view.frame.size.height/4) title:article.title image:article.image];
        thumbnail.article = article;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentArticle:)];
        
        [thumbnail addGestureRecognizer:tap];
        [scrollBar addSubview:thumbnail];
    }
    
    // insert teal rectangle here
    UIView *tealBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3 + 210, self.view.frame.size.width, self.view.frame.size.height/100)];
    tealBar.backgroundColor = [UIColor colorWithRed:56.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];

    [avc.view addSubview:mainArticleView];
    [avc.view addSubview:tealBar];
    [avc.view addSubview:scrollBar];

    return avc;
}

//when thumbnail clicked, open up a PopupViewController
- (void)presentArticle:(UITapGestureRecognizer *)sender {
    
    ThumbnailView* thumb = (ThumbnailView *)sender.view;
    Article* article = thumb.article;
    
    PopupViewController *vc = [[PopupViewController alloc] initWithArticle:article];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nc animated:YES completion:nil];
    
}

@end
