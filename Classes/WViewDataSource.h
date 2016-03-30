//
//  NFDTableViewDataSource.h
//  NoFlappyDownload
//
//  Created by Lukáš Foldýna on 29/04/14.
//  Copyright (c) 2014 Lukáš Foldýna. All rights reserved.
//

@import Foundation;
#import "WDataSourceProtocol.h"
#import "WSourceObjectProtocol.h"
#import "WCellViewObjectProtocol.h"


typedef NS_ENUM(NSUInteger, WViewDataSourceState) {
    WViewDataSourceStateLoading = 0,
    WViewDataSourceStateLoadingMore,
    WViewDataSourceStateLoaded,
    WViewDataSourceStateOutdated,
    WViewDataSourceStateEmpty,
    WViewDataSourceStateError
};


@interface WViewDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>
{
    NSInteger            _section;
}

- (instancetype) initWithLabel:(NSString *)label;
@property (nonatomic, strong, readonly) NSString *label; // used for state titles, default = default

// content data
@property (nonatomic, copy) NSArray *content; // when it set it also refresh state and reloads table/collecion view
- (NSIndexPath *) indexPathForObject:(id<WSourceObjectProtocol>)object;
- (id) objectForIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, assign, readonly) NSInteger contentCount;

// source observing
@property (nonatomic, strong, readonly) NSObject<WDataSourceProtocol> *source;
- (void) observerSourceForContentChanges:(NSObject<WDataSourceProtocol> *)source keyPath:(NSString *)keyPath;
- (void) removeSourceObserver;

// table/collection
@property (nonatomic, weak) UITableView *tableView; // set collection or table not both, set self as dataSource
@property (nonatomic, weak) UICollectionView *collectionView; // set collection or table not both, set self as dataSource

@property (nonatomic, strong) NSString *cellIdentifier; // reuse cell identifier for cells, all cells must implement WCellViewObjectProtocol
- (NSString *) cellIdentifierForIndexPath:(NSIndexPath *)indexPath; // override point for cellIdentifier, default returns just cellIdentifier

@property (nonatomic, strong) NSString *sectionIdentifier; // reuse section identifier for sections, all section views must implement WCellViewObjectProtocol
@property (nonatomic, copy) NSArray *sectionTitles;

- (void) deleteItemAtIndexPath:(NSIndexPath *)indexPath; // delete item, it will call deleteItemCallback and mark it as removing in source, same call as in UIT datasource
@property (nonatomic, strong, readonly) NSArray *deletingItems; // items that are currently in delete queue

// state
@property (nonatomic, assign, readonly) WViewDataSourceState state;
- (void) updateState; // manualy update state of source
- (NSString *) stateTitle;

@property (nonatomic, assign, readonly, getter = isLoaded) BOOL loaded;
@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, assign, readonly, getter = isOutdated) BOOL outdated;
@property (nonatomic, copy) NSError *error; // only serious error, which prevents to display data, when it set it also refresh state

- (UIImage *) imageForState; // label.state.image
- (NSString *) titleForState; // label.state.title
- (NSString *) subtitleForState; // label.state.subtitle or localized error description

// callbacks (optional)
@property (nonatomic, copy) void (^statusCallback)(WViewDataSourceState state); // called when status is changed

// callbacks for content updates, when it's not set it calls insertRowsAtIndexPaths:withRowAnimation:, ...
@property (nonatomic, copy) void (^insertObjectsAtIndexPathsCallback)(NSArray *indexPaths); // called when it want insert cells to table/collection
@property (nonatomic, copy) void (^deleteObjectsFromIndexPathsCallback)(NSArray *indexPaths); // called when it want delete cells to table/collection
@property (nonatomic, copy) void (^replaceObjectsAtIndexPathsCallback)(NSArray *indexPaths); // called when it want replace cells to table/collection
@property (nonatomic, copy) void (^reloadObjectsCallback)(); // called when it want reload table/collection

// table editing
@property (nonatomic, copy) void (^insertItemCallback)(NSIndexPath *indexPath); // called when user inserts row to table view
@property (nonatomic, copy) void (^deleteItemCallback)(NSIndexPath *indexPath); // called when user delete row from table view

@property (nonatomic, copy) BOOL (^canEditItemCallback)(NSIndexPath *indexPath); // called when it want to edit item in table view

// called after cell is created and object is set to finish init for table/collection view
@property (nonatomic, copy) void (^itemCellSetupCallback)(id<WCellViewObjectProtocol> cellView, id<WSourceObjectProtocol> object);

@end
