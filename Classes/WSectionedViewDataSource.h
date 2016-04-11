//
//  WSectionedViewDataSource.h
//  Warp
//
//  Created by Lukáš Foldýna on 26.08.14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

#import "WViewDataSource.h"


typedef NS_ENUM(NSUInteger, WSectionedViewDataSourceChangeType) {
    WSectionedViewDataSourceChangeSetting = 1,
    WSectionedViewDataSourceChangeInsert = 2,
    WSectionedViewDataSourceChangeRemove = 3,
    WSectionedViewDataSourceChangeReplacement = 4,
};


@protocol WSectionedViewDataSourceDelegate;

@interface WSectionedViewDataSource : WViewDataSource

- (void) observerSourceForContentChanges:(NSObject<WSectionedViewDataSourceDelegate> * _Nonnull)source keyPath:(NSString * _Nonnull)keyPath;
- (void) removeSourceObserver;

- (void) observerSourceForSectionTitlesChangesKeyPath:(NSString * _Nonnull)keyPath;
- (void) removeSourceObserverForSectionTitles;

- (void) source:(NSObject<WSectionedViewDataSourceDelegate> * _Nonnull)source didChangeSections:(NSArray * _Nonnull)sections titles:(NSArray * _Nonnull)titles atIndexes:(NSIndexSet * _Nullable)indexSet forChangeType:(WSectionedViewDataSourceChangeType)changeType;
- (void) source:(NSObject<WSectionedViewDataSourceDelegate> * _Nonnull)source didChangeObjects:(NSArray * _Nonnull)objects atIndexPaths:(NSArray * _Nonnull)indexPaths forChangeType:(WSectionedViewDataSourceChangeType)changeType;

@end


@protocol WSectionedViewDataSourceDelegate <WViewDataSourceProtocol>

- (void) addObserver:(WSectionedViewDataSource * _Nonnull)observer keyPath:(NSString * _Nonnull)keyPath;
- (void) removeObserver:(WSectionedViewDataSource *_Nonnull )observer keyPath:(NSString * _Nonnull)keyPath;

@end
