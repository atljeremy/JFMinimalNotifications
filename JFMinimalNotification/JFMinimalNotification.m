//
//  JFMinimalNotification.m
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 5/4/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import "JFMinimalNotification.h"
#import <QuartzCore/QuartzCore.h>

#define kDefaultFullViewHeight 112
#define kDefaultContentHeight 90
#define kDefaultViewXPadding 15
#define kDefaultViewHeight 50
#define kDefaultViewWidth 50
#define kDefaultClosebuttonHeight 30
#define kDefaultCloseButtonWidth 30
#define kDefaultXPadding 10
#define kDefaultYPadding 20

@interface JFMinimalNotification() {
    CGRect startFrame;
    CGRect endFrame;
}
@property (nonatomic, weak, readonly) UIView* superView;
@property (nonatomic, strong, readonly) UIView* contentView;
@property (nonatomic, strong, readonly) UILabel* titleLabel;
@property (nonatomic, strong, readonly) UILabel* subTitleLabel;
@property (nonatomic, strong, readonly) UIView* leftView;
@property (nonatomic, strong, readonly) UIView* rightView;
@property (nonatomic, strong, readonly) UIButton* closeButton;
@end

@implementation JFMinimalNotification

+ (JFMinimalNotification*)notificationWithStyle:(JFMinimalNotificationStytle)style
                                          title:(NSString*)title
                                       subTitle:(NSString*)subTitle
                                      superView:(UIView*)view
{
    JFMinimalNotification* notification = [[self alloc] initWithSuperView:view];
    [notification setStyle:style];
    [notification setTitle:title withSubTitle:subTitle];
    
    return notification;
}

- (id)init
{
    @throw [NSException exceptionWithName:@"JFMinimalNotificationInvalidInitializationException" reason:@"Must use initWithSuperView:" userInfo:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    @throw [NSException exceptionWithName:@"JFMinimalNotificationInvalidInitializationException" reason:@"Must use initWithSuperView:" userInfo:nil];
}

- (id)initWithSuperView:(UIView*)view
{
    if (!view) @throw [NSException exceptionWithName:@"JFMinimalNotificationInvalidInitializationException" reason:@"Must provide a superView in which this JFMinimalNotification will be presented in" userInfo:nil];
    
    // Calculate frame for entire notification view
    CGFloat selfY = view.frame.size.height - kDefaultFullViewHeight;
    endFrame = CGRectMake(view.frame.origin.x,
                          selfY,
                          view.frame.size.width,
                          kDefaultFullViewHeight);
    
    startFrame = CGRectMake(endFrame.origin.x,
                            view.frame.size.height,
                            endFrame.size.width,
                            endFrame.size.height);
    
    if (self = [super initWithFrame:startFrame]) {
        _superView = view;
        
        // Calculate frame for content view
        CGRect contentFrame = CGRectMake(view.frame.origin.x,
                                         kDefaultClosebuttonHeight / 2,
                                         view.frame.size.width,
                                         kDefaultFullViewHeight - (kDefaultClosebuttonHeight / 2));
        
        // Calculate frame for title label
        CGFloat titleLabelHeight = (kDefaultContentHeight - (kDefaultYPadding * 2)) / 1.7;
        CGFloat labelWidth = (view.frame.size.width - (kDefaultXPadding * 2));
        CGRect titleLabelFrame = CGRectMake(kDefaultXPadding,
                                            kDefaultYPadding,
                                            labelWidth,
                                            titleLabelHeight);
        
        // Calculate frame for subtitle label
        CGFloat subTitleHeight = kDefaultContentHeight - titleLabelFrame.origin.y - titleLabelHeight - kDefaultYPadding;
        CGFloat subTitleY = titleLabelFrame.origin.y + titleLabelFrame.size.height;
        CGRect subTitleLabelFrame = CGRectMake(kDefaultXPadding,
                                               subTitleY,
                                               labelWidth,
                                               subTitleHeight);
        
        // Calculate frame for close button
        CGFloat closeButtonX = self.superView.frame.size.width - kDefaultCloseButtonWidth - kDefaultViewXPadding;
        CGRect closeButtonFrame = CGRectMake(closeButtonX,
                                             0,
                                             kDefaultCloseButtonWidth,
                                             kDefaultClosebuttonHeight);
        
        _contentView = [[UIView alloc] initWithFrame:contentFrame];
        
        _titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        _titleLabel.text = @"JFMinimalNotification Title";
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_titleLabel setShadowColor:[UIColor blackColor]];
        [_titleLabel setShadowOffset:CGSizeMake(1, 1)];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:subTitleLabelFrame];
        _subTitleLabel.text = @"JFMinimalNotification Sub-title";
        _subTitleLabel.adjustsFontSizeToFitWidth = YES;
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        [_subTitleLabel setShadowColor:[UIColor blackColor]];
        [_subTitleLabel setShadowOffset:CGSizeMake(1, 1)];
        [_subTitleLabel setTextColor:[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0]];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = closeButtonFrame;
        [_closeButton setImage:[UIImage imageNamed:@"JFMinimalNotification.bundle/x.png"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        _currentStyle = JFMinimalNotificationStyleDefault;
        
        _leftView = nil;
        _rightView = nil;
    }
    return self;
}

- (void)show
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willShowNotification:)]) {
        [self.delegate willShowNotification:self];
    }
    if (![self.superView.subviews containsObject:self]) [self.superView addSubview:self];
    if (![self.contentView.subviews containsObject:self.titleLabel]) [self.contentView addSubview:self.titleLabel];
    if (![self.contentView.subviews containsObject:self.subTitleLabel]) [self.contentView addSubview:self.subTitleLabel];
    if (self.leftView && ![self.contentView.subviews containsObject:self.leftView]) [self.contentView addSubview:self.leftView];
    if (self.rightView && ![self.contentView.subviews containsObject:self.rightView]) [self.contentView addSubview:self.rightView];
    if (![self.subviews containsObject:self.contentView]) [self addSubview:self.contentView];
    if (![self.subviews containsObject:self.closeButton]) [self addSubview:self.closeButton];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = endFrame;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didShowNotification:)]) {
            [self.delegate didShowNotification:self];
        }
    }];
}

- (void)dismiss
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willDisimissNotification:)]) {
        [self.delegate willDisimissNotification:self];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = startFrame;
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissNotification:)]) {
            [self.delegate didDismissNotification:self];
        }
    }];
}

- (void)dealloc
{
    if ([self.superView.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    _superView     = nil;
    _titleLabel    = nil;
    _subTitleLabel = nil;
    _leftView      = nil;
    _rightView     = nil;
    _contentView   = nil;
}

- (void)setStyle:(JFMinimalNotificationStytle)style
{
    _currentStyle = style;
    switch (style) {
        case JFMinimalNotificationStyleError: {
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
            UIColor* darkRed = [UIColor colorWithRed:50.0f/255.0f green:0.0f blue:0.0f alpha:1.0];
            gradient.colors = @[(id)[[UIColor redColor] CGColor], (id)[darkRed CGColor]];
            CALayer* currentLayer = [self.contentView.layer.sublayers objectAtIndex:0];
            if (currentLayer) {
                [self.contentView.layer replaceSublayer:currentLayer with:gradient];
            } else {
                [self.contentView.layer insertSublayer:gradient atIndex:0];
            }
            break;
        }
            
        case JFMinimalNotificationStyleSuccess: {
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
            UIColor* darkGreen = [UIColor colorWithRed:0.0f green:50.0f/255.0f blue:0.0f alpha:1.0];
            gradient.colors = @[(id)[[UIColor greenColor] CGColor], (id)[darkGreen CGColor]];
            CALayer* currentLayer = [self.contentView.layer.sublayers objectAtIndex:0];
            if (currentLayer) {
                [self.contentView.layer replaceSublayer:currentLayer with:gradient];
            } else {
                [self.contentView.layer insertSublayer:gradient atIndex:0];
            }
            break;
        }
            
        case JFMinimalNotificationStyleDefault:
        default: {
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
            UIColor* lighterGray = [UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0];
            UIColor* darkerGray = [UIColor colorWithRed:40.0f/255.0f green:40.0f/255.0f blue:40.0f/255.0f alpha:1.0];
            gradient.colors = @[(id)[lighterGray CGColor], (id)[darkerGray CGColor]];
            CALayer* currentLayer = [self.contentView.layer.sublayers objectAtIndex:0];
            if (currentLayer) {
                [self.contentView.layer replaceSublayer:currentLayer with:gradient];
            } else {
                [self.contentView.layer insertSublayer:gradient atIndex:0];
            }
            break;
        }
    }
}

- (void)setTitle:(NSString*)title withSubTitle:(NSString*)subTitle
{
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
}

- (void)setTitleFont:(UIFont*)font
{
    [self.titleLabel setFont:font];
}

- (void)setSubTitleFont:(UIFont*)font
{
    [self.subTitleLabel setFont:font];
}

- (void)setTitleColor:(UIColor*)color
{
    [self.titleLabel setTextColor:color];
}

- (void)setSubTitleColor:(UIColor*)color
{
    [self.subTitleLabel setTextColor:color];
}

- (void)setLeftView:(UIView*)view
{
    if (view) {
        if (![self.contentView.subviews containsObject:self.leftView]) {
            _leftView = view;
        
            // Calculate frame for left view
            CGFloat y = (kDefaultContentHeight / 2) - (kDefaultViewHeight / 2);
            CGRect leftViewFrame = CGRectMake(kDefaultViewXPadding,
                                              y,
                                              kDefaultViewWidth,
                                              kDefaultViewHeight);
            
            CGFloat width = self.titleLabel.frame.size.width - leftViewFrame.size.width - kDefaultXPadding;
            CGRect newTitleFrame = CGRectMake(self.titleLabel.frame.origin.x + leftViewFrame.size.width + kDefaultXPadding,
                                              self.titleLabel.frame.origin.y,
                                              width,
                                              self.titleLabel.frame.size.height);
            
            CGRect newSubtitleFrame = CGRectMake(self.subTitleLabel.frame.origin.x + leftViewFrame.size.width + kDefaultXPadding,
                                                 self.subTitleLabel.frame.origin.y,
                                                 width,
                                                 self.subTitleLabel.frame.size.height);

            
            [self.contentView addSubview:self.leftView];
            self.leftView.contentMode = UIViewContentModeScaleAspectFit;
            self.leftView.frame = leftViewFrame;
            self.leftView.alpha = 0.0f;
            [UIView animateWithDuration:0.3 animations:^{
                self.leftView.alpha = 1.0f;
                self.titleLabel.frame = newTitleFrame;
                self.subTitleLabel.frame = newSubtitleFrame;
            }];
        }
    } else {
        if ([self.contentView.subviews containsObject:self.leftView]) {
            [UIView animateWithDuration:0.3 animations:^{
                self.leftView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.leftView removeFromSuperview];
            }];
        }
        _leftView = nil;
        
        BOOL hasRightView = (self.rightView != nil && [self.contentView.subviews containsObject:self.rightView]);
        CGFloat width = (hasRightView) ? self.rightView.frame.origin.x - kDefaultXPadding
                                       : self.superView.frame.size.width - (kDefaultXPadding * 2);
        CGRect newTitleFrame = CGRectMake(kDefaultXPadding,
                                          self.titleLabel.frame.origin.y,
                                          width,
                                          self.titleLabel.frame.size.height);
        
        CGRect newSubtitleFrame = CGRectMake(kDefaultXPadding,
                                             self.subTitleLabel.frame.origin.y,
                                             width,
                                             self.subTitleLabel.frame.size.height);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.titleLabel.frame = newTitleFrame;
            self.subTitleLabel.frame = newSubtitleFrame;
        }];
    }
}

- (void)setRightView:(UIView*)view
{
    if (view) {
        if (![self.contentView.subviews containsObject:self.rightView]) {
            _rightView = view;
            
            // Calculate frame for right view
            CGFloat y = (kDefaultContentHeight / 2) - (kDefaultViewHeight / 2);
            CGFloat x = self.superView.frame.size.width - kDefaultXPadding - kDefaultViewWidth;
            CGRect rightViewFrame = CGRectMake(x,
                                               y,
                                               kDefaultViewWidth,
                                               kDefaultViewHeight);

            CGFloat width = self.titleLabel.frame.size.width - rightViewFrame.size.width - kDefaultXPadding;
            CGRect newTitleFrame = CGRectMake(self.titleLabel.frame.origin.x,
                                              self.titleLabel.frame.origin.y,
                                              width,
                                              self.titleLabel.frame.size.height);
            
            CGRect newSubtitleFrame = CGRectMake(self.subTitleLabel.frame.origin.x,
                                                 self.subTitleLabel.frame.origin.y,
                                                 width,
                                                 self.subTitleLabel.frame.size.height);
            
            
            [self.contentView addSubview:self.rightView];
            self.rightView.contentMode = UIViewContentModeScaleAspectFit;
            self.rightView.frame = rightViewFrame;
            self.rightView.alpha = 0.0f;
            [UIView animateWithDuration:0.3 animations:^{
                self.rightView.alpha = 1.0f;
                self.titleLabel.frame = newTitleFrame;
                self.subTitleLabel.frame = newSubtitleFrame;
            }];
        }
    } else {
        if ([self.contentView.subviews containsObject:self.rightView]) {
            [UIView animateWithDuration:0.3 animations:^{
                self.rightView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.rightView removeFromSuperview];
            }];
        }
        _rightView = nil;
        
        BOOL hasLeftView = (self.leftView != nil && [self.contentView.subviews containsObject:self.leftView]);
        CGFloat x = self.titleLabel.frame.origin.x;
        CGFloat width = (hasLeftView) ? self.superView.frame.size.width - x - kDefaultXPadding : self.superView.frame.size.width - (kDefaultXPadding * 2);
        CGRect newTitleFrame = CGRectMake(x,
                                          self.titleLabel.frame.origin.y,
                                          width,
                                          self.titleLabel.frame.size.height);
        
        CGRect newSubtitleFrame = CGRectMake(x,
                                             self.subTitleLabel.frame.origin.y,
                                             width,
                                             self.subTitleLabel.frame.size.height);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.titleLabel.frame = newTitleFrame;
            self.subTitleLabel.frame = newSubtitleFrame;
        }];
    }
}

- (void)setCloseButtonPosition:(JFMinimalNotificationCloseBtnPosition)positon
{
    // Calculate frame for close button
    CGFloat closeButtonX;
    switch (positon) {
        case JFMinimalNotificationCloseBtnPositionLeft:
            closeButtonX = kDefaultViewXPadding;
            break;
            
        case JFMinimalNotificationCloseBtnPositionRight:
        default:
            closeButtonX = self.superView.frame.size.width - kDefaultCloseButtonWidth - kDefaultViewXPadding;
            break;
    }
    
    CGRect closeButtonFrame = CGRectMake(closeButtonX,
                                         0,
                                         kDefaultCloseButtonWidth,
                                         kDefaultClosebuttonHeight);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.closeButton.frame = closeButtonFrame;
    }];
}

@end
