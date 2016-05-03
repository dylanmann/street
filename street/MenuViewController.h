
//
//  MenuViewController.h
//  street
//
//  Created by Jenny Chen on 2/20/16
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Interface for the table of menu cells

#import <UIKit/UIKit.h>

//each cell is of type SWUITableViewCell
@interface SWUITableViewCell : UITableViewCell
@property (nonatomic) IBOutlet UILabel *label;
@end


@interface MenuViewController : UITableViewController

@end
