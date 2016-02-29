
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

@end