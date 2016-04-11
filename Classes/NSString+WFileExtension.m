//
//  WFileExtension.m
//  Warp
//
//  Created by Lukas on 13.7.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

#import "NSString+WFileExtension.h"


@implementation NSString (WFileExtension)

static NSArray *extImage    = nil;
static NSArray *extAudio    = nil;
static NSArray *extVideo    = nil;
static NSArray *extText     = nil;
static NSArray *extDocument = nil;
static NSArray *extBundle   = nil;
static NSArray *extArchive  = nil;

- (BOOL) canOpen
{
	if ([self isVideo]) {
		return YES;
	} else if ([self isAudio]) {
		return YES;
	} else if ([self isImage]) {
		return YES;
	} else if ([self isText]) {
		return YES;
	} else if ([self isDocument]) {
		return YES;
	}
	return NO;
}

- (NSArray *) extImage
{
	if (extImage == nil) {
		extImage = @[@"bmp", @"ico", @"jpg", @"jpeg", @"gif", @"png", @"tif", @"tiff", @"xbm", @"orf"];
	}
	return extImage;
}

- (BOOL) isImage
{
	if ([self.extImage indexOfObject: self] == NSNotFound) {
		return NO;
	}
	return YES;
}

- (NSArray *) extAudio
{
	if (extAudio == nil) {
		extAudio = @[@"aif", @"aiff", @"aac", @"caf", @"mp1", @"mp2", @"mp3", @"m4a", @"wav", @"m3u"];
	}
	return extAudio;
}

- (BOOL) isAudio
{
	if ([self.extAudio indexOfObject: self] == NSNotFound) {
		return NO;
	}
	return YES;
}

- (NSArray *) extVideo
{
	if (extVideo == nil) {
		extVideo = @[@"mov", @"mp4", @"mpv", @"m4v", @"3gp", @"m3u8", @"ts"];
	}
	return extVideo;
}

- (BOOL) isVideo
{
	if ([self.extVideo indexOfObject: self] == NSNotFound) {
		return NO;
	}
	return YES;
}

- (BOOL) isStreamedVideo
{
    return [self.lowercaseString isEqualToString:@"m3u8"];
}

- (NSArray *) extText
{
	if (extText == nil) {
		extText = @[@"txt", @"html", @"htm", @"css", @"js", @"php", @"py", @"cpp", @"c", @"cc", @"m", @"mm", @"h", 
						@"sh", @"rb", @"log", @"inf", @"ini", @"asp", @"htaccess", @"cfm", @"pm", @"pl", @"cgi", @"py", @"java", @"conf", @"xml",
				        @"xlst", @"xhtml", @"shtml", @"rhtml", @"gml", @"atom", @"sh", @"csh", @"tcsh", @"in", @"md", @"less"];
	}
	return extText;
}

- (BOOL) isText
{
	if ([self.extText indexOfObject: self] == NSNotFound) {
		return NO;
	}
	return YES;
}

- (NSArray *) extDocument
{
	if (extDocument == nil) {
		extDocument = @[@"pdf", @"html", @"htm", @"webarchive", @"doc", @"docx", @"xls", @"xlsx", @"ppt", @"pptx", 
							@"key", @"numbers", @"pages", @"rtf", @"rtfd"];
	}
	return extDocument;
}

- (BOOL) isDocument
{
	if ([self.extDocument indexOfObject: self] == NSNotFound) {
		return NO;
	}
	return YES;
}

- (NSArray *) extBundle
{
	if (extBundle == nil) {
		extBundle = @[@"pages", @"numbers", @"key", @"app", @"rtfd"];
	}
	return extBundle;
}

- (BOOL) isBundle
{
	if ([self.extBundle indexOfObject: self] == NSNotFound) {
		return NO;
	}
	return YES;
}

- (NSArray *) extArchive
{
	if (extArchive == nil) {
		extArchive = @[@"zip", @"rar", @"rev", @"r00", @"r01", @"cbr", @"7z", @"tar", @"gz", @"dmg"];
	}
	return extArchive;
}

- (BOOL) isArchive
{
	if ([self.extArchive indexOfObject: self] == NSNotFound) {
		return NO;
	}
	return YES;
}

- (BOOL) canUnarchive
{
	if ([self isEqualToString:@"zip"] || [self isEqualToString:@"rar"] || [self isEqualToString:@"rev"] || [self isEqualToString:@"r00"] || [self isEqualToString:@"r01"] || [self isEqualToString:@"cbr"]) {
		return YES;
	}
	return NO;
}

-(NSString *) stringByStrippingHTML
{
    NSRange range;
    NSString *string = [self copy];
    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        string = [string stringByReplacingCharactersInRange:range withString:@""];
    return string;
}

@end
