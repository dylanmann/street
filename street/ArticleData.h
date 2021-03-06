//
//  ArticleData.h
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 Graham Mosley. All rights reserved.
//  Interface for retrieving articles

#ifndef ArticleData_h
#define ArticleData_h

#import "Article.h"

@interface ArticleData : NSObject

@property NSArray* sectionNames;

// invoke this method to get singleton instance
+ (ArticleData*)sharedInstance;

// return NSArray of articles for given sectionName
- (NSArray*)articlesForSection:(NSString *)sectionName;

@end

#endif /* ArticleData_h */
