//
//  MMDBFetcher.m
//  MyMenu
//
//  Created by Chris Moulds on 1/25/2014.
//  Copyright (c) 2014 MyMenu. All rights reserved.
//

#import "MMDBFetcher.h"
#import "RXMLElement.h"

@implementation MMDBFetcher

static MMDBFetcher *instance;

+ (id)get {
    @synchronized (self) {
        if (instance == nil)
            instance = [[self alloc] init];
    }
    return instance;
}

- (id)init {
    self = [super init];

    if (self) {
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

    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (MMUser *)getUser:(NSString *)email {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];

    NSString *prequery = @"query=select * from users where email = '%@'";
    NSString *query = [NSString stringWithFormat:prequery, email];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];

    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

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
        user.gender = (char) [e child:@"gender"].text;
        user.birthday = [e child:@"birthday"].text;
        user.birthmonth = [e child:@"birthmonth"].text;
        user.birthyear = [e child:@"birthyear"].text;

    }];

    return user;

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
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (bool)userExists:(NSString *)email {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=select id from users where email='%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, email];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
    NSArray *rxmlResult = [rootXML children:@"result"];
    return rxmlResult.count > 0;
}

- (NSInteger)userVerified:(MMUser *)user {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    NSString *queryFormat = @"query=select id from users where email='%@' AND password='%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, user.email, user.password];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
    NSArray *rxmlResult = [rootXML children:@"result"];

    if (rxmlResult.firstObject >= 0)
        return (NSInteger) rxmlResult.firstObject;
    else return -1;
}

- (void)addUserRestrictions:(NSString *)email :(NSArray *)restrictions {
    [self removeUserRestrictions:email];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictionuserlink/put.php"]];

    NSString *queryFormat = @"restrictid=%@&email=%@";

    for (NSUInteger i = 0; i < [restrictions count]; i++) {
        NSString *query = [NSString stringWithFormat:queryFormat, [restrictions objectAtIndex:i], email];
        [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
        [[NSURLConnection alloc] initWithRequest:request delegate:self];

    }
}

- (void)removeUserRestrictions:(NSString *)email {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictionuserlink/custom.php"]];

    NSString *queryFormat = @"delete from restrictionuserlink where email=%@";
    NSString *query = [NSString stringWithFormat:queryFormat, email];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSArray *)getUserRestrictions:(NSString *)email {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictionuserlink/custom.php"]];

    NSString *queryFormat = @"query=select restrictid from restrictionuserlink where email ='%@'";
    NSString *query = [NSString stringWithFormat:queryFormat, email];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];

    NSMutableArray *restrictions = [[NSMutableArray alloc] init];

    [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
        MMRestriction *restriction = [[MMRestriction alloc] init];
        restriction.id = [NSNumber numberWithInt:[e child:@"restrictid"].textAsInt];

        [restrictions addObject:restriction];
    }];

    return restrictions;
}

- (NSArray *)getAllRestrictions {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictions/custom.php"]];

    NSString *query = @"query=select id, user_label, picture from restrictions";
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];

    NSMutableArray *restrictions = [[NSMutableArray alloc] init];

    [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
        MMRestriction *restriction = [[MMRestriction alloc] init];
        restriction.id = [NSNumber numberWithInt:[e child:@"id"].textAsInt];

        restriction.name = [e child:@"user_label"].text;
        restriction.image = [e child:@"picture"].text;

        [restrictions addObject:restriction];
    }];

    return restrictions;
}

- (NSArray *)getSpecials:(NSString *)day :(NSInteger)type {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/specials/custom.php"]];

    NSString *queryFormat = @"query=select * from specials where weekday = '%@' and categoryid = %d";
    NSString *query = [NSString stringWithFormat:queryFormat, day, type];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];
    NSMutableArray *specials = [[NSMutableArray alloc] init];

    [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
        MMSpecial *special = [[MMSpecial alloc] init];
        special.merchid = [NSNumber numberWithInt:[e child:@"merchid"].textAsInt];
        special.name = [e child:@"name"].text;
        special.desc = [e child:@"description"].text;
        special.picture = [e child:@"picture"].text;
        special.occurtype = [NSNumber numberWithInt:[e child:@"occurtype"].textAsInt];
        [specials addObject:special];
    }];
    
    for (NSUInteger i = 0; i < [specials count]; i++){
        MMSpecial* special = (MMSpecial*)[specials objectAtIndex:i];
        MMMerchant* merchant = [self getMerchant:special.merchid];
        ((MMSpecial*)[specials objectAtIndex:i]).merchant = merchant.businessname;
    }
    
    return specials;
}

- (NSArray *)getCompressedMerchants {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/merchusers/custom.php"]];

    NSString *query = @"query=select business_name, business_number, rating, business_picture, lat, longa, business_description from merchusers";
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];

    NSMutableArray *merchants = [[NSMutableArray alloc] init];


    [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {
        MMMerchant *merchant = [[MMMerchant alloc] init];
        merchant.businessname = [e child:@"business_name"].text;
        merchant.phone = [e child:@"business_number"].text;
        merchant.desc = [e child:@"business_description"].text;

        merchant.lat = [NSNumber numberWithDouble:[e child:@"lat"].textAsDouble];
        merchant.longa = [NSNumber numberWithDouble:[e child:@"longa"].textAsDouble];

        merchant.rating = [e child:@"rating"].text;
        merchant.picture = [e child:@"business_picture"].text;
        [merchants addObject:merchant];
    }];


    return merchants;
}

- (MMMerchant *)getMerchant:(NSNumber *)mid {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    [request setURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/merchusers/custom.php"]];

    NSString *queryFormat = @"query=select * from merchusers where id = '%d'";
    NSString *query = [NSString stringWithFormat:queryFormat, mid];
    [request setValue:[NSString stringWithFormat:@"%d", [query length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    RXMLElement *rootXML = [RXMLElement elementFromXMLData:data];

    MMMerchant *merchant = [[MMMerchant alloc] init];

    [rootXML iterate:@"result" usingBlock:^(RXMLElement *e) {

        merchant.businessname = [e child:@"businessname"].text;
        merchant.phone = [e child:@"phone"].text;
        merchant.rating = [NSNumber numberWithInt:[e child:@"rating"].textAsInt];

    }];
    return merchant;
}

// TODO
- (NSArray *)getMenu:(NSInteger *)merchid {
    NSArray *menu = [[NSMutableArray alloc] init];
    return menu;
}

@end
