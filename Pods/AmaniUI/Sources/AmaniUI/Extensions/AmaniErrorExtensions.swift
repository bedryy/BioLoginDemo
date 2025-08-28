//
//  AmaniErrorExtensions.swift
//  AmaniUI
//
//  Created by Deniz Can on 27.12.2023.
//

import Foundation
import AmaniSDK

extension AmaniError {
  
  func toDictonary() -> [String: String] {
    return [
      "errorCode": String(self.error_code),
      "errorMessage": self.error_message ?? "No message provided"
    ]
  }
  
  
}
