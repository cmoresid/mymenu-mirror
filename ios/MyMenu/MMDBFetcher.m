//
//  Copyright (C) 2014  MyMenu, Inc.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see [http://www.gnu.org/licenses/].
//

#import "MMDBFetcher.h"
#import "RXMLElement.h"
#import "MMDBFetcherResponse.h"
#import "MMNetworkClientProxy.h"

@implementation MMDBFetcher

static MMDBFetcher *instance;

+ (MMDBFetcher*)get {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] initWithNetworkClient:[[MMNetworkRequestProxy alloc] init]];
        }
    }
    
    return instance;
}

- (id)init {
    self = [super init];

    if (self) {
        self.networkClient = [[MMNetworkRequestProxy alloc] init];
    }

    return self;
}

- (id)initWithNetworkClient:(id<MMNetworkClientProtocol>)client {
    self = [super init];
    
    if (self) {
        self.networkClient = client;
    }
    
    return self;
}

- (void)addUser:(MMUser *)user {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/put.php"]];

    NSString *queryFormat = @"email=%@&firstname=%@&lastname=%@&password=%@&city=%@&locality=%@&country=%@&gender=%c&birthday=%@&birthmonth=%@&birthyear=%@&confirmcode=y";
    NSString *query = [NSString stringWithFormat:queryFormat, user.email, user.firstName,
                                                 user.lastName, user.password, user.city, user.locality, user.country,
                                                 user.gender, user.birthday, user.birthmonth, user.birthyear];


    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse* dbResponse = [self createResponseWith:data withError:error];
        
                                if (dbResponse.wasSuccessful) {
                                    [self.delegate didCreateUser:true withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didCreateUser:false withResponse:dbResponse];
                                }
                            }];
}

- (MMDBFetcherResponse*)createResponseWith:(NSData*)data withError:(NSError*)error
{
    MMDBFetcherResponse* response = [[MMDBFetcherResponse alloc] init];
    
    if ([data length] > 0 && error == nil) {
        response.wasSuccessful = true;
    }
    else {
        response.wasSuccessful = false;
        
        if ([data length] == 0 && error == nil)
            [response.messages addObject:@"No response received."];
        else if (error != nil)
            [response.messages addObject:[NSString stringWithFormat:@"Error : %@", error]];
    }

    return response;
}

- (void)getUser:(NSString *)email {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];

    NSString *prequery = @"query=select * from users where email = '%@'";
    NSString *query = [NSString stringWithFormat:prequery, email];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];

    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse* dbResponse = [self createResponseWith:data withError:error];
        
                                if (dbResponse.wasSuccessful) {
                                    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
            
                                    MMUser *user = [[MMUser alloc] init];
            
                                    [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                                        user.email = [e child:@"email"].text;
                                        user.firstName = [e child:@"firstname"].text;
                                        user.lastName = [e child:@"lastname"].text;
                                        user.password = [e child:@"password"].text;
                                        user.city = [e child:@"city"].text;
                                        user.locality = [e child:@"locality"].text;
                                        user.country = [e child:@"country"].text;
                                        user.gender = [[e child:@"gender"].text characterAtIndex:0];
                                        user.birthday = [e child:@"birthday"].text;
                                        user.birthmonth = [e child:@"birthmonth"].text;
                                        user.birthyear = [e child:@"birthyear"].text;
                                    }];
                                    
                                    // Check if user was found, based on whether or not
                                    // email was populated.
                                    if (user.email == nil) {
                                        user = nil;
                                    }
            
                                    [self.delegate didRetrieveUser:user withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didRetrieveUser:nil withResponse:dbResponse];
                                }
                            }];
}

- (void)editUser:(MMUser*)user {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/update.php"]];
    
    NSString *queryFormat = @"query=set firstname='%@',lastname='%@',city='%@',locality='%@',gender='%c',birthday='%@',birthmonth='%@',birthyear='%@' where email = '%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, user.firstName,
                       user.lastName, user.city, user.locality,
                       user.gender, user.birthday, user.birthmonth, user.birthyear, user.email];
    
    
    
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse* dbResponse = [self createResponseWith:data withError:error];
        
                                if (dbResponse.wasSuccessful) {
                                    [self.delegate didUpdateUser:TRUE withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didUpdateUser:FALSE withResponse:dbResponse];
                                }
                            }];
}

- (void)userExists:(NSString *)email {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=select id from users where email='%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, email];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                MMDBFetcherResponse* dbResponse = [[MMDBFetcherResponse alloc] init];
                                                
                                                if ([data length] > 0 && error == nil) {
                                                    dbResponse.wasSuccessful = TRUE;
                                                    
                                                    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
                                                    NSArray *rxmlResult = [rootXML children:@"result"];
                                                    
                                                    BOOL userExists = (rxmlResult.count > 0);
                                                    
                                                    [self.delegate doesUserExist:userExists withResponse:dbResponse];
                                                }
                                                else {
                                                    dbResponse.wasSuccessful = FALSE;
                                                    
                                                    if (error != nil) {
                                                        [dbResponse.messages addObject:@"error"];
                                                        
                                                        [self.delegate doesUserExist:FALSE withResponse:dbResponse];
                                                    }
                                                }
                                            }];
}

- (void)userVerified:(MMUser *)user {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=select id from users where email='%@' AND password='%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, user.email, user.password];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse* dbResponse = [self createResponseWith:data withError:error];
        
                                if (dbResponse.wasSuccessful) {
                                    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
                                    NSArray *rxmlResult = [rootXML children:@"result"];
            
                                    NSInteger resultCode = (rxmlResult.firstObject >= 0) ? ((NSInteger) rxmlResult.firstObject) : -1;
            
                                    [self.delegate wasUserVerified:resultCode withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate wasUserVerified:-1 withResponse:dbResponse];
                                }
                            }];
}

- (void)addUserRestrictions:(NSString *)email :(NSArray *)restrictions {
    NSMutableURLRequest* removeRestrictionsRequest = [self removeUserRestrictions:email];
    
    [self.networkClient performNetworkRequest:removeRestrictionsRequest
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                    MMDBFetcherResponse* dbResponse = [self createResponseWith:data withError:error];
                                
                                    if (dbResponse.wasSuccessful) {
                                        [self innerAddUserRestrictions:email :restrictions];
                                    }
                                    else {
                                        [dbResponse.messages addObject:@"Unable to remove existing restrictions."];
                                        [self.delegate didAddUserRestrictions:FALSE withResponse:dbResponse];
                                    }
                                }];
}

- (void)innerAddUserRestrictions:(NSString*)email :(NSArray*)restrictions {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictionuserlink/put.php"]];
    
    NSString *queryFormat = @"restrictid=%@&email=%@";
    
    for (NSUInteger i = 0; i < [restrictions count]; i++) {
        NSString *query = [NSString stringWithFormat:queryFormat, [restrictions objectAtIndex:i], email];
        [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
        
        [self.networkClient performNetworkRequest:request
                                completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                    MMDBFetcherResponse* dbResponse = [self createResponseWith:data withError:error];
                                    
                                    if (dbResponse.wasSuccessful) {
                                        [self.delegate didAddUserRestrictions:TRUE withResponse:dbResponse];
                                    }
                                    else {
                                        [dbResponse.messages addObject:@"Unable to add a dietary restriction."];
                                        [self.delegate didAddUserRestrictions:FALSE withResponse:dbResponse];
                                    }
                                }];
    }
}

- (NSMutableURLRequest*)removeUserRestrictions:(NSString *)email {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictionuserlink/custom.php"]];

    NSString *queryFormat = @"query=delete from restrictionuserlink where email='%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, email];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

- (void)getUserRestrictions:(NSString *)email {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictionuserlink/custom.php"]];

    NSString *queryFormat = @"query=select restrictid from restrictionuserlink where email ='%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, email];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                    MMDBFetcherResponse* dbResponse = [self createResponseWith:data withError:error];
                                
                                    if (dbResponse.wasSuccessful) {
                                        RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
                                    
                                        NSMutableArray *restrictions = [[NSMutableArray alloc] init];
                                    
                                        [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                                            MMRestriction *restriction = [[MMRestriction alloc] init];
                                            restriction.id = [NSNumber numberWithInt:[e child:@"restrictid"].textAsInt];
                                            [restrictions addObject:restriction];
                                        }];
                                    
                                        [self.delegate didRetrieveUserRestrictions:restrictions withResponse:dbResponse];
                                    }
                                    else {
                                        [self.delegate didRetrieveUserRestrictions:nil withResponse:dbResponse];
                                    }
                                }];
}

- (void)getAllRestrictions {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictions/custom.php"]];

    NSString *query = @"query=select id, user_label, picture from restrictions";
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    
    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                    MMDBFetcherResponse* dbResponse = [self createResponseWith:data withError:error];
                                
                                    if (dbResponse.wasSuccessful) {
                                        RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
                                    
                                        NSMutableArray *restrictions = [[NSMutableArray alloc] init];
                                    
                                        [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                                            MMRestriction *restriction = [[MMRestriction alloc] init];
                                            restriction.id = [NSNumber numberWithInt:[e child:@"id"].textAsInt];
                                        
                                            restriction.name = [e child:@"user_label"].text;
                                            restriction.image = [e child:@"picture"].text;
                                        
                                            [restrictions addObject:restriction];
                                        }];
                                    
                                        [self.delegate didRetrieveAllRestrictions:restrictions withResponse:dbResponse];
                                    }
                                    else {
                                        [self.delegate didRetrieveAllRestrictions:nil withResponse:dbResponse];
                                    }
                                }];
}

- (void)getSpecials:(NSString *)day withType:(NSInteger)type {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/specials/custom.php"]];

    NSString *queryFormat = @"query=SELECT specials.merchid, merchusers.business_name AS business, specials.name, specials.description, specials.picture, specials.occurType  FROM specials INNER JOIN merchusers ON specials.merchid=merchusers.id WHERE specials.weekday = '%@' AND specials.categoryid = %d";
    NSString *query = [NSString stringWithFormat:queryFormat, day, type];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                    MMDBFetcherResponse* dbResponse = [self createResponseWith:data withError:error];
                                
                                    if (dbResponse.wasSuccessful) {
                                        RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
                                        NSMutableArray *specials = [[NSMutableArray alloc] init];
                                    
                                        [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                                            MMSpecial *special = [[MMSpecial alloc] init];
                                            special.merchid = [NSNumber numberWithInt:[e child:@"merchid"].textAsInt];
                                            special.merchant = [e child:@"business"].text;
                                            special.name = [e child:@"name"].text;
                                            special.desc = [e child:@"description"].text;
                                            special.picture = [e child:@"picture"].text;
                                            special.occurtype = [NSNumber numberWithInt:[e child:@"occurtype"].textAsInt];
                                            [specials addObject:special];
                                        }];
                                    
                                        [self.delegate didRetrieveSpecials:specials withResponse:dbResponse];
                                    }
                                    else {
                                        [self.delegate didRetrieveSpecials:nil withResponse:dbResponse];
                                    }
                            }];
}

- (void)getCompressedMerchants {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/merchusers/custom.php"]];

    NSString *query = @"query=select id, business_name, business_number, rating, business_picture, lat, longa, business_description from merchusers";
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                    MMDBFetcherResponse* dbResponse = [self createResponseWith:data withError:error];
                                
                                    if (dbResponse.wasSuccessful) {
                                        RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
                                        NSMutableArray *merchants = [[NSMutableArray alloc] init];
                                    
                                        [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                                            MMMerchant *merchant = [[MMMerchant alloc] init];
                                            merchant.mid = [NSNumber numberWithInt:[e child:@"id"].textAsInt];
                                            merchant.businessname = [e child:@"business_name"].text;
                                            merchant.phone = [e child:@"business_number"].text;
                                            merchant.desc = [e child:@"business_description"].text;
                                            merchant.lat = [NSNumber numberWithDouble:[e child:@"lat"].textAsDouble ];
                                            merchant.longa = [NSNumber numberWithDouble:[e child:@"longa"].textAsDouble];
                                            merchant.rating = [NSNumber numberWithInt:[e child:@"rating"].textAsInt];
                                            merchant.picture = [e child:@"business_picture"].text;
                                            [merchants addObject:merchant];
                                        }];
                                    
                                        [self.delegate didRetrieveCompressedMerchants:merchants withResponse:dbResponse];
                                    }
                                    else {
                                        [self.delegate didRetrieveCompressedMerchants:nil withResponse:dbResponse];
                                    }
                            }];
}

- (void)getMerchant:(NSNumber *)mid {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/merchusers/custom.php"]];

    NSString *queryFormat = @"query=select * from merchusers where id = %@ ";
    NSString *query = [NSString stringWithFormat:queryFormat, mid];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                    MMDBFetcherResponse* dbResponse = [self createResponseWith:data withError:error];
                                
                                    if (dbResponse.wasSuccessful) {
                                        RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
                                        MMMerchant *merchant = [[MMMerchant alloc] init];
                                    
                                        [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                                            merchant.mid = [NSNumber numberWithInt: [e child:@"id"].textAsInt];
                                            merchant.businessname = [e child:@"business_name"].text;
                                            merchant.phone = [e child:@"business_number"].text;
                                            merchant.desc = [e child:@"business_description"].text;
                                            merchant.address = [e child:@"business_address1"].text;
                                            merchant.city = [e child:@"business_city"].text;
                                            merchant.locality = [e child:@"business_locality"].text;
                                            merchant.postalcode = [e child:@"business_postalcode"].text;
                                            merchant.lat = [NSNumber numberWithDouble:[e child:@"lat"].textAsDouble];
                                            merchant.longa = [NSNumber numberWithDouble:[e child:@"longa"].textAsDouble];
                                            merchant.rating = [NSNumber numberWithDouble:[e child:@"rating"].textAsDouble];
                                            merchant.picture = [e child:@"business_picture"].text;
                                            merchant.facebook = [e child:@"facebook"].text;
                                            merchant.twitter = [e child:@"twitter"].text;
                                            merchant.website = [e child:@"website"].text;
                                            merchant.pricehigh = [NSNumber numberWithFloat: [e child:@"pricehigh"].textAsInt];
                                            merchant.pricelow = [NSNumber numberWithFloat: [e child:@"pricelow"].textAsInt];
                                            merchant.opentime = [NSNumber numberWithInt: [e child:@"opentime"].textAsInt];
                                            merchant.closetime = [NSNumber numberWithInt: [e child:@"closetime"].textAsInt];
                                        }];
                                    
                                        [self.delegate didRetrieveMerchant:merchant withResponse:dbResponse];
                                    }
                                    else {
                                        [self.delegate didRetrieveMerchant:nil withResponse:dbResponse];
                                    }
                            }];
}

// TODO
- (void)getMenu:(NSInteger *)merchid {
    [self.delegate didRetrieveMenuItems:[[NSArray alloc] init] withResponse:nil];
}

@end
