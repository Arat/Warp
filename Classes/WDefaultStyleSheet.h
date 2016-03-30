//
//  WDefaultStyleSheet.h
//  Warp
//
//  Created by Lukas on 6.5.09.
//  Copyright 2009 TwoManShow. All rights reserved.
//


@interface WDefaultStyleSheet : NSObject

+ (WDefaultStyleSheet *) globalStyleSheet;
+ (void) setGlobalStyleSheet:(WDefaultStyleSheet *)styleSheet;

// Fonts
+ (UIFont *) systemFontOfSize:(CGFloat)fontSize;
- (UIFont *) systemFontOfSize:(CGFloat)fontSize;

+ (UIFont *) boldSystemFontOfSize:(CGFloat)fontSize;
- (UIFont *) boldSystemFontOfSize:(CGFloat)fontSize;

+ (UIFont *) italicSystemFontOfSize:(CGFloat)fontSize;
- (UIFont *) italicSystemFontOfSize:(CGFloat)fontSize;

// Controller
- (Class) controllerErrorViewClass;
- (UIColor *) rootContentBorderColor;

- (CGFloat) popoverMargin;
- (CGSize) popoverArrowSize;

// Activity view
- (UIFont *) activityLabelFont;
- (UIFont *) activityBannerFont;
- (UIColor *) activityTextColor;

// Error view
- (UIColor *) errorTitleColor;
- (UIColor *) errorSubtitleColor;

// Loading view
- (UIColor *) loadingTintColor;
- (UIColor *) loadingBackgroundColor;

@end


#define WSTYLESHEET ((id)[WDefaultStyleSheet globalStyleSheet])

#define WSTYLEVAR(_VARNAME) [WSTYLESHEET _VARNAME]

