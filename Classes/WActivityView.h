//
//  WActivityView.h
//  Warp
//
//  Created by Lukáš Foldýna on 12/05/14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

@import UIKit;


typedef NS_ENUM(NSInteger, WActivityViewStyle) {
    WActivityViewStyleWhite,
    WActivityViewStyleGray,
    WActivityViewStyleBlackBox,
    WActivityViewStyleBlackBezel,
    WActivityViewStyleBlackBanner,
    WActivityViewStyleWhiteBezel,
    WActivityViewStyleWhiteBox
};

@interface WActivityView : UIView

- (instancetype _Nonnull)initWithFrame:(CGRect)frame style:(WActivityViewStyle)style;
- (instancetype _Nonnull)initWithFrame:(CGRect)frame style:(WActivityViewStyle)style text:(NSString * _Nullable)text;
- (instancetype _Nonnull)initWithStyle:(WActivityViewStyle)style;
@property (nonatomic, readonly) WActivityViewStyle style;

@property (nonatomic, copy, nullable) NSString *text;
@property (nonatomic, strong, nonnull) UIFont *font;

@property (nonatomic) float progress;
@property (nonatomic) BOOL isAnimating;
@property (nonatomic) BOOL smoothesProgress;

@end
