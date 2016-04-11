//
//  NSDate+WAdditions.h
//  Warp
//
//  Created by Lukáš Foldýna on 25.08.11.
//  Copyright (c) 2011 TwoManShow. All rights reserved.
//

@import Foundation;


@interface NSDate (WAdditions)

+ (NSDate *) today;

@property (nonatomic, readonly) NSInteger dayDiffFromToday;

- (NSInteger) dayDiffFromDate:(NSDate *)date;

@property (nonatomic, readonly, copy) NSDate *date;

/** returns string in format 'yyyy-MM-dd' from date */
@property (nonatomic, readonly, copy) NSString *DBFormattedString;

/** returns string in format 'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'' from date */
@property (nonatomic, readonly, copy) NSString *ISOFormattedString;

@end


@interface NSString (NSDateWAdditions)

@property (nonatomic, readonly, copy) NSDate *date;

@property (nonatomic, readonly, copy) NSDate *dateFromUnixTimestamp;

@property (nonatomic, readonly, copy) NSDate *dateFromMillisTimestamp;

/** returns date from string in format 'yyyy-MM-dd' */
@property (nonatomic, readonly, copy) NSDate *dateFromDBFormat;

/** returns date from string in format 'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'' */
@property (nonatomic, readonly, copy) NSDate *dateFromISOFormat;

@end

@interface NSNumber (NSDateWAdditions)

@property (nonatomic, readonly, copy) NSDate *date;

@property (nonatomic, readonly, copy) NSDate *dateFromUnixTimestamp;

@property (nonatomic, readonly, copy) NSDate *dateFromMillisTimestamp;

@property (nonatomic, readonly, copy) NSDate *dateFromDBFormat;

@property (nonatomic, readonly, copy) NSDate *dateFromISOFormat;

@end

@interface NSNull (NSDateWAdditions)

@property (nonatomic, readonly, copy) NSDate *date;

@property (nonatomic, readonly, copy) NSDate *dateFromUnixTimestamp;

@property (nonatomic, readonly, copy) NSDate *dateFromMillisTimestamp;

@property (nonatomic, readonly, copy) NSDate *dateFromDBFormat;

@property (nonatomic, readonly, copy) NSDate *dateFromISOFormat;

@end
