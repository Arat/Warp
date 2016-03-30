//
//  WAppDelegate.m
//  Warp
//
//  Created by Lukáš Foldýna on 8.8.10.
//  Copyright 2010 TwoManShow. All rights reserved.
//

#import "WAppDelegate.h"
#import "WGlobal.h"


static NSString *WApplicationGroupIdentifier = nil;


@implementation WAppDelegate

+ (WAppDelegate *) sharedAppDelegate
{
#if TARGET_OS_IPHONE
	return (id)[[UIApplication sharedApplication] delegate];
#else
    return (id)[NSApp delegate];
#endif
}

#pragma mark -
#pragma mark Application

+ (BOOL) isApplicationExtension
{
    if (WISOS8()) {
        return [[[NSBundle mainBundle] executablePath] containsString:@".appex/"];
    } else {
        return NO;
    }
}

+ (BOOL) isApplicationRunningFromTestflight
{
    return [[[[NSBundle mainBundle] appStoreReceiptURL] lastPathComponent] isEqualToString:@"sandboxReceipt"];
}

+ (NSString *) applicationID
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *) applicationName
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"];
}

+ (NSString *) applicationVersion
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *) applicationDocumentsDirectory
{	
    return [WAppDelegate applicationDocumentsDirectory];
}

/**
 Returns the path to the application's library directory.
 */
- (NSString *) applicationLibraryDirectory
{	
    return [WAppDelegate applicationLibraryDirectory];
}

/**
 Returns the path to the application's cache directory.
 */
- (NSString *) applicationCacheDirectory
{	
    return [WAppDelegate applicationCacheDirectory];
}

/**
 Returns the path to the application's temp directory.
 */
- (NSString *) applicationTemporaryDirectory
{	
    return [WAppDelegate applicationTemporaryDirectory];
}

/**
 Returns the path to the application's documents directory.
 */
+ (NSString *) applicationDocumentsDirectory
{	
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

/**
 Returns the path to the application's library directory.
 */
+ (NSString *) applicationLibraryDirectory
{	
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

/**
 Returns the path to the application's cache directory.
 */
+ (NSString *) applicationCacheDirectory
{	
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? paths[0] : nil;
    return basePath;
}

/**
 Returns the path to the application's temp directory.
 */
+ (NSString *) applicationTemporaryDirectory
{	
#if TARGET_IPHONE_SIMULATOR
    NSString *tmpPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
#else
    NSString *tmpPath = NSTemporaryDirectory();
#endif
    if ([tmpPath hasSuffix:@"/"])
        return [tmpPath substringToIndex:[tmpPath length] - 1];
    return tmpPath;
}

#pragma Application Group

- (NSString *) applicationGroupIdentifier
{
    return [WAppDelegate applicationGroupIdentifier];
}

- (void) setApplicationGroupIdentifier:(NSString *)groupIdentifier
{
    [WAppDelegate setApplicationGroupIdentifier:groupIdentifier];
}

- (NSString *) applicationGroupDirectory
{
    return [WAppDelegate applicationGroupDirectory];
}

- (NSString *) applicationGroupDocumentsDirectory
{
    return [WAppDelegate applicationGroupDocumentsDirectory];
}

+ (NSString *) applicationGroupIdentifier
{
    return WApplicationGroupIdentifier;
}

+ (void) setApplicationGroupIdentifier:(NSString *)groupIdentifier
{
    WApplicationGroupIdentifier = groupIdentifier;
}

+ (NSString *) applicationGroupDirectory
{
    if (WISOSX08() || WISOS8()) {
        return [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:[WAppDelegate applicationGroupIdentifier]] path];
    } else {
        return [[WAppDelegate applicationDocumentsDirectory] stringByDeletingLastPathComponent];
    }
}

+ (NSString *) applicationGroupDocumentsDirectory
{
    if (WISOSX08() || WISOS8()) {
        return [[WAppDelegate applicationGroupDirectory] stringByAppendingPathComponent:@"Documents"];
    } else {
        return [WAppDelegate applicationDocumentsDirectory];
    }
}

+ (NSURL *) applicationGroupURL
{
    if (WISOSX08() || WISOS8()) {
        return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:[WAppDelegate applicationGroupIdentifier]];
    } else {
        return [NSURL fileURLWithPath:[[WAppDelegate applicationDocumentsDirectory] stringByDeletingLastPathComponent]];
    }
}

+ (NSURL *) applicationGroupDocumentsURL
{
    if (WISOSX08() || WISOS8()) {
        return [[WAppDelegate applicationGroupURL] URLByAppendingPathComponent:@"Documents"];
    } else {
        return [NSURL fileURLWithPath:[WAppDelegate applicationDocumentsDirectory]];
    }
}

#if TARGET_OS_IPHONE

#pragma mark -

- (UIViewController *) rootViewController
{
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

+ (UIViewController *) rootViewController
{
    return [[WAppDelegate sharedAppDelegate] rootViewController];
}

#endif

@end
