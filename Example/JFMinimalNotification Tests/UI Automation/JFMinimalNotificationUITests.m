//
//  JFMinimalNotificationUITests.m
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 4/20/15.
//  Copyright (c) 2015 Jeremy Fox. All rights reserved.
//

#import <KIF/KIF.h>
#import "UIColor+JFMinimalNotificationColors.h"

@interface JFMinimalNotificationUITests : KIFTestCase

@end

@implementation JFMinimalNotificationUITests

- (void)testErrorNotificationIsDisplayerProperly {
    [tester tapViewWithAccessibilityLabel:@"error"];
    
    [tester waitForViewWithAccessibilityLabel:@"title"];
    [tester clearTextFromAndThenEnterText:@"Error Title!" intoViewWithAccessibilityLabel:@"title"];
    
    [tester waitForViewWithAccessibilityLabel:@"subtitle"];
    [tester clearTextFromAndThenEnterText:@"Error Subtitle!" intoViewWithAccessibilityLabel:@"subtitle"];
    
    [tester tapViewWithAccessibilityLabel:@"return"];
    
    [tester waitForAbsenceOfSoftwareKeyboard];
    
    [tester tapViewWithAccessibilityLabel:@"error"];
    [tester tapViewWithAccessibilityLabel:@"show"];
    [tester waitForAnimationsToFinishWithTimeout:1.0];
    
    UIView* titleView = [tester waitForViewWithAccessibilityLabel:@"Notification Title"];
    [tester expectView:titleView toContainText:@"Error Title!"];
    
    UIView* subtitleView = [tester waitForViewWithAccessibilityLabel:@"Notification Subtitle"];
    [tester expectView:subtitleView toContainText:@"Error Subtitle!"];
    
    UIView* contentView = [tester waitForViewWithAccessibilityLabel:@"Noticiation Content View"];
    XCTAssert([contentView.backgroundColor isEqual:[UIColor notificationRedColor]], @"Error notification didn't have red color background");
    
    [tester tapViewWithAccessibilityLabel:@"dismiss"];
}

- (void)testSuccessNotificationIsDisplayerProperly {
    [tester tapViewWithAccessibilityLabel:@"success"];
    
    [tester waitForViewWithAccessibilityLabel:@"title"];
    [tester clearTextFromAndThenEnterText:@"Success Title!" intoViewWithAccessibilityLabel:@"title"];
    
    [tester waitForViewWithAccessibilityLabel:@"subtitle"];
    [tester clearTextFromAndThenEnterText:@"Success Subtitle!" intoViewWithAccessibilityLabel:@"subtitle"];
    
    [tester tapViewWithAccessibilityLabel:@"return"];
    
    [tester waitForAbsenceOfSoftwareKeyboard];
    
    [tester tapViewWithAccessibilityLabel:@"show"];
    [tester waitForAnimationsToFinishWithTimeout:1.0];
    
    UIView* titleView = [tester waitForViewWithAccessibilityLabel:@"Notification Title"];
    [tester expectView:titleView toContainText:@"Success Title!"];
    
    UIView* subtitleView = [tester waitForViewWithAccessibilityLabel:@"Notification Subtitle"];
    [tester expectView:subtitleView toContainText:@"Success Subtitle!"];
    
    UIView* contentView = [tester waitForViewWithAccessibilityLabel:@"Noticiation Content View"];
    XCTAssert([contentView.backgroundColor isEqual:[UIColor notificationGreenColor]], @"Error notification didn't have red color background");
    
    [tester tapViewWithAccessibilityLabel:@"dismiss"];
}

- (void)testInfoNotificationIsDisplayerProperly {
    [tester tapViewWithAccessibilityLabel:@"info"];
    
    [tester waitForViewWithAccessibilityLabel:@"title"];
    [tester clearTextFromAndThenEnterText:@"Info Title!" intoViewWithAccessibilityLabel:@"title"];
    
    [tester waitForViewWithAccessibilityLabel:@"subtitle"];
    [tester clearTextFromAndThenEnterText:@"Info Subtitle!" intoViewWithAccessibilityLabel:@"subtitle"];
    
    [tester tapViewWithAccessibilityLabel:@"return"];
    
    [tester waitForAbsenceOfSoftwareKeyboard];
    
    [tester tapViewWithAccessibilityLabel:@"show"];
    [tester waitForAnimationsToFinishWithTimeout:1.0];
    
    UIView* titleView = [tester waitForViewWithAccessibilityLabel:@"Notification Title"];
    [tester expectView:titleView toContainText:@"Info Title!"];
    
    UIView* subtitleView = [tester waitForViewWithAccessibilityLabel:@"Notification Subtitle"];
    [tester expectView:subtitleView toContainText:@"Info Subtitle!"];
    
    UIView* contentView = [tester waitForViewWithAccessibilityLabel:@"Noticiation Content View"];
    XCTAssert([contentView.backgroundColor isEqual:[UIColor notificationOrangeColor]], @"Error notification didn't have red color background");
    
    [tester tapViewWithAccessibilityLabel:@"dismiss"];
}

- (void)testDefaultNotificationIsDisplayerProperly {
    [tester tapViewWithAccessibilityLabel:@"default"];
    
    [tester waitForViewWithAccessibilityLabel:@"title"];
    [tester clearTextFromAndThenEnterText:@"Default Title!" intoViewWithAccessibilityLabel:@"title"];
    
    [tester waitForViewWithAccessibilityLabel:@"subtitle"];
    [tester clearTextFromAndThenEnterText:@"Default Subtitle!" intoViewWithAccessibilityLabel:@"subtitle"];
    
    [tester tapViewWithAccessibilityLabel:@"return"];
    
    [tester waitForAbsenceOfSoftwareKeyboard];
    
    [tester tapViewWithAccessibilityLabel:@"show"];
    [tester waitForAnimationsToFinishWithTimeout:1.0];
    
    UIView* titleView = [tester waitForViewWithAccessibilityLabel:@"Notification Title"];
    [tester expectView:titleView toContainText:@"Default Title!"];
    
    UIView* subtitleView = [tester waitForViewWithAccessibilityLabel:@"Notification Subtitle"];
    [tester expectView:subtitleView toContainText:@"Default Subtitle!"];
    
    UIView* contentView = [tester waitForViewWithAccessibilityLabel:@"Noticiation Content View"];
    XCTAssert([contentView.backgroundColor isEqual:[UIColor notificationBlueColor]], @"Error notification didn't have red color background");
    
    [tester tapViewWithAccessibilityLabel:@"dismiss"];
}

- (void)testWarningNotificationIsDisplayerProperly {
    [tester tapViewWithAccessibilityLabel:@"warning"];
    
    [tester waitForViewWithAccessibilityLabel:@"title"];
    [tester clearTextFromAndThenEnterText:@"Warning Title!" intoViewWithAccessibilityLabel:@"title"];
    
    [tester waitForViewWithAccessibilityLabel:@"subtitle"];
    [tester clearTextFromAndThenEnterText:@"Warning Subtitle!" intoViewWithAccessibilityLabel:@"subtitle"];
    
    [tester tapViewWithAccessibilityLabel:@"return"];
    
    [tester waitForAbsenceOfSoftwareKeyboard];
    
    [tester tapViewWithAccessibilityLabel:@"show"];
    [tester waitForAnimationsToFinishWithTimeout:1.0];
    
    UIView* titleView = [tester waitForViewWithAccessibilityLabel:@"Notification Title"];
    [tester expectView:titleView toContainText:@"Warning Title!"];
    
    UIView* subtitleView = [tester waitForViewWithAccessibilityLabel:@"Notification Subtitle"];
    [tester expectView:subtitleView toContainText:@"Warning Subtitle!"];
    
    UIView* contentView = [tester waitForViewWithAccessibilityLabel:@"Noticiation Content View"];
    XCTAssert([contentView.backgroundColor isEqual:[UIColor notificationYellowColor]], @"Error notification didn't have red color background");
    
    [tester tapViewWithAccessibilityLabel:@"dismiss"];
}

- (void)testDismissalDelayNotificationDoesntCauseCrashIfDismissalHappensAfterViewHasBeenDismissed {
    // Test for issue: https://github.com/atljeremy/JFMinimalNotifications/issues/10
    [tester tapViewWithAccessibilityLabel:@"details"];
    [tester waitForViewWithAccessibilityLabel:@"dismiss and show"];
    [tester tapViewWithAccessibilityLabel:@"dismiss and show"];
    [tester waitForAnimationsToFinishWithTimeout:1.0];
    [tester waitForTimeInterval:2.5]; // Give the dismissalDelay time to fire NSInvocation
    [tester waitForViewWithAccessibilityLabel:@"details"]; // Make sure we're back on the main view and the app didn't crash
}

@end
