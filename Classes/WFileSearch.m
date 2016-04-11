//
//  WFileSearch.m
//  Warp
//
//  Created by Lukáš Foldýna on 20.09.12.
//  Copyright (c) 2012 TwoManShow. All rights reserved.
//

#import "WFileSearch.h"


@interface WFileSearch () <WFileSourceDelegate>

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSPredicate *searchPredicate;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSMutableArray *directories;

@property (nonatomic, assign) NSInteger numberOfDirectoryLoadings;

@end

@implementation WFileSearch

- (instancetype) init
{
    self = [self initWithFileSource:nil];
    return self;
}

- (instancetype) initWithFileSource:(id<WFileSourceProtocol>)fileSource
{
    self = [super init];
    
    if (self) {
        [self setFileSource:fileSource];
    }
    return self;
}

- (void) dealloc
{
    _delegate = nil;
    [_fileSource removeDelegate:self];
}

#pragma mark -

- (void) setFileSource:(id<WFileSourceProtocol>)fileSource
{
    [_fileSource removeDelegate:self];
    _fileSource = fileSource;
}

- (void) searchWithText:(NSString *)text
{
    _searchPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ LIKE[cd] %%@", @"cxFilenameKey"],
                        [[@"*" stringByAppendingString:text] stringByAppendingString:@"*"]];
    
    if ([_fileSource type] == WFileSourceTypeSystem) {
        if (_searchText && [text hasPrefix:_searchText] && _results) {
            _searchText = text;
            NSMutableArray *content = [[NSMutableArray alloc] init];
            
            for (NSDictionary *file in [_results copy]) {
                if ([_searchPredicate evaluateWithObject:file]) {
                    [content addObject:file];
                }
            }
            _results = content;
            
            if ([content count]) {
                [_delegate search:self didFoundFiles:content text:_searchText];
            }
            if (_numberOfDirectoryLoadings == 0) {
                [_delegate search:self didStopWithText:_searchText];
                [_fileSource removeDelegate:self];
            }
        } else {
            _searchText = text;
            _results = [[NSMutableArray alloc] init];
            _directories = [[NSMutableArray alloc] init];
            _numberOfDirectoryLoadings = 1;
            [_fileSource addDelegate:self];
            [_fileSource loadAtPath:_fileSource.homePath];
        }
    } else {
        if (_searchText && [text hasPrefix:_searchText] && [_results count]) {
            _searchText = text;
            NSMutableArray *content = [[NSMutableArray alloc] init];
            
            for (NSDictionary *file in [_results copy]) {
                if ([_searchPredicate evaluateWithObject:file]) {
                    [content addObject:file];
                }
            }
            _results = content;
            
            if ([content count])
                [_delegate search:self didFoundFiles:content text:_searchText];
            
            [_delegate search:self didStopWithText:_searchText];
            [_fileSource removeDelegate:self];
        } else {
            _searchText = text;
            _results = [[NSMutableArray alloc] init];
            _directories = [[NSMutableArray alloc] init];
            _numberOfDirectoryLoadings = 1;
            [_fileSource addDelegate:self];
            [_fileSource searchPath:@"/" forKeyword:_searchText];
        }
    }
}

#pragma mark WFileSourceDelegate

- (void) source:(id<WFileSourceProtocol>)source didReceiveContents:(NSArray *)contents ofDirectory:(NSString *)dirPath error:(NSError *)error
{
    NSMutableArray *content = [[NSMutableArray alloc] init];
    
    for (NSDictionary *file in contents) {
        if ([file fileType] == NSFileTypeDirectory) {
            _numberOfDirectoryLoadings++;
            [_fileSource loadAtPath:[dirPath stringByAppendingPathComponent:file[@"cxFilenameKey"]]];
        }
        if ([_searchPredicate evaluateWithObject:file]) {
            NSMutableDictionary *mutable = [file mutableCopy];
            mutable[@"cxFilepathKey"] = [dirPath stringByAppendingPathComponent:mutable[@"cxFilenameKey"]];
            
            [_results addObject:mutable];
            [content addObject:mutable];
        }
    }
    _numberOfDirectoryLoadings--;
    
    if ([content count]) {
        [_directories addObject:contents];
        [_delegate search:self didFoundFiles:content text:_searchText];
    }
    if (_numberOfDirectoryLoadings == 0) {
        [_delegate search:self didStopWithText:_searchText];
        [_fileSource removeDelegate:self];
    }
}

- (void) source:(id <WFileSourceProtocol>) source didReceiveSearchResults:(NSArray *)results keyword:(NSString *)keyword error:(NSError *)error
{
    if (error && [keyword isEqualToString:_searchText])
        return;
    _results = [results[0] mutableCopy];
    _directories = [[results[1] allValues] mutableCopy];
    
    if ([_results count]) {
        [_delegate search:self didFoundFiles:_results text:_searchText];
    }
    [_delegate search:self didStopWithText:_searchText];
    [_fileSource removeDelegate:self];
}

@end
