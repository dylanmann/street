//
//  ThumbnailView.h
//  street
//
//  Created by Graham Mosley on 3/24/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Interface for the scroll view for additional articles

#import <UIKit/UIKit.h>
@class Article;

@interface ThumbnailView : UIScrollView

@property (nonatomic, strong) Article* article;

// initialization method specifying a frame and an article to init with
-(id)initWithFrame:(CGRect)frame article:(Article *)article;

@end
