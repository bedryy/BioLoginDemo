//
//  UIColorExtensions.swift
//  AmaniUIv1
//
//  Created by Deniz Can on 6.09.2022.
//

import Foundation
import UIKit
/**
 This file consists all the extended features of a UIColor
 */
extension UIColor {
  /**
   This method used to get hexa decimal code of UIColor
   - returns: String
   */
  func toHexString() -> String {
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0
    getRed(&r, green: &g, blue: &b, alpha: &a)
    let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    return String(format:"#%06x", rgb)
  }
}
