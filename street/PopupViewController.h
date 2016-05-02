//
//  PopupViewController.h
//  street
//
//  Created by Dylan Mann on 3/25/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Interface for the article that pop ups in a new screen

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@class Article;


@interface PopupViewController : UIViewController <WKNavigationDelegate>

-(id)initWithArticle:(Article *)article;

@end
