/*
 *  WGlobal.m
 *  Warp
 *
 *  Created by Lukas on 28.7.09.
 *  Copyright 2009 TwoManShow. All rights reserved.
 *
 */

#import "WGlobal.h"
#import <pthread.h>


static BOOL WISIOS4         = NO;
static BOOL WISIOS5         = NO;
static BOOL WISIOS6         = NO;
static BOOL WISIOS7         = NO;
static BOOL WISIOS8         = NO;
static BOOL WISIOS9         = NO;
static BOOL WISIPad         = NO;
static BOOL WISIPhone       = NO;
static BOOL WISIPhoneLong   = NO;

static BOOL WISX07       = NO;
static BOOL WISX08       = NO;
static BOOL WISX09       = NO;
static BOOL WISX10       = NO;

#if TARGET_OS_IPHONE

static int              gNetworkTaskCount = 0;
static pthread_mutex_t  gMutex = PTHREAD_MUTEX_INITIALIZER;


extern void WNetworkRequestStarted()
{
    pthread_mutex_lock(&gMutex);
    
    if (0 == gNetworkTaskCount) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
    gNetworkTaskCount++;
    
    pthread_mutex_unlock(&gMutex);
}


extern void WNetworkRequestStopped()
{
    pthread_mutex_lock(&gMutex);
    
    --gNetworkTaskCount;
    gNetworkTaskCount = MAX(0, gNetworkTaskCount);
    
    if (gNetworkTaskCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    pthread_mutex_unlock(&gMutex);
}


extern NSString *WNSStringFromNSIndexPath(NSIndexPath *indexPath)
{
	return [NSString stringWithFormat: @"%lu:%lu", (unsigned long)indexPath.section, (unsigned long)indexPath.row];
}

extern NSIndexPath *WNSIndexPathFromNSString(NSString *string)
{
	NSArray *x = [string componentsSeparatedByString:@":"];
	
	if ([x count] != 2) {
		return nil;
	}
	return [NSIndexPath indexPathForRow:[x[1] intValue] inSection:[x[0] intValue]];
}

#endif


extern void WInit(void)
{
    #if TARGET_OS_IPHONE
    WISIOS4 = [[[UIDevice currentDevice] systemVersion] hasPrefix:@"4."];
    WISIOS5 = ![[[UIDevice currentDevice] systemVersion] hasPrefix:@"4."];
    WISIOS6 = WISIOS5 && ![[[UIDevice currentDevice] systemVersion] hasPrefix:@"5."];
    WISIOS7 = WISIOS5 && WISIOS6 && ![[[UIDevice currentDevice] systemVersion] hasPrefix:@"6."];
    WISIOS8 = WISIOS5 && WISIOS6 && WISIOS7 && ![[[UIDevice currentDevice] systemVersion] hasPrefix:@"7."];
    WISIOS9 = WISIOS5 && WISIOS6 && WISIOS7 && WISIOS8 && ![[[UIDevice currentDevice] systemVersion] hasPrefix:@"8."];
    WISIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
    WISIPhone =[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;
    WISIPhoneLong = WISIPhone && [UIScreen mainScreen].bounds.size.height > 500.0;
    #endif
    #if !TARGET_OS_IPHONE && TARGET_OS_MAC
    WISX07 = YES;
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
        WISX08 = YES;
        NSOperatingSystemVersion version = {9, 9, 0};
        if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version]) {
            WISX09 = YES;
            version.minorVersion = 10;
            version.majorVersion = 10;
            version.patchVersion = 0;
            if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version]) {
                WISX10 = YES;
            }
        }
    }
    #endif
}

extern void WInitForPhone(void)
{
    WInit();
    WISIPad = NO;
    WISIPhone = YES;
}

extern void WInitForPad(void)
{
    WInit();
    WISIPad = YES;
    WISIPhone = NO;
}

extern BOOL WISOS4(void)
{
    return WISIOS4;
}

extern BOOL WISOS5(void)
{
    return WISIOS5;
}

extern BOOL WISOS6(void)
{
    return WISIOS6;
}

extern BOOL WISOS7(void)
{
    return WISIOS7;
}

extern BOOL WISOS8(void)
{
    return WISIOS8;
}

extern BOOL WISOS9(void)
{
    return WISIOS9;
}

extern BOOL WISPad(void)
{
    return WISIPad;
}

extern BOOL WISPhone(void)
{
    return WISIPhone;
}

extern BOOL WISPhoneLong(void)
{
    return WISIPhoneLong;
}

extern BOOL WISOSX07(void)
{
    return WISX07;
}

extern BOOL WISOSX08(void)
{
    return WISX08;
}

extern BOOL WISOSX09(void)
{
    return WISX09;
}

extern BOOL WISOSX10(void)
{
    return WISX10;
}

BOOL WIsStringWithAnyText(id object)
{
    return [object isKindOfClass:[NSString class]] && [(NSString *)object length] > 0;
}
