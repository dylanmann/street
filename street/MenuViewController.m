//
//  MenuViewController.m
//  street
//
//  Created by Jenny Chen on 2/20/16
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Handles displaying the menu after the button is pressed
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
    
    menuItems = @[@"home", @"about", @"highbrow", @"wordOnStreet", @"ego", @"music", @"film", @"viceAndVirtue", @"arts", @"lowbrow", @"letter", @"features", @"tech"];
    
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
        [ArticlePageViewController changeStartIndex: 2];
    } else if ([label  isEqual: @"EGO"]) {
        [ArticlePageViewController changeStartIndex: 3];
    } else if ([label  isEqual: @"MUSIC"]) {
        [ArticlePageViewController changeStartIndex: 4];
    } else if ([label  isEqual: @"FILM"]) {
        [ArticlePageViewController changeStartIndex: 5];
    } else if ([label  isEqual: @"VICE AND VIRTUE"]) {
        [ArticlePageViewController changeStartIndex: 6];
    } else if ([label  isEqual: @"ARTS"]) {
        [ArticlePageViewController changeStartIndex: 7];
    } else if ([label  isEqual: @"LOWBROW"]) {
        [ArticlePageViewController changeStartIndex: 8];
    } else if ([label  isEqual: @"LETTER"]) {
        [ArticlePageViewController changeStartIndex: 9];
    } else if ([label  isEqual: @"FEATURES"]) {
        [ArticlePageViewController changeStartIndex: 10];
    } else if ([label  isEqual: @"TECH"]) {
        [ArticlePageViewController changeStartIndex: 11];
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
