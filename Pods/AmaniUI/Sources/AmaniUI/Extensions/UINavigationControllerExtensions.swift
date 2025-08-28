//
//  UINavigationControllerExtensions.swift
//  AmaniUIv1
//
//  Created by Deniz Can on 14.10.2022.
//

import Foundation
import UIKit

extension UINavigationController {
  
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
  
  func setupNavigationBarShadow() {
    navigationBar.layer.shadowColor = UIColor.black.cgColor
    navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    navigationBar.layer.shadowRadius = 4.0
    navigationBar.layer.shadowOpacity = 0.4
    navigationBar.layer.masksToBounds = false
  }
  
}
