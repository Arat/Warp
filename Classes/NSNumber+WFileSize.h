//
//  NSNumber+WFileSize.h
//  Warp
//
//  Created by Lukas on 16.7.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/statvfs.h>


@interface NSNumber (WFileSize)

/*
 * Vrati string, prevedeny na nejvetsi odpovidajici jednotku
 */
- (NSString *) stringSize;

- (NSString *) stringFloatSize;

/*
 * Vrati string, prevedeny na nejvetsi odpovidajici jednotku
 */
+ (NSString *) stringSizeWithInteger:(unsigned long long)integer;

+ (NSString *) stringFloatSizeWithInteger:(unsigned long long)integer;

/*
 * Vrati info disku
 */
+ (NSDictionary *) fileSystemUsage;

@end

