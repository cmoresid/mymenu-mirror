//
//  MMDBFetcher.m
//  MyMenu
//
//  Created by Chris Moulds on 1/25/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMDBFetcher.h"
#import "MMRestriction.h"
#import "MMSpecial.h"
#import "RXMLElement.h"

@implementation MMDBFetcher

NSMutableData * responseData;

- (id)init
{
    self = [super init];
    
    if (self){
        responseData = [[NSMutableData alloc] init];
    }
    
    return self;
}

- (void) addUser : (MMUser*) user{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@"http://mymenuapp.ca/php/users/put.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    NSString *initstore = @"email=%@&firstname=%@&lastname=%@&password=%@&city=%@&locality=%@&country=%@&gender=%@&birthday=%@&birthmonth=%@&birthyear=%@&confirmcode=y";

    NSString *adduser = [NSString stringWithFormat:initstore, user.email, user.firstName,
                         user.lastName, user.password, user.city, user.locality, user.country,
                         user.gender, user.birthday, user.birthmonth, user.birthyear];
    
    [request setValue:[NSString stringWithFormat:@"%d", [adduser length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[adduser dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (bool) userExists : (NSString*) email{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    NSString *checkstring = @"query=select id from users where email='%@'";
    NSString *query = [NSString stringWithFormat:checkstring, email];
    
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];

    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse * response = [[NSURLResponse alloc] init];
    NSError * error = [[NSError alloc] init];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
    NSArray *rxmlResult = [rootXML children:@"result"];
    return rxmlResult.count > 0;
}

- (NSInteger) userVerified : (MMUser*) user{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    NSString *checkstring = @"query=select id from users where email='%@' AND password='%@'";
    NSString *query = [NSString stringWithFormat:checkstring, user.email, user.password];
    
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse * response = [[NSURLResponse alloc] init];
    NSError * error = [[NSError alloc] init];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
    NSArray *rxmlResult = [rootXML children:@"result"];
    
    if(rxmlResult.firstObject >= 0)
        return (NSInteger)rxmlResult.firstObject;
    else return -1;
}


//**TODO**//
- (void) updateUserRestrictions : (NSInteger*) uid : (NSArray*) restrictions {

    
}

//**TODO**//
- (NSArray*) getUserRestrictions : (NSInteger*) uid{
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    NSArray *rests = [[NSMutableArray alloc] init];
    return rests;
}

- (NSArray*) getAllRestrictions{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictions/custom.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    NSString *query = @"query=select name from restrictions";
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse * response = [[NSURLResponse alloc] init];
    NSError * error = [[NSError alloc] init];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
    NSArray *rxmlResult = [rootXML children:@"result"];
    
    return rxmlResult;
}

//**TODO**//
- (NSArray*) getSpecials : (NSString*) day{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/specials/custom.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    NSString *prequery = @"query=select * from specials where weekday = '%@'";
    NSString *query = [NSString stringWithFormat:prequery, day];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    NSArray *specials = [[NSMutableArray alloc] init];
    return specials;
}

- (NSArray*) getCompressedMerchants{
    NSArray *merchants = [[NSMutableArray alloc] init];
    return merchants;
}

//**TODO**//
- (MMMerchant*) getMerchant : (NSInteger*) mid{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/merchusers/custom.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    NSString *prequery = @"query=select * from merchusers where id = '%@'";
    NSString *query = [NSString stringWithFormat:prequery, mid];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    
    
    NSArray *merchants = [[NSMutableArray alloc] init];
    return merchants;
}

//**TODO**//
- (NSArray*) getMenu : (NSInteger*) merchid{
    NSArray *menu = [[NSMutableArray alloc] init];
    return menu;
}

@end