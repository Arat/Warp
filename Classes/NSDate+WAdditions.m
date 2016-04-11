//
//  NSDate+WAdditions.m
//  Warp
//
//  Created by Lukáš Foldýna on 25.08.11.
//  Copyright (c) 2011 TwoManShow. All rights reserved.
//

#import "NSDate+WAdditions.h"
#import "WGlobal.h"


@implementation NSDate (WAdditions)

+ (NSDateFormatter *) WDateFormatter
{
    static NSDateFormatter *dateForamtter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateForamtter = [[NSDateFormatter alloc] init];
        [dateForamtter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateForamtter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateForamtter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    });
    return dateForamtter;
}

+ (NSDate *) today
{
#ifdef __IPHONE_8_0
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
    
    NSDateComponents *todayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:[NSDate date]];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay]; 
    [components setMonth:theMonth]; 
    [components setYear:theYear];
    
    NSDate *todayDate = [gregorian dateFromComponents:components];
    return todayDate;
}

- (NSInteger) dayDiffFromToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger differenceInDays = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:self] -
                                 [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:[NSDate date]];
    return differenceInDays;
}

- (NSInteger) dayDiffFromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger differenceInDays = [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:self] -
                                 [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitEra forDate:date];
    return differenceInDays;
}

- (NSString *) DBFormattedString
{
    NSDateFormatter *formater = [NSDate WDateFormatter];
    [formater setDateFormat:@"yyyy-MM-dd"];
	return [formater stringFromDate:self];
}

- (NSString *) ISOFormattedString
{
    NSDateFormatter *formater = [NSDate WDateFormatter];
    [formater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
	return [formater stringFromDate:self];
}

- (NSDate *) date
{
    return self;
}

- (NSDate *) dateFromDBFormat
{
	return self;
}

- (NSDate *) dateFromISOFormat
{
	return self;
}

@end


@implementation NSString (NSDateWAdditions)

- (NSDate *) date
{
    if (!WIsStringWithAnyText(self))
		return nil;
    
    if (self.length > 13)
        return [self dateFromISOFormat];
    
    if (self.length == 10 && [self characterAtIndex:4] == '-')
        return [self dateFromDBFormat];
    
    if (self.length <= 10) 
        return [self dateFromUnixTimestamp];
    
    if (self.length <= 13)
        return [self dateFromMillisTimestamp];
    
    return nil;
}

- (NSDate *) dateFromUnixTimestamp
{
    return [NSDate dateWithTimeIntervalSince1970:self.longLongValue];
}

- (NSDate *) dateFromMillisTimestamp
{
    return [NSDate dateWithTimeIntervalSince1970:self.longLongValue / 1000];
}

- (NSDate *) dateFromDBFormat
{
	if (!WIsStringWithAnyText(self))
		return nil;
    NSDateFormatter *formater = [NSDate WDateFormatter];
    [formater setDateFormat:@"yyyy-MM-dd"];
	return [formater dateFromString:self];
}

- (NSDate *) dateFromISOFormat
{
	if (!WIsStringWithAnyText(self))
		return nil;
    NSDateFormatter *formater = [NSDate WDateFormatter];
    [formater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    return [formater dateFromString:self];
}

@end

@implementation NSNumber (NSDateWAdditions)

- (NSDate *) date
{
    double value = [self doubleValue];
    
    if (value < 10000000000) 
        return [self dateFromUnixTimestamp];
    
    if (value < 10000000000000) 
        return [self dateFromMillisTimestamp];

    return nil;
}

- (NSDate *) dateFromUnixTimestamp
{
    return [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
}

- (NSDate *) dateFromMillisTimestamp
{
    return [NSDate dateWithTimeIntervalSince1970:self.doubleValue / 1000];
}

- (NSDate *) dateFromDBFormat
{
	return nil;
}

- (NSDate *) dateFromISOFormat
{
    return nil;
}

@end

@implementation NSNull (NSDateWAdditions)

- (NSDate *) date
{
    return nil;
}

- (NSDate *) dateFromUnixTimestamp
{
    return nil;
}

- (NSDate *) dateFromMillisTimestamp
{
    return nil;
}

- (NSDate *) dateFromDBFormat
{
	return nil;
}

- (NSDate *) dateFromISOFormat
{
    return nil;
}

@end

