//
//  NSObject+WAdditions.h
//  Warp
//
//  Created by Lukáš Foldýna on 17.3.11.
//  Copyright 2011 TwoManShow. All rights reserved.
//

@import Foundation;


@interface NSObject (WAdditions)

- (NSInvocation *) invocationWithSelector:(SEL)selector;
- (NSInvocation *) invocationWithSelector:(SEL)selector withObject:(NSObject *)object;

@end
