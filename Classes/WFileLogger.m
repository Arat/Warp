//
//  WFileLogger.m
//  Warp
//
//  Created by Lukáš Foldýna on 17.11.11.
//  Copyright (c) 2011 TwoManShow. All rights reserved.
//

#import "WFileLogger.h"
#import "WAppDelegate.h"


@implementation WFileLogger

@synthesize allowLogging = _allowLogging;
@synthesize allowFileLogging = _allowFileLogging;

@synthesize logConnections = _logConnections;

@synthesize transcripts = _transcripts;

- (id) init
{
    self = [super init];
    
    if (self) {
        _logConnections = [[NSMutableDictionary alloc] init];
        NSString *logPath = [self logConnectionListName]; BOOL isDir = NO;
        
        if (!([[NSFileManager defaultManager] fileExistsAtPath:[logPath stringByDeletingLastPathComponent] isDirectory:&isDir] && isDir)) {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:[logPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil]) {
                NSLog(@"Failed to create log directory: %@", [logPath stringByDeletingLastPathComponent]);
            }
        }
        NSData *data = [NSData dataWithContentsOfFile:logPath];
        NSDictionary *list = [NSPropertyListSerialization propertyListWithData:data
                                                                       options:NSPropertyListImmutable
                                                                         format:nil
                                                                         error:nil];
        for (NSDictionary *dictionary in [list allValues]) {
            _logConnections[dictionary[@"name"]] = [dictionary mutableCopy];
        }
    }
    return self;
}

- (void) dealloc
{
    for (NSDictionary *dictionary in [_logConnections allValues]) {
        if (dictionary[@"fileHandle"]) {
            [dictionary[@"fileHandle"] closeFile];
        }
    }
    _logConnections = nil;
}

- (NSString *) logConnectionListName
{
    return [[WAppDelegate applicationLibraryDirectory] stringByAppendingPathComponent:@"Logs/wconnections.plist"];
}

- (NSString *) logFileNameWithConnection:(NSString *)connection
{
	return [self logFileNameWithConnection:connection date:[NSDate date]];
}

- (NSString *) logFileNameWithConnection:(NSString *)connection date:(NSDate *)date
{
    NSString *logPath = [[WAppDelegate applicationLibraryDirectory] stringByAppendingPathComponent:@"Logs"];
	BOOL isDir;
	
	if (!([[NSFileManager defaultManager] fileExistsAtPath:logPath isDirectory:&isDir] && isDir)) {
		if (![[NSFileManager defaultManager] createDirectoryAtPath:logPath withIntermediateDirectories:YES attributes:nil error:nil]) {
			NSLog(@"Failed to create log directory: %@", logPath);
		}
	}
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
	NSString *logName = [logPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.wlog", connection, [formatter stringFromDate:[NSDate date]]]];
    
	if (![[NSFileManager defaultManager] fileExistsAtPath:logName]) {
		if (![[NSFileManager defaultManager] createFileAtPath:logName contents:[NSData data] attributes:nil]) {
			NSLog(@"Failed to create log file at: %@", logName);
		}
	}
	return logName;
}

+ (NSArray *) logFromFile:(NSString *)file
{
	NSFileHandle *logFileHandle = [NSFileHandle fileHandleForReadingAtPath:file];
	NSMutableArray *log = [NSMutableArray array];
	
	@try {
		// keep going until we throw an exception for being out of bounds
		while (1) {
			unsigned len;
			NSData *lenData = [logFileHandle readDataOfLength:sizeof(unsigned)];
			[lenData getBytes:&len length:[lenData length]];
			len = CFSwapInt32LittleToHost(len);
			NSData *archive = [logFileHandle readDataOfLength:len];
#if !TARGET_OS_IPHONE
			NSDictionary *record = [NSUnarchiver unarchiveObjectWithData:archive];
#else
			if ([archive length] == 0)
				break;
			NSDictionary *record = [NSKeyedUnarchiver unarchiveObjectWithData: archive];
#endif
			[log addObject:record];
		}
	} @catch (NSException *e) {
        
	}
	[logFileHandle closeFile];
	return log;
}

- (NSArray *) transcriptForConnection:(NSString *)connection
{
    return _transcripts[connection];
}

- (void) appendToTranscript:(NSAttributedString *)string
{
    if (_allowLogging == NO || [string length] == 0)
        return;
    
    NSString *conectionName = [string attribute:@"Connection" atIndex:0 effectiveRange:NULL];
    if (conectionName == nil)
        conectionName = @"Default";
    NSMutableArray *log = nil;
    
    if (_transcripts[conectionName]) {
        log = _transcripts[conectionName];
    } else {
        log = [NSMutableArray array];
        _transcripts[conectionName] = log;
    }
    
	if ([log count] > 50) {
		[log removeObjectAtIndex:0];
	}
	[log addObject:string];
    
    if (!_logConnections[conectionName]) {
        NSDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:conectionName, @"name", [NSDate date], @"date", nil];
        NSMutableDictionary *list = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[self logConnectionListName]]
                                                                              options:NSPropertyListMutableContainers
                                                                               format:nil
                                                                                error:nil];
        if (list == nil)
            list = [NSMutableDictionary dictionary];
        list[conectionName] = dict;
        NSString *fileName = [self logConnectionListName];
        [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
        [[NSFileManager defaultManager] createFileAtPath:fileName
                                                contents:[NSPropertyListSerialization dataWithPropertyList:list
                                                                                                    format:NSPropertyListBinaryFormat_v1_0
                                                                                                   options:0
                                                                                                     error:nil]
                                              attributes:nil];
        _logConnections[conectionName] = dict;
    }
    
    if (_allowFileLogging) {
#if !TARGET_OS_IPHONE
		NSData *recData = [NSArchiver archivedDataWithRootObject:string];
#else
		NSData *recData = [NSKeyedArchiver archivedDataWithRootObject:string];
#endif
        NSFileHandle *handle = nil;
        
        if (_logConnections[conectionName]) {
            NSDictionary *dict = _logConnections[conectionName];
            if (dict[@"fileHandle"])
                handle = dict[@"fileHandle"];
        }
        
		if (!handle) {
			// need to get the log file handle
			handle = [NSFileHandle fileHandleForWritingAtPath:
                               [self logFileNameWithConnection:[string attribute:@"Connection" 
                                                                         atIndex:0 
                                                                  effectiveRange:NULL]]];
            NSMutableDictionary *dict = _logConnections[conectionName];
            dict[@"fileHandle"] = handle;
		}
		[handle seekToEndOfFile];
        
		unsigned len = CFSwapInt32HostToLittle((unsigned int)[recData length]);
		NSMutableData *entry = [NSMutableData data];
		[entry appendBytes:&len length:sizeof(unsigned)];
		[entry appendData:recData];
        
		[handle writeData:entry];
	}
}

@end
