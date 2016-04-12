//
//  WViewController.m
//  Warp
//
//  Created by Lukáš Foldýna on 13/04/15.
//  Copyright (c) 2015 TwoManShow. All rights reserved.
//

#import "WViewController.h"
#import "WViewDataSource.h"
#import "WErrorView.h"


@implementation UIViewController (WViewController)

- (WErrorView *) createErrorView
{
    WErrorView *errorView = [[WErrorView alloc] initWithTitle:@"" subtitle:@"" image:nil];
    [errorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [errorView.titleView setTextColor:WSTYLEVAR(errorTitleColor)];
    [errorView.titleView setFont:[WDefaultStyleSheet systemFontOfSize:20]];
    [errorView.titleView setNumberOfLines:1];
    [errorView.subtitleView setTextColor:WSTYLEVAR(errorSubtitleColor)];
    [errorView.subtitleView setFont:[WDefaultStyleSheet boldSystemFontOfSize:14]];
    [errorView.imageView setTintColor:errorView.subtitleView.textColor];
    [errorView setBackgroundColor:[UIColor whiteColor]];
    [errorView setUserInteractionEnabled:NO];
    return errorView;
}

- (UIActivityIndicatorView *) createLoadingView
{
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [loadingView setColor:WSTYLEVAR(loadingTintColor)];
    [loadingView setBackgroundColor:WSTYLEVAR(loadingBackgroundColor)];
    [loadingView setAlpha:0];
    [loadingView startAnimating];
    return loadingView;
}

@end


@implementation WViewController

@synthesize errorView = _errorView;
@synthesize loadingView = _loadingView;
@synthesize viewSource = _viewSource;

- (CGRect) overlayerFrame
{
    return [self.view bounds];
}

- (void) displayError
{
    if (_errorView == nil) {
        _errorView = [self createErrorView];
    }
    [_errorView setTitle:[self titleForState]];
    [_errorView setSubtitle:[self subtitleForState]];
    [_errorView setImage:[self imageForState]];
    [_errorView setNeedsLayout];
    
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
    if (_loadingView) {
        return;
    }
    _loadingView = [self createLoadingView];
    [_loadingView setFrame:[self overlayerFrame]];
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
        return [_viewSource.error localizedDescription];
    } else {
        NSString *subtitle = [NSString stringWithFormat:@"%@.%@.subtitle", _viewSource.label, [_viewSource stateTitle]];
        return NSLocalizedString(subtitle, nil);
    }
}

- (UIImage *) imageForState
{
    return [_viewSource imageForState];
}

@end



@implementation WTableViewController

@synthesize errorView = _errorView;
@synthesize loadingView = _loadingView;
@synthesize viewSource = _viewSource;

- (CGRect) overlayerFrame
{
    return [self.view bounds];
}

- (void) displayError
{
    if (_errorView == nil) {
        _errorView = [self createErrorView];
    }
    [_errorView setTitle:[self titleForState]];
    [_errorView setSubtitle:[self subtitleForState]];
    [_errorView setImage:[self imageForState]];
    [_errorView setNeedsLayout];
    
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
    if (_loadingView) {
        return;
    }
    _loadingView = [self createLoadingView];
    [_loadingView setFrame:[self overlayerFrame]];
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
        return [_viewSource.error localizedDescription];
    } else {
        NSString *subtitle = [NSString stringWithFormat:@"%@.%@.subtitle", _viewSource.label, [_viewSource stateTitle]];
        return NSLocalizedString(subtitle, nil);
    }
}

- (UIImage *) imageForState
{
    return [_viewSource imageForState];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<WViewDataObjectProtocol> object = [_viewSource objectForIndexPath:indexPath];
    if (object && !object.inserting && !object.processing && !object.removing) {
        return indexPath;
    } else {
        return nil;
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<WViewDataObjectProtocol> object = [_viewSource objectForIndexPath:indexPath];
    if (object && !object.inserting && !object.processing && !object.removing) {
        return indexPath;
    } else {
        return nil;
    }
}

@end


@implementation WCollectionViewController

@synthesize errorView = _errorView;
@synthesize loadingView = _loadingView;
@synthesize viewSource = _viewSource;

- (CGRect) overlayerFrame
{
    return [self.view bounds];
}

- (void) displayError
{
    if (_errorView == nil) {
        _errorView = [self createErrorView];
    }
    [_errorView setTitle:[self titleForState]];
    [_errorView setSubtitle:[self subtitleForState]];
    [_errorView setImage:[self imageForState]];
    [_errorView setNeedsLayout];
    
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
    if (_loadingView) {
        return;
    }
    _loadingView = [self createLoadingView];
    [_loadingView setFrame:[self overlayerFrame]];
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
        return [_viewSource.error localizedDescription];
    } else {
        NSString *subtitle = [NSString stringWithFormat:@"%@.%@.subtitle", _viewSource.label, [_viewSource stateTitle]];
        return NSLocalizedString(subtitle, nil);
    }
}

- (UIImage *) imageForState
{
    return [_viewSource imageForState];
}

#pragma mark -
#pragma mark UICollectionViewDelegate

- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<WViewDataObjectProtocol> object = [_viewSource objectForIndexPath:indexPath];
    if (object && !object.inserting && !object.processing && !object.removing) {
        return indexPath;
    } else {
        return nil;
    }
}

@end
