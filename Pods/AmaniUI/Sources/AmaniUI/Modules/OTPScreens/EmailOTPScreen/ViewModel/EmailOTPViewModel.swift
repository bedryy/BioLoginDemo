//
//  PasswordResetOTPViewModel.swift
//  AmaniStudio
//
//  Created by Deniz Can on 10.12.2023.
//

import Foundation
import Combine
import AmaniSDK

class EmailOTPViewModel {
  private let customerInfo = Amani.sharedInstance.customerInfo()
  enum ViewState {
    case loading
    case success
    case failed
    case none
  }
  
  @Published var email = ""
  @Published var state: ViewState = .none
  
  var isEmailValidPublisher: AnyPublisher<Bool, Never> {
    $email.debounce(for: 0.5, scheduler: RunLoop.main)
      .map { _ in self.isValidEmail() }
      .eraseToAnyPublisher()
  }
  
  func submitEmailForOTP() {
    state = .loading
    customerInfo.setEmail(email: email)
    customerInfo.upload(location: AmaniUI.sharedInstance.location) { [weak self] emailChanged in
        if emailChanged == false {
          self?.state = .failed
          return
        }
        
        self?.customerInfo.requestEmailOTPCode { success in
          if success == true {
            self?.state = .success
          } else {
            self?.state = .failed
          }
        }
      }
  }
  
  private func isValidEmail() -> Bool {
    if self.email == "" { return true }
    
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    
    return emailPredicate.evaluate(with: self.email)
  }

    
}
