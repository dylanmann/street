//
//  AboutViewController.m
//  street
//
//  Created by Jenny Chen on 2/27/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Displays a textview about what 34st Street is
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"
#import "ArticlePageViewController.h"

@interface AboutViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end


@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:56.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1];
    self.navigationController.navigationBar.translucent = YES;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
    
    [ArticlePageViewController changeStartIndex: 0];
}


@end

