//
//  ViewController.m
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 5/4/13.
//  Copyright (c) 2013 Jeremy Fox. All rights reserved.
//

#import "ViewController.h"
#import "JFMinimalNotification.h"

@interface ViewController ()
@property (nonatomic, strong) JFMinimalNotification* minimalNotification;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     *
     */
    self.minimalNotification = [[JFMinimalNotification alloc] initWithSuperView:self.view];
    
    /**
     *
     */
    [self.minimalNotification setTitle:@"My Test Title" withSubTitle:@"My Test Sub-Title"];
    
    /**
     *
     */
    [self.minimalNotification setTitleColor:[UIColor whiteColor]];
    [self.minimalNotification setSubTitleColor:[UIColor colorWithRed:215.0f/255.0f green:215.0f/255.0f blue:215.0f/255.0f alpha:1.0]];
    
    /**
     *
     */
    UIFont* titleFont = [UIFont fontWithName:@"STHeitiK-Light" size:22];
    [self.minimalNotification setTitleFont:titleFont];
    UIFont* subTitleFont = [UIFont fontWithName:@"STHeitiK-Light" size:16];
    [self.minimalNotification setSubTitleFont:subTitleFont];
    
    /**
     *
     */
    [self.minimalNotification setStyle:JFMinimalNotificationStyleSuccess];
    
    /**
     *
     */
    [self.minimalNotification setCloseButtonPosition:JFMinimalNotificationCloseBtnPositionLeft];
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
    /**
     *
     */
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
     *
     */
    [self.minimalNotification setLeftView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JFMinimalNotification.bundle/check-bw.png"]]];
}

- (IBAction)setRightView:(id)sender {
    /**
     *
     */
    [self.minimalNotification setRightView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"JFMinimalNotification.bundle/x-error-bw.png"]]];
}

- (IBAction)removeLeftView:(id)sender {
    /**
     *
     */
    [self.minimalNotification setLeftView:nil];
}

- (IBAction)removeRightView:(id)sender {
    /**
     *
     */
    [self.minimalNotification setRightView:nil];
}
@end
