//
//  Article.h
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 Graham Mosley. All rights reserved.
//

#ifndef Article_h
#define Article_h

@interface Article : NSObject

// this is deprecated, use the articleContent method instead
@property NSString* articleHTML;

// TODO: add properties for section and subsection
@property NSString *title;
@property NSURL *url;
@property NSDate *date;
@property NSString *author;
@property NSString *abstract;
@property NSURL *image;


-(id)initWithURL:(NSURL *)url;

// Use this to create an article
-(id)initWithTitle:(NSString *)title url:(NSURL*)url date:(NSDate*)date author:(NSString*)author abstract:(NSString*)abstract image:(NSURL*)image;

-(NSString*) articleContent;

@end

#endif /* Article_h */
