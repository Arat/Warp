//
//  WarpX.h
//  WarpX
//
//  Created by Lukáš Foldýna on 05.08.14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

@import Cocoa;

//! Project version number for WarpX.
FOUNDATION_EXPORT double WarpXVersionNumber;

//! Project version string for WarpX.
FOUNDATION_EXPORT const unsigned char WarpXVersionString[];

#import "CocoaLumberjack.h"
#import "DDAbstractDatabaseLogger.h"
#import "DDASLLogCapture.h"
#import "DDLog+LOGV.h"

#import "WGlobal.h"
#import "NSDate+WAdditions.h"
#import "NSFileManager+WFileManager.h"
#import "NSNumber+WFileSize.h"
#import "NSString+WFileExtension.h"
#import "NSString+WCrypto.h"
#import "NSStringEncodingDetector.h"
#import "NSObject+WAdditions.h"
#import "WAppDelegate.h"
#import "NSUserDefaults+WGroupDefaults.h"
