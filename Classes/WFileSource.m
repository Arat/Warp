//
//  WFileSource.m
//  Warp
//
//  Created by Lukas on 6.7.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

#import "WFileSource.h"


// No-ops for non-retaining objects.
static const void *WRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void WReleaseNoOp(CFAllocatorRef allocator, const void *value) { }


static WFileLogger *WFileSourceTranscriptLogger = nil;


@implementation WFileSource

@synthesize type = _type;
@synthesize networkBased = _networkBased;
@synthesize state = _state;
@synthesize identifier = _identifier;
@synthesize connection = _connection;

@synthesize homePath = _homePath;
@synthesize currentPath = _currentPath;
@synthesize selectedPath = _selectedPath;

@synthesize delegates = _delegates;

+ (void) initialize
{
    if ([self class] == [WFileSource class]) {
        WFileSourceTranscriptLogger = [[WFileLogger alloc] init];
    }
}

- (instancetype) initWithConnection:(WConnection *)connection
{
    self = [super init];
    
	if (self) {
        CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
        callbacks.retain = WRetainNoOp;
        callbacks.release = WReleaseNoOp;
		_delegates = CFBridgingRelease(CFArrayCreateMutable(nil, 0, &callbacks));
		[self setConnection:connection];
	}
	return self;
}

- (void) dealloc
{
	_delegates = nil;
    _connection = nil;
	
	_homePath = nil;
	_currentPath = nil;
    
	_selectedPath = nil;
    _systemAttributes = nil;
}


#pragma mark -

- (NSArray *) delegates
{
	return [NSArray arrayWithArray: _delegates];
}

- (void) addDelegate:(id<WFileSourceDelegate>) delegate
{
	if ([_delegates indexOfObject: delegate] != NSNotFound) {
		return;
	}
	[_delegates addObject: delegate];
}

- (void) removeDelegate:(id<WFileSourceDelegate>) delegate
{
	[_delegates removeObject: delegate];
}

+ (void) setTranscriptLogger:(WFileLogger *)logger
{
    WFileSourceTranscriptLogger = logger;
}

+ (WFileLogger *) transcriptLogger
{
    return WFileSourceTranscriptLogger;
}

- (void) appendToTranscript:(NSAttributedString *)string
{
    [WFileSourceTranscriptLogger appendToTranscript:string];
}

#pragma mark -

- (void) connect
{
	
}

- (BOOL) isConnected
{
	return NO;
}

- (BOOL) isBusy
{
	return NO;
}

- (void) disconnect
{
	
}

- (void) changePath:(NSString *) newPath
{
	
}

- (void) checkExistenceOfPath:(NSString *) path
{
    
}

- (void) loadAtPath:(NSString *) path
{
	
}

- (void) loadAtPath:(NSString *)path info:(id)info
{
    [self loadAtPath:path];
}

- (WFileSourceType) type
{
	return -1;
}

- (void) reload
{
	
}

#pragma mark Directory methods

- (void) makeDir:(NSString *) newDir atDirectory:(NSString *) directory
{

}

#pragma mark File methods

- (void) makeFile:(NSString *) newFile atDirectory:(NSString *) directory
{

}

- (void) copyFile:(NSString *) file toFile:(NSString *) copyFile
{
	
}

- (void) renameFile:(NSString *) file toName:(NSString *) name
{

}

- (void) moveFile:(NSString *) file toDirectory:(NSString *) directory
{

}

- (void) deleteFile:(NSString *) file
{

}

- (void) deleteDirectory:(NSString *) directory
{
	
}

#pragma mark Permissions

- (void) setOwner:(NSString *) owner forFile:(NSString *) file
{

}

- (void) setGroup:(NSString *) group forFile:(NSString *) file;
{

}

- (void) setPermissions:(NSNumber *) permissions forFile:(NSString *) file;
{

}

- (void) setPermissions:(NSNumber *) permissions owner:(NSString *) owner group:(NSString *) group forFile:(NSString *) file;
{

}

- (BOOL) supportsSearch
{
    return NO;
}

- (void) searchPath:(NSString *)path forKeyword:(NSString *)keyword
{
    
}

- (NSDictionary *) systemAtrributes
{
	return _systemAttributes;
}

- (void) systemAtrributesWithBlock:(void (^)(NSDictionary *))block
{
    block(_systemAttributes);
}

- (BOOL) supportsThumbnails
{
    return NO;
}

- (BOOL) supportsThumbnailsWithSize:(WFileSourceThumbnailsSize)thumbnailSize
{
    return NO;
}

- (void) loadThumbnailForFile:(NSString *)file toPath:(NSString *)toPath completion:(WFileThumbnailBlock)completion
{
    
}

- (void) loadThumbnailForFile:(NSString *)file toPath:(NSString *)toPath completion:(WFileThumbnailBlock)completion size:(WFileSourceThumbnailsSize)size
{
    
}

- (BOOL) supportsPublicLinks
{
    return NO;
}

- (void) publicLinkForFile:(NSString *)file completion:(WFilePublicLinkBlock)completion
{
    
}

@end


@implementation NSArray (WFileSource)

- (void) perform:(SEL) selector withObject:(id) p1 withObject:(id) p2 withObject:(id) p3 withObject:(id) p4
{
	NSEnumerator *e = [[self copy] objectEnumerator];
	
	for (id delegate; (delegate = [e nextObject]);) {
		if ([delegate respondsToSelector: selector]) {
			NSMethodSignature *sig = [delegate methodSignatureForSelector: selector];
			NSInvocation     *invo = [NSInvocation invocationWithMethodSignature: sig];
			[invo setTarget: delegate];
			[invo setSelector: selector];
			[invo setArgument:&p1 atIndex: 2];
			[invo setArgument:&p2 atIndex: 3];
			[invo setArgument:&p3 atIndex: 4];
			[invo setArgument:&p4 atIndex: 5];
			[invo invoke];
		}
	}
}

@end
