//
//  MainArticleView.h
//  street
//
//  Created by Graham Mosley on 4/10/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Interface 

#import <UIKit/UIKit.h>
@class Article;

@interface MainArticleView : UIScrollView

@property (nonatomic, strong) Article *article;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title image:(NSURL *)image;

@end
