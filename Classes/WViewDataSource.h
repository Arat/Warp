//
//  WViewDataSource.h
//  Warp
//
//  Created by Lukáš Foldýna on 29/04/14.
//  Copyright (c) 2014 Lukáš Foldýna. All rights reserved.
//

@import Foundation;
#import "WViewDataSourceProtocol.h"
#import "WViewDataObjectProtocol.h"
#import "WViewDataCellProtocol.h"


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

- (instancetype _Nonnull) initWithLabel:(NSString * _Nonnull)label;
@property (nonatomic, strong, readonly, nonnull) NSString *label; // used for state titles, default = default

// content data
@property (nonatomic, copy, nonnull) NSArray *content; // when it set it also refresh state and reloads table/collecion view
- (NSIndexPath * _Nullable) indexPathForObject:(id<WViewDataObjectProtocol> _Nonnull)object;
- (id _Nullable) objectForIndexPath:(NSIndexPath * _Nonnull)indexPath;
@property (nonatomic, assign, readonly) NSInteger contentCount;

// source observing
@property (nonatomic, strong, readonly, nullable) NSObject<WViewDataSourceProtocol> *source;
- (void) observerSourceForContentChanges:(NSObject<WViewDataSourceProtocol> * _Nonnull)source keyPath:(NSString * _Nonnull)keyPath;
- (void) removeSourceObserver;

// table/collection
@property (nonatomic, weak, nullable) UITableView *tableView; // set collection or table not both, set self as dataSource
@property (nonatomic, weak, nullable) UICollectionView *collectionView; // set collection or table not both, set self as dataSource

@property (nonatomic, strong, nonnull) NSString *cellIdentifier; // reuse cell identifier for cells, all cells must implement WViewDataCellProtocol
- (NSString * _Nonnull) cellIdentifierForIndexPath:(NSIndexPath * _Nonnull)indexPath; // override point for cellIdentifier, default returns just cellIdentifier

@property (nonatomic, strong, nullable) NSString *sectionIdentifier; // reuse section identifier for sections, all section views must implement WViewDataCellProtocol
@property (nonatomic, copy, nullable) NSArray<id<WViewDataObjectProtocol>> *sectionTitles;

- (void) deleteItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath; // delete item, it will call deleteItemCallback and mark it as removing in source, same call as in UIT datasource
@property (nonatomic, strong, readonly, nullable) NSArray *deletingItems; // items that are currently in delete queue

// state
@property (nonatomic, assign, readonly) WViewDataSourceState state;
- (void) updateState; // manualy update state of source
- (NSString * _Nonnull) stateTitle;

@property (nonatomic, assign, readonly, getter = isLoaded) BOOL loaded;
@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;
@property (nonatomic, assign, readonly, getter = isOutdated) BOOL outdated;
@property (nonatomic, copy, nullable) NSError *error; // only serious error, which prevents to display data, when it set it also refresh state

- (UIImage * _Nullable) imageForState; // label.state.image
- (NSString * _Nonnull) titleForState; // label.state.title
- (NSString * _Nonnull) subtitleForState; // label.state.subtitle or localized error description

// callbacks (optional)
@property (nonatomic, copy, nullable) void (^statusCallback)(WViewDataSourceState state); // called when status is changed

// callbacks for content updates, when it's not set it calls insertRowsAtIndexPaths:withRowAnimation:, ...
// called when it want insert cells to table/collection
@property (nonatomic, copy, nullable) void (^insertObjectsAtIndexPathsCallback)(NSArray<NSIndexPath *> * _Nonnull indexPaths);
// called when it want delete cells to table/collection
@property (nonatomic, copy, nullable) void (^deleteObjectsFromIndexPathsCallback)(NSArray<NSIndexPath *> * _Nonnull indexPaths);
// called when it want replace cells to table/collection
@property (nonatomic, copy, nullable) void (^replaceObjectsAtIndexPathsCallback)(NSArray<NSIndexPath *> *_Nonnull indexPaths);
// called when it want reload table/collection
@property (nonatomic, copy, nullable) void (^reloadObjectsCallback)();

// table editing
// called when user inserts row to table view
@property (nonatomic, copy, nullable) void (^insertItemCallback)(NSIndexPath *_Nonnull indexPath);
// called when user delete row from table view
@property (nonatomic, copy, nullable) void (^deleteItemCallback)(NSIndexPath *_Nonnull indexPath);

// called when it want to edit item in table view
@property (nonatomic, copy, nullable) BOOL (^canEditItemCallback)(NSIndexPath *_Nonnull indexPath);

// called after cell is created and object is set to finish init for table/collection view
@property (nonatomic, copy, nullable) void (^itemCellSetupCallback)(id<WViewDataCellProtocol> _Nonnull cellView, id<WViewDataObjectProtocol> _Nonnull object);

@end
