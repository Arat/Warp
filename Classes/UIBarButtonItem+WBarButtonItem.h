//
//  UIBarButtonItem+WBarButtonItem.h
//  Warp
//
//  Created by Lukáš Foldýna on 27/03/14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIBarButtonItem (WBarButtonItem)

+ (instancetype) itemWithImage:(UIImage *)image target:(id)target action:(SEL)action;
+ (instancetype) itemWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

+ (instancetype) itemWithImageName:(NSString *)name target:(id)target action:(SEL)action;
+ (instancetype) itemWithImageName:(NSString *)name style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

+ (instancetype) itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype) itemWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

+ (instancetype) itemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action;
+ (instancetype) itemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
+ (instancetype) itemWithFlexibleSpaceStyle;
+ (instancetype) itemWithFixedSpaceWidth:(CGFloat)width;

+ (instancetype) itemWithCustomView:(UIView *)customView;

@end
