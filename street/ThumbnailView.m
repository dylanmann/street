//
//  ThumbnailView.m
//  street
//
//  Created by Graham Mosley on 3/24/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//  Each thumbnail image/title in the mini carousel at the bottom of the screen

#import "ThumbnailView.h"
#import "Article.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation ThumbnailView
// initialization method specifying a frame and an article to init with
-(id) initWithFrame:(CGRect)frame article:(Article *)article {
    self = [self initWithFrame:frame];
    
    if(self = [super init]){
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // create label for article title
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Effra" size:14];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.frame = CGRectMake(5,self.frame.size.height/2 +5,self.frame.size.width -10,self.frame.size.height/2 -10);
        label.adjustsFontSizeToFitWidth = YES;
        label.text = [article.title uppercaseString];

        // create ImageView for article image
        UIImageView *imageview = [[UIImageView alloc] init];
        [imageview setImageWithURL:article.image];
        imageview.frame = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height / 2 - 10);
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:label];
        [self addSubview:imageview];
    }
    
    return self;
}

@end
