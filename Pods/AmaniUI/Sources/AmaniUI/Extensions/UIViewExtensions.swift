//
//  File.swift
//  AmaniUIv1
//
//  Created by Deniz Can on 6.09.2022.
//

import UIKit
/**
 This file consists all the extended features of a UIView
 */
extension UIView {
  
  /**
   This method used to add shadow on view
   - parameter shadowRadius: CGFloat
   - parameter shadowColor: UIColor
   - parameter shadowOpacity: Float?
   - parameter borderColor: UIColor?
   - parameter borderWidth: CGFloat?
   - parameter cornerRadious: CGFloat?
   */
  func addShadowWithBorder(shadowRadius: CGFloat, shadowColor: UIColor, shadowOpacity: Float? = 0, borderColor: UIColor? = nil, borderWidth: CGFloat? = 0, cornerRadious: CGFloat? = 0 ) {
    self.layoutIfNeeded()
    self.layer.masksToBounds = false
    self.layer.shadowColor = shadowColor.cgColor
    self.layer.shadowOpacity = shadowOpacity ?? 0.1
    self.layer.shadowOffset = CGSize.zero
    self.layer.shadowRadius = shadowRadius
    self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: shadowRadius).cgPath
    self.layer.shouldRasterize = true
    self.layer.rasterizationScale = UIScreen.main.scale
    self.layer.borderColor = borderColor?.cgColor
    self.layer.borderWidth = borderWidth ?? 0
    self.layer.cornerRadius = cornerRadious ?? 0
    self.clipsToBounds = true
  }
  
  func addCornerRadiousWith(radious: CGFloat) {
    self.layer.cornerRadius = radious
    self.clipsToBounds = true
  }
  
  func addBorder(borderWidth: CGFloat, borderColor: CGColor) {
    self.layer.borderWidth = borderWidth
    self.layer.borderColor = borderColor
  }
  
  func reportSuperviews(filtering:Bool = true) {
    var currentSuper : UIView? = self.superview
    print("reporting on \(self)\n")
    while let ancestor = currentSuper {
      let ok = ancestor.bounds.contains(ancestor.convert(self.frame, from: self.superview))
      let report = "it is \(ok ? "inside" : "OUTSIDE") \(ancestor)\n"
      if !filtering || !ok { print(report) }
      currentSuper = ancestor.superview
    }
  }
  
  // Animated show hide with a cool fade out effect
  func setIsHidden(_ hidden: Bool, animated: Bool) {
    if animated {
      if self.isHidden && !hidden {
        self.alpha = 0.0
        self.isHidden = false
      }
      UIView.animate(withDuration: 0.25, animations: {
        self.alpha = hidden ? 0.0 : 1.0
      }) { (complete) in
        self.isHidden = hidden
      }
    } else {
      self.isHidden = hidden
    }
  }
  
  func showMsgAlertWithHandler(
    alertTitle: String,
    message: String,
    successTitle: String,
    success: ((UIAlertAction) -> Void)? = nil,
    failureTitle: String? = nil,
    failure: ((UIAlertAction) -> Void)? = nil) {
      DispatchQueue.main.async {
        let alertController = UIAlertController(
          title: alertTitle, message:"",
          preferredStyle: UIAlertController.Style.alert)
        
        alertController.title = alertTitle
        alertController.message = message
        
        if let title = failureTitle {
          let failureAction = UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: failure)
          alertController.addAction(failureAction)
        }
        let successAction = UIAlertAction(title: successTitle, style: UIAlertAction.Style.default, handler: success)
        alertController.addAction(successAction)
        var responder: UIResponder? = self
        while !(responder is UIViewController) {
          responder = responder?.next
          if nil == responder {
            break
          }
        }
        let controller:UIViewController = (responder as? UIViewController)!
        
        controller.present(alertController, animated: true, completion: nil)
      }
    }
  

}
