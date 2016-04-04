//
//  NSUserDefaults+WGroupDefaults.m
//  Warp
//
//  Created by Lukáš Foldýna on 18/01/15.
//  Copyright (c) 2015 Lukáš Foldýna. All rights reserved.
//

#import "NSUserDefaults+WGroupDefaults.h"
#import "WAppDelegate.h"
#import "WGlobal.h"


@implementation NSUserDefaults (WGroupDefaults)

+ (instancetype) groupUserDefaults
{
    static NSUserDefaults *defaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if TARGET_OS_IPHONE
        if (WISOS8()) {
#else
        if (WISOSX08()) {
#endif
            defaults = [[NSUserDefaults alloc] initWithSuiteName:[WAppDelegate applicationGroupIdentifier]];
        } else {
            defaults = [NSUserDefaults standardUserDefaults];
        }
    });
    return defaults;
}

@end
