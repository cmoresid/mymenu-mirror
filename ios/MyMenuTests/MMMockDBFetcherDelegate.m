//
//  MMMockDBFetcherDelegate.m
//  MyMenu
//
//  Created by Connor Moreside on 2/5/2014.
//
//

#import "MMMockDBFetcherDelegate.h"


@implementation MMMockDBFetcherDelegate

- (id)init {
    self = [super init];

    if (self != nil) {

    }

    return self;
}


- (void)didCreateUser:(BOOL)successful withResponse:(MMDBFetcherResponse *)response {
	self.booleanResponseCallback(successful,response);
}

- (void)doesUserExist:(BOOL)exists withResponse:(MMDBFetcherResponse *)response{
	self.booleanResponseCallback(exists,response);
}

- (void)wasUserVerified:(NSInteger)resultCode withResponse:(MMDBFetcherResponse *)response{
	self.integerResponseCallback(resultCode, response);
}

- (void)didRetrieveUser:(MMUser *)user withResponse:(MMDBFetcherResponse *)response{
	self.userResponseCallback(user,response);
}

- (void)didRetrieveSpecials:(NSArray *)specials forDate:(NSDate *)date withResponse:(MMDBFetcherResponse *)response
{
	self.specialResponseCallback(specials,date,response);
}

- (void)didAddUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse *)response{
	self.booleanResponseCallback(successful,response);
}

- (void)didRemoveAllUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse *)response{
	self.booleanResponseCallback(successful,response);
}

- (void)didRetrieveCompressedMerchants:(NSArray *)compressedMerchants withResponse:(MMDBFetcherResponse *)response{
	self.arrayResponseCallback(compressedMerchants,response);
}

- (void)didRetrieveMenuItems:(NSArray *)menuItems withResponse:(MMDBFetcherResponse *)response{
	self.arrayResponseCallback(menuItems,response);
}

- (void)didRetrieveAllRestrictions:(NSArray *)allRestrictions withResponse:(MMDBFetcherResponse *)response{
	self.arrayResponseCallback(allRestrictions,response);
}

- (void)didRetrieveUserRestrictions:(NSArray *)userRestrictions withResponse:(MMDBFetcherResponse *)response{
	self.arrayResponseCallback(userRestrictions,response);
}

- (void)didRetrieveMerchant:(MMMerchant *)merchant withResponse:(MMDBFetcherResponse *)response{
	self.merchantResponseCallback(merchant,response);
}

- (void)didUpdateUser:(BOOL)successful withResponse:(MMDBFetcherResponse *)response{
	self.booleanResponseCallback(successful,response);
}

- (void)didRetrieveModifications:(NSArray *)modificationsArray withResponse:(MMDBFetcherResponse *)response{
	self.arrayResponseCallback(modificationsArray,response);
}

- (void)didCreateRating:(BOOL)successful withResponse:(MMDBFetcherResponse *)response{
	self.booleanResponseCallback(successful,response);
}

- (void)didRetrieveTopItemRatings:(NSArray *)ratings withResponse:(MMDBFetcherResponse *)response{
	self.arrayResponseCallback(ratings,response);
}


- (void)didRetrieveRecentItemRatings:(NSArray *)ratings withResponse:(MMDBFetcherResponse *)response{
	self.arrayResponseCallback(ratings,response);
}

- (void)didRetrieveCategories:(NSArray *)categories withResponse:(MMDBFetcherResponse *)response{
	self.arrayResponseCallback(categories,response);
	}

- (void)didAddEatenThis:(BOOL)succesful withResponse:(MMDBFetcherResponse *)response{
	self.booleanResponseCallback(succesful,response);
}
- (void)didAddReviewLike:(BOOL)succesful withResponse:(MMDBFetcherResponse *)response{
	self.booleanResponseCallback(succesful,response);
}

- (void)didAddReviewReport:(BOOL)succesful withResponse:(MMDBFetcherResponse *)response{
self.booleanResponseCallback(succesful,response);
}
- (void)didUserEat:(BOOL)exists withResponse:(MMDBFetcherResponse *)response{
	self.booleanResponseCallback(exists,response);
}

- (void)didUserLike:(BOOL)exists withResponse:(MMDBFetcherResponse *)response{
	self.booleanResponseCallback(exists,response);
}

- (void)didUserReport:(BOOL)exists withResponse:(MMDBFetcherResponse *)response{
	self.booleanResponseCallback(exists,response);
}

- (void)didUpdateRatings:(BOOL)exists withResponse:(MMDBFetcherResponse *)response{
	self.booleanResponseCallback(exists,response);
}

/*
//- (void)didCreateUser:(BOOL)successful withResponse:(MMDBFetcherResponse*)response {
//    booleanResponseCallback(successful, response);
//}
//
//- (void)doesUserExist:(BOOL)exists withResponse:(MMDBFetcherResponse*)response {
//    self.booleanResponseCallback(exists, response);
//}
//
//- (void)wasUserVerified:(NSInteger)resultCode withResponse:(MMDBFetcherResponse*)response {
//    self.integerResponseCallback(resultCode, response);
//}
//
- (void)didRetrieveUser:(MMUser *)user withResponse:(MMDBFetcherResponse *)response {
    self.userResponseCallback(user, response);
}

//
//- (void)didRetrieveSpecials:(NSArray*)specials withResponse:(MMDBFetcherResponse*)response {
//    self.arrayResponseCallback(specials, response);
//}
//
//- (void)didAddUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse*)response {
//    self.booleanResponseCallback(successful, response);
//}
//
//- (void)didRemoveAllUserRestrictions:(BOOL)successful withResponse:(MMDBFetcherResponse*)response {
//    self.booleanResponseCallback(successful, response);
//}
//
//- (void)didRetrieveCompressedMerchants:(NSArray*)compressedMerchants withResponse:(MMDBFetcherResponse*)response {
//    self.arrayResponseCallback(compressedMerchants, response);
//}
//
- (void)didRetrieveMenuItems:(NSArray *)menuItems withResponse:(MMDBFetcherResponse *)response {
    self.getMenuResponseCallback(menuItems, response);
}
//
//- (void)didRetrieveAllRestrictions:(NSArray*)allRestrictions withResponse:(MMDBFetcherResponse*)response {
//    self.arrayResponseCallback(allRestrictions, response);
//}
//
//- (void)didRetrieveUserRestrictions:(NSArray*)userRestrictions withResponse:(MMDBFetcherResponse*)response {
//    self.arrayResponseCallback(userRestrictions, response);
//}
//
//- (void)didRetrieveMerchant:(MMMerchant*)merchant withResponse:(MMDBFetcherResponse*)response {
//    self.merchantResponseCallback(merchant, response);
//}
//
//- (void)didUpdateUser:(BOOL)successful withResponse:(MMDBFetcherResponse*)response {
//    self.booleanResponseCallback(successful, response);
//}
*/
@end
