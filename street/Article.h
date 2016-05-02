//
//  Article.h
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 Graham Mosley. All rights reserved.
//  Interface for an article object

#ifndef Article_h
#define Article_h

@interface Article : NSObject

// Article properties
@property NSString* articleHTML;
@property NSString *title;
@property NSURL *url;
@property NSDate *date;
@property NSString *author;
@property NSString *abstract;
@property NSURL *image;

@property NSData *imageData;

// Use this to initialize an article through URL
-(id)initWithURL:(NSURL *)url;

// Use this to create an article
-(id)initWithTitle:(NSString *)title url:(NSURL*)url date:(NSDate*)date author:(NSString*)author abstract:(NSString*)abstract image:(NSURL*)image;

-(NSString*) articleContent;

@end

#endif /* Article_h */
