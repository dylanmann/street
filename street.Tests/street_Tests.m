//
//  street_Tests.m
//  street.Tests
//
//  Created by Graham Mosley on 3/18/16.
//  Copyright © 2016 CoDeveloper. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Article.h"
#import "ArticleData.h"

@interface street_Tests : XCTestCase

@end

@implementation street_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testArticleDataInstance {
    NSLog(@"TEST STARTED");
    
    // ArticleData is a singleton that stores info on articles
    ArticleData* articleData = [ArticleData sharedInstance];
    
    // articleData has a sectionNames property which contains an array of all the section names
    for (NSString *sectionName in articleData.sectionNames) {
        NSLog(@"Section Name %@", sectionName);
        NSArray *articlesForSection = [articleData articlesForSection:sectionName];
        NSLog(@"section %@ has articles %@", sectionName, articlesForSection);
    }
    
    // get an array of all articles in a section
    // currently there's no way to request more than the first page of articles (15) for each section
    // but it should be (relatively) easy to implement
    NSArray *egoArticles = [articleData articlesForSection:@"ego"];
    
    // get an individual article
    Article *egoArticle = (Article *)egoArticles[4];
    
    // access individual properties of a article
    NSLog(@"The 4th article in ego is %@ written by %@ has abstract %@", egoArticle.title, egoArticle.author, egoArticle.abstract);
    
    //HTML content will at the first call, so two repeated calls will be referentially equal
    NSString *html = [egoArticle articleContent];
    NSString *html2 = [egoArticle articleContent];
    XCTAssert(html == html2);
    
    NSLog(@"TEST ENDED");
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
