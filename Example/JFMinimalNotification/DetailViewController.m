//
//  DetailViewController.m
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 5/1/15.
//  Copyright (c) 2015 Jeremy Fox. All rights reserved.
//

#import "DetailViewController.h"
#import "JFMinimalNotification.h"

@interface DetailViewController ()
@property (nonatomic, strong) JFMinimalNotification* notification;
@end

@implementation DetailViewController

- (void)dealloc
{
    self.notification = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.notification = [JFMinimalNotification notificationWithStyle:JFMinimalNotificationStyleSuccess title:@"Testing" subTitle:@"Testing 1 2 3" dismissalDelay:2.0];
    [self.view addSubview:self.notification];
    self.notification.presentFromTop = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.notification show];
}

- (IBAction)dismissAndShowNotificationAfterDelayAction:(id)sender {
    
    // This is to simulate the view being dismissed, and therby deallocated, before the notification is shown. This causes a similar crash as reported here https://github.com/atljeremy/JFMinimalNotifications/issues/10
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
