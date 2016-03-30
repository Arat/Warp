/*
 *  WGlobal.h
 *  Warp
 *
 *  Created by Lukas on 28.7.09.
 *  Copyright 2009 TwoManShow. All rights reserved.
 *
 */

@import Foundation;


#if LUMBERMODULE
#define DD_LEGACY_MACROS 0
@import CocoaLumberjack;
#else
#import <CocoaLumberjack/CocoaLumberjack.h>
#endif


int static warpLogLevel = DDLogLevelError;

#define WARP_LOG_CONTEXT 44

#define WLogError(frmt, ...)    LOG_MAYBE(NO, warpLogLevel, DDLogFlagError,   WARP_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define WLogWarn(frmt, ...)     LOG_MAYBE(LOG_ASYNC_ENABLED, warpLogLevel, DDLogFlagWarning, WARP_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define WLogInfo(frmt, ...)     LOG_MAYBE(LOG_ASYNC_ENABLED, warpLogLevel, DDLogFlagInfo,    WARP_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define WLogVerbose(frmt, ...)  LOG_MAYBE(LOG_ASYNC_ENABLED, warpLogLevel, DDLogFlagVerbose, WARP_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define WLOG(__STRING, ARGS...) NSLog(__STRING, ##ARGS);
#define WLOGFLOAT(__FLOAT) { NSLog(@"%.4f", __FLOAT); }
#define WLOGPOINT(__POINT) { NSLog(@"%@", NSStringFromCGPoint(__POINT)); }
#define WLOGSIZE(__SIZE) { NSLog(@"%@", NSStringFromCGSize(__SIZE)); }
#define WLOGRECT(__RECT) { NSLog(@"%@", NSStringFromCGRect(__RECT)); }
#define WLOGRANGE(__RANGE) { NSLog(@"%@", NSStringFromRange(__RANGE)); }
#define WLOGOBJECT(__OBJECT) { NSLog(@"%@", __OBJECT); }

#define WLOGSEPARATOR() { printf("-------------------------------------------------------------------------------------\n"); }


#if TARGET_OS_IPHONE
@import UIKit;


extern void WNetworkRequestStarted(void);
extern void WNetworkRequestStopped(void);


extern NSString *WNSStringFromNSIndexPath(NSIndexPath *indexPath);
extern NSIndexPath *WNSIndexPathFromNSString(NSString *string);


#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#endif
#ifndef RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#endif

#else

#ifndef RGBCOLOR
#define RGBCOLOR(r,g,b) [NSColor colorWithDeviceRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#endif
#ifndef RGBACOLOR
#define RGBACOLOR(r,g,b,a) [NSColor colorWithDeviceRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#endif

#endif


extern void WInit(void);
extern void WInitForPhone(void);
extern void WInitForPad(void);

extern BOOL WISOS4(void);
extern BOOL WISOS5(void);
extern BOOL WISOS6(void);
extern BOOL WISOS7(void);
extern BOOL WISOS8(void);
extern BOOL WISOS9(void);
extern BOOL WISPad(void);
extern BOOL WISPhone(void);
extern BOOL WISPhoneLong(void);

extern BOOL WISOSX07(void);
extern BOOL WISOSX08(void);
extern BOOL WISOSX09(void);
extern BOOL WISOSX10(void);

extern BOOL WIsStringWithAnyText(id object);

#if TARGET_OS_IPHONE

typedef enum {
    WInterfaceOrientationMaskPortrait = (1 << UIInterfaceOrientationPortrait),
    WInterfaceOrientationMaskLandscapeLeft = (1 << UIInterfaceOrientationLandscapeLeft),
    WInterfaceOrientationMaskLandscapeRight = (1 << UIInterfaceOrientationLandscapeRight),
    WInterfaceOrientationMaskPortraitUpsideDown = (1 << UIInterfaceOrientationPortraitUpsideDown),
    WInterfaceOrientationMaskLandscape = (WInterfaceOrientationMaskLandscapeLeft | WInterfaceOrientationMaskLandscapeRight),
    WInterfaceOrientationMaskAll = (WInterfaceOrientationMaskPortrait | WInterfaceOrientationMaskLandscapeLeft | WInterfaceOrientationMaskLandscapeRight | WInterfaceOrientationMaskPortraitUpsideDown),
    WInterfaceOrientationMaskAllButUpsideDown = (WInterfaceOrientationMaskPortrait | WInterfaceOrientationMaskLandscapeLeft | WInterfaceOrientationMaskLandscapeRight),
} WInterfaceOrientationMask;

#endif
