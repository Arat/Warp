//
//  WGradientView.h
//  Warp
//
//  Created by Lukáš Foldýna on 15.4.11.
//  Copyright 2011 TwoManShow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WGradientView : UIView

@property (nonatomic, copy) NSArray *colors;
@property (nonatomic, copy) NSArray *locations;

@property (nonatomic, assign) CGPoint startPoint, endPoint;

@end
