//
//  MMDBFetcherTests.m
//  MyMenu
//
//  Created by Connor Moreside on 2/5/2014.
//
//

#import <XCTest/XCTest.h>
#import "MMDBFetcher.h"
#import "MMMockDBFetcherDelegate.h"

@interface MMDBFetcherTests : XCTestCase <MMDBFetcherDelegate>

@end

@implementation MMDBFetcherTests

MMDBFetcher *dbFetcher;
MMMockDBFetcherDelegate *mockDelegate;

- (void)setUp {
    [super setUp];
    
    dbFetcher = [[MMDBFetcher alloc] init];
    dbFetcher.delegate = mockDelegate;
}

- (void)tearDown {
    dbFetcher.delegate = nil;
    dbFetcher = nil;
    
    [super tearDown];
}

- (void)testGetUser_UserExists {
    NSString* fakeResponse =  @"<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?><results><result><id>107</id><email>cmoresid@ualberta.ca</email><firstname>Connor</firstname><lastname>Moreside</lastname><password>star1234</password><city>Edmonton</city><locality>Alberta</locality><country>CAN</country><gender>M</gender><birthday>5</birthday><birthmonth>2</birthmonth><birthyear>2009</birthyear><confirmcode>y</confirmcode></result></results>";

    NSData *fakeData = [fakeResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *fakeHeaders = @{@"Content-Length" : @"408"};
    
    [dbFetcher getUser:@"cmoresid@ualberta.ca"];
}

@end
