//
//  WFileSearch.h
//  Warp
//
//  Created by Lukáš Foldýna on 20.09.12.
//  Copyright (c) 2012 TwoManShow. All rights reserved.
//

@import Foundation;
#import "WFileSourceProtocol.h"


@protocol WFileSearchDelegate;

@interface WFileSearch : NSObject

- (instancetype) initWithFileSource:(id<WFileSourceProtocol>)fileSource NS_DESIGNATED_INITIALIZER;
@property (nonatomic, strong) id<WFileSourceProtocol> fileSource;

@property (nonatomic, weak) id<WFileSearchDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isSarching;
- (void) searchWithText:(NSString *)text;

@end


@protocol WFileSearchDelegate <NSObject>

- (void) search:(WFileSearch *)search didFoundFiles:(NSArray *)files text:(NSString *)text;
- (void) search:(WFileSearch *)search didStopWithText:(NSString *)text;

@end
