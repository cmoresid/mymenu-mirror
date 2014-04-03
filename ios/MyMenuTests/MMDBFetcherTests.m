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
#import "MMMockNetworkClient.h"
#import "MMNetworkClientProxy.h"
#import "MMValidator.h"
#import "MMRestaurantViewModel.h"
@class MMMenuItem;


@interface MMDBFetcherTests : XCTestCase <MMDBFetcherDelegate>

@property(atomic,strong) NSConditionLock* theLock;

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
    id <MMNetworkClientProtocol> networkClient = [[MMMockNetworkClient alloc] init];
    MMDBFetcher *fetcher = [[MMDBFetcher alloc] initWithNetworkClient:networkClient];

    XCTAssertNotNil(dbFetcher.networkClient, @"Network client not set.");
    XCTAssertEqual(networkClient, fetcher.networkClient, @"Network client not set properly.");
}

- (void)testDefaultConstructor {
    //MMDBFetcher *fetcher = [[MMDBFetcher alloc] init];

    //XCTAssertNotNil(dbFetcher.networkClient, @"Network client not set.");
}

- (void)testGetUser_UserExists {
    // Setup fake response from server.
    NSString *fakeResponse = @"<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?><results><result><id>107</id><email>cmoresid@ualberta.ca</email><firstname>Connor</firstname><lastname>Moreside</lastname><password>star1234</password><city>Edmonton</city><locality>Alberta</locality><country>CAN</country><gender>M</gender><birthday>5</birthday><birthmonth>2</birthmonth><birthyear>2009</birthyear><confirmcode>y</confirmcode></result></results>";
    NSDictionary *fakeHeaders = @{@"Content-Length" : @"408"};
    NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:fakeHeaders];

    // Initialize the mock network client that will return the fake data.
    MMMockNetworkClient *fakeClient = [[MMMockNetworkClient alloc] initWithFakeResponse:response withFakeData:fakeResponse withFakeError:nil];

    // Set the mock network client here
    dbFetcher.networkClient = fakeClient;

    // Perform any assertions here. You can ensure that the user is not nil, if properties
    // were set, if the response is ok.
    mockDelegate.userResponseCallback = ^(MMUser *user, MMDBFetcherResponse *response) {
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


- (void)testGetMenu_withUser {
    // Setup fake response from server.
    NSString *fakeResponse = @"<<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?><results><result><id>2</id><merchid>1</merchid><name>BP's Prime Rib Burger</name><cost>12</cost><picture>https://ba957a62330042319097-e95b9c2fdb68f7f6936d952304cdc503.ssl.cf1.rackcdn.com/BurgerSand-PrimeRib.png</picture><description>100% Canadian half-pound prime rib beef burger, fresh lettuce, tomato, red onion and pickles. Plus, our secret ingredient - a zesty sauce that simply defies description. Recommended for burger connoisseurs.</description><rating>8.95</rating><rating>8.95</rating><category>Dinner</category></result><result><id>3</id><merchid>1</merchid><name>Pesto Chicken Burger</name><cost>12</cost><picture>https://ba957a62330042319097-e95b9c2fdb68f7f6936d952304cdc503.ssl.cf1.rackcdn.com/BurgerSand-Pesto.png</picture><description>Chargrilled chicken breast with pesto mayo, lettuce, red onions and fresh slices of tomato.</description><rating>4.85</rating><rating>4.85</rating><category>Dinner</category></result><result><id>4</id><merchid>1</merchid><name>Boston Brute</name><cost>11.5</cost><picture>https://1093ea74d9df51084c1f-6ee0df3f8d1044014da148c7381a9023.ssl.cf1.rackcdn.com/BP_brutefull.png</picture><description>A deli style sandwich for the ages, this BP Favourite is loaded with Genoa salami, pepperoni, smoked ham, pizza mozzarella, onion and pizza sauce. Baked on a French-style bun.</description><rating>3.96</rating><rating>3.96</rating><category>Dinner</category></result><result><id>5</id><merchid>1</merchid><name>NY Striploin Steak Sandwich</name><cost>10</cost><picture>https://ba957a62330042319097-e95b9c2fdb68f7f6936d952304cdc503.ssl.cf1.rackcdn.com/BurgerSand-NYStriloin.png</picture><description>A 7-ounce New York strip loin steak, aged a minimum of 8 days to the peak of tenderness and flavour, seasoned with Montréal steak spice and charbroiled the way you like it. Served on a roasted garlic and herb panini bun, topped with sautéed mushrooms and caramelized onions and finished with fresh Parmesan.</description><rating>6.40</rating><rating>6.40</rating><category>Dinner</category></result><result><id>6</id><merchid>1</merchid><name>The Meatball Grinder</name><cost>17</cost><picture>https://c412879.ssl.cf1.rackcdn.com/52-meatball-grinder.png</picture><description>A toasted garlic-brushed bun loaded with three hearty homestyle meatballs in a blend of our signature tomato sauces, topped with balsamic-glazed red onions and roasted red peppers, smothered with pizza mozzarella, then baked to perfection. Served with a side of our signature tomato sauce for dipping.</description><rating>6.04</rating><rating>6.04</rating><category>Dinner</category></result><result><id>93</id><merchid>1</merchid><name>New York Cheesecake</name><cost>11.5</cost><picture>https://1093ea74d9df51084c1f-6ee0df3f8d1044014da148c7381a9023.ssl.cf1.rackcdn.com/BP_cheese_cake.png</picture><description>A cheesecake lover’s delight. Traditional style creamy cheesecake piled high on a graham cracker crust</description><rating>0.00</rating><rating>0.00</rating><category>Dessert</category></result><result><id>94</id><merchid>1</merchid><name>Chocolate Explosion</name><cost>7.49</cost><picture>https://92bdc9a53c0a635801e2-079edb5298b3c63a94276a21fc5c7505.ssl.cf1.rackcdn.com/Dessert-ExplosionSlice.png</picture><description>Ultimate decadence. Creamy chocolate mousse with chunks of cheesecake, caramel, toffee, pecans and almonds on a chocolate crust.</description><rating>0.00</rating><rating>0.00</rating><category>Dessert</category></result><result><id>95</id><merchid>1</merchid><name>Apple Crisp</name><cost>7.49</cost><picture>https://1093ea74d9df51084c1f-6ee0df3f8d1044014da148c7381a9023.ssl.cf1.rackcdn.com/BP_apple_crisp.png</picture><description>Just like mom used to make it. Slices of sweet granny smith apples in a butter sauce, baked to a crisp with a delicious brown sugar and oat crust. Topped with caramel sauce and served with a scoop of vanilla bean ice cream</description><rating>0.00</rating><rating>0.00</rating><category>Dessert</category></result><result><id>96</id><merchid>1</merchid><name>Chocolate Brownie Addiction</name><cost>7.49</cost><picture>https://c279666.ssl.cf1.rackcdn.com/18-chocolateBrownieAddiction.png</picture><description>A warm chocolate brownie topped with two scoops of vanilla bean ice cream, caramel and chocolate sauce.</description><rating>0.00</rating><rating>0.00</rating><category>Dessert</category></result><result><id>97</id><merchid>1</merchid><name>Margherita Tomato</name><cost>11.99</cost><picture>https://1093ea74d9df51084c1f-6ee0df3f8d1044014da148c7381a9023.ssl.cf1.rackcdn.com/Margherita_Tomato_Flatbread.png</picture><description>Our flatbread topped with sun-dried tomato pesto and pizza mozzarella then baked to perfection and garnished with fresh tomatoes, basil pesto, balsamic glaze and fresh Parmesan.</description><rating>0.00</rating><rating>0.00</rating><category>Appetizer</category></result><result><id>98</id><merchid>1</merchid><name>BBQ Chicken and Bacon</name><cost>11.99</cost><picture>https://1093ea74d9df51084c1f-6ee0df3f8d1044014da148c7381a9023.ssl.cf1.rackcdn.com/BBQ_Chicken_and_Bacon_Flatbread.png</picture><description>Diced BBQ chicken, bacon and red onions baked on our flatbread with sweet and smoky BBQ sauce and pizza mozzarella, then topped with a drizzle of ranch dressing and a sprinkling of fresh parsley.</description><rating>0.00</rating><rating>0.00</rating><category>Appetizer</category></result><result><id>99</id><merchid>1</merchid><name>Bandera Pizza Bread</name><cost>8.99</cost><picture>https://c279673.ssl.cf1.rackcdn.com/banderaBread.jpg</picture><description>Our golden pizza bread brushed with Italian seasoning, baked with pizza mozzarella and Parmesan. Served with Santa Fe ranch dip.</description><rating>0.00</rating><rating>0.00</rating><category>Appetizer</category></result><result><id>100</id><merchid>1</merchid><name>Pulled Pork Sliders</name><cost>10.99</cost><picture>https://c412879.ssl.cf1.rackcdn.com/6-pulled-pork-sliders.png</picture><description>Three pulled pork sliders tossed in whisky BBQ sauce and topped with crispy onion straws.</description><rating>0.00</rating><rating>0.00</rating><category>Appetizer</category></result></results>";
    NSDictionary *fakeHeaders = @{@"Content-Length" : @"4000"};
    NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:200 HTTPVersion:nil headerFields:fakeHeaders];
	
    // Initialize the mock network client that will return the fake data.
    MMMockNetworkClient *fakeClient = [[MMMockNetworkClient alloc] initWithFakeResponse:response withFakeData:fakeResponse withFakeError:nil];
	
    // Set the mock network client here
    dbFetcher.networkClient = fakeClient;
	
    // Perform any assertions here. You can ensure that the user is not nil, if properties
    // were set, if the response is ok.
	mockDelegate.arrayResponseCallback= ^(NSArray *menuItems, MMDBFetcherResponse *response) {
		XCTAssertTrue(response.wasSuccessful, @"Should be successful.");
		for(MMMenuItem * item in menuItems) {
			XCTAssert([MMValidator isValidMenuItem:item], @"Failed to Validate item");
		}
	};
	
    // Be sure to set network client to nil
    dbFetcher.networkClient = nil;
}






/* Need to update DBFetcher so this test pasts */
<<<<<<< HEAD
- (void)testGetUser_ServerError {
    // Setup fake response from server.
    NSString* fakeResponse =  @"<?xml version=\"1.0\" encoding=\"ISO-8859-1\" ?><results></results>";
    NSDictionary *fakeHeaders = @{@"Content-Length" : [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:[fakeResponse length]]]};
    NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:500 HTTPVersion:nil headerFields:fakeHeaders];
    
    // Initialize the mock network client that will return the fake data.
    MMMockNetworkClient *fakeClient = [[MMMockNetworkClient alloc] initWithFakeResponse:response withFakeData:fakeResponse withFakeError:nil];
    
    // Set the mock network client here
    dbFetcher.networkClient = fakeClient;
    
    // Perform any assertions here. You can ensure that the user is not nil, if properties
    // were set, if the response is ok.
    mockDelegate.userResponseCallback = ^(MMUser* user, MMDBFetcherResponse* response) {
        XCTAssertNil(user, @"User should be nil.");
        XCTAssertFalse(response.wasSuccessful, @"Should fail (500 Status code).");
    };
    
    [dbFetcher getUser:@"cmoresid@ualberta.ca"];
    
    // Be sure to set network client to nil
    dbFetcher.networkClient = nil;
}
=======
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
/*
- (void)testGetMenu {
    MMDBFetcher *fetcher = [[MMDBFetcher alloc] initWithNetworkClient:[[MMNetworkRequestProxy alloc] init]];
    MMMockDBFetcherDelegate *fakeDelegate = [[MMMockDBFetcherDelegate alloc] init];

	
	    __block BOOL waitingForBlock = YES;
	
    fakeDelegate.arrayResponseCallback= ^(NSArray *menuItems, MMDBFetcherResponse *response) {
		NSLog(@"Responded");

		for(MMMenuItem * item in menuItems) {
			XCTAssert([MMValidator isValidMenuItem:item], @"Failed to Validate item");
		}
			
		waitingForBlock = NO;
		
		    };
	
    fetcher.delegate = fakeDelegate;
	
	[fetcher getRestrictedMenu:[NSNumber numberWithInt:1] withUserEmail:@"bieber3@ualberta.ca"];
	
	while(waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
	

}*/
>>>>>>> 9fdc8658eecea7653f78a139457006dda8a309be


@end
