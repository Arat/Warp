//
//  WErrorView.m
//  Warp
//
//  Created by Lukáš Foldýna on 05/05/14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

#import "WErrorView.h"


static const CGFloat kVPadding1 = 10.0;
static const CGFloat kVPadding2 = 10.0;
static const CGFloat kHPadding  = 10.0;


@implementation WErrorView

@synthesize imageView = _imageView;
@synthesize titleView = _titleView;
@synthesize subtitleView = _subtitleView;

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        [self _createView];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    
	if (self) {
        [self _createView];
		UIColor *darkColor = RGBCOLOR(74, 74, 74);
		
		[_titleView setTextColor:darkColor];
        
        if (WISPhone()) {
            [_titleView setNumberOfLines:0];
        }
		[_subtitleView setTextColor:darkColor];
        
        _spaceBetweenImage = kVPadding2 * 2;
        
        [self setBackgroundColor:[UIColor clearColor]];
	}
    return self;
}

- (instancetype) initWithTitle:(NSString *)title subtitle:(NSString *)subtitle image:(UIImage *)image
{
    self = [self initWithFrame:CGRectZero];
    
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.image = image;
    }
    return self;
}


- (void) _createView
{
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_imageView];
    
    _titleView = [[UILabel alloc] init];
    _titleView.backgroundColor = [UIColor clearColor];
    _titleView.textColor = [UIColor blackColor];
    _titleView.font = [UIFont boldSystemFontOfSize:26];
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.numberOfLines = 0;
    [self addSubview:_titleView];
    
    _subtitleView = [[UILabel alloc] init];
    _subtitleView.backgroundColor = [UIColor clearColor];
    _subtitleView.textColor = [UIColor blackColor];
    _subtitleView.font = [UIFont systemFontOfSize:16];
    _subtitleView.textAlignment = NSTextAlignmentCenter;
    _subtitleView.numberOfLines = 0;
    [self addSubview:_subtitleView];
}

- (void) layoutSubviews
{
    _subtitleView.size = [_subtitleView sizeThatFits:CGSizeMake(self.width - kHPadding * 2, 0)];
    [_titleView sizeToFit];
    [_imageView sizeToFit];
    
    if ([_titleView width] > [self width]) {
        [_titleView setSize:[_titleView sizeThatFits:CGSizeMake(self.width - kHPadding * 2, 0)]];
    }
    CGFloat maxHeight = _imageView.height + _titleView.height + _subtitleView.height + kVPadding1 + kVPadding2 + _spaceBetweenImage;
    BOOL canShowImage = _imageView.image && self.height > maxHeight;
    
    CGFloat totalHeight = 0;
    
    if (canShowImage) {
        totalHeight += _imageView.height;
    }
    if (_titleView.text.length) {
        totalHeight += (totalHeight ? kVPadding1 : 0) + _titleView.height;
    }
    if (_subtitleView.text.length) {
        totalHeight += (totalHeight ? kVPadding2 : 0) + _subtitleView.height;
    }
    CGFloat top = floor(self.height / 2 - totalHeight / 2);
    
    if (canShowImage) {
        top -= _spaceBetweenImage;
        _imageView.origin = CGPointMake(floor(self.width / 2 - _imageView.width / 2), top);
        _imageView.hidden = NO;
        top += _imageView.height + kVPadding1;
        
    } else {
        _imageView.hidden = YES;
    }
    top += _spaceBetweenImage;
    
    if (_titleView.text.length) {
        _titleView.origin = CGPointMake(floor(self.width / 2 - _titleView.width / 2), top);
        top += _titleView.height + kVPadding2;
    }
    if (_subtitleView.text.length) {
        _subtitleView.origin = CGPointMake(floor(self.width / 2 - _subtitleView.width / 2), top);
    }
}

#pragma mark -
#pragma mark Properties

- (NSString *) title
{
    return _titleView.text;
}

- (void) setTitle:(NSString *)title
{
    _titleView.text = title;
}

- (NSString *) subtitle
{
    return _subtitleView.text;
}

- (void) setSubtitle:(NSString *)subtitle
{
    _subtitleView.text = subtitle;
}

- (UIImage *) image
{
    return _imageView.image;
}

- (void) setImage:(UIImage *)image
{
    _imageView.image = image;
}

#pragma mark Views

- (UIImageView *) imageView
{
    return _imageView;
}

- (void) setImageView:(UIImageView *)imageView
{
    [_imageView removeFromSuperview];
    _imageView = imageView;
    [self addSubview:_imageView];
}

- (UILabel *) titleView
{
    return _titleView;
}

- (void) setTitleView:(UILabel *)titleView
{
    [_titleView removeFromSuperview];
    _titleView = titleView;
    [self addSubview:_titleView];
}

- (UILabel *) subtitleView
{
    return _subtitleView;
}

- (void) setSubtitleView:(UILabel *)subtitleView
{
    [_subtitleView removeFromSuperview];
    _subtitleView = subtitleView;
    [self addSubview:_subtitleView];
}

- (void) setSpaceBetweenImage:(CGFloat)spaceBetweenImage
{
    _spaceBetweenImage = spaceBetweenImage;
    [self layoutSubviews];
}

@end
