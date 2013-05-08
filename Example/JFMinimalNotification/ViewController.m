//
//  ViewController.m
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 5/4/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import "ViewController.h"
#import "JFMinimalNotification.h"

@interface ViewController () <JFMinimalNotificationDelegate>
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     * Create the notification
     *
     * You can also use the following to each the same result:
     * self.minimalNotification = [[JFMinimalNotification alloc] initWithSuperView:self.view];
     * [self.minimalNotification setTitle:@"My Test Title" withSubTitle:@"My Test Sub-Title"];
     * [self.minimalNotification setStyle:JFMinimalNotificationStyleDefault];
     */
    self.minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleDefault
                                                                      title:@"This is my awesome title"
                                                                   subTitle:@"This is my awesome sub-title"
                                                                  superView:self.view];
    
    /**
     * Set the delegate
     */
    self.minimalNotification.delegate = self;
    
    /**
     * Set the desired colors for the title and sub-title labels text
     * Defaults:
     * - Title: [UIColor whiteColor]
     * - Sub-Title: [UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0]
     */
    [self.minimalNotification setTitleColor:[UIColor whiteColor]];
    [self.minimalNotification setSubTitleColor:[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0]];
    
    /**
     * Set the desired font for the title and sub-title labels
     * Default is System Normal
     */
    UIFont* titleFont = [UIFont fontWithName:@"STHeitiK-Light" size:22];
    [self.minimalNotification setTitleFont:titleFont];
    UIFont* subTitleFont = [UIFont fontWithName:@"STHeitiK-Light" size:16];
    [self.minimalNotification setSubTitleFont:subTitleFont];
    
    /**
     * Set the desired close button position
     * Deffault is JFMinimalNotificationCloseBtnPositionRight
     */
    [self.minimalNotification setCloseButtonPosition:JFMinimalNotificationCloseBtnPositionRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)show:(id)sender {
    [self.minimalNotification show];
}

- (IBAction)dismiss:(id)sender {
    [self.minimalNotification dismiss];
}

- (IBAction)setErrorStyle:(id)sender {
    [self.minimalNotification setStyle:JFMinimalNotificationStyleError];
}

- (IBAction)setSuccessStyle:(id)sender {
    [self.minimalNotification setStyle:JFMinimalNotificationStyleSuccess];
}

- (IBAction)setDefaultStyle:(id)sender {
    [self.minimalNotification setStyle:JFMinimalNotificationStyleDefault];
}

- (IBAction)setLeftView:(id)sender {
    /**
     * Set the left view with any UIView or UIView subclass.
     */
    [self.minimalNotification setLeftView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JFMinimalNotification.bundle/check-bw.png"]]];
}

- (IBAction)setRightView:(id)sender {
    /**
     * Set the right view with any UIView or UIView subclass
     * This will automatically recalculate the title and sub-title frame and animate to the new position
     */
    [self.minimalNotification setRightView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JFMinimalNotification.bundle/x-error-bw.png"]]];
}

- (IBAction)removeLeftView:(id)sender {
    /**
     * Remove an existing left view by passing in nil
     * This will automatically recalculate the title and sub-title frame and animate to the new position
     */
    [self.minimalNotification setLeftView:nil];
}

- (IBAction)removeRightView:(id)sender {
    /**
     * Remove an existing right view by passing in nil
     * This will automatically recalculate the title and sub-title frame and animate to the new position
     */
    [self.minimalNotification setRightView:nil];
}

#pragma mark - JFMinimalNotificationDelegate

- (void)willShowNotification:(JFMinimalNotification*)notification {
    NSLog(@"willShowNotification");
}

- (void)didShowNotification:(JFMinimalNotification*)notification {
    NSLog(@"didShowNotification");
}

- (void)willDisimissNotification:(JFMinimalNotification*)notification {
    NSLog(@"willDisimissNotification");
}

- (void)didDismissNotification:(JFMinimalNotification*)notification {
    NSLog(@"didDismissNotification");
}

@end
