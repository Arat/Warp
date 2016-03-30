//
//  WErrorView.h
//  Warp
//
//  Created by Lukáš Foldýna on 05/05/14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WErrorView : UIView

- (instancetype) initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UILabel *subtitleView;
@property (nonatomic, assign) CGFloat spaceBetweenImage;

@end
