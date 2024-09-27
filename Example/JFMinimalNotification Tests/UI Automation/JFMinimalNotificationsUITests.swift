//
//  JFMinimalNotificationsUITests.swift
//  JFMinimalNotification Tests
//
//  Created by Jeremy E Fox on 9/26/24.
//  Copyright © 2024 Jeremy Fox. All rights reserved.
//

class JFMinimalNotificationUITests: KIFTestCase {
    
    var tester: KIFUITestActor!
    
    override func setUp() async throws {
        tester = KIFUITestActor(inFile: #file, atLine: #line, delegate: nil)!
    }
    
    func testErrorNotificationIsDisplayedProperly() {
        tester.tapView(withAccessibilityLabel: "error")
        
        tester.waitForView(withAccessibilityLabel: "title")
        tester.clearText(fromAndThenEnterText: "Error Title!", intoViewWithAccessibilityLabel: "title")
        
        tester.waitForView(withAccessibilityLabel: "subtitle")
        tester.clearText(fromAndThenEnterText: "Error Subtitle!", intoViewWithAccessibilityLabel: "subtitle")
        
        tester.tapView(withAccessibilityLabel: "return")
        
        tester.waitForAbsenceOfSoftwareKeyboard()
        
        tester.tapView(withAccessibilityLabel: "error")
        tester.tapView(withAccessibilityLabel: "show")
        tester.waitForAnimationsToFinish(withTimeout: 1.0)
        
        let titleView = tester.waitForView(withAccessibilityLabel: "Notification Title")!
        tester.expect(titleView, toContainText: "Error Title!")
        
        let subtitleView = tester.waitForView(withAccessibilityLabel: "Notification Subtitle")!
        tester.expect(subtitleView, toContainText: "Error Subtitle!")
        
        if let notification = tester.waitForView(withAccessibilityLabel: "Notification Content View")?.superview {
            XCTAssertEqual(notification.backgroundColor, UIColor.notificationRedColor, "Error: notification didn't have red color background")
        }
        
        tester.tapView(withAccessibilityLabel: "dismiss")
    }
    
    func testSuccessNotificationIsDisplayedProperly() {
        tester.tapView(withAccessibilityLabel: "success")
        
        tester.waitForView(withAccessibilityLabel: "title")
        tester.clearText(fromAndThenEnterText: "Success Title!", intoViewWithAccessibilityLabel: "title")
        
        tester.waitForView(withAccessibilityLabel: "subtitle")
        tester.clearText(fromAndThenEnterText: "Success Subtitle!", intoViewWithAccessibilityLabel: "subtitle")
        
        tester.tapView(withAccessibilityLabel: "return")
        
        tester.waitForAbsenceOfSoftwareKeyboard()
        
        tester.tapView(withAccessibilityLabel: "show")
        tester.waitForAnimationsToFinish(withTimeout: 1.0)
        
        let titleView = tester.waitForView(withAccessibilityLabel: "Notification Title")!
        tester.expect(titleView, toContainText: "Success Title!")
        
        let subtitleView = tester.waitForView(withAccessibilityLabel: "Notification Subtitle")!
        tester.expect(subtitleView, toContainText: "Success Subtitle!")
        
        if let notification = tester.waitForView(withAccessibilityLabel: "Notification Content View")?.superview {
            XCTAssertEqual(notification.backgroundColor, UIColor.notificationGreenColor, "Error: notification didn't have green color background")
        }
        
        tester.tapView(withAccessibilityLabel: "dismiss")
    }
    
    func testInfoNotificationIsDisplayedProperly() {
        tester.tapView(withAccessibilityLabel: "info")
        
        tester.waitForView(withAccessibilityLabel: "title")
        tester.clearText(fromAndThenEnterText: "Info Title!", intoViewWithAccessibilityLabel: "title")
        
        tester.waitForView(withAccessibilityLabel: "subtitle")
        tester.clearText(fromAndThenEnterText: "Info Subtitle!", intoViewWithAccessibilityLabel: "subtitle")
        
        tester.tapView(withAccessibilityLabel: "return")
        
        tester.waitForAbsenceOfSoftwareKeyboard()
        
        tester.tapView(withAccessibilityLabel: "show")
        tester.waitForAnimationsToFinish(withTimeout: 1.0)
        
        let titleView = tester.waitForView(withAccessibilityLabel: "Notification Title")!
        tester.expect(titleView, toContainText: "Info Title!")
        
        let subtitleView = tester.waitForView(withAccessibilityLabel: "Notification Subtitle")!
        tester.expect(subtitleView, toContainText: "Info Subtitle!")
        
        if let notification = tester.waitForView(withAccessibilityLabel: "Notification Content View")?.superview {
            XCTAssertEqual(notification.backgroundColor, UIColor.notificationOrangeColor, "Error: notification didn't have orange color background")
        }
        
        tester.tapView(withAccessibilityLabel: "dismiss")
    }
    
    func testDefaultNotificationIsDisplayedProperly() {
        tester.tapView(withAccessibilityLabel: "default")
        
        tester.waitForView(withAccessibilityLabel: "title")
        tester.clearText(fromAndThenEnterText: "Default Title!", intoViewWithAccessibilityLabel: "title")
        
        tester.waitForView(withAccessibilityLabel: "subtitle")
        tester.clearText(fromAndThenEnterText: "Default Subtitle!", intoViewWithAccessibilityLabel: "subtitle")
        
        tester.tapView(withAccessibilityLabel: "return")
        
        tester.waitForAbsenceOfSoftwareKeyboard()
        
        tester.tapView(withAccessibilityLabel: "show")
        tester.waitForAnimationsToFinish(withTimeout: 1.0)
        
        let titleView = tester.waitForView(withAccessibilityLabel: "Notification Title")!
        tester.expect(titleView, toContainText: "Default Title!")
        
        let subtitleView = tester.waitForView(withAccessibilityLabel: "Notification Subtitle")!
        tester.expect(subtitleView, toContainText: "Default Subtitle!")
        
        if let notification = tester.waitForView(withAccessibilityLabel: "Notification Content View")?.superview {
            XCTAssertEqual(notification.backgroundColor, UIColor.notificationBlueColor, "Error: notification didn't have blue color background")
        }
        
        tester.tapView(withAccessibilityLabel: "dismiss")
    }
    
    func testWarningNotificationIsDisplayedProperly() {
        tester.tapView(withAccessibilityLabel: "warning")
        
        tester.waitForView(withAccessibilityLabel: "title")
        tester.clearText(fromAndThenEnterText: "Warning Title!", intoViewWithAccessibilityLabel: "title")
        
        tester.waitForView(withAccessibilityLabel: "subtitle")
        tester.clearText(fromAndThenEnterText: "Warning Subtitle!", intoViewWithAccessibilityLabel: "subtitle")
        
        tester.tapView(withAccessibilityLabel: "return")
        
        tester.waitForAbsenceOfSoftwareKeyboard()
        
        tester.tapView(withAccessibilityLabel: "show")
        tester.waitForAnimationsToFinish(withTimeout: 1.0)
        
        let titleView = tester.waitForView(withAccessibilityLabel: "Notification Title")!
        tester.expect(titleView, toContainText: "Warning Title!")
        
        let subtitleView = tester.waitForView(withAccessibilityLabel: "Notification Subtitle")!
        tester.expect(subtitleView, toContainText: "Warning Subtitle!")
        
        if let notification = tester.waitForView(withAccessibilityLabel: "Notification Content View")?.superview {
            XCTAssertEqual(notification.backgroundColor, UIColor.notificationYellowColor, "Error: notification didn't have yellow color background")
        }
        
        tester.tapView(withAccessibilityLabel: "dismiss")
    }
    
    func testDismissalDelayNotificationDoesntCauseCrashIfDismissalHappensAfterViewHasBeenDismissed() {
        // Test for issue: https://github.com/atljeremy/JFMinimalNotifications/issues/10
        tester.tapView(withAccessibilityLabel: "details")
        tester.waitForView(withAccessibilityLabel: "dismiss and show")
        tester.tapView(withAccessibilityLabel: "dismiss and show")
        tester.waitForAnimationsToFinish(withTimeout: 1.0)
        tester.wait(forTimeInterval: 2.5) // Give the dismissalDelay time to fire NSInvocation
        tester.waitForView(withAccessibilityLabel: "details") // Make sure we're back on the main view and the app didn't crash
    }
}
