//
//  WGradientView.m
//  Warp
//
//  Created by Lukáš Foldýna on 15.4.11.
//  Copyright 2011 TwoManShow. All rights reserved.
//

#import "WGradientView.h"


@interface WNicerGradientLayer : CALayer

@property (nonatomic, copy) NSArray *colors;
@property (nonatomic, copy) NSArray *locations;

@end

@implementation WNicerGradientLayer

- (void) setColors:(NSArray *)colors
{
    _colors = colors;
    [self setNeedsDisplay];
}

- (void) setLocations:(NSArray *)locations
{
    _locations = locations;
    [self setNeedsDisplay];
}

- (void) drawInContext:(CGContextRef)context
{
	if (_locations == nil) {
		_locations = @[@0.0f, @1.0f];
	}
	CGFloat *locations = malloc([_locations count] * sizeof(CGFloat));
	
	NSUInteger i, count = [_locations count];
	for (i = 0; i < count; i++) {
		NSNumber *location = _locations[i];
		locations[i] = [location floatValue];
	}
	
	CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef		 gradient = CGGradientCreateWithColors(rgbColorspace, (__bridge CFArrayRef)_colors, locations);
	CGColorSpaceRelease(rgbColorspace);
	free(locations);
	
	CGFloat     height = self.frame.size.height;
	CGPoint startPoint = CGPointMake(0.0, 0.0);
	CGPoint   endPoint = CGPointMake(0.0, height);
	
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);
}

@end


@implementation WGradientView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    return self;
}

#pragma mark -

+ (Class) layerClass
{
    return [WNicerGradientLayer class];
}

- (NSArray *) colors
{
    NSMutableArray *colors = [NSMutableArray array];
    for (NSObject *object in [(CAGradientLayer *)[self layer] colors]) {
        CGColorRef color = (__bridge CGColorRef)object;
        [colors addObject:[UIColor colorWithCGColor:color]];
    }
    return colors;
}

- (void) setColors:(NSArray *)colors
{
    NSMutableArray *CGColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [CGColors addObject:(id)[color CGColor]];
    }
    [(CAGradientLayer *)[self layer] setColors:CGColors];
}

- (NSArray *) locations
{
    return [(CAGradientLayer *)[self layer] locations];
}

- (void) setLocations:(NSArray *)locations
{
    [(CAGradientLayer *)[self layer] setLocations:locations];
}

- (CGPoint) startPoint
{
    return [(CAGradientLayer *)[self layer] startPoint];
}

- (void) setStartPoint:(CGPoint)startPoint
{
    return [(CAGradientLayer *)[self layer] setStartPoint:startPoint];
}

- (CGPoint) endPoint
{
    return [(CAGradientLayer *)[self layer] endPoint];
}

- (void) setEndPoint:(CGPoint)endPoint
{
    return [(CAGradientLayer *)[self layer] setEndPoint:endPoint];
}

@end
