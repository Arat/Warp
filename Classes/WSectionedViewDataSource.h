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

- (void) observerSourceForContentChanges:(NSObject<WSectionedViewDataSourceDelegate> *)source keyPath:(NSString *)keyPath;
- (void) removeSourceObserver;

- (void) observerSourceForSectionTitlesChangesKeyPath:(NSString *)keyPath;
- (void) removeSourceObserverForSectionTitles;

- (void) source:(NSObject<WSectionedViewDataSourceDelegate> *)source didChangeSections:(NSArray *)sections titles:(NSArray *)titles atIndexes:(NSIndexSet *)indexSet forChangeType:(WSectionedViewDataSourceChangeType)changeType;
- (void) source:(NSObject<WSectionedViewDataSourceDelegate> *)source didChangeObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths forChangeType:(WSectionedViewDataSourceChangeType)changeType;

@end


@protocol WSectionedViewDataSourceDelegate <WViewDataSourceProtocol>

- (void) addObserver:(WSectionedViewDataSource *)observer keyPath:(NSString *)keyPath;
- (void) removeObserver:(WSectionedViewDataSource *)observer keyPath:(NSString *)keyPath;

@end
