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

@implementation MMDBFetcher

NSMutableData * responseData;

- (id)init
{
    self = [super init];
    
    if (self){
        responseData = [NSMutableData dataWithLength:500];
    }
    
        
    
    return self;
}




- (void) addUser : (MMUser*) user{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@"http://mymenuapp.ca/php/users/put.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded"
   forHTTPHeaderField:@"Content-type"];

    NSString *initstore = @"email=%@&firstname=%@&lastname=%@&password=%@&city=%@&locality=%@&country=%@&gender=%@&birthday=%@&birthmonth=%@&birthyear=%@&confirmcode=y";
    
    NSString *adduser = [NSString stringWithFormat:initstore, user.email, user.firstName,
                         user.lastName, user.password, user.city, user.locality, user.country,
                         user.gender, user.birthday, user.birthmonth, user.birthyear];
    
    
    
    [request setValue:[NSString stringWithFormat:@"%d",
                       [adduser length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[adduser
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * conn = [[NSURLConnection alloc]
     initWithRequest:request
     delegate:self];

    
}


- (bool) userExists : (NSString*) email{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded"
   forHTTPHeaderField:@"Content-type"];
    
    NSString *checkstring = @"query=select%20id%20from%20users%20where%20email%20=%20%@&submit=";
    
    NSString *query = [NSString stringWithFormat:checkstring, email];
    
    [request setValue:[NSString stringWithFormat:@"%d",
                       [query length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[query
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * conn = [[NSURLConnection alloc]
                              initWithRequest:request
                              delegate:self];
    
    NSLog(@"%@",[[NSString alloc] initWithData:conn.currentRequest.HTTPBody encoding:NSUTF8StringEncoding]);
    
    return true;
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (bool) userVerified : (MMUser*) user{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@"http://mymenuapp.ca/php/users/custom.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded"
   forHTTPHeaderField:@"Content-type"];
    
    NSString *checkstring = @"select id from users where email = %@ AND password = %@ ";
    
    NSString *query = [NSString stringWithFormat:checkstring, user.email, user.password];
    
    
    
    
    [request setValue:[NSString stringWithFormat:@"%d",
                       [query length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[query
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * conn = [[NSURLConnection alloc]
                              initWithRequest:request
                              delegate:self];
    
    
    
    
    
    return true;
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"Test %@",responseString);

}

- (void) updatePreferences : (NSInteger*) uid : (NSArray*) restrictions {
    
    
    
    
}

- (NSArray*) getSpecials : (NSString*) day{
    
    NSArray *specials = [[NSMutableArray alloc] init];
    
    return specials;
    
}

- (NSArray*) getMerchants{
    
    NSArray *merchants = [[NSMutableArray alloc] init];
    
    return merchants;
    
}

@end