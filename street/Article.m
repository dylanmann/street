
//  Article.m
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 Graham Mosley. All rights reserved.
//  Class that represents an 34st article

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
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd/yy hh:mma";
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        _title = [document firstChildWithXPath:@"//h1"].stringValue;
        _url = url;
        _date = [dateFormatter dateFromString:[document firstChildWithXPath:@"//aside/div/div[2]"].stringValue];
        _author = [document firstChildWithXPath:@"//aside/div/div[1]"].stringValue;
        _abstract = [document firstChildWithXPath:@"//p[@class=\"smaller abstract\"]"].stringValue;
        NSString *imageURLString =[document firstChildWithXPath:@"//figure/a/@href"].stringValue;
        imageURLString = [imageURLString stringByReplacingOccurrencesOfString:@"f.png" withString:@"t.png"];
        _image = [NSURL URLWithString:imageURLString];
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
    }
    return articleHTML;
}

// equivalent to toString();
- (NSString *)description {
    return [NSString stringWithFormat: @"Title: %@", _title];
}

@end