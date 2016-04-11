//
//  WErrorView.h
//  Warp
//
//  Created by Lukáš Foldýna on 05/05/14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

@import UIKit;


@interface WErrorView : UIView

- (instancetype _Nonnull) initWithTitle:(NSString * _Nullable)title subtitle:(NSString * _Nullable)subtitle image:(UIImage * _Nullable)image;

@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@property (nonatomic, strong, nonnull) UIImageView *imageView;
@property (nonatomic, strong, nonnull) UILabel *titleView;
@property (nonatomic, strong, nonnull) UILabel *subtitleView;
@property (nonatomic, assign) CGFloat spaceBetweenImage;

@end
