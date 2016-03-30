//
//  WViewDataSourcePrivate.h
//  Warp
//
//  Created by Lukáš Foldýna on 26.08.14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

#import "WViewDataSource.h"


static void *WTableViewDataSourceLoadingChangeContext = &WTableViewDataSourceLoadingChangeContext;
static void *WTableViewDataSourceContentChangeContext = &WTableViewDataSourceContentChangeContext;
static void *WTableViewDataSourceSectionChangeContext = &WTableViewDataSourceSectionChangeContext;


@interface WViewDataSource ()
{
    @protected
    NSArray                         *_content;
    NSInteger                       _contentCount;
    
    NSArray                         *_sectionTitles;
    
    NSObject<WDataSourceProtocol>   *_source;
    
    UICollectionView                __weak *_collectionView;
    UITableView                     __weak *_tableView;
    
    NSError                         *_error;
    
    NSMutableArray                  *_deletingItems;
}

@property (nonatomic, assign) WViewDataSourceState lastState;

@property (nonatomic, strong) NSString *sourceKeyPath;

@end