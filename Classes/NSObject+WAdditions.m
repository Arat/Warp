//
//  NSObject+WAdditions.m
//  Warp
//
//  Created by Lukáš Foldýna on 17.3.11.
//  Copyright 2011 TwoManShow. All rights reserved.
//

#import "NSObject+WAdditions.h"


@implementation NSObject (WAdditions)

- (NSInvocation *) invocationWithSelector:(SEL)selector
{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    return invocation;
}

- (NSInvocation *) invocationWithSelector:(SEL)selector withObject:(NSObject *)object
{
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [invocation setTarget:self];
    [invocation setSelector:selector];
    [invocation setArgument:&object atIndex:2];
    [invocation retainArguments];
    return invocation;
}

@end
