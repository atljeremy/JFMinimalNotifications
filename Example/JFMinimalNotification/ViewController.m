//
//  ViewController.m
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 5/4/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import "ViewController.h"
#import "JFMinimalNotification.h"

@interface ViewController () <JFMinimalNotificationDelegate, UITextFieldDelegate>
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabelTextField.text = @"Testing";
    self.subTitleLabelTextField.text = @"This is my awesome sub-title";
    
    /**
     * Create the notification
     */
    self.minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleBlurLight title:self.titleLabelTextField.text subTitle:self.subTitleLabelTextField.text dismissalDelay:0.0 touchHandler:^{
        [self.minimalNotification dismiss];
    }];
    
    self.minimalNotification.edgePadding = UIEdgeInsetsMake(0, 0, 10, 0);
    
    [self.view addSubview:self.minimalNotification];
    
    /**
     * Set the delegate
     */
    self.minimalNotification.delegate = self;
    
    /**
     * Set the desired font for the title and sub-title labels
     * Default is System Normal
     */
    UIFont* titleFont = [UIFont fontWithName:@"STHeitiK-Light" size:22];
    [self.minimalNotification setTitleFont:titleFont];
    UIFont* subTitleFont = [UIFont fontWithName:@"STHeitiK-Light" size:16];
    [self.minimalNotification setSubTitleFont:subTitleFont];
    
    /**
     * Uncomment the following line to present notifications from the top of the screen.
     */
    // self.minimalNotification.presentFromTop = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)showToastWithMessage:(NSString *)message {
    if (self.minimalNotification) {
        [self.minimalNotification dismiss];
        [self.minimalNotification removeFromSuperview];
        self.minimalNotification = nil;
    }
    
    self.minimalNotification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleError
                                                          title:NSLocalizedString(@"Refresh Error", @"Refresh Error")
                                                       subTitle:message
                                                 dismissalDelay:10.0];
    
    /**
     * Set the desired font for the title and sub-title labels
     * Default is System Normal
     */
    UIFont* titleFont = [UIFont systemFontOfSize:22.0];
    [self.minimalNotification setTitleFont:titleFont];
    UIFont* subTitleFont = [UIFont systemFontOfSize:16.0];
    [self.minimalNotification setSubTitleFont:subTitleFont];
    
    /**
     * Add the notification to a view
     */
    [self.view addSubview:self.minimalNotification];
    
    // show
    [self performSelector:@selector(showNotification) withObject:nil afterDelay:0.1];
}

- (void)showNotification {
    [self.minimalNotification show];
}

- (IBAction)show:(id)sender {
    [self.minimalNotification show];
}

- (IBAction)dismiss:(id)sender {
    [self.minimalNotification dismiss];
}

- (IBAction)setLightStyle:(id)sender {
    [self.minimalNotification setStyle:JFMinimalNotificationStyleBlurLight animated:YES];
}

- (IBAction)setDarkStyle:(id)sender {
    [self.minimalNotification setStyle:JFMinimalNotificationStyleBlurDark animated:YES];
}

- (IBAction)setCustomStyle:(id)sender {
    [self.minimalNotification setStyle:JFMinimalNotificationStyleCustom animated:YES];
}

- (IBAction)setErrorStyle:(id)sender {
    [self.minimalNotification setStyle:JFMinimalNotificationStyleError animated:YES];
}

- (IBAction)setSuccessStyle:(id)sender {
    [self.minimalNotification setStyle:JFMinimalNotificationStyleSuccess animated:YES];
}

- (IBAction)setDefaultStyle:(id)sender {
    [self.minimalNotification setStyle:JFMinimalNotificationStyleDefault animated:YES];
}

- (IBAction)setInfoStyle:(id)sender {
    [self.minimalNotification setStyle:JFMinimalNotificationStyleInfo animated:YES];
}

- (IBAction)setWarningStyle:(id)sender {
    [self.minimalNotification setStyle:JFMinimalNotificationStyleWarning animated:YES];
}

- (IBAction)setLeftView:(id)sender {
    /**
     * Set the left view with any UIView or UIView subclass.
     */
    [self.minimalNotification setLeftAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumbs-up.jpg"]] animated:YES];
}

- (IBAction)setRightView:(id)sender {
    /**
     * Set the right view with any UIView or UIView subclass
     * This will automatically recalculate the title and sub-title frame and animate to the new position
     */
    [self.minimalNotification setRightAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumbs-up.jpg"]] animated:YES];
}

- (IBAction)removeLeftView:(id)sender {
    /**
     * Remove an existing left view by passing in nil
     * This will automatically recalculate the title and sub-title frame and animate to the new position
     */
    [self.minimalNotification setLeftAccessoryView:nil animated:YES];
}

- (IBAction)removeRightView:(id)sender {
    /**
     * Remove an existing right view by passing in nil
     * This will automatically recalculate the title and sub-title frame and animate to the new position
     */
    [self.minimalNotification setRightAccessoryView:nil animated:YES];
}

#pragma mark ----------------------
#pragma mark UITextFieldDelegate
#pragma mark ----------------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    JFMinimalNotificationStyle style = self.minimalNotification.currentStyle;
    [self.minimalNotification removeFromSuperview];
    self.minimalNotification = nil;
    self.minimalNotification = [JFMinimalNotification notificationWithStyle:style title:self.titleLabelTextField.text subTitle:self.subTitleLabelTextField.text dismissalDelay:0.0f touchHandler:^{
        [self.minimalNotification dismiss];
    }];
    self.minimalNotification.delegate = self;
    UIFont* titleFont = [UIFont fontWithName:@"STHeitiK-Light" size:22];
    [self.minimalNotification setTitleFont:titleFont];
    UIFont* subTitleFont = [UIFont fontWithName:@"STHeitiK-Light" size:16];
    [self.minimalNotification setSubTitleFont:subTitleFont];
    [self.view addSubview:self.minimalNotification];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.minimalNotification show];
    });
    
    return YES;
}

#pragma mark ----------------------
#pragma mark JFMinimalNotificationDelegate
#pragma mark ----------------------

- (void)minimalNotificationWillShowNotification:(JFMinimalNotification*)notification {
    NSLog(@"willShowNotification");
}

- (void)minimalNotificationDidShowNotification:(JFMinimalNotification*)notification {
    NSLog(@"didShowNotification");
}

- (void)minimalNotificationWillDisimissNotification:(JFMinimalNotification*)notification {
    NSLog(@"willDisimissNotification");
}

- (void)minimalNotificationDidDismissNotification:(JFMinimalNotification*)notification {
    NSLog(@"didDismissNotification");
}

@end
