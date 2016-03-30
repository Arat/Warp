//
//  WDefaultStyleSheet.m
//  Warp
//
//  Created by Lukas on 6.5.09.
//  Copyright 2009 TwoManShow. All rights reserved.
//

#import "WDefaultStyleSheet.h"
#import "WErrorView.h"


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

#pragma mark Fonts

+ (UIFont *) systemFontOfSize:(CGFloat)fontSize
{
    return [[WDefaultStyleSheet globalStyleSheet] systemFontOfSize:fontSize];
}

- (UIFont *) systemFontOfSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *) boldSystemFontOfSize:(CGFloat)fontSize
{
    return [[WDefaultStyleSheet globalStyleSheet] boldSystemFontOfSize:fontSize];
}

- (UIFont *) boldSystemFontOfSize:(CGFloat)fontSize
{
    return [UIFont boldSystemFontOfSize:fontSize];
}

+ (UIFont *) italicSystemFontOfSize:(CGFloat)fontSize
{
    return [[WDefaultStyleSheet globalStyleSheet] italicSystemFontOfSize:fontSize];
}

- (UIFont *) italicSystemFontOfSize:(CGFloat)fontSize
{
    return [UIFont italicSystemFontOfSize:fontSize];
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
    return [self systemFontOfSize:17];
}

- (UIFont *) activityBannerFont
{
    return [self boldSystemFontOfSize:11];
}

- (UIColor *) activityTextColor
{
    return RGBCOLOR(99, 109, 125);
}

#pragma mark WErrorView

- (UIColor *) errorTitleColor
{
    return [UIColor blackColor];
}

- (UIColor *) errorSubtitleColor
{
    return [UIColor darkGrayColor];
}

#pragma mark Loading View

- (UIColor *) loadingTintColor
{
    return [UIColor whiteColor];
}

- (UIColor *) loadingBackgroundColor
{
    return RGBACOLOR(0, 0, 0, 0.5);
}

@end
