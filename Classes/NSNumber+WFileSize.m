//
//  NSNumber+WFileSize.m
//  Warp
//
//  Created by Lukas on 16.7.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

#import "NSNumber+WFileSize.h"


@implementation NSNumber (WFileSize)

- (NSString *) stringSize
{
	float floatSize = [self floatValue];
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.0f b", floatSize]);
	}
	floatSize = floatSize / 1024;
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.0f KB", floatSize]);
	}
	floatSize = floatSize / 1024;
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.0f MB", floatSize]);
	}
	floatSize = floatSize / 1024;
    
    if (floatSize < 1023) {
        return([NSString stringWithFormat: @"%1.0f GB", floatSize]);
    }
    floatSize = floatSize / 1024;
	return [NSString stringWithFormat: @"%1.0f TR", floatSize];
}

- (NSString *) stringFloatSize
{
	float floatSize = [self floatValue];
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.1f b", floatSize]);
	}
	floatSize = floatSize / 1024;
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.1f KB", floatSize]);
	}
	floatSize = floatSize / 1024;
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.1f MB", floatSize]);
	}
	floatSize = floatSize / 1024;
	
    if (floatSize < 1023) {
        return([NSString stringWithFormat: @"%1.1f GB", floatSize]);
    }
    floatSize = floatSize / 1024;
	return [NSString stringWithFormat: @"%1.1f TR", floatSize];
}

+ (NSString *) stringSizeWithInteger:(unsigned long long)integer
{
	float floatSize = integer;
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.0f b", floatSize]);
	}
	floatSize = floatSize / 1024;
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.0f KB", floatSize]);
	}
	floatSize = floatSize / 1024;
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.0f MB", floatSize]);
	}
	floatSize = floatSize / 1024;
	
    if (floatSize < 1023) {
        return([NSString stringWithFormat: @"%1.0f GB", floatSize]);
    }
    floatSize = floatSize / 1024;
	return [NSString stringWithFormat: @"%1.0f TR", floatSize];
}

+ (NSString *) stringFloatSizeWithInteger:(unsigned long long)integer
{
    float floatSize = integer;
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.1f b", floatSize]);
	}
	floatSize = floatSize / 1024;
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.1f KB", floatSize]);
	}
	floatSize = floatSize / 1024;
	
	if (floatSize < 1023) {
		return([NSString stringWithFormat: @"%1.1f MB", floatSize]);
	}
	floatSize = floatSize / 1024;
	
    if (floatSize < 1023) {
        return([NSString stringWithFormat: @"%1.1f GB", floatSize]);
    }
    floatSize = floatSize / 1024;
	return [NSString stringWithFormat: @"%1.1f TR", floatSize];
}

+ (NSNumber *) freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return fattributes[NSFileSystemFreeSize];
}

+ (NSDictionary *) fileSystemUsage
{
	return [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
}

@end


@implementation NSNull (WFileSize)

- (NSString *) stringSize
{
    return @"0 b";
}

- (NSString *) stringFloatSize
{
    return @"0.0 b";
}

@end
