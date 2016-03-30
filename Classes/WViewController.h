//
//  WViewController.h
//  Warp
//
//  Created by Lukáš Foldýna on 13/04/15.
//  Copyright (c) 2015 TwoManShow. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WViewDataSource, WErrorView;

@interface WViewController : UIViewController

@property (nonatomic, strong) WViewDataSource *viewSource;

@property (nonatomic, strong) WErrorView *errorView;
- (void) displayError;
- (void) hideError;

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
- (void) displayLoading;
- (void) hideLoading;

- (CGRect) overlayerFrame;
- (void) hideOverlayer;

@property (nonatomic, readonly, strong) NSString *titleForState;
@property (nonatomic, readonly, strong) NSString *subtitleForState;
@property (nonatomic, readonly, strong) UIImage *imageForState;

@end