//
//  JFMinimalNotification.swift
//  JFMinimalNotification
//
//  Created by Jeremy E Fox on 9/25/24.
//  Copyright © 2024 Jeremy Fox. All rights reserved.
//

import UIKit

public enum JFMinimalNotificationStyle {
    case `default`
    case error
    case success
    case info
    case warning
    
    /**
     * @return Used to get a title and subtitle, no accessory views, and white background with black label text. Use the `backgroundColor` property on the notification to set the desired background color and `textColor` property on the titleLabel and subTitleLabel UILabels to change text color.
     */
    case custom
    
    /**
     * @return A dark blur with vibrancy effect in the background with white label text.
     */
    case blurDark
    
    /**
     * @return A light blur with vibrancy effect in the background with black label text.
     */
    case blurLight
}

public typealias JFMinimalNotificationTouchHandler = () -> Void

public protocol JFMinimalNotificationDelegate: AnyObject {
    func minimalNotificationWillShow(notification: JFMinimalNotification)
    func minimalNotificationDidShow(notification: JFMinimalNotification)
    func minimalNotificationWillDismiss(notification: JFMinimalNotification)
    func minimalNotificationDidDismiss(notification: JFMinimalNotification)
}

public class JFMinimalNotification: UIView {

    // MARK: - Public Properties
    
    /// The titleLabel used to display the title text in the notification.
    public private(set) var titleLabel: UILabel!

    /// The subTitleLabel used to display the subtitle text in the notification.
    public private(set) var subTitleLabel: UILabel!

    /// The UIView displayed in the left accessory view of the notification.
    public private(set) var leftAccessoryView: UIView!

    /// The UIView displayed in the right accessory view of the notification.
    public private(set) var rightAccessoryView: UIView!

    /// The current JFMinimalNotificationStyle of the notification.
    public private(set) var currentStyle: JFMinimalNotificationStyle

    /// Used to present the notification from the top of the screen.
    public var presentFromTop: Bool = false {
        didSet {
            configureInitialNotificationConstraints(forTopPresentation: presentFromTop, layoutIfNeeded: true)
        }
    }

    /// The delegate for the notification.
    public weak var delegate: JFMinimalNotificationDelegate?

    /// The edge padding to be used for the notification's layout.
    public var edgePadding: UIEdgeInsets = .zero
    
    // MARK: - Private Properties
    
    private static let notificationViewHeight: CGFloat = 85.0
    private static let notificationTitleLabelHeight: CGFloat = 20.0
    private static let notificationPadding: CGFloat = 20.0
    private static let notificationAccessoryPadding: CGFloat = 10.0
    
    // MARK: - Views
    private var contentView: UIView!
    private var accessoryView: UIView!
    private var blurView: UIVisualEffectView!
    private var vibrancyView: UIVisualEffectView!

    // MARK: - Content view constraints
    private var contentViewVerticalConstraints: [NSLayoutConstraint] = []
    private var contentViewHorizontalConstraints: [NSLayoutConstraint] = []

    // MARK: - Constraints for animations
    private var notificationVerticalConstraints: [NSLayoutConstraint] = []
    private var notificationHorizontalConstraints: [NSLayoutConstraint] = []
    private var titleLabelHorizontalConstraints: [NSLayoutConstraint] = []
    private var titleLabelVerticalConstraints: [NSLayoutConstraint] = []
    private var subTitleLabelHorizontalConstraints: [NSLayoutConstraint] = []
    private var subTitleLabelVerticalConstraints: [NSLayoutConstraint] = []

    // MARK: - Touch Handling
    private var touchHandler: JFMinimalNotificationTouchHandler?

    // MARK: - Dismissal
    private var dismissalDelay: TimeInterval = 0
    private var dismissalTimer: Timer?
    
    private var isReadyToDisplay: Bool {
        return superview != nil
    }

    // MARK: - Initializers

    public init(
        withStyle style: JFMinimalNotificationStyle,
        title: String,
        subTitle: String,
        dismissalDelay: TimeInterval = 0,
        touchHandler: JFMinimalNotificationTouchHandler? = nil
    ) {
        self.currentStyle = style
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Initialize contentView
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.accessibilityLabel = "Notification Content View"
        
        // Add contentView to the view hierarchy
        addSubview(contentView)
        
        // Create constraints for contentView
        contentViewVerticalConstraints = [
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        contentViewHorizontalConstraints = [
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        // Activate constraints
        NSLayoutConstraint.activate(contentViewVerticalConstraints)
        NSLayoutConstraint.activate(contentViewHorizontalConstraints)
        
        // Set the title and subtitle
        setTitle(title, withSubTitle: subTitle)
        
        // Set the style
        setStyle(style, animated: false)
        
        if dismissalDelay > 0 {
            self.dismissalDelay = dismissalDelay
        }
        
        if let handler = touchHandler {
            self.touchHandler = handler
            let tapHandler = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            isUserInteractionEnabled = true
            addGestureRecognizer(tapHandler)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Must use the designated initializer JFMinimalNotification(withStyle:title:subtitle:)")
    }
    
    deinit {
        if self.superview?.subviews.contains(where: { $0 == self }) == true {
            self.removeFromSuperview()
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.isReadyToDisplay {
            configureInitialNotificationConstraints(forTopPresentation: self.presentFromTop, layoutIfNeeded: true)
        }
    }
    
    // MARK: - Public
    
    // MARK: Presentation

    /// Presents the notification.
    public func show() {
        guard isReadyToDisplay else {
            fatalError("Must have a superview before calling show")
        }

        delegate?.minimalNotificationWillShow(notification: self)
        
        superview?.removeConstraints(notificationVerticalConstraints)
        
        let safeAreaPadding = presentFromTop ? safeAreaInsets.top : safeAreaInsets.bottom
        let views = ["notification": self]
        let metrics = ["height": JFMinimalNotification.notificationViewHeight + edgePadding.top + edgePadding.bottom + safeAreaPadding]
        
        let verticalConstraintString = presentFromTop ? "V:|[notification(==height)]" : "V:[notification(==height)]|"
        notificationVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalConstraintString, options: [], metrics: metrics, views: views)
        
        superview?.addConstraints(notificationVerticalConstraints)
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .allowAnimatedContent, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: { finished in
            if self.dismissalDelay > 0 {
                self.dismissalTimer = Timer.scheduledTimer(withTimeInterval: self.dismissalDelay, repeats: false) { _ in
                    self.dismiss()
                }
            }
            
            self.delegate?.minimalNotificationDidShow(notification: self)
        })
    }

    /// Dismisses the notification.
    public func dismiss() {
        delegate?.minimalNotificationWillDismiss(notification: self)
        
        dismissalTimer?.invalidate()
        dismissalTimer = nil
        
        configureInitialNotificationConstraints(forTopPresentation: presentFromTop, layoutIfNeeded: false)
        
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .allowAnimatedContent, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: { finished in
            self.delegate?.minimalNotificationDidDismiss(notification: self)
        })
    }

    // MARK: Appearance
    
    /// Sets the style for the notification and updates the UI accordingly.
    ///
    /// - Parameters:
    ///   - style: The `JFMinimalNotificationStyle` to be applied to the notification.
    ///   - animated: A `Bool` indicating whether the style change should be animated.
    public func setStyle(_ style: JFMinimalNotificationStyle, animated: Bool) {
        currentStyle = style
        
        removeBlurViews()
        
        switch style {
        case .blurDark:
            let primaryColor = UIColor.clear
            let secondaryColor = UIColor.white
            backgroundColor = primaryColor
            titleLabel?.textColor = secondaryColor
            subTitleLabel?.textColor = secondaryColor
            configureBlurView(forBlurEffectStyle: .dark)
            
        case .blurLight:
            let primaryColor = UIColor.clear
            let secondaryColor = UIColor.black
            backgroundColor = primaryColor
            titleLabel?.textColor = secondaryColor
            subTitleLabel?.textColor = secondaryColor
            configureBlurView(forBlurEffectStyle: .light)
            
        case .custom:
            let primaryColor = UIColor.white
            let secondaryColor = UIColor.black
            backgroundColor = primaryColor
            titleLabel?.textColor = secondaryColor
            subTitleLabel?.textColor = secondaryColor
            
        case .error:
            let primaryColor = UIColor.notificationRedColor
            let secondaryColor = UIColor.notificationWhiteColor
            backgroundColor = primaryColor
            titleLabel?.textColor = secondaryColor
            subTitleLabel?.textColor = secondaryColor
            
        case .success:
            let primaryColor = UIColor.notificationGreenColor
            let secondaryColor = UIColor.notificationWhiteColor
            backgroundColor = primaryColor
            titleLabel?.textColor = secondaryColor
            subTitleLabel?.textColor = secondaryColor
            
        case .info:
            let primaryColor = UIColor.notificationOrangeColor
            let secondaryColor = UIColor.notificationWhiteColor
            backgroundColor = primaryColor
            titleLabel?.textColor = secondaryColor
            subTitleLabel?.textColor = secondaryColor
            
        case .warning:
            let primaryColor = UIColor.notificationYellowColor
            let secondaryColor = UIColor.notificationBlackColor
            backgroundColor = primaryColor
            titleLabel?.textColor = secondaryColor
            subTitleLabel?.textColor = secondaryColor
            
        case .default:
            fallthrough
        default:
            let primaryColor = UIColor.notificationBlueColor
            let secondaryColor = UIColor.notificationWhiteColor
            backgroundColor = primaryColor
            titleLabel?.textColor = secondaryColor
            subTitleLabel?.textColor = secondaryColor
        }
        
        setAccessoryView(forStyle: style, animated: animated)
    }

    /// Sets the title label font.
    public func setTitleFont(_ font: UIFont) {
        titleLabel.font = font
    }

    /// Sets the subtitle label font.
    public func setSubTitleFont(_ font: UIFont) {
        subTitleLabel.font = font
    }
    
    /// Sets the left accessory view for the notification.
    ///
    /// - Parameters:
    ///   - view: The `UIView` to be applied displayed as the left accessory view.
    ///   - animated: A `Bool` indicating whether the change should be animated.
    public func setLeftAccessoryView(_ view: UIView?, animated: Bool) {
        let animationDuration: TimeInterval = animated ? 0.3 : 0.0
        
        if let newView = view {
            UIView.animate(withDuration: animationDuration, animations: {
                self.leftAccessoryView?.alpha = 0.0
            }) { _ in
                if newView != self.leftAccessoryView {
                    self.leftAccessoryView?.removeFromSuperview()
                    self.leftAccessoryView = newView
                    self.leftAccessoryView?.accessibilityLabel = "Left Accessory"
                    self.leftAccessoryView?.translatesAutoresizingMaskIntoConstraints = false
                    self.leftAccessoryView?.contentMode = .scaleAspectFit
                    self.leftAccessoryView?.alpha = 0.0
                    self.contentView.addSubview(self.leftAccessoryView!)
                    
                    let padding = JFMinimalNotification.notificationAccessoryPadding
                    
                    // Center Y constraint
                    self.contentView.addConstraint(NSLayoutConstraint(
                        item: self.leftAccessoryView!,
                        attribute: .centerY,
                        relatedBy: .equal,
                        toItem: self.contentView,
                        attribute: .centerY,
                        multiplier: 1.0,
                        constant: 0.0
                    ))
                    
                    // Height constraint
                    self.contentView.addConstraints(NSLayoutConstraint.constraints(
                        withVisualFormat: "V:[leftView(==60)]",
                        options: [],
                        metrics: nil,
                        views: ["leftView": self.leftAccessoryView!]
                    ))
                    
                    // Horizontal constraints
                    if let titleLabel = self.titleLabel {
                        var views: [String: UIView] = ["leftView": self.leftAccessoryView!, "titleLabel": titleLabel]
                        var visualFormat: String
                        if let rightView = self.rightAccessoryView {
                            views["rightView"] = rightView
                            visualFormat = "H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-[rightView(==60)]-padding-|"
                        } else {
                            visualFormat = "H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-|"
                        }
                        
                        self.contentView.removeConstraints(self.titleLabelHorizontalConstraints)
                        self.titleLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                            withVisualFormat: visualFormat,
                            options: [],
                            metrics: ["padding": padding],
                            views: views
                        )
                        self.contentView.addConstraints(self.titleLabelHorizontalConstraints)
                    }
                    
                    if let subTitleLabel = self.subTitleLabel {
                        var views: [String: UIView] = ["leftView": self.leftAccessoryView!, "subTitleLabel": subTitleLabel]
                        var visualFormat: String
                        if let rightView = self.rightAccessoryView {
                            views["rightView"] = rightView
                            visualFormat = "H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-[rightView(==60)]-padding-|"
                        } else {
                            visualFormat = "H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-|"
                        }
                        
                        self.contentView.removeConstraints(self.subTitleLabelHorizontalConstraints)
                        self.subTitleLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                            withVisualFormat: visualFormat,
                            options: [],
                            metrics: ["padding": padding],
                            views: views
                        )
                        self.contentView.addConstraints(self.subTitleLabelHorizontalConstraints)
                    }
                    
                    self.layoutIfNeeded()
                    self.leftAccessoryView?.makeRound()
                    
                    UIView.animate(withDuration: animationDuration) {
                        self.leftAccessoryView?.alpha = 1.0
                    }
                }
            }
        } else {
            if let leftView = self.leftAccessoryView, self.contentView.subviews.contains(leftView) {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.leftAccessoryView?.alpha = 0.0
                }) { _ in
                    self.leftAccessoryView?.subviews.forEach { $0.removeFromSuperview() }
                    
                    let padding = JFMinimalNotification.notificationAccessoryPadding
                    
                    // Horizontal constraints without left accessory view
                    if let titleLabel = self.titleLabel {
                        var views: [String: UIView] = ["titleLabel": titleLabel]
                        var visualFormat: String
                        if let rightView = self.rightAccessoryView {
                            views["rightView"] = rightView
                            visualFormat = "H:|-padding-[titleLabel(>=100)]-[rightView(==60)]-padding-|"
                        } else {
                            visualFormat = "H:|-padding-[titleLabel(>=100)]-padding-|"
                        }
                        
                        self.contentView.removeConstraints(self.titleLabelHorizontalConstraints)
                        self.titleLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                            withVisualFormat: visualFormat,
                            options: [],
                            metrics: ["padding": padding],
                            views: views
                        )
                        self.contentView.addConstraints(self.titleLabelHorizontalConstraints)
                    }
                    
                    if let subTitleLabel = self.subTitleLabel {
                        var views: [String: UIView] = ["subTitleLabel": subTitleLabel]
                        var visualFormat: String
                        if let rightView = self.rightAccessoryView {
                            views["rightView"] = rightView
                            visualFormat = "H:|-padding-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|"
                        } else {
                            visualFormat = "H:|-padding-[subTitleLabel(>=100)]-padding-|"
                        }
                        
                        self.contentView.removeConstraints(self.subTitleLabelHorizontalConstraints)
                        self.subTitleLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                            withVisualFormat: visualFormat,
                            options: [],
                            metrics: ["padding": padding],
                            views: views
                        )
                        self.contentView.addConstraints(self.subTitleLabelHorizontalConstraints)
                    }
                    
                    UIView.animate(withDuration: animationDuration, animations: {
                        self.layoutIfNeeded()
                    }) { _ in
                        self.leftAccessoryView?.removeFromSuperview()
                        self.leftAccessoryView = nil
                    }
                }
            }
        }
    }

    /// Sets the right accessory view for the notification.
    ///
    /// - Parameters:
    ///   - view: The `UIView` to be applied displayed as the right accessory view.
    ///   - animated: A `Bool` indicating whether the change should be animated.
    public func setRightAccessoryView(_ view: UIView?, animated: Bool) {
        let animationDuration: TimeInterval = animated ? 0.3 : 0.0
        
        if let newView = view {
            UIView.animate(withDuration: animationDuration, animations: {
                self.rightAccessoryView?.alpha = 0.0
            }) { _ in
                if newView != self.rightAccessoryView {
                    self.rightAccessoryView?.removeFromSuperview()
                    self.rightAccessoryView = newView
                    self.rightAccessoryView?.accessibilityLabel = "Right Accessory"
                    self.rightAccessoryView?.translatesAutoresizingMaskIntoConstraints = false
                    self.contentView.addSubview(self.rightAccessoryView!)
                    
                    if let rightView = self.rightAccessoryView {
                        // Center Y constraint
                        self.contentView.addConstraint(NSLayoutConstraint(
                            item: rightView,
                            attribute: .centerY,
                            relatedBy: .equal,
                            toItem: self.contentView,
                            attribute: .centerY,
                            multiplier: 1.0,
                            constant: 0.0
                        ))
                        
                        rightView.contentMode = .scaleAspectFit
                        rightView.alpha = 0.0
                        
                        let padding = JFMinimalNotification.notificationAccessoryPadding
                        
                        // Horizontal constraints for titleLabel and rightView
                        if let titleLabel = self.titleLabel {
                            var views: [String: UIView] = ["titleLabel": titleLabel, "rightView": rightView]
                            var visualFormat: String
                            
                            if let leftView = self.leftAccessoryView {
                                views["leftView"] = leftView
                                visualFormat = "H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-[rightView(==60)]-padding-|"
                            } else {
                                visualFormat = "H:|-padding-[titleLabel(>=100)]-[rightView(==60)]-padding-|"
                            }
                            
                            self.contentView.removeConstraints(self.titleLabelHorizontalConstraints)
                            self.titleLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                                withVisualFormat: visualFormat,
                                options: [],
                                metrics: ["padding": padding],
                                views: views
                            )
                            self.contentView.addConstraints(self.titleLabelHorizontalConstraints)
                            self.contentView.addConstraints(NSLayoutConstraint.constraints(
                                withVisualFormat: "V:[rightView(==60)]",
                                options: [],
                                metrics: nil,
                                views: views
                            ))
                        }
                        
                        // Horizontal constraints for subTitleLabel and rightView
                        if let subTitleLabel = self.subTitleLabel {
                            var views: [String: UIView] = ["subTitleLabel": subTitleLabel, "rightView": rightView]
                            var visualFormat: String
                            
                            if let leftView = self.leftAccessoryView {
                                views["leftView"] = leftView
                                visualFormat = "H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|"
                            } else {
                                visualFormat = "H:|-padding-[subTitleLabel(>=100)]-[rightView(==60)]-padding-|"
                            }
                            
                            self.contentView.removeConstraints(self.subTitleLabelHorizontalConstraints)
                            self.subTitleLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                                withVisualFormat: visualFormat,
                                options: [],
                                metrics: ["padding": padding],
                                views: views
                            )
                            self.contentView.addConstraints(self.subTitleLabelHorizontalConstraints)
                        }
                        
                        self.layoutIfNeeded()
                        rightView.makeRound()
                        
                        UIView.animate(withDuration: animationDuration) {
                            rightView.alpha = 1.0
                        }
                    }
                }
            }
        } else {
            if let rightView = self.rightAccessoryView, self.contentView.subviews.contains(rightView) {
                UIView.animate(withDuration: animationDuration, animations: {
                    rightView.alpha = 0.0
                }) { _ in
                    rightView.subviews.forEach { $0.removeFromSuperview() }
                    
                    let padding = JFMinimalNotification.notificationAccessoryPadding
                    
                    // Horizontal constraints without right accessory view
                    if let titleLabel = self.titleLabel {
                        var views: [String: UIView] = ["titleLabel": titleLabel]
                        var visualFormat: String
                        
                        if let leftView = self.leftAccessoryView {
                            views["leftView"] = leftView
                            visualFormat = "H:|-padding-[leftView(==60)]-[titleLabel(>=100)]-padding-|"
                        } else {
                            visualFormat = "H:|-padding-[titleLabel(>=100)]-padding-|"
                        }
                        
                        self.contentView.removeConstraints(self.titleLabelHorizontalConstraints)
                        self.titleLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                            withVisualFormat: visualFormat,
                            options: [],
                            metrics: ["padding": padding],
                            views: views
                        )
                        self.contentView.addConstraints(self.titleLabelHorizontalConstraints)
                    }
                    
                    if let subTitleLabel = self.subTitleLabel {
                        var views: [String: UIView] = ["subTitleLabel": subTitleLabel]
                        var visualFormat: String
                        
                        if let leftView = self.leftAccessoryView {
                            views["leftView"] = leftView
                            visualFormat = "H:|-padding-[leftView(==60)]-[subTitleLabel(>=100)]-padding-|"
                        } else {
                            visualFormat = "H:|-padding-[subTitleLabel(>=100)]-padding-|"
                        }
                        
                        self.contentView.removeConstraints(self.subTitleLabelHorizontalConstraints)
                        self.subTitleLabelHorizontalConstraints = NSLayoutConstraint.constraints(
                            withVisualFormat: visualFormat,
                            options: [],
                            metrics: ["padding": padding],
                            views: views
                        )
                        self.contentView.addConstraints(self.subTitleLabelHorizontalConstraints)
                    }
                    
                    UIView.animate(withDuration: animationDuration, animations: {
                        self.layoutIfNeeded()
                    }) { _ in
                        rightView.removeFromSuperview()
                        self.rightAccessoryView = nil
                    }
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func configureInitialNotificationConstraints(forTopPresentation topPresentation: Bool, layoutIfNeeded: Bool) {
        if notificationVerticalConstraints.count > 0 {
            superview?.removeConstraints(notificationVerticalConstraints)
        }
        
        if notificationHorizontalConstraints.count > 0 {
            superview?.removeConstraints(notificationHorizontalConstraints)
        }
        
        guard let superview = self.superview, let contentView = self.contentView else {
            return
        }
        
        if edgePadding.top > 0 || edgePadding.bottom > 0 {
            removeConstraints(contentViewVerticalConstraints)
            let views = ["contentView": contentView]
            let metrics = ["height": JFMinimalNotification.notificationViewHeight, "toppadding": edgePadding.top, "bottompadding": edgePadding.bottom]
            let visualForamt = topPresentation ? "V:[contentView(==height)]-bottompadding-|" : "V:|-toppadding-[contentView(==height)]"
            contentViewVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: visualForamt, options: [], metrics: metrics, views: views)
            addConstraints(contentViewVerticalConstraints)
        }
        
        if edgePadding.left > 0 || edgePadding.right > 0 {
            removeConstraints(contentViewHorizontalConstraints)
            let views = ["contentView": contentView]
            let metrics = ["leftpadding": JFMinimalNotification.notificationPadding + edgePadding.left, "rightpadding": JFMinimalNotification.notificationPadding + edgePadding.right]
            contentViewHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-leftpadding-[contentView]-rightpadding-|", options: [], metrics: metrics, views: views)
            addConstraints(contentViewHorizontalConstraints)
        }
        
        let views = ["superview": superview, "notification": self]
        
        let verticalConstraintString = topPresentation ? "V:[notification]-1-[superview]" : "V:[superview]-1-[notification]"
        notificationVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalConstraintString, options: [], metrics: nil, views: views)
        superview.addConstraints(notificationVerticalConstraints)
        
        notificationHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[notification]|", options: [], metrics: nil, views: views)
        superview.addConstraints(notificationHorizontalConstraints)
        
        if layoutIfNeeded {
            superview.layoutIfNeeded()
        }
    }

    private func configureBlurView(forBlurEffectStyle blurStyle: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: blurStyle)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView?.translatesAutoresizingMaskIntoConstraints = false
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView?.translatesAutoresizingMaskIntoConstraints = false
        
        insertSubview(blurView!, belowSubview: contentView)
        insertSubview(vibrancyView!, belowSubview: contentView)
        
        let views = ["blurView": blurView!, "vibrancyView": vibrancyView!]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[blurView]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[blurView]|", options: [], metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[vibrancyView]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[vibrancyView]|", options: [], metrics: nil, views: views))
    }

    private func removeBlurViews() {
        blurView?.removeFromSuperview()
        blurView = nil
        
        vibrancyView?.removeFromSuperview()
        vibrancyView = nil
    }
    
    private func setTitle(_ title: String?, withSubTitle subTitle: String?) {
        // Handle title
        if let title = title, !title.isEmpty {
            if titleLabel == nil {
                titleLabel = UILabel()
                titleLabel.accessibilityLabel = "Notification Title"
                titleLabel.adjustsFontSizeToFitWidth = true
                titleLabel.backgroundColor = .clear
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(titleLabel)
                
                // Setup title label constraints
                titleLabelVerticalConstraints = [
                    titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ]
                
                let padding = JFMinimalNotification.notificationPadding
                titleLabelHorizontalConstraints = [
                    titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                    titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
                ]
                
                NSLayoutConstraint.activate(titleLabelVerticalConstraints)
                NSLayoutConstraint.activate(titleLabelHorizontalConstraints)
            }
            
            titleLabel.text = title
        } else {
            titleLabel?.removeFromSuperview()
            titleLabel = nil
        }
        
        // Handle subTitle
        if let subTitle = subTitle, !subTitle.isEmpty {
            if subTitleLabel == nil {
                subTitleLabel = UILabel()
                subTitleLabel.accessibilityLabel = "Notification Subtitle"
                subTitleLabel.adjustsFontSizeToFitWidth = true
                subTitleLabel.backgroundColor = .clear
                subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(subTitleLabel)
                
                // Remove old constraints if any
                NSLayoutConstraint.deactivate(titleLabelVerticalConstraints)
                NSLayoutConstraint.deactivate(subTitleLabelVerticalConstraints)
                
                if titleLabel != nil {
                    // Both title and subtitle exist, set constraints accordingly
                    subTitleLabelVerticalConstraints = NSLayoutConstraint.constraints(
                        withVisualFormat: "V:|-padding-[titleLabel(>=height)][subTitleLabel(>=height)]-padding-|",
                        options: [],
                        metrics: [
                            "height": JFMinimalNotification.notificationTitleLabelHeight,
                            "padding": JFMinimalNotification.notificationPadding
                        ],
                        views: [
                            "titleLabel": titleLabel!,
                            "subTitleLabel": subTitleLabel!
                        ]
                    )
                } else {
                    // Only subtitle exists
                    subTitleLabelVerticalConstraints = [
                        subTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                    ]
                }
                
                // Set horizontal constraints for subtitle label
                let padding = JFMinimalNotification.notificationPadding
                subTitleLabelHorizontalConstraints = [
                    subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                    subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
                ]
                
                NSLayoutConstraint.activate(subTitleLabelVerticalConstraints)
                NSLayoutConstraint.activate(subTitleLabelHorizontalConstraints)
            }
            
            subTitleLabel.text = subTitle
        } else {
            subTitleLabel?.removeFromSuperview()
            subTitleLabel = nil
        }
    }
    
    private func setAccessoryView(forStyle style: JFMinimalNotificationStyle, animated: Bool) {
        var image: UIImage?
        accessoryView = UIView()
        accessoryView?.translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .blurDark, .blurLight, .custom:
            setLeftAccessoryView(nil, animated: animated)
            setRightAccessoryView(nil, animated: animated)
            accessoryView = nil
            return
            
        case .error:
            let secondaryColor = UIColor.notificationWhiteColor
            image = JFMinimalNotificationArt.imageOfCross(color: UIColor.notificationRedColor)
            accessoryView?.backgroundColor = secondaryColor
            
        case .success:
            let primaryColor = UIColor.notificationGreenColor
            let secondaryColor = UIColor.notificationWhiteColor
            image = JFMinimalNotificationArt.imageOfCheckmark(with: primaryColor)
            accessoryView?.backgroundColor = secondaryColor
            
        case .info:
            let primaryColor = UIColor.notificationOrangeColor
            let secondaryColor = UIColor.notificationWhiteColor
            image = JFMinimalNotificationArt.imageOfInfo(with: primaryColor)
            accessoryView?.backgroundColor = secondaryColor
            
        case .warning:
            let primaryColor = UIColor.notificationYellowColor
            let secondaryColor = UIColor.notificationBlackColor
            image = JFMinimalNotificationArt.imageOfWarning(with: primaryColor, and: secondaryColor)
            accessoryView?.backgroundColor = secondaryColor
            
        case .default:
            fallthrough
        default:
            let primaryColor = UIColor.notificationBlueColor
            let secondaryColor = UIColor.notificationWhiteColor
            image = JFMinimalNotificationArt.imageOfInfo(with: primaryColor)
            accessoryView?.backgroundColor = secondaryColor
        }
        
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            accessoryView?.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.centerYAnchor.constraint(equalTo: accessoryView!.centerYAnchor),
                imageView.centerXAnchor.constraint(equalTo: accessoryView!.centerXAnchor),
                imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 30),
                imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 30)
            ])
        }
        
        setLeftAccessoryView(accessoryView, animated: animated)
    }
    
    // MARK: Touch handler
    
    @objc func handleTap() {
        touchHandler?()
    }
    
}
