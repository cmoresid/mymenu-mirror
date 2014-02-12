//
//  MMMockNetworkClient.m
//  MyMenu
//
//  Created by Connor Moreside on 2/6/2014.
//
//

#import "MMMockNetworkClient.h"

@interface MMMockNetworkClient ()

@property(nonatomic, strong) NSURLResponse *fakeResponse;
@property(nonatomic, strong) NSString *fakeData;
@property(nonatomic, strong) NSError *fakeError;

@end

@implementation MMMockNetworkClient

- (id)initWithFakeResponse:(NSURLResponse *)response withFakeData:(NSString *)data withFakeError:(NSError *)error {
    self = [super init];

    if (self != nil) {
        self.fakeResponse = response;
        self.fakeData = data;
        self.fakeError = error;
    }

    return self;
}

- (void)performNetworkRequest:(NSMutableURLRequest *)request completionHandler:(NetworkResponseBlock)completionBlock {
    NSData *fakeData = [self.fakeData dataUsingEncoding:NSUTF8StringEncoding];

    completionBlock(self.fakeResponse, fakeData, self.fakeError);
}

@end
