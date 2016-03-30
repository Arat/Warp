//
//  WDefaultStyleSheet.m
//  Warp
//
//  Created by Lukas on 6.5.09.
//  Copyright 2009 TwoManShow. All rights reserved.
//

#import "WDefaultStyleSheet.h"


static WDefaultStyleSheet *WDefaultStyleSheetInstance = nil;


@implementation WDefaultStyleSheet

+ (WDefaultStyleSheet *) globalStyleSheet
{
    if (WDefaultStyleSheetInstance == nil) {
        WDefaultStyleSheetInstance = [[WDefaultStyleSheet alloc] init];
    }
    return WDefaultStyleSheetInstance;
}

+ (void) setGlobalStyleSheet:(WDefaultStyleSheet *)styleSheet
{
    WDefaultStyleSheetInstance = styleSheet;
}

#pragma mark Controller

- (Class) controllerErrorViewClass
{
    return [WErrorView class];
}

- (UIColor *) rootContentBorderColor
{
    return [UIColor clearColor];
}

#pragma mark WMenuView

- (UIColor *) menuBackgroudColor
{
	return RGBCOLOR(29, 29, 29);
}

- (UIColor *) menuSeparatorColor
{
	return RGBCOLOR(108, 108, 108);
}

- (UIColor *) menuTextColor
{
	return RGBCOLOR(177, 177, 177);
}

- (UIColor *) menuSelectedTextColor
{
	return RGBCOLOR(255.0, 214.0, 0.0);
}

- (UIColor *) menuInnerShadowColor
{
	return RGBCOLOR(36, 39, 39);
}

#pragma mark -
#pragma mark WPopoverView

- (CGFloat) popoverMargin
{
	return 10.0;
}

- (CGSize) popoverArrowSize
{
	return CGSizeZero;
}

#pragma mark WActivityView

- (UIFont *) activityLabelFont
{
    return [UIFont systemFontOfSize:17];
}

- (UIFont *) activityBannerFont
{
    return [UIFont boldSystemFontOfSize:11];
}

- (UIColor *) activityTextColor
{
    return RGBCOLOR(99, 109, 125);
}

@end
