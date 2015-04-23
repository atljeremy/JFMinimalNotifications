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
    [tester waitForViewWithAccessibilityLabel:@"error"];
    [tester tapViewWithAccessibilityLabel:@"error"];
    [tester tapViewWithAccessibilityLabel:@"show"];
    [tester waitForTimeInterval:2.0];
    [tester waitForViewWithAccessibilityLabel:@"Notification Title"];
}

@end
