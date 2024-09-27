//
//  DetailViewController.swift
//  JFMinimalNotification
//
//  Created by Jeremy E Fox on 9/26/24.
//  Copyright © 2024 Jeremy Fox. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var notification: JFMinimalNotification?
    
    deinit {
        notification = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notification = JFMinimalNotification(
            withStyle: .success,
            title: "Testing",
            subTitle: "Testing 1 2 3",
            dismissalDelay: 2.0,
            touchHandler: { [weak self] in
                self?.notification?.dismiss()
            }
        )
        notification?.edgePadding = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        if let notificationView = notification {
            navigationController?.view.addSubview(notificationView)
        }
        
        notification?.presentFromTop = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notification?.show()
    }
    
    @IBAction func dismissAndShowNotificationAfterDelayAction(_ sender: Any) {
        // This simulates the view being dismissed and deallocated before the notification is shown.
        // This is to reproduce a potential crash similar to https://github.com/atljeremy/JFMinimalNotifications/issues/10
        navigationController?.popViewController(animated: true)
    }
}
