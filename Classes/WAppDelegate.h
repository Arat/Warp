//
//  WAppDelegate.h
//  Warp
//
//  Created by Lukáš Foldýna on 8.8.10.
//  Copyright 2010 TwoManShow. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#else
#import <AppKit/AppKit.h>
#endif


#if TARGET_OS_IPHONE
@interface WAppDelegate : UIResponder <UIApplicationDelegate>
#else
@interface WAppDelegate : NSObject <NSApplicationDelegate>
#endif

+ (instancetype) sharedAppDelegate;

+ (BOOL) isApplicationExtension;
+ (BOOL) isApplicationRunningFromTestflight;
+ (NSString *) applicationID;
+ (NSString *) applicationName;
+ (NSString *) applicationVersion;

@property (nonatomic, weak, readonly) NSString *applicationDocumentsDirectory;
@property (nonatomic, weak, readonly) NSString *applicationLibraryDirectory;
@property (nonatomic, weak, readonly) NSString *applicationCacheDirectory;
@property (nonatomic, weak, readonly) NSString *applicationTemporaryDirectory;
+ (NSString *) applicationDocumentsDirectory;
+ (NSString *) applicationLibraryDirectory;
+ (NSString *) applicationCacheDirectory;
+ (NSString *) applicationTemporaryDirectory;

@property (nonatomic, strong) NSString *applicationGroupIdentifier;
@property (nonatomic, weak, readonly) NSString *applicationGroupDirectory;
@property (nonatomic, weak, readonly) NSString *applicationGroupDocumentsDirectory;
+ (NSString *) applicationGroupIdentifier;
+ (void) setApplicationGroupIdentifier:(NSString *)groupIdentifier;
+ (NSString *) applicationGroupDirectory;
+ (NSString *) applicationGroupDocumentsDirectory;
+ (NSURL *) applicationGroupURL;
+ (NSURL *) applicationGroupDocumentsURL;

#if TARGET_OS_IPHONE
@property (nonatomic, weak, readonly) UIViewController *rootViewController;
+ (UIViewController *) rootViewController;
#endif

@end
