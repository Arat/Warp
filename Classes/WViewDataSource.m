//
//  NFDTableViewDataSource.m
//  NoFlappyDownload
//
//  Created by Lukáš Foldýna on 29/04/14.
//  Copyright (c) 2014 Lukáš Foldýna. All rights reserved.
//

#import "WViewDataSource.h"
#import "WViewDataSourcePrivate.h"
#import "WGlobal.h"

@implementation WViewDataSource

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        _label = @"default";
        _lastState = WViewDataSourceStateLoading;

        _contentCount = 0;
        _section = 0;
        
        _deletingItems = [NSMutableArray array];
    }
    return self;
}

- (instancetype) initWithLabel:(NSString *)label
{
    self = [self init];
    
    if (self) {
        _label = label;
    }
    return self;
}

- (void) dealloc
{
    [self removeSourceObserver];
}

#pragma mark -

- (void) setSectionTitles:(NSArray *)sectionTitles
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setSectionTitles:sectionTitles];
        });
        return;
    }
    _sectionTitles = [sectionTitles copy];
    
    if ([self reloadObjectsCallback]) {
        self.reloadObjectsCallback();
    } else if ([self tableView] && _content) {
        [self.tableView reloadData];
    } else if (_content) {
        [self.collectionView reloadData];
    }
    [self updateState];
}

- (void) setTableView:(UITableView *)tableView
{
    if ([_tableView dataSource] == self) {
        [_tableView setDataSource:nil];
    }
    _tableView = tableView;
    [_tableView setDataSource:self];
}

- (void) setCollectionView:(UICollectionView *)collectionView
{
    if ([_collectionView dataSource] == self) {
        [_collectionView setDataSource:nil];
    }
    _collectionView = collectionView;
    [_collectionView setDataSource:self];
}

- (void) setContent:(NSArray *)content
{
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setContent:content];
        });
        return;
    }
    _content = [content copy];
    _contentCount = [_content count];
    
    if ([self reloadObjectsCallback]) {
        self.reloadObjectsCallback();
    } else if ([self tableView]) {
        [self.tableView reloadData];
    } else {
        [self.collectionView reloadData];
    }
    [self updateState];
}

- (NSArray *) deletingItems
{
    return [_deletingItems copy];
}

- (NSIndexPath *) indexPathForObject:(id)object
{
    NSInteger index = [_content indexOfObject:object];
    if (index == NSNotFound)
        return nil;
    else if (_collectionView)
        return [NSIndexPath indexPathForItem:index inSection:_section];
    else
        return [NSIndexPath indexPathForRow:index inSection:_section];
}

- (id) objectForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = NSNotFound;
    if (_collectionView)
        index = [indexPath item];
    else
        index = [indexPath row];
    
    if (index >= _contentCount)
        return nil;
    else
        return _content[index];
}

- (void) observerSourceForContentChanges:(NSObject<WDataSourceProtocol> *)source keyPath:(NSString *)keyPath
{
    NSAssert([NSThread isMainThread], @"Call only from main thread!");
    
    [self removeSourceObserver];
    
    if (!source) {
        return;
    }
    NSAssert(WIsStringWithAnyText(keyPath), @"Yout must specify keyPath for source");
    
    _source = source;
    [self setSourceKeyPath:keyPath];
    [source addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:&WTableViewDataSourceContentChangeContext];
}

- (void) removeSourceObserver
{
    if (!_source) {
        return;
    }
    [_source removeObserver:self forKeyPath:self.sourceKeyPath context:&WTableViewDataSourceContentChangeContext];
    _source = nil;
    
    [self setSourceKeyPath:nil];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![NSThread isMainThread]) {
        //NSLog(@"%@ redirecting observer to main thread", self.label);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        });
    } else if (context == WTableViewDataSourceContentChangeContext && object == _source) {
        _error = [_source.error copy];
        
        NSKeyValueChange valueChange = [change[NSKeyValueChangeKindKey] intValue];
        NSIndexSet *indexSet = change[NSKeyValueChangeIndexesKey];
        NSMutableArray *indexPaths = [NSMutableArray array];
        [indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:index inSection:_section]];
        }];
        
        if ([self tableView]) {
            [self.tableView numberOfRowsInSection:0]; // fix for iOS8 table view crash bug
        }
        if ([self collectionView]) {
            [self.collectionView numberOfItemsInSection:0]; // fix for iOS8 table view crash bug
        }
        //NSLog(@"%@ %li, %@", self.label, (long)[_tableView numberOfRowsInSection:0], _tableView);
        //NSLog(@"%@ change %@", self.label, change);
        
        switch (valueChange) {
            case NSKeyValueChangeInsertion: {
                [self _insertObjects:change[NSKeyValueChangeNewKey] indexPaths:indexPaths];
            } break;
            case NSKeyValueChangeRemoval: {
                [self _removeObjects:change[NSKeyValueChangeOldKey] indexPaths:indexPaths];
            } break;
            case NSKeyValueChangeReplacement: {
                [self _replaceObjects:change[NSKeyValueChangeOldKey] newObjects:change[NSKeyValueChangeNewKey] indexPaths:indexPaths];
            } break;
            default: {
                [self _reloadDataWithObjects:[object valueForKeyPath:keyPath]];
            } break;
        }
        [self updateState];
        
        //NSLog(@"---");
    } else {
        WLogError(@"Unkwnon source or context, %@", object);
    }
}

- (void) _insertObjects:(NSArray *)objects indexPaths:(NSArray *)indexPaths
{
    NSMutableArray *content = [_content mutableCopy];
    NSInteger i = 0;
    for (NSIndexPath *indexPath in indexPaths) {
        NSInteger index = (_collectionView ? indexPath.item : indexPath.row);
        if (_contentCount <= index) {
            [content addObject:objects[i]];
        } else {
            [content insertObject:objects[i] atIndex:index];
        }
        i++;
    }
    
    _content = [content copy];
    _contentCount = [_content count];
    
    if ([self insertObjectsAtIndexPathsCallback]) {
        self.insertObjectsAtIndexPathsCallback(indexPaths);
    } else if ([self tableView]) {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
    }
}

- (void) _removeObjects:(NSArray *)objects indexPaths:(NSArray *)indexPaths
{
    NSMutableArray *content = [_content mutableCopy];
    [content removeObjectsInArray:objects];
    
    _content = [content copy];
    _contentCount = [_content count];
    
    [_deletingItems removeObjectsInArray:objects];
    
    if ([self deleteObjectsFromIndexPathsCallback]) {
        self.deleteObjectsFromIndexPathsCallback(indexPaths);
    } else if ([self tableView]) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    }
}

- (void) _replaceObjects:(NSArray *)oldObjects newObjects:(NSArray *)newObjects indexPaths:(NSArray *)indexPaths
{
    NSMutableArray *content = [_content mutableCopy];
    NSArray *new = newObjects;
    NSArray *old = oldObjects;
    NSInteger i = 0;
    for (NSIndexPath *indexPath in indexPaths) {
        if ([_deletingItems indexOfObject:old[i]] != NSNotFound) {
            [_deletingItems replaceObjectAtIndex:[_deletingItems indexOfObject:old[i]] withObject:new[i]];
        }
        NSInteger index = (_collectionView ? indexPath.item : indexPath.row);
        [content replaceObjectAtIndex:index withObject:new[i]];
        i++;
    }
    _content = [content copy];
    _contentCount = [_content count];
    
    if ([self replaceObjectsAtIndexPathsCallback]) {
        self.replaceObjectsAtIndexPathsCallback(indexPaths);
    } else if ([self tableView]) {
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }
}

- (void) _reloadDataWithObjects:(NSArray *)objects
{
    // reload
    [_deletingItems removeAllObjects];
    
    _content = [objects copy];
    _contentCount = [_content count];
    
    if ([self reloadObjectsCallback]) {
        self.reloadObjectsCallback();
    } else if ([self tableView]) {
        [self.tableView reloadData];
    } else {
        [self.collectionView reloadData];
    }
}

#pragma mark States

- (BOOL) isLoaded
{
    return _content != nil;
}

- (BOOL) isLoading
{
    return _content == nil;
}

- (BOOL) isOutdated
{
    return NO;
}

- (WViewDataSourceState) state
{
    if ([self error]) {
        return WViewDataSourceStateError;
    } else if ([self isLoading] && [self isLoaded]) {
        return WViewDataSourceStateLoadingMore;
    } else if ([self isLoading]) {
        return WViewDataSourceStateLoading;
    } else if ([self isOutdated]) {
        return WViewDataSourceStateOutdated;
    } else if ([self isLoaded] && [self.content count] == 0) {
        return WViewDataSourceStateEmpty;
    } else {
        return WViewDataSourceStateLoaded;
    }
}

- (void) updateState
{
    WViewDataSourceState state = [self state];
    if (state != _lastState && _statusCallback) {
        WLogInfo(@"View data source: '%@' change state: %@", _label, [self stateTitleForState:state]);
        
        if ([NSThread isMainThread]) {
            _statusCallback(state);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _statusCallback(state);
            });
        }
    }
    _lastState = state;
}

- (NSString *) stateTitle
{
    return [self stateTitleForState:_lastState];
}

- (NSString *) stateTitleForState:(WViewDataSourceState)state
{
    switch ([self state]) {
        case WViewDataSourceStateLoading:
            return @"loading";
        case WViewDataSourceStateLoadingMore:
            return @"loadingMore";
        case WViewDataSourceStateLoaded:
            return @"loaded";
        case WViewDataSourceStateEmpty:
            return @"empty";
        case WViewDataSourceStateOutdated:
            return @"outdated";
        case WViewDataSourceStateError:
            return @"error";
    }
    return @"unknown";
}

- (void) setError:(NSError *)error
{
    _error = error;
    [self updateState];
}

- (UIImage *) imageForState
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.%@.image", _label, [self stateTitle]]];
}

- (NSString *) titleForState
{
    NSString *title = [NSString stringWithFormat:@"%@.%@.title", _label, [self stateTitle]];
    return NSLocalizedString(title, nil);
}

- (NSString *) subtitleForState
{
    if ([self state] == WViewDataSourceStateError) {
        return [self.error localizedDescription];
    } else {
        NSString *subtitle = [NSString stringWithFormat:@"%@.%@.subtitle", _label, [self stateTitle]];
        return NSLocalizedString(subtitle, nil);
    }
}

#pragma mark Callbacks

- (void) setStatusCallback:(void (^)(WViewDataSourceState))statusCallback
{
    _statusCallback = statusCallback;
    
    if (statusCallback) {
        WViewDataSourceState state = [self state];
        WLogInfo(@"View data source: '%@' state: %@", _label, [self stateTitleForState:state]);
        
        if ([NSThread isMainThread]) {
            statusCallback(state);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                statusCallback(state);
            });
        }
    }
}

#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _section + 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentCount;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionTitles[section];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell<WCellViewObjectProtocol> *cell = (id)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    NSObject *item = self.content[indexPath.row];
    [cell setObject:item];
    if ([cell respondsToSelector:@selector(removing)]) {
        [cell setRemoving:[self.deletingItems indexOfObject:item] != NSNotFound];
    }
    if (self.itemCellSetupCallback) {
        self.itemCellSetupCallback(cell, item);
    }
    [cell setEditing:tableView.isEditing];
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (editingStyle) {
        case UITableViewCellEditingStyleInsert: {
            if (self.insertItemCallback) {
                self.insertItemCallback(indexPath);
            }
        } break;
        case UITableViewCellEditingStyleDelete: {
            NSObject *object = [self objectForIndexPath:indexPath];
            if ([_deletingItems indexOfObject:object] != NSNotFound || object == nil) {
                return;
            }
            [_deletingItems addObject:object];
            
            if (self.deleteItemCallback) {
                self.deleteItemCallback(indexPath);
            }
        } break;
        case UITableViewCellEditingStyleNone: {
        } break;
    }
}

#pragma mark UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _section + 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _contentCount;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell<WCellViewObjectProtocol> *cell = (id)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    NSObject *item = self.content[indexPath.item];
    [cell setObject:item];
    if ([cell respondsToSelector:@selector(removing)]) {
        [cell setRemoving:[self.deletingItems indexOfObject:item] != NSNotFound];
    }
    if (self.itemCellSetupCallback) {
        self.itemCellSetupCallback(cell, item);
    }
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([self sectionIdentifier] == nil) {
        return nil;
    }
    UICollectionReusableView<WCellViewObjectProtocol> *sectionView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:self.sectionIdentifier forIndexPath:indexPath];
    NSArray *sectionTitles = [self sectionTitles];
    if ([sectionTitles count] > [indexPath section]) {
        [sectionView setObject:self.sectionTitles[indexPath.section]];
    }
    return sectionView;
}

@end
