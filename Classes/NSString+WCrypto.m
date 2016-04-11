//
//  NSString+WCrypto.m
//  Warp
//
//  Created by Lukas on 28.7.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

#import "NSString+WCrypto.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>


@implementation NSString (WCrypto)

- (NSString *) MD5String
{
	return [NSString MD5String: self];
}

+ (NSString *) MD5String:(NSString *) string
{
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
	CC_MD5(string.UTF8String, (CC_LONG)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
	NSMutableString *ms = [NSMutableString string];
	
	for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		[ms appendFormat: @"%02x", (int) (digest[i])];
	}
	return [ms copy];
}

- (NSString *) SHA1String
{
	return [NSString SHA1String: self];
}

+ (NSString *) SHA1String:(NSString *) string
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH], i;
	CC_SHA1(string.UTF8String, (CC_LONG)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
	NSMutableString *ms = [NSMutableString string];
	
	for (i = 0; i< CC_SHA1_DIGEST_LENGTH; i++) {
		[ms appendFormat: @"%02x", (int) (digest[i])];
	}
	return [ms copy];
}

@end
