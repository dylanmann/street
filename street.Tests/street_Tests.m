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
    ArticleData* aData = [ArticleData sharedInstance];
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
