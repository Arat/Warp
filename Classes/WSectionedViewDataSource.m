//
//  WSectionedViewDataSource.m
//  Warp
//
//  Created by Lukáš Foldýna on 26.08.14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

#import "WSectionedViewDataSource.h"
#import "WViewDataSourcePrivate.h"


@interface WSectionedViewDataSource ()
{
    NSObject<WSectionedViewDataSourceDelegate> *_sectionSource;
}

@property (nonatomic, strong) NSString *sourceSectionKeyPath;

@end

@implementation WSectionedViewDataSource

- (void) dealloc
{
    [self removeSourceObserverForSectionTitles];
    [self removeSourceObserver];
}

#pragma mark -

- (NSIndexPath *) indexPathForObject:(id)object
{
    for (NSArray *section in _content) {
        NSInteger index = [section indexOfObject:object];

        if (index != NSNotFound) {
            NSInteger sectionIndex = [_content indexOfObject:section];
            if (_collectionView)
                return [NSIndexPath indexPathForItem:index inSection:sectionIndex];
            else
                return [NSIndexPath indexPathForRow:index inSection:sectionIndex];
        }
    }
    return nil;
}

- (id) objectForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = NSNotFound;
    if (_collectionView)
        index = [indexPath item];
    else
        index = [indexPath row];
    
    if (indexPath.section >= _contentCount)
        return nil;
    else
        return _content[indexPath.section][index];
}

- (void) observerSourceForContentChanges:(NSObject<WSectionedViewDataSourceDelegate> *)source keyPath:(NSString *)keyPath
{
    NSAssert([NSThread isMainThread], @"Call only from main thread!");
    
    [self removeSourceObserver];
    
    if (!source) {
        return;
    }
    NSAssert(WIsStringWithAnyText(keyPath), @"Yout must specify keyPath for source");
    
    _sectionSource = source;
    [self setSourceKeyPath:keyPath];
    [source addObserver:self keyPath:keyPath];
}

- (void) removeSourceObserver
{
    if (!_sectionSource) {
        return;
    }
    [_sectionSource removeObserver:self keyPath:self.sourceKeyPath];
    if (!_sourceSectionKeyPath) {
        _sectionSource = nil;
    }
    [self setSourceKeyPath:nil];
}

- (void) observerSourceForSectionTitlesChangesKeyPath:(NSString *)keyPath
{
    NSAssert([NSThread isMainThread], @"Call only from main thread!");
    NSAssert(_sectionSource != nil, @"Set observerSourceForContentChanges:keyPath: first!");
    
    [self removeSourceObserverForSectionTitles];
    
    if (!_sectionSource) {
        return;
    }
    NSAssert(WIsStringWithAnyText(keyPath), @"Yout must specify keyPath for source");
    
    [self setSourceSectionKeyPath:keyPath];
    [_sectionSource addObserver:self keyPath:keyPath];
    [self source:_sectionSource didChangeSections:[_sectionSource valueForKey:self.sourceKeyPath] titles:[_sectionSource valueForKey:keyPath] atIndexes:nil forChangeType:WSectionedViewDataSourceChangeSetting];
}

- (void) removeSourceObserverForSectionTitles
{
    if (!_sourceSectionKeyPath) {
        return;
    }
    [_sectionSource removeObserver:self keyPath:self.sourceSectionKeyPath];
    [self setSourceSectionKeyPath:nil];
    
    if (!self.sourceKeyPath) {
        _sectionSource = nil;
    }
}

- (void) source:(NSObject<WSectionedViewDataSourceDelegate> *)source didChangeObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths forChangeType:(WSectionedViewDataSourceChangeType)changeType
{
    if (![NSThread isMainThread]) {
        //NSLog(@"%@ redirecting observer to main thread", self.label);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self source:source didChangeObjects:objects atIndexPaths:indexPaths forChangeType:changeType];
        });
    } else if (_sectionSource == source) {
        // update section
        _error = [_sectionSource.error copy];
        
        if ([self tableView]) {
            [self.tableView numberOfRowsInSection:0]; // fix for iOS8 table view crash bug
        }
        if ([self collectionView]) {
            [self.collectionView numberOfItemsInSection:0]; // fix for iOS8 table view crash bug
        }
        //NSLog(@"%@ %li type: %u, %@", self.label, (long)[_tableView numberOfRowsInSection:0], changeType, _tableView);
        //NSLog(@"%@ change %@", self.label, objects);
        
        switch (changeType) {
            case WSectionedViewDataSourceChangeInsert: {
                [self _insertObjects:objects atIndexPaths:indexPaths];
            } break;
            case WSectionedViewDataSourceChangeRemove: {
                [self _removeObjects:objects atIndexPaths:indexPaths];
            } break;
            case WSectionedViewDataSourceChangeReplacement: {
                [self _replaceObjects:objects atIndexPaths:indexPaths];
            } break;
            default: {
                [self _reploadDataWithObjects:objects titles:nil];
            } break;
        }
        [self updateState];
        
        //NSLog(@"---");
    } else {
        WLogError(@"Unkwnon source or context, %@", source);
    }
}

- (void) _insertObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths
{
    NSMutableArray *content = [_content mutableCopy];
    NSInteger i = 0;
    for (NSIndexPath *indexPath in indexPaths) {
        NSInteger sectionCount = [content[indexPath.section] count];
        if (![content[indexPath.section] respondsToSelector:@selector(addObject:)]) {
            [content replaceObjectAtIndex:indexPath.section withObject:[content[indexPath.section] mutableCopy]];
        }
        
        if (sectionCount <= indexPath.row) {
            [content[indexPath.section] addObject:objects[i]];
        } else {
            [content[indexPath.section] insertObject:objects[i] atIndex:(_collectionView ? indexPath.item : indexPath.row)];
        }
        i++;
    }
    
    _content = [[NSArray alloc] initWithArray:content copyItems:YES];
    _contentCount = [_content count];
    
    if ([self insertObjectsAtIndexPathsCallback]) {
        self.insertObjectsAtIndexPathsCallback(indexPaths);
    } else if ([self tableView]) {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.collectionView insertItemsAtIndexPaths:indexPaths];
    }
}

- (void) _removeObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths
{
    NSMutableArray *content = [_content mutableCopy];
    NSMutableArray *removedObjects = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths) {
        if (![content[indexPath.section] respondsToSelector:@selector(addObject:)]) {
            [content replaceObjectAtIndex:indexPath.section withObject:[content[indexPath.section] mutableCopy]];
        }
        NSObject *object = _content[indexPath.section][(_collectionView ? indexPath.item : indexPath.row)];
        [removedObjects addObject:object];
        [content[indexPath.section] removeObject:object];
    }
    
    _content = [[NSArray alloc] initWithArray:content copyItems:YES];
    _contentCount = [_content count];
    
    [_deletingItems removeObjectsInArray:removedObjects];
    
    if ([self deleteObjectsFromIndexPathsCallback]) {
        self.deleteObjectsFromIndexPathsCallback(indexPaths);
    } else if ([self tableView]) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
    }
}

- (void) _replaceObjects:(NSArray *)objects atIndexPaths:(NSArray *)indexPaths
{
    NSMutableArray *content = [_content mutableCopy];
    NSInteger i = 0;
    for (NSIndexPath *indexPath in indexPaths) {
        NSMutableArray *section = content[indexPath.section];
        if (![section respondsToSelector:@selector(addObject:)]) {
            [content replaceObjectAtIndex:indexPath.section withObject:[section mutableCopy]];
            section = content[indexPath.section];
        }
        NSInteger sectionCount = [section count];
        NSInteger index = (_collectionView ? indexPath.item : indexPath.row);
        if (sectionCount > index) {
            [section replaceObjectAtIndex:index withObject:objects[i]];
        } else {
            [section addObject:objects[i]];
        }
        i++;
    }
    _content = [[NSArray alloc] initWithArray:content copyItems:YES];
    _contentCount = [_content count];
    
    if ([self replaceObjectsAtIndexPathsCallback]) {
        self.replaceObjectsAtIndexPathsCallback(indexPaths);
    } else if ([self tableView]) {
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }
}

- (void) _reploadDataWithObjects:(NSArray *)objects titles:(NSArray *)titles
{
    // reload section data
    [_deletingItems removeAllObjects];
    
    if (titles) {
        _sectionTitles = titles;
    }
    _content = [[NSArray alloc] initWithArray:objects copyItems:YES];
    _contentCount = [_content count];
    
    if ([self reloadObjectsCallback]) {
        self.reloadObjectsCallback();
    } else if ([self tableView]) {
        [self.tableView reloadData];
    } else {
        [self.collectionView reloadData];
    }
    
    // reload
    [_deletingItems removeAllObjects];
}

- (void) source:(NSObject<WSectionedViewDataSourceDelegate> *)source didChangeSections:(NSArray *)sections titles:(NSArray *)titles atIndexes:(NSIndexSet *)indexSet forChangeType:(WSectionedViewDataSourceChangeType)changeType
{
    if (![NSThread isMainThread]) {
        //NSLog(@"%@ redirecting observer to main thread", self.label);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self source:source didChangeSections:sections titles:titles atIndexes:indexSet forChangeType:changeType];
        });
    } else if (source == (id)_sectionSource) {
        // update sections
        _error = [_sectionSource.error copy];
        
        if (_tableView) {
            [self.tableView numberOfRowsInSection:0]; // fix for iOS8 table view crash bug
        }
        //NSLog(@"%@ %li type: %li, %@", self.label, (long)[_tableView numberOfRowsInSection:0], changeType, _tableView);
        //NSLog(@"%@, object: %@", self.label, sections);
        
        switch (changeType) {
            case WSectionedViewDataSourceChangeInsert: {
                [self _insertSections:sections titles:titles indexSet:indexSet];
            } break;
            case WSectionedViewDataSourceChangeRemove: {
                [self _removeSections:sections titles:titles indexSet:indexSet];
            } break;
            case WSectionedViewDataSourceChangeReplacement: {
                [self _replaceSections:sections titles:titles indexSet:indexSet];
            } break;
            default: {
                [self _reploadDataWithObjects:sections titles:titles];
            } break;
        }
        [self updateState];
        
        //NSLog(@"---");
    } else {
        WLogError(@"Unkwnon source or context, %@", source);
    }
}

- (void) _insertSections:(NSArray *)sections titles:(NSArray *)titles indexSet:(NSIndexSet *)indexSet
{
    NSMutableArray *headers = [_sectionTitles mutableCopy];
    NSMutableArray *content = [_content mutableCopy];
    
    NSInteger i = 0, currentIndex = [indexSet firstIndex];
    while (currentIndex != NSNotFound) {
        if (_contentCount <= currentIndex) {
            [headers addObject:titles[i]];
            [content addObject:sections[currentIndex]];
        } else {
            [headers insertObject:titles[i] atIndex:currentIndex];
            [content insertObject:sections[currentIndex] atIndex:currentIndex];
        }
        currentIndex = [indexSet indexGreaterThanIndex:currentIndex];
        i++;
    }
    _sectionTitles = [headers copy];
    _content = [content copy];
    _contentCount = [content count];
    
    if ([self insertObjectsAtIndexPathsCallback]) {
        self.insertObjectsAtIndexPathsCallback(@[]); //TODO
    } else if ([self tableView]) {
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.collectionView insertSections:indexSet];
    }
}

- (void) _removeSections:(NSArray *)sections titles:(NSArray *)titles indexSet:(NSIndexSet *)indexSet
{
    NSMutableArray *headers = [_sectionTitles mutableCopy];
    NSMutableArray *content = [_content mutableCopy];
    
    NSInteger currentIndex = [indexSet firstIndex];
    while (currentIndex != NSNotFound) {
        [headers removeObjectAtIndex:currentIndex];
        [content removeObjectAtIndex:currentIndex];
        currentIndex = [indexSet indexGreaterThanIndex:currentIndex];
    }
    for (NSObject<WViewDataObjectProtocol> *object in [_deletingItems copy]) {
        NSIndexPath *indexPath = [self indexPathForObject:object];
        if ([indexSet containsIndex:indexPath.section]) {
            [_deletingItems removeObject:object];
        }
    }
    _sectionTitles = [headers copy];
    _content = [content copy];
    _contentCount = [content count];
    
    if ([self deleteObjectsFromIndexPathsCallback]) {
        self.deleteObjectsFromIndexPathsCallback(@[]); //TODO
    } else if ([self tableView]) {
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.collectionView deleteSections:indexSet];
    }
}

- (void) _replaceSections:(NSArray *)sections titles:(NSArray *)titles indexSet:(NSIndexSet *)indexSet
{
    NSMutableArray *headers = [_sectionTitles mutableCopy];
    NSMutableArray *content = [_content mutableCopy];
    
    NSInteger i = 0, currentIndex = [indexSet firstIndex];
    while (currentIndex != NSNotFound) {
        [headers replaceObjectAtIndex:currentIndex withObject:titles[i]];
        [content replaceObjectAtIndex:currentIndex withObject:sections[i]];
        currentIndex = [indexSet indexGreaterThanIndex:currentIndex];
        i++;
    }
    for (NSIndexPath<WViewDataObjectProtocol> *object in [_deletingItems copy]) {
        NSIndexPath *indexPath = [self indexPathForObject:object];
        if ([indexSet containsIndex:indexPath.section]) {
            [_deletingItems removeObject:object];
        }
    }
    _sectionTitles = [headers copy];
    _content = [content copy];
    _contentCount = [content count];
    
    if ([self deleteObjectsFromIndexPathsCallback]) {
        self.deleteObjectsFromIndexPathsCallback(@[]); //TODO
    } else if ([self tableView]) {
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.collectionView reloadSections:indexSet];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _contentCount;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.content[section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell<WViewDataCellProtocol> *cell = (id)[tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    NSObject<WViewDataObjectProtocol> *item = self.content[indexPath.section][indexPath.row];
    if (item) {
        [cell setObject:(id)item];
    }

    if (self.itemCellSetupCallback) {
        self.itemCellSetupCallback(cell, item);
    }
    return cell;
}

#pragma mark UICollectionViewDataSource

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _contentCount;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.content[section] count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell<WViewDataCellProtocol> *cell = (id)[collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    NSObject<WViewDataObjectProtocol> *item = self.content[indexPath.section][indexPath.item];
    [cell setObject:item];

    if (self.itemCellSetupCallback) {
        self.itemCellSetupCallback(cell, item);
    }
    return cell;
}

@end
