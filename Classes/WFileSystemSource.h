//
//  FilesModel.h
//  Warp
//
//  Created by Lukas on 12.3.08.
//  Copyright 2008 TwoManShow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WFileSource.h"


/*
 * Implementace WFileSourceProtocol, pro lokalni file system, pres ConnectionKit
 */
@interface WFileSystemSource : WFileSource

/*
 * Vrati sdilenou instanci, neni singleton
 */
+ (WFileSystemSource *) sharedFiles;

@end
