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
@property (nonatomic, readonly, strong) Class controllerErrorViewClass;
@property (nonatomic, readonly, copy) UIColor *rootContentBorderColor;

@property (nonatomic, readonly) CGFloat popoverMargin;
@property (nonatomic, readonly) CGSize popoverArrowSize;

// Activity view
@property (nonatomic, readonly, copy) UIFont *activityLabelFont;
@property (nonatomic, readonly, copy) UIFont *activityBannerFont;
@property (nonatomic, readonly, copy) UIColor *activityTextColor;

// Error view
@property (nonatomic, readonly, copy) UIColor *errorTitleColor;
@property (nonatomic, readonly, copy) UIColor *errorSubtitleColor;

// Loading view
@property (nonatomic, readonly, copy) UIColor *loadingTintColor;
@property (nonatomic, readonly, copy) UIColor *loadingBackgroundColor;

@end


#define WSTYLESHEET ((id)[WDefaultStyleSheet globalStyleSheet])

#define WSTYLEVAR(_VARNAME) [WSTYLESHEET _VARNAME]

