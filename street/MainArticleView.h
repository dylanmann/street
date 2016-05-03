//
//  MainArticleView.h
//  street
//
//  Created by Graham Mosley on 4/10/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Interface for displaying the main article

#import <UIKit/UIKit.h>
@class Article;

@interface MainArticleView : UIScrollView

@property (nonatomic, strong) Article *article;

// initialization method specifying a frame and an article title and image
-(id)initWithFrame:(CGRect)frame title:(NSString *)title image:(NSURL *)image;

@end
