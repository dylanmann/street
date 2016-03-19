//
//  ArticleData.h
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 Graham Mosley. All rights reserved.
//

#ifndef ArticleData_h
#define ArticleData_h

#import "Article.h"

@interface ArticleData : NSObject

@property NSArray* sectionNames;

+ (ArticleData*)sharedInstance;

- (NSArray*)articlesForSection:(NSString *)sectionName;

@end


#endif /* ArticleData_h */
