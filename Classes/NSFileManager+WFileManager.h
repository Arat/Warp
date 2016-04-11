//
//  NSFileManager+WFileManager.h
//  Warp
//
//  Created by Lukáš Foldýna on 17.10.12.
//  Copyright (c) 2012 TwoManShow. All rights reserved.
//

@import Foundation;


@interface NSFileManager (WFileManager)

- (BOOL) addSkipBackupAttributeToItemAtPath:(NSString *)path;
+ (BOOL) addSkipBackupAttributeToItemAtPath:(NSString *)path;

- (void) storeBookmarkForURL:(NSURL *)bookmarkURL toLocationAtURL:(NSURL *)locationURL;
- (NSData *) bookmarkFromURL:(NSURL *)URL;
- (NSURL *) URLFromBookmark:(NSData *)bookmark bookmarkDataIsStale:(BOOL *)isStale;

#if !TARGET_OS_IPHONE

- (void) storePermanentBookmarkForURL:(NSURL *)bookmarkURL toLocationAtURL:(NSURL *)locationURL;
- (NSData *) permanentBookmarkFromURL:(NSURL *)URL;
- (NSURL *) URLFromPermanentBookmark:(NSData *)bookmark bookmarkDataIsStale:(BOOL *)isStale;

#endif

@end
