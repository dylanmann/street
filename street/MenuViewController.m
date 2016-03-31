//
//  MenuViewController.m
//
//  Created by Jenny Chen on 2/20/16
//

#import "MenuViewController.h"
#import "ArticlePageViewController.h"

@implementation SWUITableViewCell
@end

@implementation MenuViewController
NSArray *menuItems;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    menuItems = @[@"home", @"about", @"highbrow", @"wordOnStreet", @"ego"];
    
}

//when a section is pressed in the menu, switch the ArticlePageViewController to the right index
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    SWUITableViewCell *senderCell = sender;
    NSString *label = senderCell.textLabel.text;

    
    if ([label  isEqual: @"HOME"]) {
        [ArticlePageViewController changeStartIndex: 0];
    } else if ([label  isEqual: @"HIGHBROW"]) {
        [ArticlePageViewController changeStartIndex: 1];
    } else if ([label  isEqual: @"WORD ON THE STREET"]) {
         //NSLog(@"here");
        [ArticlePageViewController changeStartIndex: 2];
    } else if ([label  isEqual: @"EGO"]) {
        [ArticlePageViewController changeStartIndex: 3];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
