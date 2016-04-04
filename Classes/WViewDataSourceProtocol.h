//
//  WViewDataSourceProtocol.h
//  Warp
//
//  Created by Lukáš Foldýna on 06/05/14.
//  Copyright (c) 2014 Lukáš Foldýna. All rights reserved.
//

@import Foundation;


@protocol WViewDataSourceProtocol <NSObject>

@property (nonatomic, strong, nullable) NSError *error;

@property (nonatomic, assign, readonly, getter = isLoading) BOOL loading;

@end
