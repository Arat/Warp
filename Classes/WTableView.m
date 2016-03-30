//
//  WTableView.m
//  Warp
//
//  Created by Lukáš Foldýna on 30.9.09.
//  Copyright 2009 TwoManShow. All rights reserved.
//

#import "WTableView.h"
#import "WGlobal.h"


#define WSHADOW_HEIGHT			20.0
#define WSHADOW_INVERSE_HEIGHT	10.0
#define WSHADOW_RATIO			(SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)


@interface WTableView ()
{
    UIView			*_tableBackgroundView;
    
    CAGradientLayer *_originShadow;
    CAGradientLayer *_topShadow;
    CAGradientLayer *_bottomShadow;
    
    UIImage			*_patternImage;
    CALayer			*_patternLayer;
    
    BOOL			 _displayShadow;
}

- (CAGradientLayer *) _shadowAsInverse:(BOOL) inverse;

@end


@implementation WTableView

@synthesize displayShadow = _displayShadow;

- (void) dealloc
{
	_topShadow = nil;	
	_bottomShadow = nil;
    
	_tableBackgroundView = nil;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	if (!_displayShadow) {
		return;
	}
	// Construct the origin shadow if needed
	if (!_originShadow) {
		_originShadow = [self _shadowAsInverse: NO];
		[self.layer insertSublayer: _originShadow atIndex: 0];
	} else if (![(self.layer.sublayers)[0] isEqual: _originShadow]) {
		[self.layer insertSublayer: _originShadow atIndex: 0];
	}
	CGRect shadowFrame = CGRectZero;
	
	[CATransaction begin];
	[CATransaction setValue:(id) kCFBooleanTrue forKey: kCATransactionDisableActions];
	
	// Stretch and place the origin shadow
	shadowFrame = [_originShadow frame];
	shadowFrame.size.width = self.frame.size.width;
	shadowFrame.origin.y   = self.contentOffset.y;
	[_originShadow setFrame: shadowFrame];
	
	[CATransaction commit];
	
	NSArray *indexPathsForVisibleRows = [self indexPathsForVisibleRows];
	
	if ([indexPathsForVisibleRows count] == 0 && [self numberOfSections] == 0) {
		[_topShadow removeFromSuperlayer];
        _topShadow = nil;
		[_bottomShadow removeFromSuperlayer];
        _bottomShadow = nil;
		return;
	}

	if (!_topShadow) {
		_topShadow = [self _shadowAsInverse: YES];
		shadowFrame = [_topShadow frame];
		shadowFrame.size.width = self.frame.size.width;
		shadowFrame.origin.y   = -10.0;
		[_topShadow setFrame: shadowFrame];
		[self.layer addSublayer: _topShadow];
	}
	NSIndexPath *lastRow = [indexPathsForVisibleRows lastObject];
	NSUInteger   numberOfSections = [self numberOfSections];
	
	if ([lastRow section] == numberOfSections - 1 && [lastRow row] == [self numberOfRowsInSection: [lastRow section]] - 1) {
		UIView *cell = [self cellForRowAtIndexPath: lastRow];
		
		if ([self backgroundView]) {
			return;
		}
		if (!_bottomShadow) {
			_bottomShadow = [self _shadowAsInverse: NO];
			[cell.layer insertSublayer:_bottomShadow atIndex: 0];
		} else if ([cell.layer.sublayers indexOfObjectIdenticalTo:_bottomShadow] != 0) {
			[cell.layer insertSublayer:_bottomShadow atIndex: 0];
		}
		
		shadowFrame = _bottomShadow.frame;
		shadowFrame.size.width = cell.frame.size.width;
		shadowFrame.origin.y   = cell.frame.size.height + (self.tableFooterView ? self.tableFooterView.frame.size.height : 0);
		_bottomShadow.frame = shadowFrame;
	} else if ([self numberOfRowsInSection: numberOfSections - 1] == 0 && [self.delegate respondsToSelector: @selector(tableView:viewForHeaderInSection:)]) {
		UIView *sectionView = [self.delegate tableView: self viewForHeaderInSection: numberOfSections - 1];
		
		if ([self backgroundView]) {
			return;
		}
		if (!_bottomShadow) {
			_bottomShadow = [self _shadowAsInverse: NO];
			[sectionView.layer insertSublayer:_bottomShadow atIndex: 0];
		} else if ([sectionView.layer.sublayers indexOfObjectIdenticalTo:_bottomShadow] != 0) {
			[sectionView.layer insertSublayer:_bottomShadow atIndex: 0];
		}
		
		shadowFrame = _bottomShadow.frame;
		shadowFrame.size.width = sectionView.frame.size.width;
		shadowFrame.origin.y   = sectionView.frame.size.height + (self.tableFooterView ? self.tableFooterView.frame.size.height : 0);
		_bottomShadow.frame = shadowFrame;
	} else {
		[_bottomShadow removeFromSuperlayer];
        _bottomShadow = nil;
	}
}

#pragma mark -

- (UIView *) backgroundView
{
	return _tableBackgroundView;
}

- (void) setBackgroundView:(UIView *) backgroundView
{
	@try {
		[super setBackgroundView: backgroundView];
	} @catch (NSException *exception) {
		[_tableBackgroundView removeFromSuperview];
		[backgroundView setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[backgroundView setFrame: self.bounds];
		[[self layer] addSublayer: [backgroundView layer]];
		[[self layer] insertSublayer: [backgroundView layer] below: (self.layer.sublayers)[0]];
		//[self addSubview: backgroundView];
	} @finally {
		_tableBackgroundView = nil;
		_tableBackgroundView = backgroundView;
	}
}

#pragma mark -
#pragma mark Private

- (CAGradientLayer *) _shadowAsInverse:(BOOL) inverse
{
	CAGradientLayer *shadowLayer = [CAGradientLayer layer];
	
	CGRect frame = CGRectMake(0, 0, self.frame.size.width, inverse ? WSHADOW_INVERSE_HEIGHT : WSHADOW_HEIGHT);
	[shadowLayer setFrame: frame];
	
	CGColorRef  darkColor = [[UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 
											 alpha: inverse ? (WSHADOW_INVERSE_HEIGHT / WSHADOW_HEIGHT) * 0.5 : 0.5] CGColor];
	CGColorRef lightColor = [[self.backgroundColor colorWithAlphaComponent: 0.0] CGColor];
	[shadowLayer setColors: @[(__bridge id) (inverse ? lightColor : darkColor), 
													  (__bridge id) (inverse ? darkColor : lightColor)]];
	return shadowLayer;
}

@end
