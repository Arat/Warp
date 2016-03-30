//
//  NFDTableViewObjectProtocol.h
//  NoFlappyDownload
//
//  Created by Lukáš Foldýna on 10/04/14.
//  Copyright (c) 2014 Lukáš Foldýna. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol WCellViewObjectProtocol <NSObject>

- (void) setObject:(id)object;

@optional

@property (nonatomic, assign) BOOL removing;

@end
