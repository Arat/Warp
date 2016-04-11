//
//  FilesModel.m
//  Warp
//
//  Created by Lukas on 12.3.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

#import "WFileSystemSource.h"
#import "NSNumber+WFileSize.h"
#import "WAppDelegate.h"


@interface WFileSystemSource (Private)

- (NSDictionary *) loadFilesAtPath:(NSString *)path;

@end

@implementation WFileSystemSource

// instance
static WFileSystemSource *sharedFiles = nil;

+ (WFileSystemSource *) sharedFiles
{
	@synchronized(self) {
		if (sharedFiles == nil) {
			sharedFiles = [[self alloc] init];
		}
	}
    return sharedFiles;
}

- (instancetype) init
{
    if ((self = [super init])) {
        NSString  *docDirectory = [WAppDelegate applicationDocumentsDirectory];
        _homePath = [docDirectory copy];
        
        [self loadAtPath:docDirectory];
    }
    return self;
}

#pragma mark -

- (WFileSourceType) type
{
	return WFileSourceTypeSystem;
}

- (BOOL) networkBased
{
    return NO;
}

- (NSDictionary *) systemAtrributes
{
	return [NSNumber fileSystemUsage];
}

- (void) systemAtrributesWithBlock:(void (^)(NSDictionary *attributtes))block
{
    block([self systemAtrributes]);
}

- (BOOL) supportsThumbnails
{
    return YES;
}

- (BOOL) supportsThumbnailsWithSize:(WFileSourceThumbnailsSize)thumbnailSize
{
    return YES;
}

- (BOOL) supportsPublicLinks
{
    return NO;
}

- (void) publicLinkForFile:(NSString *)file completion:(WFilePublicLinkBlock)completion
{
    NSURL *URL = [[NSFileManager defaultManager] URLForPublishingUbiquitousItemAtURL:[NSURL fileURLWithPath:file]
                                                                      expirationDate:nil error:nil];
    completion(URL);
}

@end
