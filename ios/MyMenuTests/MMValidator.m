//
//  MMMenuItemValidator.m
//  MyMenu
//
//  Created by Chris Pavlicek on 2014-03-27.
//
//

#import "MMValidator.h"
#import "MMMenuItem.h"

@implementation MMValidator

+(BOOL)isValidMenuItem:(MMMenuItem *) item {
	
	/**
	 *
	 @property(nonatomic) NSNumber *itemid;
	 @property(nonatomic) NSNumber *merchid;
	 @property(nonatomic) NSString *name;
	 @property(nonatomic) NSNumber *cost;
	 @property(nonatomic) NSString *picture;
	 @property(nonatomic) NSString *desc;
	 @property(nonatomic) NSString *mods;
	 @property(nonatomic) NSNumber *rating;
	 @property(nonatomic) NSNumber *ratingcount;
	 @property(nonatomic) NSString *category;
	 @property(nonatomic) BOOL restrictionflag;
	 
	 Checks all of these things except rescrictionFlag.
	 
	 */
	
	if(![item isKindOfClass:[MMMenuItem class]]) {
		return false;
	}
	
	if(![[item itemid] isKindOfClass:[NSNumber class]] || [[item itemid] intValue] < 0) {
		return false;
	}
	
	if(![[item merchid] isKindOfClass:[NSNumber class]] || [[item merchid] intValue] < 0) {
		return false;
	}
	
	if(![[item name] isKindOfClass:[NSString class]] || ![[item name] length] > 0) {
		return false;
	}
	
	if([[item cost] intValue] < 0) {
		return false;
	}
	
	if(![[item picture] isKindOfClass:[NSString class]] || [UIImage imageWithData:[[item picture] dataUsingEncoding:NSUTF8StringEncoding]] == nil) {
		return false;
	}
	
	//TODO: can we have no description?
	if(![[item description] isKindOfClass:[NSString class]] || ![[item description] length] >= 0) {
		return false;
	}
	
	if(![[item mods] isKindOfClass:[NSString class]]) {
		return false;
	}
	
	if(![[item rating] isKindOfClass:[NSNumber class]] || ![[item name] length] > 0) {
		return false;
	}
	
	if(![[item ratingcount] isKindOfClass:[NSNumber class]]) {
		return false;
	}
	
	// Do items have to be in a category?
	if(![[item category] isKindOfClass:[NSString class]] || [[item category] length] > 0) {
		return false;
	}
	
	// Can't be both yes and no at the same time.
	if([item restrictionflag] && ![item restrictionflag]) {
		return false;
	}
	
	return true;
}

@end
