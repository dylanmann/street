//
//  SectionViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Jenny Chen 2/20/16
//

#import "SectionViewController.h"

@interface SectionViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

//TODO: try and refactor this so can specify which section
//SECTIONS: Highbrow, Word on the Street, Ego, Music & TV, Vice and Virtue, Arts, Lowbrow, Letter, Features
//Tech

@implementation SectionViewController

// called when ViewController is presented.  Create UINavigation Bar and reveal button item
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;  
    self.navigationController.navigationBar.translucent = YES;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
}


#pragma mark state preservation / restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here

    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here

    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore

    [super applicationFinishedRestoringState];
}

@end
