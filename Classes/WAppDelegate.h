//
//  WAppDelegate.h
//  Warp
//
//  Created by Lukáš Foldýna on 8.8.10.
//  Copyright 2010 TwoManShow. All rights reserved.
//

@import Foundation;
#if TARGET_OS_IPHONE
#else
@import AppKit;
#endif


#if TARGET_OS_IPHONE
@interface WAppDelegate : UIResponder <UIApplicationDelegate>
#else
@interface WAppDelegate : NSObject <NSApplicationDelegate>
#endif

+ (instancetype _Nonnull) sharedAppDelegate;

+ (BOOL) isApplicationExtension;
+ (BOOL) isApplicationRunningFromTestflight;
+ (NSString * _Nonnull) applicationID;
+ (NSString * _Nonnull) applicationName;
+ (NSString * _Nonnull) applicationVersion;

@property (nonatomic, weak, readonly, nullable) NSString *applicationDocumentsDirectory;
@property (nonatomic, weak, readonly, nullable) NSString *applicationLibraryDirectory;
@property (nonatomic, weak, readonly, nullable) NSString *applicationCacheDirectory;
@property (nonatomic, weak, readonly, nullable) NSString *applicationTemporaryDirectory;
+ (NSString * _Nonnull) applicationDocumentsDirectory;
+ (NSString * _Nonnull) applicationLibraryDirectory;
+ (NSString * _Nonnull) applicationCacheDirectory;
+ (NSString * _Nonnull) applicationTemporaryDirectory;

@property (nonatomic, strong, nullable) NSString *applicationGroupIdentifier;
@property (nonatomic, weak, readonly, nullable) NSString *applicationGroupDirectory;
@property (nonatomic, weak, readonly, nullable) NSString *applicationGroupDocumentsDirectory;
+ (NSString * _Nullable) applicationGroupIdentifier;
+ (void) setApplicationGroupIdentifier:(NSString * _Nonnull)groupIdentifier;
+ (NSString * _Nullable) applicationGroupDirectory;
+ (NSString * _Nullable) applicationGroupDocumentsDirectory;
+ (NSURL * _Nullable) applicationGroupURL;
+ (NSURL * _Nullable) applicationGroupDocumentsURL;

#if TARGET_OS_IPHONE
@property (nonatomic, weak, readonly, nullable) UIViewController *rootViewController;
+ (UIViewController * _Nullable) rootViewController;
#endif

@end
