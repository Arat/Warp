//
//  WActivityView.m
//  Warp
//
//  Created by Lukáš Foldýna on 12/05/14.
//  Copyright (c) 2014 TwoManShow. All rights reserved.
//

#import "WActivityView.h"
#import "WDefaultStyleSheet.h"


static CGFloat kMargin          = 10;
static CGFloat kPadding         = 15;
static CGFloat kBannerPadding   = 8;
static CGFloat kSpacing         = 6;
static CGFloat kProgressMargin  = 6;


@interface WActivityView ()
{
    UIView                  *_bezelView;
    UIProgressView          *_progressView;
    UIActivityIndicatorView *_activityIndicator;
    UILabel                 *_label;
    
    NSTimer                 *_smoothTimer;
}
@end

@implementation WActivityView

- (instancetype) initWithFrame:(CGRect)frame style:(WActivityViewStyle)style text:(NSString *)text
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _style = style;
        _progress = 0;
        _smoothesProgress = NO;
        _smoothTimer =nil;
        _progressView = nil;
        
        _bezelView = [[UIView alloc] init];
        if (_style == WActivityViewStyleBlackBezel) {
            _bezelView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor clearColor];
        } else if (_style == WActivityViewStyleWhiteBezel) {
            _bezelView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor clearColor];
        } else if (_style == WActivityViewStyleWhiteBox) {
            _bezelView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor whiteColor];
        } else if (_style == WActivityViewStyleBlackBox) {
            _bezelView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        } else if (_style == WActivityViewStyleBlackBanner) {
            _bezelView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor clearColor];
        } else {
            _bezelView.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor clearColor];
        }
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _label = [[UILabel alloc] init];
        _label.text = text;
        _label.backgroundColor = [UIColor clearColor];
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
        
        if (_style == WActivityViewStyleWhite) {
            _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                  UIActivityIndicatorViewStyleWhite];
            _label.font = WSTYLEVAR(activityLabelFont);
            _label.textColor = [UIColor whiteColor];
        } else if (_style == WActivityViewStyleGray
                   || _style == WActivityViewStyleWhiteBox
                   || _style == WActivityViewStyleWhiteBezel) {
            _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                  UIActivityIndicatorViewStyleGray];
            _label.font = WSTYLEVAR(activityLabelFont);
            _label.textColor = WSTYLEVAR(activityTextColor);
        } else if (_style == WActivityViewStyleBlackBezel || _style == WActivityViewStyleBlackBox) {
            _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                  UIActivityIndicatorViewStyleWhite];
            _activityIndicator.frame = CGRectMake(0, 0, 24, 24);
            _label.font = WSTYLEVAR(activityLabelFont);
            _label.textColor = [UIColor whiteColor];
            _label.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            _label.shadowOffset = CGSizeMake(1, 1);
        } else if (_style == WActivityViewStyleBlackBanner) {
            _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                  UIActivityIndicatorViewStyleWhite];
            _label.font = WSTYLEVAR(activityBannerFont);
            _label.textColor = [UIColor whiteColor];
            _label.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            _label.shadowOffset = CGSizeMake(1, 1);
        }
        
        [self addSubview:_bezelView];
        [_bezelView addSubview:_activityIndicator];
        [_bezelView addSubview:_label];
        [_activityIndicator startAnimating];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame style:(WActivityViewStyle)style
{
    self = [self initWithFrame:frame style:style text:nil];
    
    if (self) {
        
    }
    return self;
}

- (instancetype) initWithStyle:(WActivityViewStyle)style
{
    self = [self initWithFrame:CGRectZero style:style text:nil];
    
    if (self) {
        
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame style:WActivityViewStyleWhiteBox text:nil];
    
    if (self) {
        
    }
    return self;
}

- (void) dealloc
{
    [_smoothTimer invalidate];
    _smoothTimer = nil;
}

#pragma mark -
#pragma mark UIView

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize textSize;
    if (!WISOS7()) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        textSize = [_label.text sizeWithFont:_label.font];
#pragma GCC diagnostic pop
    } else {
        textSize = [_label.text sizeWithAttributes:@{NSFontAttributeName: _label.font}];
    }
    CGFloat indicatorSize = 0;
    [_activityIndicator sizeToFit];
    if (_activityIndicator.isAnimating) {
        if (_activityIndicator.height > textSize.height) {
            indicatorSize = textSize.height;
        } else {
            indicatorSize = _activityIndicator.height;
        }
    }
    
    CGFloat contentWidth = indicatorSize + kSpacing + textSize.width;
    CGFloat contentHeight = textSize.height > indicatorSize ? textSize.height : indicatorSize;
    
    if (_progressView) {
        [_progressView sizeToFit];
        contentHeight += _progressView.height + kSpacing;
    }
    
    CGFloat margin, padding, bezelWidth, bezelHeight;
    if (_style == WActivityViewStyleBlackBezel || _style == WActivityViewStyleWhiteBezel) {
        margin = kMargin;
        padding = kPadding;
        bezelWidth = contentWidth + padding*2;
        bezelHeight = contentHeight + padding*2;
    } else {
        margin = 0;
        padding = kBannerPadding;
        bezelWidth = self.width;
        bezelHeight = self.height;
    }
    
    CGFloat maxBevelWidth = [[UIScreen mainScreen] applicationFrame].size.width - margin*2;
    if (bezelWidth > maxBevelWidth) {
        bezelWidth = maxBevelWidth;
        contentWidth = bezelWidth - (kSpacing + indicatorSize);
    }
    
    CGFloat textMaxWidth = (bezelWidth - (indicatorSize + kSpacing)) - padding*2;
    CGFloat textWidth = textSize.width;
    if (textWidth > textMaxWidth) {
        textWidth = textMaxWidth;
    }
    
    _bezelView.frame = CGRectMake(floor(self.width/2 - bezelWidth/2),
                                  floor(self.height/2 - bezelHeight/2),
                                  bezelWidth, bezelHeight);
    
    CGFloat y = padding + floor((bezelHeight - padding*2)/2 - contentHeight/2);
    
    if (_progressView) {
        if (_style == WActivityViewStyleBlackBanner) {
            y += kBannerPadding/2;
        }
        _progressView.frame = CGRectMake(kProgressMargin, y,
                                         bezelWidth - kProgressMargin*2, _progressView.height);
        y += _progressView.height + kSpacing-1;
    }
    _label.frame = CGRectMake(floor((bezelWidth/2 - contentWidth/2) + indicatorSize + kSpacing), y,
                              textWidth, textSize.height);
    
    _activityIndicator.frame = CGRectMake(_label.left - (indicatorSize+kSpacing), y,
                                          indicatorSize, indicatorSize);
}

- (CGSize) sizeThatFits:(CGSize)size
{
    CGFloat padding;
    if (_style == WActivityViewStyleBlackBezel || _style == WActivityViewStyleWhiteBezel) {
        padding = kPadding;
    } else {
        padding = kBannerPadding;
    }
    
    CGFloat height = _label.font.lineHeight + padding * 2;
    if (_progressView) {
        height += _progressView.height + kSpacing;
    }
    return CGSizeMake(size.width, height);
}

- (void) smoothTimer
{
    if (_progressView.progress < _progress) {
        _progressView.progress += 0.01;
    } else {
        [_smoothTimer invalidate];
        _smoothTimer = nil;
    }
}

#pragma mark -
#pragma mark Public

- (NSString *)text
{
    return _label.text;
}

- (void)setText:(NSString *)text
{
    _label.text = text;
    [self setNeedsLayout];
}

- (UIFont *)font
{
    return _label.font;
}

- (void)setFont:(UIFont *)font
{
    _label.font = font;
    [self setNeedsLayout];
}

- (BOOL)isAnimating
{
    return _activityIndicator.isAnimating;
}

- (void)setIsAnimating:(BOOL)isAnimating
{
    if (isAnimating) {
        [_activityIndicator startAnimating];
        
    } else {
        [_activityIndicator stopAnimating];
    }
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progress = 0;
        [_bezelView addSubview:_progressView];
        [self setNeedsLayout];
    }
    
    if (_smoothesProgress) {
        if (!_smoothTimer) {
            _smoothTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self
                                                          selector:@selector(smoothTimer) userInfo:nil repeats:YES];
        }
    } else {
        _progressView.progress = progress;
    }
}


@end
