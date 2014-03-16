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

#import <Foundation/Foundation.h>
#import "MMUser.h"
#import "MMRestriction.h"
#import "MMSpecial.h"
#import "MMMerchant.h"
#import "MMDBFetcherDelegate.h"
#import "MMNetworkClientProtocol.h"
#import "MMMenuItemRating.h"

@class RACSignal;
@class CLLocation;

/**
* A model for qeurying data from the api.
*/
@interface MMDBFetcher : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, strong) id <MMDBFetcherDelegate> delegate;
@property(nonatomic, strong) id <MMNetworkClientProtocol> networkClient;

/**
* Get a singleton instance of this class.
* Clients should use this, and not initialize a new instance for every request.
*
* NOTE: The idea is to encapsulate request merging in this class, so a singleton will give us
* significant performance improvements.
*
*/
+ (MMDBFetcher *)get;

- (id)initWithNetworkClient:(id <MMNetworkClientProtocol>)client;

/**
* Add a user to the service.
*/
- (void)addUser:(MMUser *)user;

/**
* Check if the user with this email address exists already.
*/
- (void)userExists:(NSString *)email;

/**
* Checks if the password for the user is entered correctly (for login).
*/
- (void)userVerified:(MMUser *)user;

/**
* Get drink specials for the given day of the given type.
*/

//- (NSArray *)getDrinkSpecials:(NSString *)weekday :(NSInteger)type;
- (void)getDrinkSpecialsForDate:(NSDate *)date;

/**
 * Get dessert specials for the given day of the given type.
 */

//- (NSArray *)getDessertSpecials:(NSString *)weekday :(NSInteger)type;
- (void)getDessertSpecialsForDate:(NSDate *)date;

/**
 * Get food specials for the given day of the given type.
 */

//- (NSArray *)getFoodSpecials:(NSString *)weekday :(NSInteger)type;
- (void)getFoodSpecialsForDate:(NSDate *)date;

/**
* Add all given restrictions for the given user.
*/
- (void)addUserRestrictions:(NSString *)email withRestrictionIDs:(NSArray *)restrictions;

/**
 * Add a rating/review for a menu item.
 */
- (void)addMenuRating:(MMMenuItemRating *)rating;

/**
* Get all merchants. Only return a subset of the fields to minify data.
*/

- (void)getCompressedMerchants:(CLLocation *)usrloc;

/**
 * Get all merchants with name = merchname. Only return a subset of the fields to minify data.
 */
- (void)getCompressedMerchantsByName:(CLLocation *)usrloc withName:(NSString *)merchname;

/**
 * Get all merchants with category cuisine. Only return a subset of the fields to minify data.
 */
- (void)getCompressedMerchantsByCuisine:(CLLocation *)usrloc withCuisine:(NSString *)cuisine;

/**
* Get the menu for the restaurant.
*/
- (RACSignal *)getMenuWithMerchantId:(NSNumber *)merchid withUserEmail:(NSString *)email;

- (RACSignal *)getRestrictedMenu:(NSNumber *)merchid withUserEmail:(NSString *)email;

/**
* Get all restrictions that we support.
*/
- (void)getAllRestrictions;

/**
* Get all restrictions for the given user.
*/
- (void)getUserRestrictions:(NSString *)email;

/**
* Get all information about the merchant (restaurant) with the given id.
*/
- (void)getMerchant:(NSNumber *)merchid;

/**
* Edit the given user's information on the server.
*/
- (void)editUser:(MMUser *)user;

/**
* Get all information for the user with the given email.
*/
- (void)getUser:(NSString *)email;

/**
 * Get all modifications for a specific menu item with the given email.
 */
- (void)getModifications:(NSNumber *)menuid withUser:(NSString *)email;

/**
 * Get all ratings for a specific meny item with the given menuid
 */
- (void)getItemRatings:(NSNumber *)menuid;

/**
 * Get all menu item ratings for a specific merchant.
 */
- (RACSignal *)getItemRatingsMerchant:(NSNumber *)merchid;

/**
 * Get all merchant categories.
 */
- (void)getCategories;

/**
 * Get all ratings for a specific item ordered by rating.
 */
- (void)getItemRatingsTop:(NSNumber *)itemid;

/**
 * Get today as a string, e.g. 'tuesday'
 */
- (NSString *)getDay:(NSDate *)date;

/**
 * Helper method that adds all relevant information to the rating object.
 */
- (void)compressedMerchantsHelper:(NSMutableURLRequest *)request;

/**
 * When a user reports a review they find offensive.
 */
- (void)reportReview:(NSString *)email withMenuItem:(NSNumber *)menuid withMerch:(NSNumber *)merchid withReview:(NSNumber *)rid;

/**
 * When a user likes a menu item review.
 */
- (void)likeReview:(NSString *)email withMenuItem:(NSNumber *)menuid withMerch:(NSNumber *)merchid withReview:(NSNumber *)rid;

/**
 * When a user clicks 'I've Eaten This'.
 */
- (void)userEaten:(NSString *)email withItem:(NSNumber *)mid;

/**
 * Checks if the user has already liked a review.
 */
- (void)userLiked:(NSString *)email withReview:(NSNumber *)rid;

/**
 * Checks if the user has already reported a review.
 */
- (void)userReported:(NSString *)email withReview:(NSNumber *)rid;

/**
 * Checks if the user has already clicked 'I've Eaten this'
 */
- (void)eatenThis:(NSString *)email withMenuItem:(NSNumber *)menuid withMerch:(NSNumber *)merchid;

/**
 * Updates a review.
 */
- (void)editReview:(MMMenuItemRating *)review;

@end
