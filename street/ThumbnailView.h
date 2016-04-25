//
//  ThumbnailView.h
//  street
//
//  Created by Graham Mosley on 3/24/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Article;

@interface ThumbnailView : UIScrollView


@property (nonatomic, strong) Article* article;

-(id)initWithFrame:(CGRect)frame article:(Article *)article;

@end
