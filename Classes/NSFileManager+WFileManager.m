//
//  NSFileManager+WFileManager.m
//  Warp
//
//  Created by Lukáš Foldýna on 17.10.12.
//  Copyright (c) 2012 TwoManShow. All rights reserved.
//

#import "NSFileManager+WFileManager.h"
#import "WGlobal.h"
#import <sys/xattr.h>


@implementation NSFileManager (WFileManager)

- (BOOL) addSkipBackupAttributeToItemAtPath:(NSString *)path
{
#if TARGET_OS_IPHONE
    if (WISOS5()) {
        if ([[UIDevice currentDevice].systemVersion hasPrefix:@"5.1."]) {
            return [self _newAddSkipBackupAttributeToItemAtPath:path];
        } else {
            return [self _oldAddSkipBackupAttributeToItemAtPath:path];
        }
    } else if (WISOS6()) {
        return [self _newAddSkipBackupAttributeToItemAtPath:path];
    } else {
        return YES; // iOS4 or lower
    }
#else
    return NO;
#endif
}

+ (BOOL) addSkipBackupAttributeToItemAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] addSkipBackupAttributeToItemAtPath:path];
}

- (BOOL) _newAddSkipBackupAttributeToItemAtPath:(NSString *)path
{
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!exists)
        return NO;
    
    NSError *error = nil;
    BOOL success = [[NSURL fileURLWithPath:path] setResourceValue:@YES
                                                           forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", path, error);
    }
    return success;
}

- (BOOL) _oldAddSkipBackupAttributeToItemAtPath:(NSString *)path
{
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (!exists)
        return NO;
    
    const char *filePath = [path fileSystemRepresentation];
    const char *attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

#pragma mark Sandbox

- (void) storeBookmarkForURL:(NSURL *)bookmarkURL toLocationAtURL:(NSURL *)locationURL
{
    [[NSFileManager defaultManager] createFileAtPath:locationURL.path contents:[self bookmarkFromURL:bookmarkURL] attributes:nil];
}

- (NSData *) bookmarkFromURL:(NSURL *)URL
{
    NSError *error = nil;
    NSData *bookmark = [URL bookmarkDataWithOptions:NSURLBookmarkCreationMinimalBookmark
                     includingResourceValuesForKeys:NULL
                                      relativeToURL:NULL
                                              error:&error];
    
    if (error) {
        NSLog(@"bookmarkFromURL: %@", error);
    }
    return bookmark;
}

- (NSURL *) URLFromBookmark:(NSData *)bookmark bookmarkDataIsStale:(BOOL *)isStale
{
    NSError *error = nil;
    NSURL *URL = [NSURL URLByResolvingBookmarkData:bookmark
                                           options:NSURLBookmarkResolutionWithoutUI
                                     relativeToURL:NULL
                               bookmarkDataIsStale:isStale
                                             error:&error];
    
    
    if (error) {
        NSLog(@"URLFromBookmark: %@", error);
    }
    return URL;
}

#if !TARGET_OS_IPHONE

- (void) storePermanentBookmarkForURL:(NSURL *)bookmarkURL toLocationAtURL:(NSURL *)locationURL
{
    [[NSFileManager defaultManager] createFileAtPath:[locationURL path] contents:[self permanentBookmarkFromURL:bookmarkURL] attributes:nil];
}

- (NSData *) permanentBookmarkFromURL:(NSURL *)URL
{
    NSError *error = nil;
    NSData *bookmark = [URL bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope
                     includingResourceValuesForKeys:NULL
                                      relativeToURL:NULL
                                              error:&error];
    
    if (error) {
        NSLog(@"permanentBookmarkFromURL: %@", error);
    }
    return bookmark;
}

- (NSURL *) URLFromPermanentBookmark:(NSData *)bookmark bookmarkDataIsStale:(BOOL *)isStale
{
    NSError *error = nil;
    NSURL *URL = [NSURL URLByResolvingBookmarkData:bookmark
                                           options:NSURLBookmarkResolutionWithSecurityScope
                                     relativeToURL:NULL
                               bookmarkDataIsStale:isStale
                                             error:&error];
    
    
    if (error) {
        NSLog(@"URLFromPermanentBookmark: %@", error);
    }
    return URL;
}

#endif

@end
