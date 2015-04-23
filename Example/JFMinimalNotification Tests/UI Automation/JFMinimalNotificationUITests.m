//
//  JFMinimalNotificationUITests.m
//  JFMinimalNotification
//
//  Created by Jeremy Fox on 4/20/15.
//  Copyright (c) 2015 Jeremy Fox. All rights reserved.
//

#import <KIF/KIF.h>

@interface JFMinimalNotificationUITests : KIFTestCase

@end

@implementation JFMinimalNotificationUITests

- (void)testErrorNotificationIsDisplayerProperly {
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
    
    [tester tapViewWithAccessibilityLabel:@"dismiss"];
}

@end
