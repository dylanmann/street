//
//  SearchData.m
//  street
//
//  Created by Graham Mosley on 4/24/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//

#import "SearchData.h"
#import "Ono.h"

@implementation SearchData

+(NSArray *)articlesByTerm:(NSString *)searchTerm
{
    NSMutableArray *articles = [NSMutableArray new];
    
    NSURL *searchURL = [NSURL URLWithString: [NSString stringWithFormat: @"http://www.34st.com/page/search?q=%@", searchTerm]];
    NSLog(@"URL = %@", searchURL.description);
    NSString *searchHTML = [NSString stringWithContentsOfURL: searchURL encoding:NSUTF8StringEncoding error:NULL];
    
    NSLog(@"%@", searchHTML);
    
    ONOXMLDocument* searchDoc = [ONOXMLDocument HTMLDocumentWithString:searchHTML encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *articlesXPath = @"//div[@class=\"gs-title\"]";
    [searchDoc enumerateElementsWithXPath:articlesXPath usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSLog(@"Description of element :");
//        [articles addObject:[[Article alloc] initWithURL:[NSURL URLWithString:element.description]]];
    }];
    return articles;
}

@end
