
//  Article.m
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 Graham Mosley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ono.h"

#import "Article.h"


@implementation Article : NSObject

@synthesize articleHTML;

//@synthesize title;
//@synthesize url;
//@synthesize date;
//@synthesize author;
//@synthesize abstract;
//@synthesize image;

-(id) initWithURL:(NSURL *)url {
    if( self = [super init] )
    {
        NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
        
        // Use Ono to parse the document for the article-text HTML
        ONOXMLDocument* document = [ONOXMLDocument HTMLDocumentWithString:html encoding:NSUTF8StringEncoding error:NULL];
        
        // Add every article-text div to a string
        NSMutableString *stuffToRender = [[NSMutableString alloc] init];
        [document enumerateElementsWithXPath:@"//div[@class=\"article-text\"]" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
            [stuffToRender appendString: [element description]];
        }];
        
        //articleHTML = [[NSString alloc] init];
        articleHTML = stuffToRender;
    }
    
    return self;
}

-(id)initWithTitle:(NSString *)title url:(NSURL *)url date:(NSDate *)date author:(NSString *)author abstract:(NSString *)abstract image:(NSURL *)image {
    
    if(self = [super init]){
        _title = title;
        _url = url;
        _date = date;
        _author = author;
        _abstract = abstract;
        _image = image;
    }
    
    return self;
}

-(NSString*) articleContent {
    if (!articleHTML) {
        NSLog(@"Article HTML does not already exist");
        NSString *html = [NSString stringWithContentsOfURL:_url encoding:NSUTF8StringEncoding error:NULL];
        
        // Use Ono to parse the document for the article-text HTML
        ONOXMLDocument* document = [ONOXMLDocument HTMLDocumentWithString:html encoding:NSUTF8StringEncoding error:NULL];
        
        // Add every article-text div to a string
        NSMutableString *stuffToRender = [[NSMutableString alloc] init];
        [document enumerateElementsWithXPath:@"//div[@class=\"article-text\"]" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                    [stuffToRender appendString: [element description]];
                }];
        
        articleHTML = [[NSString alloc] init];
        articleHTML = stuffToRender;
    } else {
        NSLog(@"Article HTML already loaded");
    }
    return articleHTML;
}

// equivalent to toString();
- (NSString *)description {
    return [NSString stringWithFormat: @"Title: %@", _title];
}

@end