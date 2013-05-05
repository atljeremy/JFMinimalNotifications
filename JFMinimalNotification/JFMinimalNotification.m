//
//  JFMinimalNotification.m
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 5/4/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import "JFMinimalNotification.h"
#import <QuartzCore/QuartzCore.h>

#define kDefaultHeight 90
#define kDefaultImageViewXPadding 15
#define kDefaultImageViewHeight 50
#define kDefaultImageViewWidth 50
#define kDefaultXPadding 10
#define kDefaultYPadding 20

@interface JFMinimalNotification() {
    CGRect startFrame;
    CGRect endFrame;
}
@property (nonatomic, weak, readonly) UIView* superView;
@property (nonatomic, strong, readonly) UILabel* titleLabel;
@property (nonatomic, strong, readonly) UILabel* subTitleLabel;
@property (nonatomic, strong, readonly) NSString* title;
@property (nonatomic, strong, readonly) NSString* subTitle;
@property (nonatomic, strong, readonly) UIImage* leftImage;
@property (nonatomic, strong, readonly) UIImage* rightImage;
@property (nonatomic, strong, readonly) UIImageView* leftImageView;
@property (nonatomic, strong, readonly) UIImageView* rightImageView;
@end

@implementation JFMinimalNotification

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
    
    _superView = view;
    
    // Calculate frame for entire notification view
    CGFloat selfY = view.frame.size.height - kDefaultHeight;
    endFrame = CGRectMake(view.frame.origin.x,
                            selfY,
                            view.frame.size.width,
                            kDefaultHeight);
    
    startFrame = CGRectMake(endFrame.origin.x,
                          view.frame.size.height,
                          endFrame.size.width,
                          endFrame.size.height);
    
    // Calculate frame for title label
    CGFloat titleLabelHeight = (kDefaultHeight - (kDefaultYPadding * 2)) / 1.7;
    CGFloat labelWidth = (view.frame.size.width - (kDefaultXPadding * 2));
    CGRect titleLabelFrame = CGRectMake(kDefaultXPadding,
                                        kDefaultYPadding,
                                        labelWidth,
                                        titleLabelHeight);
    
    // Calculate frame for subtitle label
    CGFloat subTitleHeight = kDefaultHeight - titleLabelFrame.origin.y - titleLabelHeight - kDefaultYPadding;
    CGFloat subTitleY = titleLabelFrame.origin.y + titleLabelFrame.size.height;
    CGRect subTitleLabelFrame = CGRectMake(kDefaultXPadding,
                                           subTitleY,
                                           labelWidth,
                                           subTitleHeight);
    
    if (self = [super initWithFrame:startFrame]) {
        _title = @"JFMinimalNotification Title";
        _titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        _titleLabel.text = _title;
        _subTitle = @"JFMinimalNotification Sub-title";
        _subTitleLabel = [[UILabel alloc] initWithFrame:subTitleLabelFrame];
        _subTitleLabel.text = _subTitle;
    }
    return self;
}

- (void)show
{
    if (![self.superView.subviews containsObject:self]) [self.superView addSubview:self];
    if (![self.subviews containsObject:self.titleLabel]) [self addSubview:self.titleLabel];
    if (![self.subviews containsObject:self.subTitleLabel]) [self addSubview:self.subTitleLabel];
    if (![self.subviews containsObject:self.leftImageView]) [self addSubview:self.leftImageView];
    if (![self.subviews containsObject:self.rightImageView]) [self addSubview:self.rightImageView];
    self.backgroundColor = [UIColor darkGrayColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.subTitleLabel.backgroundColor = [UIColor clearColor];
    [self.titleLabel setShadowColor:[UIColor blackColor]];
    [self.titleLabel setShadowOffset:CGSizeMake(1, 1)];
    [self.subTitleLabel setShadowColor:[UIColor blackColor]];
    [self.subTitleLabel setShadowOffset:CGSizeMake(1, 1)];
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
    _title          = nil;
    _subTitleLabel  = nil;
    _subTitle       = nil;
    _leftImage      = nil;
    _leftImageView  = nil;
    _rightImage     = nil;
    _rightImageView = nil;
}

- (void)setStyle:(JFMinimalNotificationStytle)style
{
    switch (style) {
        case JFMinimalNotificationStyleDefault: {
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
            gradient.colors = @[(id)[[UIColor lightGrayColor] CGColor], (id)[[UIColor darkGrayColor] CGColor]];
            [self.layer insertSublayer:gradient atIndex:0];
            break;
        }
            
        case JFMinimalNotificationStyleError: {
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
            gradient.colors = @[(id)[[UIColor redColor] CGColor], (id)[[UIColor blackColor] CGColor]];
            [self.layer insertSublayer:gradient atIndex:0];
            break;
        }
            
        case JFMinimalNotificationStyleSuccess: {
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = self.bounds;
            gradient.colors = @[(id)[[UIColor greenColor] CGColor], (id)[[UIColor blackColor] CGColor]];
            [self.layer insertSublayer:gradient atIndex:0];
            break;
        }
            
        default:
            break;
    }
}

- (void)setTitle:(NSString*)title withSubTitle:(NSString*)subTitle
{
    _title = title;
    _subTitle = subTitle;
}

- (void)setTitleFont:(UIFont*)font
{
    [_titleLabel setFont:font];
}

- (void)setSubTitleFont:(UIFont*)font
{
    [_subTitleLabel setFont:font];
}

- (void)setTitleColor:(UIColor*)color
{
    [_titleLabel setTextColor:color];
}

- (void)setSubTitleColor:(UIColor*)color
{
    [_subTitleLabel setTextColor:color];
}

- (void)setLeftImage:(UIImage*)image
{
    _leftImage = image;
    // Calculate frame for left image
    CGFloat leftImageY = (kDefaultHeight / 2) - (kDefaultImageViewHeight / 2);
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
    CGFloat rightImageY = (kDefaultHeight / 2) - (kDefaultImageViewHeight / 2);
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
