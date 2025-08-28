//
//  KeyboardAvoidenceViewController.swift
//  AmaniUI
//
//  Created by Deniz Can on 25.12.2023.
//
import Foundation
import UIKit
import AmaniSDK

class KeyboardAvoidanceViewController: BaseViewController {
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    // Set these properties to a default value that suits you:
    scrollView.keyboardDismissMode = .onDrag
    scrollView.alwaysBounceVertical = false
    return scrollView
  }()
  
  /// The `KeyboardAvoidanceViewController`'s `contentView`. Use this property when adding subviews to this ViewController / View.
  private(set) lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  /// The keyboard dismiss mode as defined on `UIScrollView`. This is a mirror of the property with the same name on the underlying `UIScrollView`.
  var keyboardDismissMode: UIScrollView.KeyboardDismissMode {
    get { scrollView.keyboardDismissMode }
    set { scrollView.keyboardDismissMode = newValue }
  }
  
  /// The strategy for vertical bounce as defined on `UIScrollView`. This is a mirror of the property with the same name on the underlying `UIScrollView`.
  var alwaysBounceVertical: Bool {
    get { scrollView.alwaysBounceVertical }
    set { scrollView.alwaysBounceVertical = newValue }
  }
  
  private var adjustContentInsetInsteadOfSafeArea: Bool = false
  
  /// Initiate a `KeyboardAvoidanceViewController` with the option to adjust the underlying `UIScrollView`'s content inset instead of the safe area when the keyboard appears/disappears.
  ///
  /// - Parameter adjustContentInsetInsteadOfSafeArea: If the underlying `UIScrollView`'s content inset should be adjusted instead of the safe area when the keyboard appears/disappears.
  convenience init(adjustContentInsetInsteadOfSafeArea: Bool = false) {
    self.init()
    self.adjustContentInsetInsteadOfSafeArea = adjustContentInsetInsteadOfSafeArea
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardFrameWillChange),
      name: UIWindow.keyboardWillChangeFrameNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIWindow.keyboardWillHideNotification,
      object: nil
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func loadView() {
    view = UIView()
    
    view.addSubview(scrollView)
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    
    scrollView.addSubview(contentView)
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(
        equalTo: scrollView.contentLayoutGuide.topAnchor
      ),
      contentView.leadingAnchor.constraint(
        equalTo: scrollView.contentLayoutGuide.leadingAnchor
      ),
      contentView.trailingAnchor.constraint(
        equalTo: scrollView.contentLayoutGuide.trailingAnchor
      ),
      contentView.bottomAnchor.constraint(
        equalTo: scrollView.contentLayoutGuide.bottomAnchor
      ),
    ])
    
    let heightConstraint = scrollView.contentLayoutGuide.heightAnchor.constraint(
      greaterThanOrEqualTo: scrollView.safeAreaLayoutGuide.heightAnchor
    )
    // Set the UIScrollView's content height constraint priority a little bit lower than `.required`.
    // That way we avoid any initial layout conflicts and/or any other `.required` constraints on `contentView`.
    // We want the `contentView` to take up as much space as possible,
    // so we can easily place content all over the screen (represented by this UIViewController).
    heightConstraint.priority = .required - 1
    
    NSLayoutConstraint.activate([
      scrollView.contentLayoutGuide.widthAnchor.constraint(
        equalTo: scrollView.frameLayoutGuide.widthAnchor
      ),
      heightConstraint
    ])
    setupNavigationBackButton()
  }
  
  func setupNavigationBackButton() {
    let appConfig = try! Amani.sharedInstance.appConfig().getApplicationConfig()
    let buttonRadious = CGFloat(appConfig.generalconfigs?.buttonRadius ?? 10)
    
    self.setNavigationLeftButton(TintColor: appConfig.generalconfigs?.topBarFontColor ?? "ffffff")
  }
  
  @objc private func keyboardFrameWillChange(_ notification: Notification) {
    guard
      let userInfo = notification.userInfo,
      let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
      let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
      let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
    else {
      return assertionFailure("This should never happen")
    }
    
    let animationOptions = UIView.AnimationOptions(rawValue: animationCurve << 16)
    
    let convertedKeyboardFrameEnd = view.convert(
      keyboardFrameEnd, from: view.window
    )
    
    let keyboardFrameHeightChange = convertedKeyboardFrameEnd.height - view.safeAreaInsets.bottom
    
    if adjustContentInsetInsteadOfSafeArea {
      scrollView.contentInset = .init(
        top: 0,
        left: 0,
        bottom: additionalSafeAreaInsets.bottom + keyboardFrameHeightChange,
        right: 0
      )
    } else {
      additionalSafeAreaInsets = .init(
        top: 0,
        left: 0,
        bottom: additionalSafeAreaInsets.bottom + keyboardFrameHeightChange,
        right: 0
      )
    }
    
    UIView.animate(
      withDuration: animationDuration,
      delay: 0,
      options: [animationOptions, .beginFromCurrentState]
    ) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc private func keyboardWillHide(_ notification: Notification) {
    guard
      let userInfo = notification.userInfo,
      let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
      let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
    else {
      return assertionFailure("This should never happen")
    }
    
    let animationOptions = UIView.AnimationOptions(rawValue: animationCurve << 16)
    
    if adjustContentInsetInsteadOfSafeArea {
      scrollView.contentInset = .zero
    } else {
      additionalSafeAreaInsets = .zero
    }
    
    UIView.animate(
      withDuration: animationDuration,
      delay: 0,
      options: [animationOptions, .beginFromCurrentState]
    ) {
      self.view.layoutIfNeeded()
    }
  }
}

extension KeyboardAvoidanceViewController {
  
  /// A simple utility/convenience method to pin a subview to all edges of the `contentView`.
  func pinToContentView(_ view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: contentView.topAnchor),
      view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
