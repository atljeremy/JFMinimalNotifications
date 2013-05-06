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
#define kDefaultImageViewXPadding 15
#define kDefaultImageViewHeight 50
#define kDefaultImageViewWidth 50
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
@property (nonatomic, strong, readonly) UIImage* leftImage;
@property (nonatomic, strong, readonly) UIImage* rightImage;
@property (nonatomic, strong, readonly) UIImageView* leftImageView;
@property (nonatomic, strong, readonly) UIImageView* rightImageView;
@property (nonatomic, strong, readonly) UIButton* closeButton;
@end

@implementation JFMinimalNotification

+ (JFMinimalNotification*)notificationWithStyle:(JFMinimalNotificationStytle)style superView:(UIView*)view
{
    if (!view) @throw [NSException exceptionWithName:@"JFMinimalNotification: Invalid Initialization" reason:@"Must provide a superView in which this JFMinimalNotification will be presented in" userInfo:nil];
    
    JFMinimalNotification* notification = [[self alloc] initWithSuperView:view];
    [notification setStyle:style];
    
    return notification;
}

- (id)init
{
    @throw [NSException exceptionWithName:@"JFMinimalNotification: Invalid Initialization" reason:@"Must use initWithSuperView:" userInfo:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    @throw [NSException exceptionWithName:@"JFMinimalNotification: Invalid Initialization" reason:@"Must use initWithSuperView:" userInfo:nil];
}

- (id)initWithSuperView:(UIView*)view
{
    if (!view) @throw [NSException exceptionWithName:@"JFMinimalNotification: Invalid Initialization" reason:@"Must provide a superView in which this JFMinimalNotification will be presented in" userInfo:nil];
    
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
        CGFloat closeButtonX = self.superView.frame.size.width - kDefaultCloseButtonWidth - kDefaultImageViewXPadding;
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
    }
    return self;
}

- (void)show
{
    if (![self.superView.subviews containsObject:self]) [self.superView addSubview:self];
    if (![self.contentView.subviews containsObject:self.titleLabel]) [self.contentView addSubview:self.titleLabel];
    if (![self.contentView.subviews containsObject:self.subTitleLabel]) [self.contentView addSubview:self.subTitleLabel];
    if (![self.contentView.subviews containsObject:self.leftImageView]) [self.contentView addSubview:self.leftImageView];
    if (![self.contentView.subviews containsObject:self.rightImageView]) [self.contentView addSubview:self.rightImageView];
    if (![self.subviews containsObject:self.contentView]) [self addSubview:self.contentView];
    if (![self.subviews containsObject:self.closeButton]) [self addSubview:self.closeButton];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = endFrame;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = startFrame;
    }];
}

- (void)dealloc
{
    if ([self.superView.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    _superView      = nil;
    _titleLabel     = nil;
    _subTitleLabel  = nil;
    _leftImage      = nil;
    _leftImageView  = nil;
    _rightImage     = nil;
    _rightImageView = nil;
    _contentView    = nil;
}

- (void)setStyle:(JFMinimalNotificationStytle)style
{
    _currentStyle = style;
    switch (style) {
        case JFMinimalNotificationStyleError: {
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
            gradient.colors = @[(id)[[UIColor redColor] CGColor], (id)[[UIColor blackColor] CGColor]];
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
            gradient.colors = @[(id)[[UIColor greenColor] CGColor], (id)[[UIColor blackColor] CGColor]];
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
            gradient.colors = @[(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor darkGrayColor] CGColor]];
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

- (void)setLeftImage:(UIImage*)image
{
    _leftImage = image;
    // Calculate frame for left image
    CGFloat leftImageY = (kDefaultContentHeight / 2) - (kDefaultImageViewHeight / 2);
    CGRect leftImageFrame = CGRectMake(kDefaultImageViewXPadding,
                                       leftImageY,
                                       kDefaultImageViewWidth,
                                       kDefaultImageViewHeight);
    _leftImageView = [[UIImageView alloc] initWithFrame:leftImageFrame];
    _leftImageView.image = self.leftImage;
    if (![self.subviews containsObject:self.leftImageView]) {
        [self addSubview:self.leftImageView];
    }
}

- (void)setRightImage:(UIImage*)image
{
    _rightImage = image;
    // Calculate frame for right image
    CGFloat rightImageY = (kDefaultContentHeight / 2) - (kDefaultImageViewHeight / 2);
    CGFloat rightImageX = self.superView.frame.size.width - kDefaultImageViewWidth - kDefaultImageViewXPadding;
    CGRect rightImageFrame = CGRectMake(rightImageX,
                                        rightImageY,
                                        kDefaultImageViewWidth,
                                        kDefaultImageViewHeight);
    _rightImageView = [[UIImageView alloc] initWithFrame:rightImageFrame];
    _rightImageView.image = self.rightImage;
    if (![self.subviews containsObject:self.rightImageView]) {
        [self addSubview:self.rightImageView];
    }
}

@end
