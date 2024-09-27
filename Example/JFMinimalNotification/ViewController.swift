//
//  ViewController.swift
//  JFMinimalNotification
//
//  Created by Jeremy E Fox on 9/26/24.
//  Copyright © 2024 Jeremy Fox. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JFMinimalNotificationDelegate, UITextFieldDelegate {
    
    var minimalNotification: JFMinimalNotification?
    
    @IBOutlet weak var titleLabelTextField: UITextField!
    @IBOutlet weak var subTitleLabelTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabelTextField.text = "Testing"
        subTitleLabelTextField.text = "This is my awesome sub-title"
        
        // Create the notification
        minimalNotification = JFMinimalNotification(
            withStyle: .custom,
            title: titleLabelTextField.text ?? "",
            subTitle: subTitleLabelTextField.text ?? ""
        ) {
            self.minimalNotification?.dismiss()
        }
        
        minimalNotification?.edgePadding = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        view.addSubview(minimalNotification!)
        minimalNotification?.backgroundColor = .purple
        minimalNotification?.titleLabel?.textColor = .white
        minimalNotification?.subTitleLabel?.textColor = .white
        
        // Set the delegate
        minimalNotification?.delegate = self
        
        // Set the desired font for title and subtitle labels
        if let titleFont = UIFont(name: "STHeitiK-Light", size: 22) {
            minimalNotification?.setTitleFont(titleFont)
        }
        if let subTitleFont = UIFont(name: "STHeitiK-Light", size: 16) {
            minimalNotification?.setSubTitleFont(subTitleFont)
        }
        
        // Uncomment to present notification from the top of the screen
//         minimalNotification?.presentFromTop = true
    }
    
    func showToast(withMessage message: String) {
        minimalNotification?.dismiss()
        minimalNotification?.removeFromSuperview()
        minimalNotification = nil
        
        minimalNotification = JFMinimalNotification(
            withStyle: .error,
            title: NSLocalizedString("Refresh Error", comment: "Refresh Error"),
            subTitle: message,
            dismissalDelay: 10.0
        )
        
        // Set the desired font for title and subtitle labels
        minimalNotification?.setTitleFont(UIFont.systemFont(ofSize: 22.0))
        minimalNotification?.setSubTitleFont(UIFont.systemFont(ofSize: 16.0))
        
        // Add the notification to a view
        view.addSubview(minimalNotification!)
        
        // Show after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showNotification()
        }
    }
    
    @objc func showNotification() {
        minimalNotification?.show()
    }
    
    @IBAction func show(_ sender: Any? = nil) {
        minimalNotification?.show()
    }
    
    @IBAction func dismiss(_ sender: Any? = nil) {
        minimalNotification?.dismiss()
    }
    
    @IBAction func setLightStyle(_ sender: Any? = nil) {
        minimalNotification?.setStyle(.blurLight, animated: true)
    }
    
    @IBAction func setDarkStyle(_ sender: Any? = nil) {
        minimalNotification?.setStyle(.blurDark, animated: true)
    }
    
    @IBAction func setCustomStyle(_ sender: Any? = nil) {
        minimalNotification?.setStyle(.custom, animated: true)
    }
    
    @IBAction func setErrorStyle(_ sender: Any? = nil) {
        minimalNotification?.setStyle(.error, animated: true)
    }
    
    @IBAction func setSuccessStyle(_ sender: Any? = nil) {
        minimalNotification?.setStyle(.success, animated: true)
    }
    
    @IBAction func setDefaultStyle(_ sender: Any? = nil) {
        minimalNotification?.setStyle(.default, animated: true)
    }
    
    @IBAction func setInfoStyle(_ sender: Any? = nil) {
        minimalNotification?.setStyle(.info, animated: true)
    }
    
    @IBAction func setWarningStyle(_ sender: Any? = nil) {
        minimalNotification?.setStyle(.warning, animated: true)
    }
    
    @IBAction func setLeftView(_ sender: Any? = nil) {
        // Set the left view with any UIView or UIView subclass
        minimalNotification?.setLeftAccessoryView(UIImageView(image: UIImage(named: "thumbs-up.jpg")), animated: true)
    }
    
    @IBAction func setRightView(_ sender: Any? = nil) {
        // Set the right view with any UIView or UIView subclass
        minimalNotification?.setRightAccessoryView(UIImageView(image: UIImage(named: "thumbs-up.jpg")), animated: true)
    }
    
    @IBAction func removeLeftView(_ sender: Any? = nil) {
        // Remove an existing left view by passing nil
        minimalNotification?.setLeftAccessoryView(nil, animated: true)
    }
    
    @IBAction func removeRightView(_ sender: Any? = nil) {
        // Remove an existing right view by passing nil
        minimalNotification?.setRightAccessoryView(nil, animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let style = minimalNotification?.currentStyle
        minimalNotification?.removeFromSuperview()
        minimalNotification = nil
        minimalNotification = JFMinimalNotification(
            withStyle: style ?? .custom,
            title: titleLabelTextField.text ?? "",
            subTitle: subTitleLabelTextField.text ?? "",
            dismissalDelay: 0.0
        ) {
            self.minimalNotification?.dismiss()
        }
        minimalNotification?.delegate = self
        minimalNotification?.setTitleFont(UIFont(name: "STHeitiK-Light", size: 22)!)
        minimalNotification?.setSubTitleFont(UIFont(name: "STHeitiK-Light", size: 16)!)
        view.addSubview(minimalNotification!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.minimalNotification?.show()
        }
        
        return true
    }
    
    // MARK: - JFMinimalNotificationDelegate
    
    func minimalNotificationWillShow(notification: JFMinimalNotification) {
        print("willShowNotification")
    }
    
    func minimalNotificationDidShow(notification: JFMinimalNotification) {
        print("didShowNotification")
    }
    
    func minimalNotificationWillDismiss(notification: JFMinimalNotification) {
        print("willDisimissNotification")
    }
    
    func minimalNotificationDidDismiss(notification: JFMinimalNotification) {
        print("didDismissNotification")
    }
}
