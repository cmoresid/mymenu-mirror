//
//  MMDBFetcherResponse.h
//  MyMenu
//
//  Created by Connor Moreside on 2/1/2014.
//
//

#import <Foundation/Foundation.h>



@interface MMDBFetcherResponse : NSObject

@property (atomic) BOOL wasSuccessful;
@property (atomic) NSMutableArray* messages;

@end
