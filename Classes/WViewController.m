//
//  WViewController.m
//  Warp
//
//  Created by Lukáš Foldýna on 13/04/15.
//  Copyright (c) 2015 TwoManShow. All rights reserved.
//

#import "WViewController.h"


@interface WViewController ()

@end

@implementation WViewController

- (CGRect) overlayerFrame
{
    return [self.view bounds];
}

- (void) displayError
{
    if (_errorView == nil) {
        _errorView = [[WErrorView alloc] initWithTitle:[self titleForState] subtitle:[self subtitleForState] image:[self imageForState]];
        [_errorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_errorView.titleView setTextColor:[UIColor whiteColor]];
        [_errorView.titleView setFont:[UIFont systemFontOfSize:20]];
        [_errorView.titleView setNumberOfLines:1];
        [_errorView.subtitleView setTextColor:RGBCOLOR(84, 85, 104)];
        [_errorView.subtitleView setFont:[UIFont boldSystemFontOfSize:14]];
        [_errorView.imageView setTintColor:_errorView.subtitleView.textColor];
    } else {
        [_errorView setTitle:[self titleForState]];
        [_errorView setSubtitle:[self subtitleForState]];
        [_errorView setImage:[self imageForState]];
        [_errorView setNeedsLayout];
    }
    [_errorView setFrame:[self overlayerFrame]];
    
    if ([_errorView superview] == nil) {
        [_errorView setAlpha:0];
        [self.view addSubview:_errorView];
        
        [UIView animateWithDuration:0.25 animations:^{
            [_errorView setAlpha:1];
        }];
    } else {
        [_errorView.superview bringSubviewToFront:_errorView];
    }
}

- (void) hideError
{
    WErrorView *errorView = _errorView;
    _errorView = nil;
    
    [UIView animateWithDuration:0.25 animations:^{
        [errorView setAlpha:0];
    } completion:^(BOOL finished) {
        [errorView removeFromSuperview];
    }];
}

- (void) displayLoading
{
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_loadingView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [_loadingView setFrame:[self overlayerFrame]];
    [_loadingView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    [_loadingView setAlpha:0];
    [_loadingView startAnimating];
    [self.view addSubview:_loadingView];
    
    [UIView animateWithDuration:0.25 animations:^{
        [_loadingView setAlpha:1];
    }];
}

- (void) hideLoading
{
    UIActivityIndicatorView *indicator = _loadingView;
    _loadingView = nil;
    
    [UIView animateWithDuration:0.25 animations:^{
        [indicator setAlpha:0];
    } completion:^(BOOL finished) {
        [indicator removeFromSuperview];
    }];
}

- (void) hideOverlayer
{
    [self hideError];
    [self hideLoading];
}

#pragma mark -

- (NSString *) titleForState
{
    NSString *title = [NSString stringWithFormat:@"%@.%@.title", _viewSource.label, [_viewSource stateTitle]];
    return NSLocalizedString(title, nil);
}

- (NSString *) subtitleForState
{
    if ([_viewSource state] == WViewDataSourceStateError) {
        return [[_viewSource.error localizedDescription] uppercaseString];
    } else {
        NSString *subtitle = [NSString stringWithFormat:@"%@.%@.subtitle", _viewSource.label, [_viewSource stateTitle]];
        return [NSLocalizedString(subtitle, nil) uppercaseString];
    }
}

- (UIImage *) imageForState
{
    return [_viewSource imageForState];
}

@end
