//
//  JFMinimalNotificationTests.swift
//  JFMinimalNotification Tests
//
//  Created by Jeremy E Fox on 9/26/24.
//  Copyright © 2024 Jeremy Fox. All rights reserved.
//

import UIKit
import XCTest
@testable import JFMinimalNotification

class JFMinimalNotification_Tests: XCTestCase, JFMinimalNotificationDelegate {

    var viewController: ViewController!
    var titleTextField: UITextField!
    var subTitleTextField: UITextField!
    var expectation: XCTestExpectation?
    var allowShowFulfillment: Bool = true
    
    override func setUp() {
        super.setUp()
        titleTextField = UITextField()
        subTitleTextField = UITextField()
        viewController = ViewController()
        viewController.titleLabelTextField = titleTextField
        viewController.subTitleLabelTextField = subTitleTextField
        viewController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
        allowShowFulfillment = true
    }
    
    override func tearDown() {
        expectation = nil
        super.tearDown()
    }
    
    func testNotificationIsAssignedAValidSuperview() {
        viewController.view.addSubview(viewController.minimalNotification!)
        viewController.view.layoutIfNeeded()
        let notificationMinY = viewController.minimalNotification!.frame.minY
        let viewMaxY = viewController.view.frame.maxY
        XCTAssertNotNil(viewController.minimalNotification!.superview, "Notification must have a superview before being displayed")
        XCTAssert(notificationMinY >= viewMaxY, "Notification should be placed at the bottom of its superview - outside the visible area of the view")
    }
    
    func testNotificationIsDisplayed() {
        expectation = self.expectation(description: "Animation Complete Expectation")
        viewController.showToast(withMessage: "Testing...")
        viewController.minimalNotification?.delegate = self
        waitForExpectations(timeout: 5.0) { error in
            let notificationMinY = self.viewController.minimalNotification!.frame.minY
            let viewMaxY = self.viewController.view.frame.maxY
            XCTAssert(notificationMinY < viewMaxY, "Notification must be visible - within the view's visible rect")
        }
    }
    
    func testNotificationIsDismissed() {
        expectation = self.expectation(description: "Animation Complete Expectation")
        viewController.minimalNotification?.delegate = self
        viewController.dismiss()
        waitForExpectations(timeout: 5.0) { error in
            let notificationMinY = self.viewController.minimalNotification!.frame.minY
            let viewMaxY = self.viewController.view.frame.maxY
            XCTAssert(notificationMinY >= viewMaxY, "Notification should be placed at the bottom of its superview - outside the visible area of the view")
        }
    }
    
    func testRepeatedCallsToShowAndDismissWorkProperly() {
        expectation = self.expectation(description: "Animation Complete Expectation")
        
        // Repeated calls to show and dismiss
        viewController.showToast(withMessage: "Testing...")
        viewController.dismiss()
        viewController.showToast(withMessage: "Testing...")
        viewController.dismiss()
        viewController.showToast(withMessage: "Testing...")
        viewController.dismiss()
        viewController.showToast(withMessage: "Testing...")
        viewController.dismiss()
        viewController.showToast(withMessage: "Testing...")
        viewController.dismiss()
        viewController.showToast(withMessage: "Testing...")
        viewController.dismiss()
        
        viewController.showToast(withMessage: "Testing...")
        
        viewController.dismiss()
        viewController.dismiss()
        viewController.dismiss()
        
        viewController.showToast(withMessage: "Testing...")
        viewController.showToast(withMessage: "Testing...")
        viewController.showToast(withMessage: "Testing...")
        
        viewController.minimalNotification?.delegate = self
        viewController.dismiss()
        
        waitForExpectations(timeout: 5.0) { error in
            let notificationMinY = self.viewController.minimalNotification!.frame.minY
            let viewMaxY = self.viewController.view.frame.maxY
            XCTAssert(notificationMinY >= viewMaxY, "Notification should be placed at the bottom of its superview - outside the visible area of the view")
        }
    }
    
    func testAsyncCallsToShowAndDismissWorkProperly() {
        allowShowFulfillment = false
        expectation = self.expectation(description: "Animation Complete Expectation")
        viewController.minimalNotification?.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewController.minimalNotification?.show()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.01) {
            self.viewController.minimalNotification?.dismiss()
        }
        
        waitForExpectations(timeout: 5.0) { error in
            let notificationMinY = self.viewController.minimalNotification!.frame.minY
            let viewMaxY = self.viewController.view.frame.maxY
            XCTAssert(notificationMinY >= viewMaxY, "Notification should be placed at the bottom of its superview - outside the visible area of the view")
        }
    }
    
    // MARK: - JFMinimalNotificationDelegate
    
    func minimalNotificationWillShow(notification: JFMinimalNotification) {}
    
    func minimalNotificationDidShow(notification: JFMinimalNotification) {
        if allowShowFulfillment, let expectation = expectation {
            expectation.fulfill()
        }
    }
    
    func minimalNotificationWillDismiss(notification: JFMinimalNotification) {}
    
    func minimalNotificationDidDismiss(notification: JFMinimalNotification) {
        expectation?.fulfill()
    }
    
}
