//
//  PhoneOTPViewModel.swift
//  AmaniUI
//
//  Created by Deniz Can on 26.12.2023.
//

import Foundation
import Combine
import AmaniSDK

class PhoneOTPViewModel {
  private let customerInfo = Amani.sharedInstance.customerInfo()
  enum ViewState {
    case loading
    case success
    case failed
    case none
  }
  
  @Published var phone = ""
  @Published var state: ViewState = .none
  
  var isEmailValidPublisher: AnyPublisher<Bool, Never> {
    $phone.debounce(for: 0.5, scheduler: RunLoop.main)
      .map { _ in self.isValidPhone() }
      .eraseToAnyPublisher()
  }
  
    func submitPhoneForOTP() {
        if self.phone == ""{
            state = .none
        }else{
            state = .loading
            customerInfo.setPhone(phone: phone)
            customerInfo.upload(location: AmaniUI.sharedInstance.location) {[weak self] phoneChanged in
                
                if (phoneChanged == false) {
                    self?.state = .failed
                }
                
                self?.customerInfo.requestPhoneOTPCode { success in
                    if let success = success {
                        self?.state = .success
                    } else {
                        self?.state = .failed
                    }
                }
            }
        }
    }
  
    private func isValidPhone() -> Bool {
//        let phoneRegex = "^\\+(?:[0-9] ?){6,14}[0-9]$"
//        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//
//        return phonePredicate.evaluate(with: self.phone)
        
        return true
    }
  
  
}
