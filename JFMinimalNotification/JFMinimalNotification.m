/*
 * JFMinimalNotification
 *
 * Created by Jeremy Fox on 5/4/13.
 * Copyright (c) 2013 Jeremy Fox. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

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

// Configuration
@property (nonatomic, readwrite) JFMinimalNotificationStytle currentStyle;

// Views
@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong, readwrite) UILabel* titleLabel;
@property (nonatomic, strong, readwrite) UILabel* subTitleLabel;
@property (nonatomic, strong, readwrite) UIView* leftAccessoryView;
@property (nonatomic, strong, readwrite) UIView* righAccessorytView;
@property (nonatomic, strong) UIView* accessoryView;

// Constraints for animations
@property (nonatomic, strong) NSArray* notificationVerticalConstraints;
@property (nonatomic, strong) NSArray* notificationHorizontalConstraints;
@property (nonatomic, strong) NSArray* titleLabelHorizontalConsraints;
@property (nonatomic, strong) NSArray* titleLabelVerticalConsraints;
@property (nonatomic, strong) NSArray* subTitleLabelHorizontalConsraints;
@property (nonatomic, strong) NSArray* subTitleLabelVerticalConsraints;

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
    _titleLabel                         = nil;
    _subTitleLabel                      = nil;
    _leftAccessoryView                  = nil;
    _rightAccessoryView                 = nil;
    _accessoryView                      = nil;
    _contentView                        = nil;
    _touchHandler                       = nil;
    _notificationVerticalConstraints    = nil;
    _notificationHorizontalConstraints  = nil;
    _titleLabelHorizontalConsraints     = nil;
    _titleLabelVerticalConsraints       = nil;
    _subTitleLabelHorizontalConsraints  = nil;
    _subTitleLabelVerticalConsraints    = nil;
    _dismissalTimer                     = nil;
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
    JFMinimalNotification* notification = [[JFMinimalNotification alloc] initWithStyle:style title:title subTitle:subTitle];
    
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
    [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must use one of the designated initializers like notificationWithStyle:title:subTitle:..." userInfo:nil] raise];
    return nil;
}

- (instancetype)initWithStyle:(JFMinimalNotificationStytle)style title:(NSString*)title subTitle:(NSString*)subTitle
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
        
        [self setTitle:title withSubTitle:subTitle];
        [self setStyle:style animated:NO];
        
    }
    return self;
}

#pragma mark ----------------------
#pragma mark UIView Hierarchy
#pragma mark ----------------------

- (void)didMoveToSuperview
{
    if (self.isReadyToDisplay) {
        [self configureInitialNotificationConstraintsForTopPresentation:self.presentFromTop];
    }
}

#pragma mark ----------------------
#pragma mark Presentation
#pragma mark ----------------------

- (BOOL)isReadyToDisplay
{
    return (BOOL)self.superview;
}

- (void)show
{
    if (self.isReadyToDisplay) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(willShowNotification:)]) {
            [self.delegate willShowNotification:self];
        }
        
        [self.superview removeConstraints:self.notificationVerticalConstraints];
        UIView* superview = self.superview;
        UIView* notification = self;
        NSDictionary* views = NSDictionaryOfVariableBindings(superview, notification);
        NSDictionary* metrics = @{@"height": @(kNotificationViewHeight)};
        
        NSString* verticalConstraintString;
        if (self.presentFromTop) {
            verticalConstraintString = @"V:|[notification(==height)]";
        } else {
            verticalConstraintString = @"V:[notification(==height)]|";
        }
        
        self.notificationVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintString options:0 metrics:metrics views:views];
        [self.superview addConstraints:self.notificationVerticalConstraints];
        
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.3f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
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
        [[NSException exceptionWithName:NSInternalInconsistencyException reason:@"Must have a superview before calling show" userInfo:nil] raise];
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
    
    [self configureInitialNotificationConstraintsForTopPresentation:self.presentFromTop];
    
    [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.3f options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDismissNotification:)]) {
            [self.delegate didDismissNotification:self];
        }
    }];
}

- (void)configureInitialNotificationConstraintsForTopPresentation:(BOOL)topPresentation
{
    if (self.notificationVerticalConstraints.count > 0) {
        [self.superview removeConstraints:self.notificationVerticalConstraints];
    }
    if (self.notificationHorizontalConstraints.count > 0) {
        [self.superview removeConstraints:self.notificationHorizontalConstraints];
    }
    UIView* superview = self.superview;
    UIView* notification = self;
    NSDictionary* views = NSDictionaryOfVariableBindings(superview, notification);
    NSDictionary* metrics = @{@"height": @(kNotificationViewHeight)};
    
    NSString* verticalConstraintString;
    if (topPresentation) {
        verticalConstraintString = @"V:[notification(==height)][superview]";
    } else {
        verticalConstraintString = @"V:[superview][notification(==height)]";
    }
    
    self.notificationVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintString options:0 metrics:metrics views:views];
    [self.superview addConstraints:self.notificationVerticalConstraints];
    
    self.notificationHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[notification]|" options:0 metrics:metrics views:views];
    [self.superview addConstraints:self.notificationHorizontalConstraints];
}

#pragma mark ----------------------
#pragma mark Setters / Configuration
#pragma mark ----------------------

- (void)setPresentFromTop:(BOOL)presentFromTop
{
    _presentFromTop = presentFromTop;
    [self configureInitialNotificationConstraintsForTopPresentation:_presentFromTop];
}

- (void)setStyle:(JFMinimalNotificationStytle)style animated:(BOOL)animated
{
    UIImage* image;
    self.accessoryView = nil;
    self.accessoryView = [UIView new];
    self.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.currentStyle = style;
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
            UIColor* primaryColor = [UIColor notificationOrangeColor];
            UIColor* secondaryColor = [UIColor notificationWhiteColor];
            self.contentView.backgroundColor = primaryColor;
            self.titleLabel.textColor = secondaryColor;
            self.subTitleLabel.textColor = secondaryColor;
            image = [JFMinimalNotificationArt imageOfInfoWithColor:primaryColor];
            self.accessoryView.backgroundColor = secondaryColor;
            break;
        }
            
        case JFMinimalNotificationStyleWarning: {
            UIColor* primaryColor = [UIColor notificationYellowColor];
            UIColor* secondaryColor = [UIColor notificationBlackColor];
            self.contentView.backgroundColor = primaryColor;
            self.titleLabel.textColor = secondaryColor;
            self.subTitleLabel.textColor = secondaryColor;
            image = [JFMinimalNotificationArt imageOfWarningWithBGColor:primaryColor forgroundColor:secondaryColor];
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
    [self.accessoryView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.accessoryView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
    [self.accessoryView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.accessoryView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self.accessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[imageView(<=30)]" options:0 metrics:metrics views:views]];
    [self.accessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(<=30)]" options:0 metrics:metrics views:views]];
    [self setLeftAccessoryView:self.accessoryView animated:animated];
}

- (void)setTitle:(NSString*)title withSubTitle:(NSString*)subTitle
{
    if (title && title.length > 0) {
        if (!self.titleLabel) {
            self.titleLabel = [UILabel new];
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:self.titleLabel];
            UIView* titleLabel = self.titleLabel;
            NSDictionary* views = NSDictionaryOfVariableBindings(titleLabel);
            NSDictionary* metrics = @{@"height": @(kNotificationTitleLabelHeight), @"padding": @(kNotificationPadding)};
            self.titleLabelVerticalConsraints = @[[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
            self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[titleLabel]-padding-|" options:0 metrics:metrics views:views];
            
            [self.contentView addConstraints:self.titleLabelVerticalConsraints];
            [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
        }
        
        self.titleLabel.text = title;
    } else {
        [self.titleLabel removeFromSuperview];
        self.titleLabel = nil;
    }
    
    if (subTitle && subTitle.length > 0) {
        if (!self.subTitleLabel) {
            self.subTitleLabel = [UILabel new];
            self.subTitleLabel.text = subTitle;
            self.subTitleLabel.adjustsFontSizeToFitWidth = YES;
            self.subTitleLabel.backgroundColor = [UIColor clearColor];
            self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:self.subTitleLabel];
            UIView* titleLabel = self.titleLabel;
            UIView* subTitleLabel = self.subTitleLabel;
            NSDictionary* views;
            NSDictionary* metrics = @{@"height": @(kNotificationTitleLabelHeight), @"padding": @(kNotificationPadding)};
            if (self.titleLabelVerticalConsraints.count > 0) {
                [self.contentView removeConstraints:self.titleLabelVerticalConsraints];
            }
            if (self.subTitleLabelVerticalConsraints.count > 0) {
                [self.contentView removeConstraints:self.subTitleLabelVerticalConsraints];
            }
            if (titleLabel) {
                views = NSDictionaryOfVariableBindings(titleLabel, subTitleLabel);
                self.subTitleLabelVerticalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[titleLabel(>=height)][subTitleLabel(>=height)]-padding-|" options:0 metrics:metrics views:views];
            } else {
                views = NSDictionaryOfVariableBindings(subTitleLabel);
                self.subTitleLabelVerticalConsraints = @[[NSLayoutConstraint constraintWithItem:self.subTitleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
            }
            self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[subTitleLabel]-padding-|" options:0 metrics:metrics views:views];
            
            [self.contentView addConstraints:self.subTitleLabelVerticalConsraints];
            [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
        }
        
        self.subTitleLabel.text = subTitle;
    } else {
        [self.subTitleLabel removeFromSuperview];
        self.subTitleLabel = nil;
    }
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

- (void)setLeftAccessoryView:(UIView*)view animated:(BOOL)animated
{
    NSTimeInterval animationDuration = (animated) ? 0.3f : 0.0f;
    if (view) {
        [UIView animateWithDuration:animationDuration animations:^{
            self.leftAccessoryView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (![view isEqual:self.leftAccessoryView]) {
                [self.leftAccessoryView removeFromSuperview];
                _leftAccessoryView = view;
                _leftAccessoryView.translatesAutoresizingMaskIntoConstraints = NO;
                self.leftAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
                self.leftAccessoryView.alpha = 0.0f;
                [self.contentView addSubview:self.leftAccessoryView];
                NSDictionary* views;
                NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
                UIView* rightView = self.rightAccessoryView;
                UIView* leftView = self.leftAccessoryView;
                UIView* titleLabel = self.titleLabel;
                UIView* subTitleLabel = self.subTitleLabel;
                NSString* visualFormat;
                
                views = NSDictionaryOfVariableBindings(leftView);
                [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.leftAccessoryView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0.f]];
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[leftView(==60)]" options:0 metrics:nil views:views]];
                
                if (titleLabel) {
                    if (rightView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, leftView, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, leftView);
                    }
                    [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                    self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                }
                
                if (subTitleLabel) {
                    if (rightView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, leftView, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, leftView);
                    }
                    [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                    self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                }
                
                [self layoutIfNeeded];
                [self.leftAccessoryView makeRound];
                [UIView animateWithDuration:animationDuration animations:^{
                    self.leftAccessoryView.alpha = 1.0f;
                }];
            }
        }];
    } else {
        if ([self.contentView.subviews containsObject:self.leftAccessoryView]) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.leftAccessoryView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.leftAccessoryView.subviews enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger idx, BOOL *stop) {
                    [subview removeFromSuperview];
                }];
                
                NSDictionary* views;
                NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
                UIView* rightView = self.rightAccessoryView;
                UIView* titleLabel = self.titleLabel;
                UIView* subTitleLabel = self.subTitleLabel;
                NSString* visualFormat;
                
                if (titleLabel) {
                    if (rightView) {
                        visualFormat = @"H:|-padding-[titleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[titleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel);
                    }
                    [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                    self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                }
                
                if (subTitleLabel) {
                    if (rightView) {
                        visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel);
                    }
                    [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                    self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                }
                
                [UIView animateWithDuration:animationDuration animations:^{
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [_leftAccessoryView removeFromSuperview];
                    _leftAccessoryView = nil;
                }];
            }];
        }
    }
}

- (void)setRightAccessoryView:(UIView*)view animated:(BOOL)animated
{
    NSTimeInterval animationDuration = (animated) ? 0.3f : 0.0f;
    if (view) {
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
                
                if (titleLabel) {
                    if (leftView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, leftView, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[titleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, rightView);
                    }
                    [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                    self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rightView(==60)]" options:0 metrics:nil views:views]];
                }
                
                if (subTitleLabel) {
                    if (leftView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, leftView, rightView);
                    } else {
                        visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, rightView);
                    }
                    [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                    self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                }
                
                [self layoutIfNeeded];
                [self.rightAccessoryView makeRound];
                [UIView animateWithDuration:animationDuration animations:^{
                    self.rightAccessoryView.alpha = 1.0f;
                }];
            }
        }];
    } else {
        if ([self.contentView.subviews containsObject:self.rightAccessoryView]) {
            [UIView animateWithDuration:animationDuration animations:^{
                self.rightAccessoryView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.rightAccessoryView.subviews enumerateObjectsUsingBlock:^(UIView* subview, NSUInteger idx, BOOL *stop) {
                    [subview removeFromSuperview];
                }];
                
                NSDictionary* views;
                NSDictionary* metrics = @{@"padding": @(kNotificationAccessoryPadding)};
                UIView* leftView = self.leftAccessoryView;
                UIView* titleLabel = self.titleLabel;
                UIView* subTitleLabel = self.subTitleLabel;
                NSString* visualFormat;
                
                if (titleLabel) {
                    if (leftView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel, leftView);
                    } else {
                        visualFormat = @"H:|-padding-[titleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(titleLabel);
                    }
                    [self.contentView removeConstraints:self.titleLabelHorizontalConsraints];
                    self.titleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.titleLabelHorizontalConsraints];
                }
                
                if (subTitleLabel) {
                    if (leftView) {
                        visualFormat = @"H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel, leftView);
                    } else {
                        visualFormat = @"H:|-padding-[subTitleLabel(>=100)]-padding-|";
                        views = NSDictionaryOfVariableBindings(subTitleLabel);
                    }
                    [self.contentView removeConstraints:self.subTitleLabelHorizontalConsraints];
                    self.subTitleLabelHorizontalConsraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
                    [self.contentView addConstraints:self.subTitleLabelHorizontalConsraints];
                }
                
                [UIView animateWithDuration:animationDuration animations:^{
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
