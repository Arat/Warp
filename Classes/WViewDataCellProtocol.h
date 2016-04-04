//
//  WViewDataCellProtocol.h
//  Warp
//
//  Created by Lukáš Foldýna on 10/04/14.
//  Copyright (c) 2014 Lukáš Foldýna. All rights reserved.
//

@import Foundation;
#import "WViewDataObjectProtocol.h"


@protocol WViewDataCellProtocol <NSObject>

- (void) setObject:(id<WViewDataObjectProtocol> _Nonnull)object;

@end
