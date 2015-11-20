//
//  PlickersAppTests.m
//  PlickersAppTests
//
//  Created by Evan on 11/17/15.
//  Copyright © 2015 none. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PlickersAPI.h"

@interface PlickersAppTests : XCTestCase

@end

@implementation PlickersAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void)testGetJSON {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"something"];
    
    [PlickersAPI getJSON:^ (NSArray *jsonArray, NSError *error) {
       
        XCTAssertNil(error);
        XCTAssertNotNil(jsonArray);
        
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:0.5 handler: ^ (NSError *error) {
       
        if (error) {
            XCTFail(@"error: %@", error);
        }
        
    }];
    
}

-(void)testGetImage {
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"something"];
    
    [PlickersAPI getJSON:^(NSArray *jsonArray, NSError *error) {
       
        NSURL *url = [NSURL URLWithString:[[[jsonArray objectAtIndex:0]valueForKey:@"question"]valueForKey:@"image"]];
        
        [PlickersAPI getImageFromURL:url block:^(UIImage *image, NSError *error) {
           
            XCTAssertNil(error);
            XCTAssertNotNil(image);
            
            [expectation fulfill];
            
        }];
        
    }];
    
    [self waitForExpectationsWithTimeout:0.5 handler:^ (NSError *error) {
       
        if (error) {
            XCTFail(@"error: %@", error);
        }
        
    }];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
