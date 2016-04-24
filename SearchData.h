//
//  SearchData.h
//  street
//
//  Created by Graham Mosley on 4/24/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"


@interface SearchData : UIScrollView

+(NSArray *) articlesByTerm:(NSString *)searchTerm;

@end