
//
//  ArticleData.m
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 Graham Mosley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArticleData.h"
#import "Ono.h"

@implementation ArticleData : NSObject


/*
 Sections are as follows:
 http://www.34st.com/section/highbrow
 http://www.34st.com/section/word-on-the-street
 http://www.34st.com/section/ego
 http://www.34st.com/section/music
 http://www.34st.com/section/film
 http://www.34st.com/section/vice-and-virtue
 http://www.34st.com/section/arts
 http://www.34st.com/section/lowbrow
 http://www.34st.com/section/letter
 http://www.34st.com/section/features
 http://www.34st.com/section/tech
*/

+ (ArticleData *)sharedInstance {
    static ArticleData *_sharedInstance = nil;
 
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        NSURL *highbrowSection = [NSURL URLWithString:@"http://www.34st.com/section/highbrow"];
        [_sharedInstance parseSection:highbrowSection];
    });
    
    return _sharedInstance;
}

- (void)parseSection:(NSURL *)sectionURL {
    NSString *sectionHTML = [NSString stringWithContentsOfURL:sectionURL encoding:NSUTF8StringEncoding error:NULL];
    ONOXMLDocument* articlesDoc = [ONOXMLDocument HTMLDocumentWithString:sectionHTML encoding:NSUTF8StringEncoding error:NULL];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yy hh:mma";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    // for each article, parse information
    NSString *articlesXPath = @"//article[@class = 'standard hidden-xs']/div[@class = 'media']";
    [articlesDoc enumerateElementsWithXPath:articlesXPath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSString *aTitle = [element firstChildWithXPath:@"./div/h4/a"].stringValue;
        NSString *aURL = [element firstChildWithXPath:@"./div/h4/a/@href"].stringValue;
        
        NSString *aDateString = [element firstChildWithXPath:@"./div/aside/p/span[2]"].stringValue;
        NSString *aAuthorWithoutTrim = [element firstChildWithXPath:@"./div/aside/p/span[1]"].stringValue;
        
        NSString *aAuthor = [aAuthorWithoutTrim stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *aAbstract = [element firstChildWithXPath:@"./div/p[not(contains(@class, \" \"))]"].stringValue;
        
        NSString *aImage = [element firstChildWithXPath:@"./a/div/img/@src"].stringValue;
        
        NSDate *aDate = [dateFormatter dateFromString:aDateString];
        
        NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n\n", aTitle, aURL, aAuthor, aDate, aImage, aAbstract);
    }];
}

@end

