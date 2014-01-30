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

NSMutableData *responseData;

- (id)init {
    self = [super init];

    if (self) {
        responseData = [[NSMutableData alloc] init];
    }

    return self;
}

- (void)addUser:(MMUser *)user {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
            initWithURL:[NSURL
                    URLWithString:@"http://mymenuapp.ca/php/users/put.php"]];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    
    NSString *initstore = @"email=%@&firstname=%@&lastname=%@&password=%@&city=%@&locality=%@&country=%@&gender=%c&birthday=%@&birthmonth=%@&birthyear=%@&confirmcode=y";

    NSString *adduser = [NSString stringWithFormat:initstore, user.email, user.firstName,
                                                   user.lastName, user.password, user.city, user.locality, user.country,
                                                   user.gender, user.birthday, user.birthmonth, user.birthyear];

    [request setValue:[NSString stringWithFormat:@"%d", [adduser length]] forHTTPHeaderField:@"Content-length"];

    [request setHTTPBody:[adduser dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [conn cancel];
    
    
}

- (MMUser*)getUser:(NSString*)email {
    
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
        user.gender = (char)[e child:@"gender"].text;
        user.birthday = [e child:@"birthday"].text;
        user.birthmonth = [e child:@"birthmonth"].text;
        user.birthyear = [e child:@"birthyear"].text;
        
    }];
    
    return user;
    
}

- (bool)userExists:(NSString *)email {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];

    NSString *checkstring = @"query=select id from users where email='%@'";
    NSString *query = [NSString stringWithFormat:checkstring, email];

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

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];

    NSString *checkstring = @"query=select id from users where email='%@' AND password='%@'";
    NSString *query = [NSString stringWithFormat:checkstring, user.email, user.password];

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

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
            initWithURL:[NSURL
                    URLWithString:@"http://mymenuapp.ca/php/restrictionuserlink/put.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];

    for (NSUInteger i = 0; i < [restrictions count]; i++) {
        NSString *initstore = @"restrictid=%@&email=%@";
        NSString *remrestrict = [NSString stringWithFormat:initstore, [restrictions objectAtIndex:i], email];

        [request setValue:[NSString stringWithFormat:@"%d", [remrestrict length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:[remrestrict dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [conn cancel];
    }

}

- (void)removeUserRestrictions:(NSString *)email {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
            initWithURL:[NSURL
                    URLWithString:@"http://mymenuapp.ca/php/restrictionuserlink/delete.php"]];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    NSString *initrem = @"email=%@";
    NSString *remrestrict = [NSString stringWithFormat:initrem, email];
    [request setValue:[NSString stringWithFormat:@"%d", [remrestrict length]] forHTTPHeaderField:@"Content-length"];
    [request setHTTPBody:[remrestrict dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn cancel];


}


- (NSArray *)getUserRestrictions:(NSString *)email {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictionuserlink/custom.php"]];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    NSString *prequery = @"query=select restrictid from restrictionuserlink where email ='%@'";
    NSString *query = [NSString stringWithFormat:prequery, email];
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

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/restrictions/custom.php"]];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];

    NSString *query = @"query=select id, user_label, picture from restrictions";
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

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/specials/custom.php"]];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    NSString *prequery = @"query=select * from specials where weekday = '%@' and categoryid = %d";
    NSString *query = [NSString stringWithFormat:prequery, day, type];
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

    return specials;
}

- (NSArray *)getCompressedMerchants {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/merchusers/custom.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
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

        //merchant.rating = [NSNumber numberWithInt:[e child:@"rating"].textAsInt];
        merchant.rating = [e child:@"rating"].text;
        merchant.picture = [e child:@"business_picture"].text;
        [merchants addObject:merchant];
    }];


    return merchants;
}


- (MMMerchant *)getMerchant:(NSInteger *)mid {

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://mymenuapp.ca/php/merchusers/custom.php"]];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
    NSString *prequery = @"query=select * from merchusers where id = '%d'";
    NSString *query = [NSString stringWithFormat:prequery, mid];
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

//**TODO**//
- (NSArray *)getMenu:(NSInteger *)merchid {
    NSArray *menu = [[NSMutableArray alloc] init];
    return menu;
}

@end
