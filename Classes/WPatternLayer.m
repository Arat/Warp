//
//  WPatternLayer.m
//  Warp
//
//  Created by Lukáš Foldýna on 2.2.10.
//  Copyright 2010 TwoManShow. All rights reserved.
//

#import "WPatternLayer.h"


// callback for CreateImagePattern.
static void WDrawPatternImage(void *info, CGContextRef ctx)
{
    CGImageRef image = (CGImageRef) info;
    CGContextDrawImage(ctx, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
}

// callback for CreateImagePattern.
static void WReleasePatternImage(void *info)
{
    CGImageRelease((CGImageRef) info);
}

CGPatternRef WCreateImagePattern(CGImageRef image);

CGPatternRef WCreateImagePattern(CGImageRef image)
{
    NSCParameterAssert(image);
    CGFloat  width = CGImageGetWidth(image);
    CGFloat height = CGImageGetHeight(image);
	CGImageRetain(image);
    static const CGPatternCallbacks callbacks = {0, &WDrawPatternImage, &WReleasePatternImage};
    return CGPatternCreate(image,
						   CGRectMake(0.0, 0.0, width, height),
						   CGAffineTransformMake(1.0, 0, 0, -1.0, 0, 0),
						   width,
						   height,
						   kCGPatternTilingConstantSpacing,
						   true,
						   &callbacks);
}

@interface WSPatternLayer : CALayer
{
	
}

@end


@implementation WPatternLayer
{
    CGPatternRef		 _pattern;
    CGColorRef			 _patternColor;
    UIImage				*_patternImage;
    
    CGFloat				 _cornerRadius;
    CGPathRef			 _path;
    
    UIImage				*_newImage;
}

@synthesize patternImage = _patternImage;

- (void) dealloc
{
	if (_pattern != NULL) {
		CGPatternRelease(_pattern);
	}
	if (_patternColor != NULL) {
		CGColorRelease(_patternColor);
	}	
	_patternImage = nil;
	
	if (_path != NULL) {
		CGPathRelease(_path);
	}
}

- (void) drawInContext:(CGContextRef) ctx
{
	if (_path != NULL) {
		CGContextSaveGState(ctx);
		CGContextAddPath(ctx, _path);
		CGContextClip(ctx);
	}
	CGContextSetFillColorWithColor(ctx, _patternColor);
    CGContextFillRect(ctx, self.bounds);
}

#pragma mark -

- (void) setFrame:(CGRect)frame
{
	if (CGRectEqualToRect(frame, self.frame)) {
		return;
	}
	[super setFrame:frame];
	[self setCornerRadius:_cornerRadius];
}

- (CGFloat) cornerRadius
{
	return _cornerRadius;
}

- (void) setCornerRadius:(CGFloat)cornerRadius
{
	_cornerRadius = cornerRadius;
	
	if (_path != NULL) {
		CGPathRelease(_path);
		_path = NULL;
	}
	if (_cornerRadius > 0) {
		_path = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius] CGPath];
		CGPathRetain(_path);
	}
}

- (void) setPatternImage:(UIImage *) patternImage
{
	_patternImage = patternImage;
	
	if (_pattern) {
		CGPatternRelease(_pattern);
	}
	_pattern = WCreateImagePattern([_patternImage CGImage]);
	
	if (_patternColor) {
		CGColorRelease(_patternColor);
	}
	CGFloat alpha = [self opacity];
    CGColorSpaceRef colorSpace = CGColorSpaceCreatePattern(NULL);
	_patternColor = CGColorCreateWithPattern(colorSpace, _pattern, &alpha);
    CGColorSpaceRelease(colorSpace);
}

@end
