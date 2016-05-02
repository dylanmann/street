//
//  MainArticleView.m
//  street
//
//  Created by Graham Mosley on 4/10/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//

#import "MainArticleView.h"

@implementation MainArticleView

// initialization method specifying a frame and an article title and image
- (id)initWithFrame:(CGRect)frame title:(NSString *)title image:(NSURL *)imageUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        // create the title label
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Effra" size:24];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.frame = CGRectMake(10,self.frame.size.height/2 + 50,self.frame.size.width - 20, self.frame.size.height/4);
        label.text = [title uppercaseString];
        
        // load the article view
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];

        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        
        imageview.frame = CGRectMake(10, 20, self.frame.size.width - 20, self.frame.size.height/2 + 50);
        imageview.contentMode = UIViewContentModeScaleAspectFit;
    
        [imageview setBackgroundColor: [UIColor clearColor]];
        
        // attach subviews
        [self addSubview:label];
        [self addSubview:imageview];
    }
    return self;
}

@end
