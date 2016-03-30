//
//  NSString+Crypto.h
//  Warp
//
//  Created by Lukas on 28.7.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (WCrypto)

+ (NSString *) MD5String:(NSString *) string;
+ (NSString *) SHA1String:(NSString *) string;

- (NSString *) MD5String;
- (NSString *) SHA1String;

@end
