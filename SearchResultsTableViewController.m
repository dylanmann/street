//
//  SearchResultsTableViewController.m
//  street
//
//  Created by Jenny Chen on 4/25/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//

#import "SearchResultsTableViewController.h"

@interface SearchResultsTableViewController ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation SearchResultsTableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.searchResults[indexPath.row];
    
    return cell;
}


@end