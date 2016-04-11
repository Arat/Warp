//
//  NSString+Crypto.h
//  Warp
//
//  Created by Lukas on 28.7.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

@import Foundation;


@interface NSString (WCrypto)

+ (NSString *) MD5String:(NSString *) string;
+ (NSString *) SHA1String:(NSString *) string;

@property (nonatomic, readonly, copy) NSString *MD5String;
@property (nonatomic, readonly, copy) NSString *SHA1String;

@end
