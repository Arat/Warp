//
//  WFileLogger.h
//  Warp
//
//  Created by Lukáš Foldýna on 17.11.11.
//  Copyright (c) 2011 TwoManShow. All rights reserved.
//

@import Foundation;


@interface WFileLogger : NSObject
{
    NSMutableDictionary     *_logConnections;
}

@property (nonatomic, assign) BOOL allowLogging;
@property (nonatomic, assign) BOOL allowFileLogging;
- (NSString *) logConnectionListName;
- (NSString *) logFileNameWithConnection:(NSString *)connection;
- (NSString *) logFileNameWithConnection:(NSString *)connection date:(NSDate *)date;
+ (NSArray *) logFromFile:(NSString *)file;

@property (nonatomic, strong, readonly) NSDictionary *logConnections;

@property (nonatomic, strong) NSMutableDictionary *transcripts; // Transcript
- (NSArray *) transcriptForConnection:(NSString *)connection;
- (void) appendToTranscript:(NSAttributedString *)string; // Pridat to transcriptu

@end
