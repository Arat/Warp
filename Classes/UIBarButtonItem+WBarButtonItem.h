//
//  UIBarButtonItem+WBarButtonItem.h
//  Warp
//
//  Created by Lukáš Foldýna on 27/03/14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIBarButtonItem (WBarButtonItem)

+ (id) itemWithImage:(UIImage *)image target:(id)target action:(SEL)action;
+ (id) itemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

+ (id) itemWithImageName:(NSString *)name target:(id)target action:(SEL)action;
+ (id) itemWithImageName:(NSString *)name style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

+ (id) itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (id) itemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

+ (id) itemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action;
+ (id) itemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
+ (id) itemWithFlexibleSpaceStyle;
+ (id) itemWithFixedSpaceWidth:(CGFloat)width;

+ (id) itemWithCustomView:(UIView *)customView;

@end
