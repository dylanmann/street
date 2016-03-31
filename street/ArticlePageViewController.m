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
#import "ThumbnailView.h"
#import "PopupViewController.h"

@interface ArticlePageViewController () <UIPageViewControllerDataSource>

@property (nonatomic) UIPageViewController *pageViewController;
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *screenTitle;

@end

@implementation ArticlePageViewController

int static startIndex = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/255.0 green:150.0/255.0 blue:178.0/255.0 alpha:1];
    //self.navigationController.navigationBar.titleTextAttributes
    //self.navigationController.navigationBar.translucent = YES;

    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;

    ArticleViewController *start = [self viewControllerAtIndex: startIndex];
     
    [self syncTitle: startIndex];
    
    [self.pageViewController setViewControllers:@[start] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    self.pageViewController.view.frame = self.view.bounds;
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

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
    
    NSString *title = [ArticleData sharedInstance].sectionNames[index];
    title = [[title uppercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@" "];
    
    [_screenTitle setTitle:title forState:UIControlStateNormal];
    
}

- (ArticleViewController *)viewControllerAtIndex:(int) index {
    
    CGFloat bottom = 0;
    
    ArticleViewController *avc = [[ArticleViewController alloc] init];
    avc.index = index;

    bottom += self.view.frame.size.height / 2;
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Effra" size:24];
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    label.frame = CGRectMake(10,self.view.frame.size.height/4 + 120,self.view.frame.size.width - 20,self.view.frame.size.height/8);
    bottom += 150;
    NSString *section;
    
    //TODO: Also some issues with how the button's title changes. dumb fix for now.
    //Issue is because afterVC and beforeVC also call this method
    section = [ArticleData sharedInstance].sectionNames[index];
    
    _screenTitle.titleLabel.numberOfLines = 1;
    _screenTitle.titleLabel.adjustsFontSizeToFitWidth = YES;
    _screenTitle.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    ArticleData* articleData = [ArticleData sharedInstance];
    NSArray *articlesInSection = [articleData articlesForSection:section];

    Article *a = (Article *) articlesInSection[0];
    
    label.text = [a.title uppercaseString];
    NSURL *imageUrl = a.image;
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];

    imageview.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height/3 + 50);
    imageview.contentMode = UIViewContentModeScaleAspectFit;
     
    UIScrollView *scrollBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 3 * self.view.frame.size.height/4, self.view.frame.size.width, self.view.frame.size.height/4)];
    
    scrollBar.pagingEnabled = YES;
    [scrollBar setContentSize:CGSizeMake(self.view.frame.size.width * ([articlesInSection count] - 1) / 2, self.view.frame.size.height / 4)];

    for (int i = 1; i < [articlesInSection count]; i++) {
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
    tealBar.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:150.0/255.0 blue:178.0/255.0 alpha:1];

    
    [avc.view addSubview:imageview];
    [avc.view addSubview:label];
    [avc.view addSubview:tealBar];
    [avc.view addSubview:scrollBar];
    
    avc.navigationController.navigationBar.translucent = NO;
    return avc;
}

- (void)presentArticle:(UITapGestureRecognizer *)sender {
    
    ThumbnailView* thumb = (ThumbnailView *)sender.view;
    Article* article = thumb.article;
    NSLog(@"%@", article.title);
    
    PopupViewController *vc = [[PopupViewController alloc] initWithArticle:article];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nc animated:YES completion:nil];
    
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
