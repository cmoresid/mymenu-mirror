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
#import "MMNetworkClientProxy.h"
#import <MapKit/MapKit.h>
#import "MMMenuItem.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>
#import <RACEXTScope.h>

@interface MMDBFetcher ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *networkManager;

- (BOOL)canPerformCallback:(id)delegate withSelector:(SEL)delegateSelector;

@end

@implementation MMDBFetcher

static MMDBFetcher *instance;

+ (MMDBFetcher *)get {
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

- (id)initWithNetworkClient:(id <MMNetworkClientProtocol>)client {
    self = [super init];

    if (self) {
        self.networkClient = client;
        
        self.networkManager = [AFHTTPRequestOperationManager manager];
        self.networkManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.networkManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }

    return self;
}

- (BOOL)canPerformCallback:(id)delegate withSelector:(SEL)delegateSelector {
    return [delegate conformsToProtocol:@protocol(MMDBFetcherDelegate)] && [delegate respondsToSelector:delegateSelector];
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
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didCreateUser:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didCreateUser:withResponse");
                                    return;
                                }

                                if (dbResponse.wasSuccessful) {
                                    [self.delegate didCreateUser:true withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didCreateUser:false withResponse:dbResponse];
                                }
                            }];
}

- (void)addMenuRating:(MMMenuItemRating *)rating {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/ratings/custom.php"]];
    NSString *dateString = @"yyyy-MM-dd HH:mm:ss";
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:dateString];

    NSString *queryFormat = @"query=insert into ratings (useremail, menuid, merchid, rating, ratingdescription, ratingdate) values('%@', %@, %@, %@, '%@', sysdate())";
    NSString *query = [NSString stringWithFormat:queryFormat, rating.useremail, rating.menuid, rating.merchid, rating.rating, rating.review];


    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didCreateRating:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didCreateRating:withResponse");
                                    return;
                                }

                                if (dbResponse.wasSuccessful) {
                                    [self.delegate didCreateRating:true withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didCreateRating:false withResponse:dbResponse];
                                }
                            }];
}

- (RACSignal *)getItemRatingsMerchantRecent:(NSNumber *)merchid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *sqlQueryFormat = @"SELECT r.useremail, r.rating, r.ratingdate, r.ratingdescription, m.name, r.id, u.firstname, u.lastname, r.likecount, mu.business_name, m.picture, m.id as menuid, mu.id as merchid FROM ratings r, menu m, users u, merchusers mu WHERE r.merchid=%@ AND m.merchid = r.merchid AND m.id = r.menuid AND u.email = r.useremail AND mu.id = m.merchid ORDER BY ratingdate DESC";
        NSString *sqlQuery = [NSString stringWithFormat:sqlQueryFormat, merchid];
        NSDictionary *parameters = @{@"query": sqlQuery};
        
        AFHTTPRequestOperation *operation = [self.networkManager POST:@"http://mymenuapp.ca/php/ratings/custom.php" parameters:parameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                RXMLElement *rootXML = [RXMLElement elementFromXMLData:responseObject];
                
                NSMutableArray *ratings = [[NSMutableArray alloc] init];
                NSDateFormatter *dateform = [[NSDateFormatter alloc] init];
                [dateform setDateFormat:@"yyyy-MM--d H:m:s"];
                
                [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                    MMMenuItemRating *rating = [[MMMenuItemRating alloc] init];
                    rating.id = [NSNumber numberWithInt:[e child:@"id"].textAsInt];
                    rating.useremail = [e child:@"useremail"].text;
                    rating.merchid = [NSNumber numberWithInt:[e child:@"merchid"].textAsInt];
                    rating.menuid = [NSNumber numberWithInt:[e child:@"menuid"].textAsInt];
                    rating.rating = [NSNumber numberWithDouble:[e child:@"rating"].textAsDouble];
                    rating.date = [dateform dateFromString:[e child:@"ratingdate"].text];
                    rating.review = [e child:@"ratingdescription"].text;
                    rating.menuitemname = [e child:@"name"].text;
                    rating.firstname = [e child:@"firstname"].text;
                    rating.lastname = [e child:@"lastname"].text;
                    rating.likeCount = [NSNumber numberWithInt:[e child:@"likecount"].textAsInt];
                    rating.merchantName = [e child:@"business_name"].text;
                    rating.itemImage = [e child:@"picture"].text;
                    [ratings addObject:rating];
                }];

                [subscriber sendNext:ratings];
                [subscriber sendCompleted];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [subscriber sendError:error];
            }
        ];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}
- (RACSignal *)getItemRatingsMerchantTop:(NSNumber *)merchid {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *sqlQueryFormat = @"SELECT r.useremail, r.rating, r.ratingdate, r.ratingdescription, m.name, r.id, u.firstname, u.lastname, r.likecount, mu.business_name, m.picture, m.id as menuid, mu.id as merchid FROM ratings r, menu m, users u, merchusers mu WHERE r.merchid=%@ AND m.merchid = r.merchid AND m.id = r.menuid AND u.email = r.useremail AND mu.id = m.merchid ORDER BY r.likecount DESC";
        NSString *sqlQuery = [NSString stringWithFormat:sqlQueryFormat, merchid];
        NSDictionary *parameters = @{@"query": sqlQuery};
        
        AFHTTPRequestOperation *operation = [self.networkManager POST:@"http://mymenuapp.ca/php/ratings/custom.php" parameters:parameters
                                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                  RXMLElement *rootXML = [RXMLElement elementFromXMLData:responseObject];
                                                                  
                                                                  NSMutableArray *ratings = [[NSMutableArray alloc] init];
                                                                  NSDateFormatter *dateform = [[NSDateFormatter alloc] init];
                                                                  [dateform setDateFormat:@"yyyy-MM--d H:m:s"];
                                                                  
                                                                  [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                                                                      MMMenuItemRating *rating = [[MMMenuItemRating alloc] init];
                                                                      rating.id = [NSNumber numberWithInt:[e child:@"id"].textAsInt];
                                                                      rating.useremail = [e child:@"useremail"].text;
                                                                      rating.merchid = [NSNumber numberWithInt:[e child:@"merchid"].textAsInt];
                                                                      rating.menuid = [NSNumber numberWithInt:[e child:@"menuid"].textAsInt];
                                                                      rating.rating = [NSNumber numberWithDouble:[e child:@"rating"].textAsDouble];
                                                                      rating.date = [dateform dateFromString:[e child:@"ratingdate"].text];
                                                                      rating.review = [e child:@"ratingdescription"].text;
                                                                      rating.menuitemname = [e child:@"name"].text;
                                                                      rating.firstname = [e child:@"firstname"].text;
                                                                      rating.lastname = [e child:@"lastname"].text;
                                                                      rating.likeCount = [NSNumber numberWithInt:[e child:@"likecount"].textAsInt];
                                                                      rating.merchantName = [e child:@"business_name"].text;
                                                                      rating.itemImage = [e child:@"picture"].text;
                                                                      [ratings addObject:rating];
                                                                  }];
                                                                  
                                                                  [subscriber sendNext:ratings];
                                                                  [subscriber sendCompleted];
                                                              }
                                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                  [subscriber sendError:error];
                                                              }
                                             ];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

- (void)getItemRatings:(NSNumber *)itemid {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/ratings/custom.php"]];

    NSString *queryFormat = @"query=SELECT r.useremail, r.rating, r.ratingdate, r.ratingdescription, m.name, u.firstname, u.lastname, r.id, mu.business_name, m.picture, m.id as menuid, mu.id as merchid, r.likecount FROM ratings r, menu m, users u, merchusers mu WHERE m.id=%@ AND m.id = r.menuid AND u.email = r.useremail AND mu.id = m.merchid ORDER BY ratingdate DESC";
    NSString *query = [NSString stringWithFormat:queryFormat, itemid];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self getRatingsHelper:request withTopFlag:NO];

}



- (void)getItemRatingsTop:(NSNumber *)itemid {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/ratings/custom.php"]];

    NSString *queryFormat = @"query=SELECT r.useremail, r.rating, r.ratingdate, r.ratingdescription, r.id, m.name, u.firstname, u.lastname, r.likecount, mu.business_name, m.picture, m.id as menuid, mu.id as merchid FROM menu m, users u, ratings r, merchusers mu WHERE r.menuid=%@ AND m.merchid = r.merchid AND m.id = r.menuid AND u.email = r.useremail AND mu.id = m.merchid ORDER BY r.likecount DESC";
    NSString *query = [NSString stringWithFormat:queryFormat, itemid];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self getRatingsHelper:request withTopFlag:YES];

}

- (MMDBFetcherResponse *)createResponseWith:(NSData *)data withError:(NSError *)error {
    MMDBFetcherResponse *response = [[MMDBFetcherResponse alloc] init];

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

    NSString *prequery = @"query=SELECT * FROM users WHERE email='%@'";
    NSString *query = [NSString stringWithFormat:prequery, email];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];

    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didRetrieveUser:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didRetrieveUser:withResponse:");
                                    return;
                                }

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

- (void)editUser:(MMUser *)user {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=UPDATE users SET firstname='%@',lastname='%@', city='%@',locality='%@' WHERE email = '%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, user.firstName,
                                                 user.lastName, user.city, user.locality, user.email];


    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didUpdateUser:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didUpdateUser:withResponse");
                                    return;
                                }

                                if (dbResponse.wasSuccessful) {
                                    [self.delegate didUpdateUser:TRUE withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didUpdateUser:FALSE withResponse:dbResponse];
                                }
                            }];
}

- (RACSignal *)changePasswordForUser:(MMUser *)user {
    static NSString *url = @"http://mymenuapp.ca/php/users/custom.php";
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *sqlQueryFormat = @"UPDATE users SET password='%@' WHERE email = '%@'";
        NSString *sqlQuery = [NSString stringWithFormat:sqlQueryFormat, user.password, user.email];
        
        NSDictionary *parameters = @{@"query": sqlQuery};
        AFHTTPRequestOperation *operation = [self.networkManager POST:url parameters:parameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [subscriber sendNext:@YES];
                [subscriber sendCompleted];
        }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

- (void)editReview:(MMMenuItemRating *)review {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=UPDATE ratings SET rating='%@',ratingdescription='%@',ratingdate=sysdate() WHERE id=%@";
    NSString *query = [NSString stringWithFormat:queryFormat, review.rating, review.review, review.id];


    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didUpdateRatings:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didUpdateRatings:withResponse:");
                                    return;
                                }

                                if (dbResponse.wasSuccessful) {
                                    [self.delegate didUpdateRatings:TRUE withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didUpdateRatings:FALSE withResponse:dbResponse];
                                }
                            }];
}

- (void)userExists:(NSString *)email {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=SELECT id FROM users WHERE email='%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, email];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [[MMDBFetcherResponse alloc] init];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(doesUserExist:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - doesUserExist:withResponse:");
                                    return;
                                }

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

    NSString *queryFormat = @"query=SELECT id FROM users WHERE email='%@' AND password='%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, user.email, user.password];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(wasUserVerified:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - wasUserVerified:withResponse:");
                                    return;
                                }

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

- (void)addUserRestrictions:(NSString *)email withRestrictionIDs:(NSArray *)restrictions {
    NSMutableURLRequest *removeRestrictionsRequest = [self removeUserRestrictions:email];

    [self.networkClient performNetworkRequest:removeRestrictionsRequest
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (dbResponse.wasSuccessful) {
                                    [self innerAddUserRestrictions:email withRestrictionIDs:restrictions];
                                }
                                else {
                                    [dbResponse.messages addObject:@"Unable to remove existing restrictions."];
                                    [self.delegate didAddUserRestrictions:FALSE withResponse:dbResponse];
                                }
                            }];
}


- (void)innerAddUserRestrictions:(NSString *)email withRestrictionIDs:(NSArray *)restrictions {
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
                                    MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                    if (!dbResponse.wasSuccessful) {
                                        [dbResponse.messages addObject:@"Unable to add a dietary restriction."];
                                        [self.delegate didAddUserRestrictions:FALSE withResponse:dbResponse];
                                    }
                                }];
    }
}

- (NSMutableURLRequest *)removeUserRestrictions:(NSString *)email {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictionuserlink/custom.php"]];

    NSString *queryFormat = @"query=DELETE FROM restrictionuserlink WHERE email='%@'";
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

    NSString *queryFormat = @"query=SELECT restrictid FROM restrictionuserlink WHERE email ='%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, email];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didRetrieveUserRestrictions:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didRetrieveUserRestrictions:withResponse:");
                                    return;
                                }

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

    NSString *query = @"query=SELECT id, user_label, picture FROM restrictions";
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didRetrieveAllRestrictions:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didRetrieveAllRestrictions:withResponse:");
                                    return;
                                }

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

/**
 * Get today as a string, e.g. 'tuesday'
 */
- (NSString *)getDay:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    return [[dateFormatter stringFromDate:date] lowercaseString];
}


- (void)getDrinkSpecialsForDate:(NSDate *)date {
    NSString *weekday = [self getDay:date];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/specials/custom.php"]];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [format stringFromDate:date];

    NSString *queryFormat = @"query=SELECT DISTINCT specials.id, specials.merchid, merchusers.business_name AS business, specials.name, specials.description, specials.picture, specials.occurType FROM specials INNER JOIN merchusers ON specials.merchid=merchusers.id WHERE (specials.weekday = '%@' OR (datediff(specials.startdate, '%@')<= 0 AND datediff('%@', specials.enddate)<=0)) AND specials.categoryid=2";
    NSString *query = [NSString stringWithFormat:queryFormat, weekday, dateString, dateString];

	
	
	
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didRetrieveSpecials:forDate:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didRetrieveSpecials:forDate:withResponse:");
                                    return;
                                }

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
                                        special.categoryid = [NSNumber numberWithInt:2];
                                        [specials addObject:special];
                                    }];

                                    [self.delegate didRetrieveSpecials:specials forDate:date withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didRetrieveSpecials:nil forDate:nil withResponse:dbResponse];
                                }
                            }];
}

- (void)getFoodSpecialsForDate:(NSDate *)date {
    NSString *weekday = [self getDay:date];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/specials/custom.php"]];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [format stringFromDate:date];

    NSString *queryFormat = @"query=SELECT DISTINCT specials.id, specials.merchid, merchusers.business_name AS business, specials.name, specials.description, specials.picture, specials.occurType FROM specials INNER JOIN merchusers ON specials.merchid=merchusers.id WHERE (specials.weekday = '%@' OR (datediff(specials.startdate, '%@')<= 0 AND datediff('%@', specials.enddate)<=0)) AND specials.categoryid=1";
    NSString *query = [NSString stringWithFormat:queryFormat, weekday, dateString, dateString];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didRetrieveSpecials:forDate:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didRetrieveSpecials:forDate:withResponse:");
                                    return;
                                }

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
                                        special.categoryid = [NSNumber numberWithInt:1];
                                        [specials addObject:special];
                                    }];

                                    [self.delegate didRetrieveSpecials:specials forDate:date withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didRetrieveSpecials:nil forDate:nil withResponse:dbResponse];
                                }
                            }];
}

- (void)getDessertSpecialsForDate:(NSDate *)date {
    NSString *weekday = [self getDay:date];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/specials/custom.php"]];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [format stringFromDate:date];

    NSString *queryFormat = @"query=SELECT DISTINCT specials.id, specials.merchid, merchusers.business_name AS business, specials.name, specials.description, specials.picture, specials.occurType FROM specials INNER JOIN merchusers ON specials.merchid=merchusers.id WHERE (specials.weekday = '%@' OR (datediff(specials.startdate, '%@')<= 0 AND datediff('%@', specials.enddate)<=0)) AND specials.categoryid=3";
    NSString *query = [NSString stringWithFormat:queryFormat, weekday, dateString, dateString];
    NSLog(@"%@",query);
	[request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didRetrieveSpecials:forDate:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didRetrieveSpecials:forDate:withResponse:");
                                    return;
                                }

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
                                        special.categoryid = [NSNumber numberWithInt:3];
                                        special.fetchDate = date;
                                        [specials addObject:special];
                                    }];

                                    [self.delegate didRetrieveSpecials:specials forDate:date withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didRetrieveSpecials:nil forDate:nil withResponse:dbResponse];
                                }
                            }];
}

- (RACSignal *)getCompressedMerchants:(CLLocation *)usrloc {
    CLLocationCoordinate2D coords = usrloc.coordinate;
    
    NSString *url = @"http://mymenuapp.ca/php/merchusers/custom.php";
    NSString *queryFormat = @"SELECT id, business_name, category, business_number, business_address1, rating, business_picture, business_description, distance, lat, longa FROM(SELECT id, business_name, category, business_number, business_address1, rating, business_picture, lat, longa, business_description, SQRT(longadiff - -latdiff)*111.12 AS distance FROM (SELECT m.id, m.business_name, mc.name AS category, m.business_number, m.business_address1, m.rating, m.business_picture, m.business_description, m.lat, m.longa, POW(m.longa - %@, 2) AS longadiff, POW(m.lat - %@, 2) AS latdiff FROM merchusers m, merchcategories mc WHERE m.categoryid=mc.id) AS temp) AS distances ORDER BY distance ASC LIMIT 50";
    
    NSString *sqlQuery = [NSString stringWithFormat:queryFormat, [NSNumber numberWithDouble:coords.longitude], [NSNumber numberWithDouble:coords.latitude]];
    NSDictionary *queryParameters = @{@"query": sqlQuery};
    
    return [self compressedMerchantsHelperWithUrl:url withParameters:queryParameters];
}

- (RACSignal *)getCompressedMerchantsByName:(CLLocation *)usrloc withName:(NSString *)merchname {
    CLLocationCoordinate2D coords = usrloc.coordinate;

    NSString *url = @"http://mymenuapp.ca/php/merchusers/custom.php";
    NSString *queryFormat = @"SELECT id, business_name, category, business_number, business_address1, rating, business_picture, business_description, distance, lat, longa FROM(SELECT id, business_name, category, business_number, business_address1, rating, business_picture, lat, longa, business_description, SQRT(longadiff - -latdiff)*111.12 AS distance FROM (SELECT m.id, m.business_name, mc.name AS category, m.business_number, m.business_address1, m.rating, m.business_picture, m.business_description, m.lat, m.longa, POW(m.longa - %@, 2) AS longadiff, POW(m.lat - %@, 2) AS latdiff FROM merchusers m, merchcategories mc WHERE m.categoryid=mc.id) AS temp) AS distances WHERE UPPER(business_name) LIKE UPPER('%%%@%%') ORDER BY distance ASC LIMIT 25";

    NSString *sqlQuery = [NSString stringWithFormat:queryFormat, [NSNumber numberWithDouble:coords.longitude], [NSNumber numberWithDouble:coords.latitude], merchname];
    
    //NSString *encodedQuery = [sqlQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *queryParameters = @{@"query": sqlQuery};

    return [self compressedMerchantsHelperWithUrl:url withParameters:queryParameters];
}

- (RACSignal *)getCompressedMerchantsByCuisine:(CLLocation *)usrloc withCuisine:(NSString *)cuisine {
    CLLocationCoordinate2D coords = usrloc.coordinate;

    NSString *url = @"http://mymenuapp.ca/php/merchusers/custom.php";
    NSString *queryFormat = @"SELECT id, business_name, category, business_number, business_address1, rating, business_picture, business_description, distance, lat, longa FROM(SELECT id, business_name, category, business_number, business_address1, rating, business_picture, lat, longa, business_description, SQRT(longadiff - -latdiff)*111.12 AS distance FROM (SELECT m.id, m.business_name, mc.name AS category, m.business_number, m.business_address1, m.rating, m.business_picture, m.business_description, m.lat, m.longa, POW(m.longa - %@, 2) AS longadiff, POW(m.lat - %@, 2) AS latdiff FROM merchusers m, merchcategories mc WHERE m.categoryid=mc.id) AS temp) AS distances WHERE category = '%@' ORDER BY distance ASC LIMIT 50";

    NSString *sqlQuery = [NSString stringWithFormat:queryFormat, [NSNumber numberWithDouble:coords.longitude], [NSNumber numberWithDouble:coords.latitude], cuisine];
    
    NSString *encodedQuery = [sqlQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *queryParameters = @{@"query": encodedQuery};

    return [self compressedMerchantsHelperWithUrl:url withParameters:queryParameters];
}

- (RACSignal *)getMerchant:(NSNumber *)mid {
    NSString *url = @"http://mymenuapp.ca/php/merchusers/custom.php";
    NSString *queryFormat = @"SELECT * FROM merchusers WHERE id=%@";
    NSString *sqlQuery = [NSString stringWithFormat:queryFormat, mid];
    NSDictionary *parameters = @{@"query": sqlQuery};
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AFHTTPRequestOperation *operation = [self.networkManager POST:url parameters:parameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                RXMLElement *rootXML = [RXMLElement elementFromXMLData:responseObject];
                MMMerchant *merchant = [[MMMerchant alloc] init];
                
                [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                    merchant.mid = [NSNumber numberWithInt:[e child:@"id"].textAsInt];
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
                    merchant.pricehigh = [NSNumber numberWithFloat:[e child:@"pricehigh"].textAsInt];
                    merchant.pricelow = [NSNumber numberWithFloat:[e child:@"pricelow"].textAsInt];
                    merchant.opentime = [e child:@"opentime"].text;
                    merchant.closetime = [e child:@"closetime"].text;
                }];
                
                [subscriber sendNext:merchant];
                [subscriber sendCompleted];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

- (RACSignal *)getMenuWithMerchantId:(NSNumber *)merchid withUserEmail:(NSString *)email; {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString *sqlFormat = @"SELECT m.id, m.merchid, m.name, m.cost, m.picture, m.description, m.rating, m.rating, mc.name AS category FROM menu m, menucategories mc WHERE m.id not IN(SELECT Distinct rml.menuid FROM restrictionmenulink rml WHERE rml.restrictid IN(SELECT rul.restrictid FROM restrictionuserlink rul WHERE rul.email='%@')) AND m.merchid = %d AND m.categoryid = mc.id";
        
        NSString *sqlQuery = [NSString stringWithFormat:sqlFormat, email, merchid.intValue];
        NSDictionary *queryParameters = @{@"query": sqlQuery};
        
        AFHTTPRequestOperation *operation = [self.networkManager POST:@"http://mymenuapp.ca/php/menu/custom.php" parameters:queryParameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
				NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                RXMLElement *rootXML = [RXMLElement elementFromXMLData:responseObject];
                NSMutableArray *menuitems = [[NSMutableArray alloc] init];
                
                [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                    MMMenuItem *item = [[MMMenuItem alloc] init];
                    item.itemid = [NSNumber numberWithInt:[e child:@"id"].textAsInt];
                    item.merchid = [NSNumber numberWithInt:[e child:@"merchid"].textAsInt];
                    item.name = [e child:@"name"].text;
                    item.cost = [NSNumber numberWithDouble:[e child:@"cost"].textAsDouble];
                    item.picture = [e child:@"picture"].text;
                    item.desc = [e child:@"description"].text;
                    item.rating = [NSNumber numberWithDouble:[e child:@"rating"].textAsDouble];
                    item.category = [e child:@"category"].text;
                    item.restrictionflag = FALSE;
                    
                    [menuitems addObject:item];
                }];
                
                [subscriber sendNext:menuitems];
                [subscriber sendCompleted];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [subscriber sendError:error];
            }
        ];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

- (RACSignal *)getRestrictedMenu:(NSNumber *)merchid withUserEmail:(NSString *)email {
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSString *sqlFormat = @"SELECT m.id, m.merchid, m.name, m.cost, m.picture, m.description, m.rating, m.rating, mc.name AS category FROM menu m, menucategories mc WHERE m.id IN(SELECT rml.menuid FROM restrictionmenulink rml WHERE rml.restrictid IN(SELECT rul.restrictid FROM restrictionuserlink rul WHERE rul.email='%@')) AND m.merchid = %d AND m.categoryid = mc.id";
        
        NSString *sqlQuery = [NSString stringWithFormat:sqlFormat, email, merchid.intValue];
        NSDictionary *queryParameters = @{@"query": sqlQuery};
        
        AFHTTPRequestOperation *operation = [self.networkManager POST:@"http://mymenuapp.ca/php/menu/custom.php" parameters:queryParameters
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                RXMLElement *rootXML = [RXMLElement elementFromXMLData:responseObject];
                
                NSMutableArray *restrictedMenuItems = [NSMutableArray new];
                
                [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                    MMMenuItem *item = [[MMMenuItem alloc] init];
                    item.itemid = [NSNumber numberWithInt:[e child:@"id"].textAsInt];
                    item.merchid = [NSNumber numberWithInt:[e child:@"merchid"].textAsInt];
                    item.name = [e child:@"name"].text;
                    item.cost = [NSNumber numberWithDouble:[e child:@"cost"].textAsDouble];
                    item.picture = [e child:@"picture"].text;
                    item.desc = [e child:@"description"].text;
                    item.rating = [NSNumber numberWithDouble:[e child:@"rating"].textAsDouble];
                    item.category = [e child:@"category"].text;
                    item.restrictionflag = TRUE;
                    
                    [restrictedMenuItems addObject:item];
                }];
                
                [subscriber sendNext:restrictedMenuItems];
                [subscriber sendCompleted];
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [subscriber sendError:error];
            }
        ];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

- (void)getModifications:(NSNumber *)menuid withUser:(NSString *)email {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/modificationmenulink/custom.php"]];

    NSString *queryFormat = @"query=SELECT modification FROM modificationmenulink WHERE menuid = %@ AND restrictid IN(SELECT restrictid FROM restrictionuserlink WHERE email = '%@')";

    NSString *query = [NSString stringWithFormat:queryFormat, menuid, email];

    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didRetrieveModifications:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didRetrieveModifications:withResponse:");
                                    return;
                                }

                                if (dbResponse.wasSuccessful) {
                                    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];

                                    NSMutableArray *modifications = [[NSMutableArray alloc] init];
                                    [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                                        NSString *modification;
                                        modification = [e child:@"modification"].text;
                                        [modifications addObject:modification];
                                    }];

                                    NSArray *modificationArray = [modifications copy];
                                    [self.delegate didRetrieveModifications:modificationArray withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didRetrieveModifications:nil withResponse:dbResponse];
                                }
                            }];
}

- (void)getCategories {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/merchcategories/custom.php"]];

    NSString *query = @"query=SELECT name FROM merchcategories";

    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didRetrieveCategories:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didRetrieveCategories:withResponse:");
                                    return;
                                }

                                if (dbResponse.wasSuccessful) {
                                    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];

                                    NSMutableArray *categories = [[NSMutableArray alloc] init];
                                    [categories addObject:@"All Categories"];
                                    [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                                        NSString *category;
                                        category = [e child:@"name"].text;
                                        [categories addObject:category];
                                    }];

                                    NSArray *categoryArray = [categories copy];
                                    [self.delegate didRetrieveCategories:categoryArray withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didRetrieveCategories:nil withResponse:dbResponse];
                                }
                            }];

}

- (RACSignal *)compressedMerchantsHelperWithUrl:(NSString *)url withParameters:(NSDictionary *)parameters {
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
       
        AFHTTPRequestOperation *operation = [self.networkManager POST:url parameters:parameters
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    RXMLElement *rootXML = [RXMLElement elementFromXMLData:responseObject];
                    NSMutableArray *merchants = [[NSMutableArray alloc] init];
                    
                    [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                        MMMerchant *merchant = [[MMMerchant alloc] init];
                        merchant.mid = [NSNumber numberWithInt:[e child:@"id"].textAsInt];
                        merchant.businessname = [e child:@"business_name"].text;
                        merchant.category = [e child:@"category"].text;
                        merchant.address = [e child:@"business_address1"].text;
                        merchant.desc = [e child:@"business_description"].text;
                        merchant.rating = [NSNumber numberWithInt:[e child:@"rating"].textAsInt];
                        merchant.picture = [e child:@"business_picture"].text;
                        merchant.lat = [NSNumber numberWithDouble:[e child:@"lat"].textAsDouble];
                        merchant.longa = [NSNumber numberWithDouble:[e child:@"longa"].textAsDouble];
                        merchant.rating = [NSNumber numberWithDouble:[e child:@"rating"].textAsDouble];
                        merchant.distfromuser = [NSNumber numberWithDouble:[e child:@"distance"].textAsDouble];
                        
                        [merchants addObject:merchant];
                    }];

                    [subscriber sendNext:merchants];
                    [subscriber sendCompleted];
                }
                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [subscriber sendError:error];
                }];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }];
}

- (void)getRatingsHelper:(NSMutableURLRequest *)request withTopFlag:(BOOL)topFlag {

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (!([self canPerformCallback:self.delegate withSelector:@selector(didRetrieveRecentItemRatings:withResponse:)] &&
                                        [self canPerformCallback:self.delegate withSelector:@selector(didRetrieveTopItemRatings:withResponse:)])) {

                                    return;
                                }

                                if (dbResponse.wasSuccessful) {
                                    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];

                                    NSMutableArray *ratings = [[NSMutableArray alloc] init];
                                    NSDateFormatter *dateform = [[NSDateFormatter alloc] init];
                                    [dateform setDateFormat:@"yyyy-MM--d H:m:s"];

                                    [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
                                        MMMenuItemRating *rating = [[MMMenuItemRating alloc] init];
                                        rating.id = [NSNumber numberWithInt:[e child:@"id"].textAsInt];
                                        rating.useremail = [e child:@"useremail"].text;
                                        rating.merchid = [NSNumber numberWithInt:[e child:@"merchid"].textAsInt];
                                        rating.menuid = [NSNumber numberWithInt:[e child:@"menuid"].textAsInt];
                                        rating.rating = [NSNumber numberWithDouble:[e child:@"rating"].textAsDouble];
                                        rating.date = [dateform dateFromString:[e child:@"ratingdate"].text];
                                        rating.review = [e child:@"ratingdescription"].text;
                                        rating.menuitemname = [e child:@"name"].text;
                                        rating.firstname = [e child:@"firstname"].text;
                                        rating.lastname = [e child:@"lastname"].text;
                                        rating.likeCount = [NSNumber numberWithInt:[e child:@"likecount"].textAsInt];
                                        rating.merchantName = [e child:@"business_name"].text;
                                        rating.itemImage = [e child:@"picture"].text;
                                        [ratings addObject:rating];
                                    }];

                                    if (topFlag == YES)
                                        [self.delegate didRetrieveTopItemRatings:ratings withResponse:dbResponse];
                                    else
                                        [self.delegate didRetrieveRecentItemRatings:ratings withResponse:dbResponse];
                                }
                                else {
                                    if (topFlag == YES)
                                        [self.delegate didRetrieveTopItemRatings:nil withResponse:dbResponse];
                                    else
                                        [self.delegate didRetrieveRecentItemRatings:nil withResponse:dbResponse];
                                }
                            }];
}

- (void)eatenThis:(NSString *)email withMenuItem:(NSNumber *)menuid withMerch:(NSNumber *)merchid {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=insert into eatenthis (useremail, menuid, merchid, adddate) values('%@', %@, %@, sysdate())";
    NSString *query = [NSString stringWithFormat:queryFormat, email, menuid, merchid];


    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didAddEatenThis:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didAddEatenThis:withResponse:");
                                    return;
                                }

                                if (dbResponse.wasSuccessful) {
                                    [self.delegate didAddEatenThis:true withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didAddEatenThis:false withResponse:dbResponse];
                                }
                            }];


}

- (void)reportReview:(NSString *)email withMenuItem:(NSNumber *)menuid withMerch:(NSNumber *)merchid withReview:(NSNumber *)rid {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=insert into ratingreport (useremail, ratingid, merchid, menuid, adddate) values('%@', %@, %@, %@, sysdate())";
    NSString *query = [NSString stringWithFormat:queryFormat, email, rid, merchid, menuid];


    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didAddReviewReport:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didAddReviewReport:withResponse:");
                                    return;
                                }

                                if (dbResponse.wasSuccessful) {
                                    [self.delegate didAddReviewReport:true withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didAddReviewReport:false withResponse:dbResponse];
                                }
                            }];

}


- (void)likeReview:(NSString *)email withMenuItem:(NSNumber *)menuid withMerch:(NSNumber *)merchid withReview:(NSNumber *)rid {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=insert into ratinglikes (useremail, ratingid, merchid, menuid, adddate) values('%@', %@, %@, %@, sysdate())";
    NSString *query = [NSString stringWithFormat:queryFormat, email, rid, merchid, menuid];


    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [self createResponseWith:data withError:error];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didAddReviewLike:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didAddReviewLike:withResponse:");
                                    return;
                                }

                                if (dbResponse.wasSuccessful) {
                                    [self.delegate didAddReviewLike:true withResponse:dbResponse];
                                }
                                else {
                                    [self.delegate didAddReviewLike:false withResponse:dbResponse];
                                }
                            }];

}

- (void)userEaten:(NSString *)email withItem:(NSNumber *)mid {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=SELECT id FROM eatenthis WHERE useremail='%@' AND menuid = %@";
    NSString *query = [NSString stringWithFormat:queryFormat, email, mid];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [[MMDBFetcherResponse alloc] init];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didUserEat:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didUserEat:withResponse:");
                                    return;
                                }

                                if ([data length] > 0 && error == nil) {
                                    dbResponse.wasSuccessful = TRUE;

                                    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
                                    NSArray *rxmlResult = [rootXML children:@"result"];

                                    BOOL userEaten = (rxmlResult.count > 0);

                                    [self.delegate didUserEat:userEaten withResponse:dbResponse];
                                }
                                else {
                                    dbResponse.wasSuccessful = FALSE;

                                    if (error != nil) {
                                        [dbResponse.messages addObject:@"error"];

                                        [self.delegate didUserEat:FALSE withResponse:dbResponse];
                                    }
                                }
                            }];
}

- (void)userLiked:(NSString *)email withReview:(NSNumber *)rid {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=SELECT id FROM ratinglikes WHERE useremail='%@' AND ratingid = %@";
    NSString *query = [NSString stringWithFormat:queryFormat, email, rid];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [[MMDBFetcherResponse alloc] init];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didUserLike:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didUserLike:withResponse:");
                                    return;
                                }

                                if ([data length] > 0 && error == nil) {
                                    dbResponse.wasSuccessful = TRUE;

                                    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
                                    NSArray *rxmlResult = [rootXML children:@"result"];

                                    BOOL userLiked = (rxmlResult.count > 0);

                                    [self.delegate didUserLike:userLiked withResponse:dbResponse];
                                }
                                else {
                                    dbResponse.wasSuccessful = FALSE;

                                    if (error != nil) {
                                        [dbResponse.messages addObject:@"error"];

                                        [self.delegate didUserLike:FALSE withResponse:dbResponse];
                                    }
                                }
                            }];
}

- (void)userReported:(NSString *)email withReview:(NSNumber *)rid {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=SELECT id FROM ratingreport WHERE useremail='%@' AND ratingid = %@";
    NSString *query = [NSString stringWithFormat:queryFormat, email, rid];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [self.networkClient performNetworkRequest:request
                            completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                MMDBFetcherResponse *dbResponse = [[MMDBFetcherResponse alloc] init];

                                if (![self canPerformCallback:self.delegate withSelector:@selector(didUserReport:withResponse:)]) {
                                    NSLog(@"Warning: Delegate does not implement optional protocol selector - didUserReport:withResponse:");
                                    return;
                                }

                                if ([data length] > 0 && error == nil) {
                                    dbResponse.wasSuccessful = TRUE;

                                    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
                                    NSArray *rxmlResult = [rootXML children:@"result"];

                                    BOOL userReport = (rxmlResult.count > 0);

                                    [self.delegate didUserReport:userReport withResponse:dbResponse];
                                }
                                else {
                                    dbResponse.wasSuccessful = FALSE;

                                    if (error != nil) {
                                        [dbResponse.messages addObject:@"error"];

                                        [self.delegate didUserReport:FALSE withResponse:dbResponse];
                                    }
                                }
                            }];
}

@end
