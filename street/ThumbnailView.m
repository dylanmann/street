//
//  ThumbnailView.m
//  street
//
//  Created by Graham Mosley on 3/24/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//

#import "ThumbnailView.h"

@implementation ThumbnailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect)frame title:(NSString *)title image:(NSURL *)image {

    self = [self initWithFrame:frame];
    
    if(self = [super init]){
        [self setBackgroundColor:[UIColor grayColor]];
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Effra" size:25];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        label.frame = CGRectMake(5,self.frame.size.height/2 +5,self.frame.size.width -10,self.frame.size.height/2 -10);
        label.adjustsFontSizeToFitWidth = YES;
        label.text = [title uppercaseString];
        NSURL *imageUrl = image;
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
        
        UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
        imageview.frame = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height / 2 - 10);
        
        
        [self addSubview:label];
        [self addSubview:imageview];
    }
    
    return self;
}

@end
