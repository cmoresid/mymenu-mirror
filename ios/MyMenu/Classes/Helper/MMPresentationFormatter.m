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

#import "MMPresentationFormatter.h"

@implementation MMPresentationFormatter

+ (NSString *)formatRatingForRawRating:(NSNumber *)rating {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:1];
    [formatter setMinimumFractionDigits:1];
    
    NSString *rate = [formatter stringFromNumber:rating];
    
    return [rate isEqualToString:@".0"] ? @"N/A" : rate;
}

+ (NSString *)formatBusinessHoursForOpenTime:(NSString *)openTime withCloseTime:(NSString *)closeTime {
    NSString *formattedOpenTime = [openTime substringToIndex:[openTime length] - 3];
    NSString *formattedCloseTime = [closeTime substringToIndex:[closeTime length] - 3];
    
    return [NSString stringWithFormat:@"%@ - %@", formattedOpenTime, formattedCloseTime];
}

+ (NSString *)formatNumberAsPrice:(NSNumber *)price {
    NSNumberFormatter *formatterCost = [[NSNumberFormatter alloc] init];
    [formatterCost setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatterCost setMaximumFractionDigits:3];
    [formatterCost setMinimumFractionDigits:2];
    
    return [NSString stringWithFormat:@"$%@", [formatterCost stringFromNumber:price]];
}

@end
