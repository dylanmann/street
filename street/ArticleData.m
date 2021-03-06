
//
//  ArticleData.m
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 Graham Mosley. All rights reserved.
//  Retrieves 34st articles from website using xpath matching on individual article blocks

#import <Foundation/Foundation.h>
#import "ArticleData.h"
#import "Ono.h"

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

 Home page
 http://www.34st.com/
*/

@interface ArticleData ()

@property NSMutableDictionary* sections;

@end

@implementation ArticleData : NSObject

// invoke this method to get singleton instance
+ (ArticleData *)sharedInstance {
    static ArticleData *_sharedInstance = nil;
 
    static dispatch_once_t oncePredicate;
    
    // built in singleton method for Objective-C
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.sectionNames = @[@"home", @"highbrow", @"word-on-the-street", @"ego", @"music", @"film", @"vice-and-virtue", @"arts", @"lowbrow", @"letter", @"features", @"tech"];
        _sharedInstance.sections = [[NSMutableDictionary alloc] init];
        
        NSURL *baseURL = [NSURL URLWithString:@"http://www.34st.com/section/"];
        
        // for each section, load the first page of articles
        for (NSString* section in _sharedInstance.sectionNames) {
            NSURL *sectionURL;
            
            if ([section isEqualToString:@"home"]) {
                continue;
            }
            
            sectionURL = [baseURL URLByAppendingPathComponent:section];

            // parse Sections asynchronously and store the results for later getting
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithURL:sectionURL
                    completionHandler:^(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error) {
                        if (data) {
                            NSMutableArray *articlesForSection = [_sharedInstance parseSection:data];
                            [_sharedInstance.sections setObject:articlesForSection forKey:section];
                        }
            }] resume];
        }
        
        // get homeData not asynchronously so that it loads immediately upon viewing
        NSData *homeData = [NSData dataWithContentsOfURL: [NSURL URLWithString:@"http://www.34st.com/"]];
        NSMutableArray *articlesForSection = [_sharedInstance parseSection:homeData];
        [_sharedInstance.sections setObject:articlesForSection forKey:@"home"];
    });
    return _sharedInstance;
}

// given a sectionURL, creates an Array of Articles
- (NSMutableArray *)parseSection:(NSData *)sectionURL {
    
    NSMutableArray *articles = [[NSMutableArray alloc] init];
    
    // get html from section webpage and create ONO doc for parsing
    NSString *sectionHTML = [[NSString alloc] initWithData:sectionURL encoding:NSUTF8StringEncoding];
    ONOXMLDocument* articlesDoc = [ONOXMLDocument HTMLDocumentWithString:sectionHTML encoding:NSUTF8StringEncoding error:NULL];
    
    // DateFormatter for parsing date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yy hh:mma";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    // for each article, parse information using xpath matching on each article display on each section page
    NSString *articlesXPath = @"//article[@class = 'standard hidden-xs']/div[@class = 'media']";
    [articlesDoc enumerateElementsWithXPath:articlesXPath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        
        // get all the important article info using xpath
        NSString *title = [element firstChildWithXPath:@"./div/h4/a"].stringValue;
        NSURL *url = [NSURL URLWithString:[element firstChildWithXPath:@"./div/h4/a/@href"].stringValue];

        NSString *dateString = [element firstChildWithXPath:@"./div/aside/p/span[2]"].stringValue;
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        NSString *authorWithoutTrim = [element firstChildWithXPath:@"./div/aside/p/span[1]"].stringValue;
        NSString *author = [authorWithoutTrim stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *abstract = [element firstChildWithXPath:@"./div/p[not(contains(@class, \" \"))]"].stringValue;
        NSURL *image = [NSURL URLWithString:[element firstChildWithXPath:@"./a/div/img/@src"].stringValue];
        
        // initialize article object and add to articles array
        Article *article = [[Article alloc] initWithTitle:title url:url date:date author:author abstract:abstract image:image];
        [articles addObject:article];
    }];
    return articles;
}

// return NSArray of articles for given sectionName
- (NSArray *)articlesForSection:(NSString *)sectionName {
    return [_sections objectForKey:sectionName];
}

@end

