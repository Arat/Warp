//
//  UIBarButtonItem+WBarButtonItem.m
//  Warp
//
//  Created by Lukáš Foldýna on 27/03/14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

#import "UIBarButtonItem+WBarButtonItem.h"


@implementation UIBarButtonItem (WBarButtonItem)

+ (instancetype) itemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    return [UIBarButtonItem itemWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
}

+ (instancetype) itemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
}

+ (instancetype) itemWithImageName:(NSString *)name target:(id)target action:(SEL)action
{
    return [UIBarButtonItem itemWithImageName:name style:UIBarButtonItemStylePlain target:target action:action];
}

+ (instancetype) itemWithImageName:(NSString *)name style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    if (style == UIBarButtonItemStylePlain) {
        return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:name] style:style target:target action:action];
    } else {
        return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:name] style:UIBarButtonItemStylePlain target:target action:action];
    }
}

+ (instancetype) itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

+ (instancetype) itemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    if (style == UIBarButtonItemStylePlain) {
        return [[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action];
    } else {
        return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    }
}

+ (instancetype) itemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:target action:action];
    [item setStyle:UIBarButtonItemStylePlain];
    return item;
}

+ (instancetype) itemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:target action:action];
    [item setStyle:style];
    return item;
}

+ (instancetype) itemWithFlexibleSpaceStyle
{
    return [UIBarButtonItem itemWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

+ (instancetype) itemWithFixedSpaceWidth:(CGFloat)width
{
    UIBarButtonItem *item = [UIBarButtonItem itemWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [item setWidth:width];
    return item;
}

+ (instancetype) itemWithCustomView:(UIView *)customView
{
    return [[UIBarButtonItem alloc] initWithCustomView:customView];
}

@end
