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

@implementation ArticleViewController

- (id)init {
    
    if (self = [super init]) {
        self.index = 10;
    }
    
    return self;
}

- (id)initWithArticle:(Article *)art {
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
