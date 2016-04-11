//
//  UIView+WAdditions.m
//  Warp
//
//  Created by Lukas on 15.3.09.
//  Copyright 2009 TwoManShow. All rights reserved.
//

#import "UIView+WAdditions.h"
@import QuartzCore;


@interface UIView (WAdditionsPrivate)

- (void) dumpView:(UIView *) superView i:(int) i;

@end


@implementation UIView (WAdditions)
 
- (UIScrollView *) findScrollView
{
	if ([self isKindOfClass: [UIScrollView class]] || [self isKindOfClass: NSClassFromString(@"UIScroller")]) {
		return (UIScrollView *) self;
	}
	
	for (UIView *child in self.subviews) {
		UIScrollView *result = [child findScrollView];
		
		if (result) {
			return result;
		}
	}
	return nil;
}

- (UIImage *) takeScreenshot
{
	UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
	[self.layer renderInContext: UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}

- (void) dumpView
{
	NSLog(@"Dumping view:");
	
	if ([self isKindOfClass: [UIScrollView class]] || [self isKindOfClass: NSClassFromString(@"UIScroller")]) {
		UIScrollView *scrollView = (UIScrollView *) self;
		NSLog(@"|0 %li %@ f: %@ s: %@", (long)self.tag, NSStringFromClass([self class]), NSStringFromCGRect(self.frame), NSStringFromCGSize(scrollView.contentSize));
	} else {
		NSLog(@"|0 %li %@ f: %@", (long)self.tag, NSStringFromClass([self class]), NSStringFromCGRect(self.frame));
	}
	[self dumpView: self i: 1];
}

- (void) dumpView:(UIView *) superView i:(int) i
{
	int e = 0;
	for (UIView *view in [superView subviews]) {
		
		if ([view isKindOfClass: [UIImageView class]]) {
			UIImageView *imageView = (UIImageView *) view;
			NSLog(@"|%i%@ %li %@ f: %@ i: %@ ", i, [@"" stringByPaddingToLength: i withString: @"_" startingAtIndex: 0], (long)view.tag,
				  NSStringFromClass([view class]), imageView.image, NSStringFromCGRect(imageView.frame));
		} else if ([view isKindOfClass: [UIScrollView class]] || [view isKindOfClass: NSClassFromString(@"UIScroller")]) {
			UIScrollView *scrollView = (UIScrollView *) view;
			NSLog(@"|%i%@ %li %@ f: %@ s: %@", i, [@"" stringByPaddingToLength: i withString: @"_" startingAtIndex: 0], (long)view.tag,
				  NSStringFromClass([view class]), NSStringFromCGRect(view.frame), NSStringFromCGSize(scrollView.contentSize));
		} else {
			NSLog(@"|%i%@ %li %@ f: %@", i, [@"" stringByPaddingToLength: i withString: @"_" startingAtIndex: 0], (long)view.tag,
				  NSStringFromClass([view class]), NSStringFromCGRect(view.frame));
		}
		[self dumpView: view i: i + 1];
		e++;
	}
}

@end
