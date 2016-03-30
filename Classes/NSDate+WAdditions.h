//
//  NSDate+WAdditions.h
//  Warp
//
//  Created by Lukáš Foldýna on 25.08.11.
//  Copyright (c) 2011 TwoManShow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (WAdditions)

+ (NSDate *) today;

- (NSInteger) dayDiffFromToday;

- (NSInteger) dayDiffFromDate:(NSDate *)date;

- (NSDate *) date;

/** returns string in format 'yyyy-MM-dd' from date */
- (NSString *) DBFormattedString;

/** returns string in format 'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'' from date */
- (NSString *) ISOFormattedString;

@end


@interface NSString (NSDateWAdditions)

- (NSDate *) date;

- (NSDate *) dateFromUnixTimestamp;

- (NSDate *) dateFromMillisTimestamp;

/** returns date from string in format 'yyyy-MM-dd' */
- (NSDate *) dateFromDBFormat;

/** returns date from string in format 'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'' */
- (NSDate *) dateFromISOFormat;

@end

@interface NSNumber (NSDateWAdditions)

- (NSDate *) date;

- (NSDate *) dateFromUnixTimestamp;

- (NSDate *) dateFromMillisTimestamp;

- (NSDate *) dateFromDBFormat;

- (NSDate *) dateFromISOFormat;

@end

@interface NSNull (NSDateWAdditions)

- (NSDate *) date;

- (NSDate *) dateFromUnixTimestamp;

- (NSDate *) dateFromMillisTimestamp;

- (NSDate *) dateFromDBFormat;

- (NSDate *) dateFromISOFormat;

@end
