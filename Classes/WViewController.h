//
//  WViewController.h
//  Warp
//
//  Created by Lukáš Foldýna on 13/04/15.
//  Copyright (c) 2015 TwoManShow. All rights reserved.
//

@import UIKit;


@class WViewDataSource, WErrorView;

@protocol WViewControllerProtocol <NSObject>

@property (nonatomic, strong, nullable) WViewDataSource *viewSource;

@property (nonatomic, strong, nonnull) WErrorView *errorView;
- (void) displayError;
- (void) hideError;

@property (nonatomic, strong, nonnull) UIActivityIndicatorView *loadingView;
- (void) displayLoading;
- (void) hideLoading;

@property (nonatomic, assign, readonly) CGRect overlayerFrame;
- (void) hideOverlayer;

@property (nonatomic, readonly, strong, nullable) UIImage *imageForState; // source-label.source-state.image
@property (nonatomic, readonly, strong, nonnull) NSString *titleForState; // source-label.source-state.title
@property (nonatomic, readonly, strong, nonnull) NSString *subtitleForState; // source-label.source-state.subtitle or error description

@end


@interface UIViewController (WViewController)

@property (nonatomic, strong, readonly, nonnull) WErrorView *errorView;
@property (nonatomic, strong, readonly, nonnull) UIActivityIndicatorView *loadingView;

@end


@interface WViewController : UIViewController <WViewControllerProtocol>

@end

@interface WTableViewController : UITableViewController <WViewControllerProtocol>

@end


@interface WCollectionViewController : UICollectionViewController <WViewControllerProtocol>

@end
