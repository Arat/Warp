//
//  UIView+WAdditions.h
//  Warp
//
//  Created by Lukas on 15.3.09.
//  Copyright 2009 TwoManShow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIView (WAdditions)

/*
 * Vypise do console prehledne vsechny subviews
 */
- (void) dumpView;

/*
 * Najde a vrati ve view hierarchii prvni UIScrollView
 */
- (UIScrollView *) findScrollView;

/*
 * Vytvori UIImage z obsahu view
 */
- (UIImage *) takeScreenshot;

@end
