//
//  ArticleViewController.h
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface ArticleViewController : UIViewController

@property (nonatomic) int index;

- (id)initWithArticle:(Article *)art;

@end
