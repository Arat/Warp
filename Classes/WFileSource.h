//
//  WFileSource.h
//  Warp
//
//  Created by Lukas on 6.7.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFileSourceProtocol.h"
#import "WFileLogger.h"


/*
 * Zakladni implementace WFileSourceProtocol
 */
@interface WFileSource : NSObject <WFileSourceProtocol>
{
    @protected
	WFileSourceType						 _type;
	NSUInteger							 _state;
	WConnection							*_connection;
	
	NSString							*_homePath;
    NSString							*_currentPath;
	
	NSMutableArray						*_delegates;
	NSString							*_selectedPath;
	NSDictionary						*_systemAttributes;
}

@property (nonatomic, strong) NSString *selectedPath;

+ (void) setTranscriptLogger:(WFileLogger *)logger;
+ (WFileLogger *) transcriptLogger;
- (void) appendToTranscript:(NSAttributedString *)string; // Pridat to transcriptu

@end


@interface NSArray (WFileSource)

- (void) perform:(SEL) selector withObject:(id) p1 withObject:(id) p2 withObject:(id) p3 withObject:(id) p4;

@end
