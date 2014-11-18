//
//  JFMinimalNotification.m
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 5/4/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import "JFMinimalNotification.h"
#import "JFMinimalNotificationArt.h"
#import "UIView+Round.h"
#import "UIColor+JFMinimalNotificationColors.h"
#import "NSInvocation+Constructors.h"

static CGFloat const kNotificationViewHeight = 85.0f;
static CGFloat const kNotificationTitleLabelHeight = 20.0f;
static CGFloat const kNotificationPadding = 20.0f;
static CGFloat const kNotificationAccessoryPadding = 10.0f;

@interface JFMinimalNotification()

// Views
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong, readwrite) UILabel* titleLabel;
@property (nonatomic, strong, readwrite) UILabel* subTitleLabel;
@property (nonatomic, strong, readwrite) UIView* leftAccessoryView;
@property (nonatomic, strong, readwrite) UIView* righAccessorytView;
@property (nonatomic, strong) UIView* accessoryView;

// Constraints for animations
@property (nonatomic, weak) NSLayoutConstraint* notificationYConstraint;
@property (nonatomic, strong) NSArray* titleLabelHorizontalConsraints;
@property (nonatomic, strong) NSArray* subTitleLabelHorizontalConsraints;

// Touch Handling
@property (nonatomic, copy) JFMinimalNotificationTouchHandler touchHandler;

// Dismissal
@property (nonatomic, assign) NSTimeInterval dismissalDelay;
@property (nonatomic, strong) NSTimer* dismissalTimer;

- (BOOL)isReadyToDisplay;
@end

@implementation JFMinimalNotification

- (void)dealloc
{
    if ([self.superview.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    _titleLabel              = nil;
    _subTitleLabel           = nil;
    _leftAccessoryView       = nil;
    _rightAccessoryView      = nil;
    _accessoryView           = nil;
    _contentView             = nil;
    _touchHandler            = nil;
    _notificationYConstraint = nil;
}

+ (instancetype)notificationWithStyle:(JFMinimalNotificationStytle)style title:(NSString*)title subTitle:(NSString*)subTitle
{
    return [self notificationWithStyle:style title:title subTitle:subTitle dismissalDelay:0];
}

+ (instancetype)notificationWithStyle:(JFMinimalNotificationStytle)style title:(NSString *)title subTitle:(NSString *)subTitle dismissalDelay:(NSTimeInterval)dismissalDelay
{
    return [self notificationWithStyle:style title:title subTitle:subTitle dismissalDelay:dismissalDelay touchHandler:nil];
}

+ (instancetype)notificationWithStyle:(JFMinimalNotificationStytle)style title:(NSString *)title subTitle:(NSString *)subTitle dismissalDelay:(NSTimeInterval)dismissalDelay touchHandler:(JFMinimalNotificationTouchHandler)touchHandler
{
    JFMinimalNotification* notification = [JFMinimalNotification new];
    [notification setStyle:style];
    [notification setTitle:title withSubTitle:subTitle];
    
    if (dismissalDelay > 0) {
        notification.dismissalDelay = dismissalDelay;
    }
    
    if (touchHandler) {
        notification.touchHandler = touchHandler;
        UITapGestureRecognizer* tapHandler = [[UITapGestureRecognizer alloc] initWithTarget:notification action:@selector(handleTap)];
        notification.userInteractionEnabled = YES;
        [notification addGestureRecognizer:tapHandler];
    }
    
    return notification;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        UIView* contentView = _contentView;
        NSDictionary* views = NSDictionaryOfVariableBindings(contentView);
        [self addSubview:_contentView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views]];
        
        _leftAccessoryView = [UIView new];
        _leftAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
        _rightAccessoryView = [UIView new];
        _rightAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
        UIView* leftView = _leftAccessoryView;
        UIView* rightView = _rightAccessoryView;
        [_contentView addSubview:_leftAccessoryView];
        [_contentView addSubview:_rightAccessoryView];
        NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
        views = NSDictionaryOfVariableBindings(leftView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[leftView]-padding-|" options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[leftView(==50)]" options:0 metrics:metrics views:views]];
        views = NSDictionaryOfVariableBindings(rightView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[rightView]-padding-|" options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightView(==50)]-padding-|" options:0 metrics:metrics views:views]];
        
        _titleLabel = [UILabel new];
        _titleLabel.text = @"JFMinimalNotification Title";
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addSubview:_titleLabel];
        UIView* titleLabel = _titleLabel;
        views = NSDictionaryOfVariableBindings(titleLabel, leftView, rightView);
        metrics = @{@"height": @(kNotificationTitleLabelHeight), @"padding": @(kNotificationPadding)};
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[titleLabel(==height)]" options:0 metrics:metrics views:views]];
        self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftView]-padding-[titleLabel]-padding-[rightView]" options:0 metrics:metrics views:views];
        [_contentView addConstraints:self.titleLabelHorizontalConsraints];
        
        _subTitleLabel = [UILabel new];
        _subTitleLabel.text = @"JFMinimalNotification Sub-title";
        _subTitleLabel.adjustsFontSizeToFitWidth = YES;
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentView addSubview:_subTitleLabel];
        UIView* subTitleLabel = _subTitleLabel;
        views = NSDictionaryOfVariableBindings(titleLabel, subTitleLabel, leftView, rightView);
        metrics = @{@"height": @(kNotificationTitleLabelHeight), @"padding": @(kNotificationPadding)};
        [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel][subTitleLabel(==height)]" options:0 metrics:metrics views:views]];
        self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftView]-padding-[subTitleLabel]-padding-[rightView]" options:0 metrics:metrics views:views];
        [_contentView addConstraints:self.subTitleLabelHorizontalConsraints];
        
        _currentStyle = JFMinimalNotificationStyleDefault;
        
        _leftAccessoryView = nil;
        _rightAccessoryView = nil;
    }
    return self;
}

#pragma mark ----------------------
#pragma mark UIView Hierarchy
#pragma mark ----------------------

- (void)didMoveToSuperview
{
    if (self.isReadyToDisplay) {
        UIView* superview = self.superview;
        UIView* notification = self;
        NSDictionary* views = NSDictionaryOfVariableBindings(superview, notification);
        NSDictionary* metrics = @{@"height": @(kNotificationViewHeight)};
        NSArray* constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview][notification(==height)]" options:0 metrics:metrics views:views];
        self.notificationYConstraint = [constraints firstObject];
        [self.superview addConstraints:constraints];
        [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[notification]|" options:0 metrics:metrics views:views]];
    }
}

#pragma mark ----------------------
#pragma mark Presentation
#pragma mark ----------------------

- (BOOL)isReadyToDisplay
{
    return self.superview;
}

- (void)show
{
    if (self.isReadyToDisplay) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(willShowNotification:)]) {
            [self.delegate willShowNotification:self];
        }
        
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.3f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            self.notificationYConstraint.constant -= kNotificationViewHeight;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            if (self.dismissalDelay > 0) {
                NSInvocation* dismissalInvocation = [NSInvocation invocationWithTarget:self selector:@selector(dismiss)];
                self.dismissalTimer = [NSTimer scheduledTimerWithTimeInterval:self.dismissalDelay invocation:dismissalInvocation repeats:NO];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(didShowNotification:)]) {
                [self.delegate didShowNotification:self];
            }
        }];
    } else {
        [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must have a superview before calling show" userInfo:@{NSLocalizedDescriptionKey: @"-show was called before adding the notification to a superview that is contained in the application window."}];
    }
}

- (void)dismiss
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willDisimissNotification:)]) {
        [self.delegate willDisimissNotification:self];
    }
    
    if (self.dismissalTimer) {
        [self.dismissalTimer invalidate];
        self.dismissalTimer = nil;
    }
    
    [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.3f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        self.notificationYConstraint.constant += kNotificationViewHeight;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissNotification:)]) {
            [self.delegate didDismissNotification:self];
        }
    }];
}

#pragma mark ----------------------
#pragma mark Setters / Configuration
#pragma mark ----------------------

- (void)setStyle:(JFMinimalNotificationStytle)style
{
    UIImage* image;
    self.accessoryView = nil;
    self.accessoryView = [UIView new];
    self.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    
    _currentStyle = style;
    switch (style) {
        case JFMinimalNotificationStyleError: {
            UIColor* primaryColor = [UIColor notificationRedColor];
            UIColor* secondaryColor = [UIColor notificationWhiteColor];
            self.contentView.backgroundColor = primaryColor;
            self.titleLabel.textColor = secondaryColor;
            self.subTitleLabel.textColor = secondaryColor;
            image = [JFMinimalNotificationArt imageOfCrossWithColor:primaryColor];
            self.accessoryView.backgroundColor = secondaryColor;
            break;
        }
            
        case JFMinimalNotificationStyleSuccess: {
            UIColor* primaryColor = [UIColor notificationGreenColor];
            UIColor* secondaryColor = [UIColor notificationWhiteColor];
            self.contentView.backgroundColor = primaryColor;
            self.titleLabel.textColor = secondaryColor;
            self.subTitleLabel.textColor = secondaryColor;
            image = [JFMinimalNotificationArt imageOfCheckmarkWithColor:primaryColor];
            self.accessoryView.backgroundColor = secondaryColor;
            break;
        }
            
        case JFMinimalNotificationStyleInfo: {
            UIColor* primaryColor = [UIColor notificationYellowColor];
            UIColor* secondaryColor = [UIColor notificationBlackColor];
            self.contentView.backgroundColor = primaryColor;
            self.titleLabel.textColor = secondaryColor;
            self.subTitleLabel.textColor = secondaryColor;
            image = [JFMinimalNotificationArt imageOfInfoWithColor:primaryColor];
            self.accessoryView.backgroundColor = secondaryColor;
            break;
        }
            
        case JFMinimalNotificationStyleDefault:
        default: {
            UIColor* primaryColor = [UIColor notificationBlueColor];
            UIColor* secondaryColor = [UIColor notificationWhiteColor];
            self.contentView.backgroundColor = primaryColor;
            self.titleLabel.textColor = secondaryColor;
            self.subTitleLabel.textColor = secondaryColor;
            image = [JFMinimalNotificationArt imageOfInfoWithColor:primaryColor];
            self.accessoryView.backgroundColor = secondaryColor;
            break;
        }
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.accessoryView addSubview:imageView];
    NSDictionary* views = NSDictionaryOfVariableBindings(imageView);
    NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
    [self.accessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[imageView(<=40)]-padding-|" options:0 metrics:metrics views:views]];
    [self.accessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[imageView(<=40)]-padding-|" options:0 metrics:metrics views:views]];
    [self setLeftAccessoryView:self.accessoryView];
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

- (void)setLeftAccessoryView:(UIView*)view
{
    if (view) {
        NSTimeInterval animationDuration = (self.leftAccessoryView) ? 0.3f : 0.0f;
        [UIView animateWithDuration:animationDuration animations:^{
            self.leftAccessoryView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (![view isEqual:self.leftAccessoryView]) {
                [self.leftAccessoryView removeFromSuperview];
                _leftAccessoryView = view;
                _leftAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
                [self.contentView addSubview:self.leftAccessoryView];
                UIView* leftView = self.leftAccessoryView;
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftAccessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
                self.leftAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
                self.leftAccessoryView.alpha = 0.0f;
                
                NSDictionary* views;
                NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
                UIView* rightView = self.rightAccessoryView;
                UIView* titleLabel = self.titleLabel;
                UIView* subTitleLabel = self.subTitleLabel;
                NSString* visualFormat;
                if (rightView) {
                    visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-[rightView(==60)]-padding-|";
                    views = NSDictionaryOfVariableBindings(titleLabel, subTitleLabel, leftView, rightView);
                } else {
                    visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-|";
                    views = NSDictionaryOfVariableBindings(titleLabel, subTitleLabel, leftView);
                }
                [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[leftView(==60)]" options:0 metrics:nil views:views]];
                
                if (rightView) {
                    visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-[rightView(==60)]-padding-|";
                } else {
                    visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-|";
                }
                [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                
                [self layoutIfNeeded];
                [self.leftAccessoryView makeRound];
                [UIView animateWithDuration:0.3 animations:^{
                    self.leftAccessoryView.alpha = 1.0f;
                }];
            }
        }];
    } else {
        if ([self.contentView.subviews containsObject:self.leftAccessoryView]) {
            [UIView animateWithDuration:0.3 animations:^{
                self.leftAccessoryView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.leftAccessoryView.subviews enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger idx, BOOL *stop) {
                    [subview removeFromSuperview];
                }];
                
                NSDictionary* views;
                NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
                UIView* leftView = self.leftAccessoryView;
                UIView* rightView = self.rightAccessoryView;
                UIView* titleLabel = self.titleLabel;
                UIView* subTitleLabel = self.subTitleLabel;
                NSString* visualFormat;
                if (rightView) {
                    visualFormat = @"H:|-padding-[titleLabel(>=100)]-[rightView(==60)]-padding-|";
                    views = NSDictionaryOfVariableBindings(titleLabel, subTitleLabel, leftView, rightView);
                } else {
                    visualFormat = @"H:|-padding-[titleLabel(>=100)]-padding-|";
                    views = NSDictionaryOfVariableBindings(titleLabel, subTitleLabel, leftView);
                }
                [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                
                if (rightView) {
                    visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|";
                } else {
                    visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-padding-|";
                }
                [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                
                [UIView animateWithDuration:0.3 animations:^{
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [_leftAccessoryView removeFromSuperview];
                    _leftAccessoryView = nil;
                }];
            }];
        }
    }
}

- (void)setRightAccessoryView:(UIView*)view
{
    if (view) {
        NSTimeInterval animationDuration = (self.rightAccessoryView) ? 0.3f : 0.0f;
        [UIView animateWithDuration:animationDuration animations:^{
            self.rightAccessoryView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (![view isEqual:self.rightAccessoryView]) {
                [self.rightAccessoryView removeFromSuperview];
                _rightAccessoryView = view;
                _rightAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
                [self.contentView addSubview:self.rightAccessoryView];
                UIView* rightView = self.rightAccessoryView;
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.rightAccessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
                self.rightAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
                self.rightAccessoryView.alpha = 0.0f;
                
                NSDictionary* views;
                NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
                UIView* leftView = self.leftAccessoryView;
                UIView* titleLabel = self.titleLabel;
                UIView* subTitleLabel = self.subTitleLabel;
                NSString* visualFormat;
                if (leftView) {
                    visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-[rightView(==60)]-padding-|";
                    views = NSDictionaryOfVariableBindings(titleLabel, subTitleLabel, leftView, rightView);
                } else {
                    visualFormat = @"H:|-padding-[titleLabel(>=100)]-[rightView(==60)]-padding-|";
                    views = NSDictionaryOfVariableBindings(titleLabel, subTitleLabel, rightView);
                }
                [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rightView(==60)]" options:0 metrics:nil views:views]];
                
                if (leftView) {
                    visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|";
                } else {
                    visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|";
                }
                [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                
                [self layoutIfNeeded];
                [self.rightAccessoryView makeRound];
                [UIView animateWithDuration:0.3 animations:^{
                    self.rightAccessoryView.alpha = 1.0f;
                }];
            }
        }];
    } else {
        if ([self.contentView.subviews containsObject:self.rightAccessoryView]) {
            [UIView animateWithDuration:0.3 animations:^{
                self.rightAccessoryView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.rightAccessoryView.subviews enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger idx, BOOL *stop) {
                    [subview removeFromSuperview];
                }];
                
                NSDictionary* views;
                NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
                UIView* leftView = self.leftAccessoryView;
                UIView* rightView = self.rightAccessoryView;
                UIView* titleLabel = self.titleLabel;
                UIView* subTitleLabel = self.subTitleLabel;
                NSString* visualFormat;
                if (leftView) {
                    visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-|";
                    views = NSDictionaryOfVariableBindings(titleLabel, subTitleLabel, leftView, rightView);
                } else {
                    visualFormat = @"H:|-padding-[titleLabel(>=100)]-padding-|";
                    views = NSDictionaryOfVariableBindings(titleLabel, subTitleLabel, rightView);
                }
                [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                
                if (leftView) {
                    visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-|";
                } else {
                    visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-padding-|";
                }
                [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                
                [UIView animateWithDuration:0.3 animations:^{
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [_rightAccessoryView removeFromSuperview];
                    _rightAccessoryView = nil;
                }];
            }];
        }
    }
}

#pragma mark ----------------------
#pragma mark Touch Handler
#pragma mark ----------------------

- (void)handleTap
{
    if (self.touchHandler) {
        self.touchHandler();
    }
}

@end
