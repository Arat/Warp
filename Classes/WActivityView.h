//
//  WActivityView.h
//  Warp
//
//  Created by Lukáš Foldýna on 12/05/14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WActivityViewStyleWhite,
    WActivityViewStyleGray,
    WActivityViewStyleBlackBox,
    WActivityViewStyleBlackBezel,
    WActivityViewStyleBlackBanner,
    WActivityViewStyleWhiteBezel,
    WActivityViewStyleWhiteBox
} WActivityViewStyle;

@interface WActivityView : UIView

- (id)initWithFrame:(CGRect)frame style:(WActivityViewStyle)style;
- (id)initWithFrame:(CGRect)frame style:(WActivityViewStyle)style text:(NSString *)text;
- (id)initWithStyle:(WActivityViewStyle)style;
@property (nonatomic, readonly) WActivityViewStyle style;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) UIFont *font;

@property (nonatomic) float progress;
@property (nonatomic) BOOL isAnimating;
@property (nonatomic) BOOL smoothesProgress;

@end
