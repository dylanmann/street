//
//  ArticleViewController.m
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  View Controller inside of the ArticlePageViewController. Container for each screen of the carousel.

#import "ArticleViewController.h"
#import "Article.h"

@interface ArticleViewController ()

@end

// basic view controller that exists to hold section content.  Know's it's index relative to the ArticlePageViewController
@implementation ArticleViewController

// called when initialized
- (id)init {
    if (self = [super init]) {
        self.index = 10;
    }
    return self;
}

@end
