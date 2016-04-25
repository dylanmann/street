//
//  SearchViewController.m
//  street
//
//  Created by Jenny Chen on 4/25/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Uses code from Jason Hoffman
//

#import "SearchViewController.h"
#import "SearchResultsTableViewController.h"

@interface SearchViewController () <UISearchResultsUpdating>

@property (nonatomic, strong) NSArray *articles;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end

//TODO: NEEDS A BACK BUTTON SO CAN EXIT SEARCH

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.articles = @[ @"ugh", @"blah"]; //CURRENTLY HARDCODED - NEEDS TO BE CHANGED TO ARTICLE TITLES. MAKE SURE TITLES ARE LOWERCASE.

    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];

    self.searchController.searchResultsUpdater = self;

    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articles count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [_articles objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text =[_articles objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UISearchControllerDelegate & UISearchResultsDelegate

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    // Set searchString equal to what's typed into the searchbar
    NSString *searchString = [self.searchController.searchBar.text lowercaseString];
    // [myString lowercaseString]
    
    [self updateFilteredContentForArticleName:searchString];
    
    if (self.searchController.searchResultsController) {
        
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        // Present SearchResultsTableViewController as the topViewController
        SearchResultsTableViewController *vc = (SearchResultsTableViewController *)navController.topViewController;
        
        // Update searchResults
        vc.searchResults = self.searchResults;
        
        // And reload the tableView with the new data
        [vc.tableView reloadData];
    }
}


// Update self.searchResults based on searchString, which is the argument in passed to this method
- (void)updateFilteredContentForArticleName:(NSString *)articleName
{

    if (articleName == nil) {
        
        // If empty the search results are the same as the original data
        self.searchResults = [self.articles mutableCopy];
    } else {
        NSMutableArray *searchResults = [[NSMutableArray alloc] init];
        
        for (NSString *title in _articles) {
            if ([title containsString: articleName]) {
                [searchResults addObject: title];
            }
        }
            self.searchResults = searchResults;
        }
    }


@end

