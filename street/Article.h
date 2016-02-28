//
//  Article.h
//  street
//
//  Created by Graham Mosley on 2/28/16.
//  Copyright © 2016 Graham Mosley. All rights reserved.
//

#ifndef Article_h
#define Article_h

@interface Article : NSObject
//{
//    NSString* articleHTML;
//}

@property NSString* articleHTML;

-(id)initWithURL:(NSURL *)url;

//@property NSString *title;
//@property NSURL *url;
//@property NSString *articleHTML;
//@property NSDate *date;
//@property NSString *author;
//@property NSString *abstract;
//@property NSURL *image;

@end

#endif /* Article_h */
