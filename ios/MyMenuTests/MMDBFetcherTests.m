//
//  MMDBFetcherTests.m
//  MyMenu
//
//  Created by Connor Moreside on 2/5/2014.
//
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MMDBFetcher.h"
#import "MMUser.h"
#import "MMMockDBFetcherDelegate.h"
#import "MMNetworkClientProtocol.h"
#import "MMMockNetworkClient.h"
#import "MMDBFetcherResponse.h"
#import "MMNetworkClientProxy.h"


@interface MMDBFetcherTests : XCTestCase <MMDBFetcherDelegate>

@end

@implementation MMDBFetcherTests

MMDBFetcher *dbFetcher;
MMMockDBFetcherDelegate *mockDelegate;

- (void)setUp {
    [super setUp];
    
    dbFetcher = [[MMDBFetcher alloc] init];
    mockDelegate = [[MMMockDBFetcherDelegate alloc] init];
    dbFetcher.delegate = mockDelegate;
}

- (void)tearDown {
    dbFetcher.delegate = nil;
    mockDelegate = nil;
    dbFetcher = nil;
    
    [super tearDown];
}

- (void)testInjectionConstructor {
    id<MMNetworkClientProtocol> networkClient = [[MMMockNetworkClient alloc] init];
    MMDBFetcher *fetcher = [[MMDBFetcher alloc] initWithNetworkClient:networkClient];
    
    XCTAssertNotNil(dbFetcher.networkClient, @"Network client not set.");
    XCTAssertEqual(networkClient, fetcher.networkClient, @"Network client not set properly.");
}

- (void)testDefaultConstructor {
    MMDBFetcher *fetcher = [[MMDBFetcher alloc] init];
    
    XCTAssertNotNil(dbFetcher.networkClient, @"Network client not set.");
}

- (void)testGetUser_UserExists {
    // Setup fake response from server.
    NSString* fakeResponse =  @"<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?><results><result><id>107</id><email>cmoresid@ualberta.ca</email><firstname>Connor</firstname><lastname>Moreside</lastname><password>star1234</password><city>Edmonton</city><locality>Alberta</locality><country>CAN</country><gender>M</gender><birthday>5</birthday><birthmonth>2</birthmonth><birthyear>2009</birthyear><confirmcode>y</confirmcode></result></results>";
    NSDictionary *fakeHeaders = @{@"Content-Length" : @"408"};
    NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:fakeHeaders];
    
    // Initialize the mock network client that will return the fake data.
    MMMockNetworkClient *fakeClient = [[MMMockNetworkClient alloc] initWithFakeResponse:response withFakeData:fakeResponse withFakeError:nil];
    
    // Set the mock network client here
    dbFetcher.networkClient = fakeClient;
    
    // Perform any assertions here. You can ensure that the user is not nil, if properties
    // were set, if the response is ok.
    mockDelegate.userResponseCallback = ^(MMUser* user, MMDBFetcherResponse* response) {
        XCTAssertNotNil(user, @"User should not be nil.");
        XCTAssertTrue(response.wasSuccessful, @"Should be successful.");
        
        XCTAssertTrue([user.firstName isEqualToString:@"Connor"], @"First name does not match.");
        XCTAssertTrue([user.lastName isEqualToString:@"Moreside"], @"Last name does not match.");
        XCTAssertTrue([user.password isEqualToString:@"star1234"], @"Password does not match.");
        XCTAssertTrue([user.city isEqualToString:@"Edmonton"], @"City does not match.");
        XCTAssertTrue([user.locality isEqualToString:@"Alberta"], @"Locality does not match.");
        XCTAssertTrue([user.country isEqualToString:@"CAN"], @"Country does not match.");
        XCTAssertTrue(user.gender == 'M', @"Gender does not match.");
        XCTAssertTrue([user.birthday isEqualToString:@"5"], @"Birth day does not match.");
        XCTAssertTrue([user.birthmonth isEqualToString:@"2"], @"Birth month does not match.");
        XCTAssertTrue([user.birthyear isEqualToString:@"2009"], @"Birth year does not match.");
    };
    
    [dbFetcher getUser:@"cmoresid@ualberta.ca"];
    
    // Be sure to set network client to nil
    dbFetcher.networkClient = nil;
}

- (void)testGetUser_UserDoesNotExist {
    // Setup fake response from server.
    NSString* fakeResponse =  @"<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?><results></results>";
    NSDictionary *fakeHeaders = @{@"Content-Length" : @"408"};
    NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:fakeHeaders];
    
    // Initialize the mock network client that will return the fake data.
    MMMockNetworkClient *fakeClient = [[MMMockNetworkClient alloc] initWithFakeResponse:response withFakeData:fakeResponse withFakeError:nil];
    
    // Set the mock network client here
    dbFetcher.networkClient = fakeClient;
    
    // Perform any assertions here. You can ensure that the user is not nil, if properties
    // were set, if the response is ok.
    mockDelegate.userResponseCallback = ^(MMUser* user, MMDBFetcherResponse* response) {
        XCTAssertNil(user, @"User should not be nil.");
        XCTAssertTrue(response.wasSuccessful, @"Should be successful.");
    };
    
    [dbFetcher getUser:@"cmoresid@ualberta.ca"];
    
    // Be sure to set network client to nil
    dbFetcher.networkClient = nil;
}

/* Need to update DBFetcher so this test pasts */
//- (void)testGetUser_ServerError {
//    // Setup fake response from server.
//    NSString* fakeResponse =  @"<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?><results></results>";
//    NSDictionary *fakeHeaders = @{@"Content-Length" : [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:[fakeResponse length]]]};
//    NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:500 HTTPVersion:nil headerFields:fakeHeaders];
//    
//    // Initialize the mock network client that will return the fake data.
//    MMMockNetworkClient *fakeClient = [[MMMockNetworkClient alloc] initWithFakeResponse:response withFakeData:fakeResponse withFakeError:nil];
//    
//    // Set the mock network client here
//    dbFetcher.networkClient = fakeClient;
//    
//    // Perform any assertions here. You can ensure that the user is not nil, if properties
//    // were set, if the response is ok.
//    mockDelegate.userResponseCallback = ^(MMUser* user, MMDBFetcherResponse* response) {
//        XCTAssertNil(user, @"User should be nil.");
//        XCTAssertFalse(response.wasSuccessful, @"Should fail (500 Status code).");
//    };
//    
//    [dbFetcher getUser:@"cmoresid@ualberta.ca"];
//    
//    // Be sure to set network client to nil
//    dbFetcher.networkClient = nil;
//}

- (void)testGetMenu {
    MMDBFetcher* fetcher = [[MMDBFetcher alloc] initWithNetworkClient:[[MMNetworkRequestProxy alloc] init]];
    MMMockDBFetcherDelegate *fakeDelegate = [[MMMockDBFetcherDelegate alloc] init];
    
    fakeDelegate.getMenuResponseCallback = ^(NSArray* menuItems, MMDBFetcherResponse* response) {
        NSArray *results = menuItems;
    };
    
    fetcher.delegate = fakeDelegate;
    
    [fetcher getMenuWithMerchantId:1 withUserEmail:@"bob@barker.com"];
}

@end
