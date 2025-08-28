//
//  AlertDialougeUtility.swift
//  AmaniUIv1
//
//  Created by Deniz Can on 26.10.2022.
//
import UIKit
/**
 This file represents the native alerts utility as a Singleton instance
 
 
 */

protocol AlertDelegate: AnyObject {
  func showAlert(title: String, message: String, actions: [(String, UIAlertAction.Style)], completion: ((Int) -> Void)?)
}

class AlertDialogueUtility {
  // MARK: - Local properties
  
  /// This property represents theshared instance of AlertDialogueUtility
  static var shared: AlertDialogueUtility = AlertDialogueUtility()

  // MARK: - Private initializer

  private init() {}

  // MARK: - Helper methods

  /**
   This method is used to present UIAlertController with handler
   - parameter viewController: UIViewController
   - parameter alertTitle: String
   - parameter alertMessage: String
   - returns: Voida
   */
  func showMsgAlertWithHandler(controller: UIViewController?, alertTitle: String, message: String, successTitle: String, success: ((UIAlertAction) -> Void)? = nil, failureTitle: String? = nil, failure: ((UIAlertAction) -> Void)? = nil) {
    DispatchQueue.main.async {
      
      
      let alertController = UIAlertController(title: alertTitle, message:
                                                "", preferredStyle: UIAlertController.Style.alert)
      
      alertController.title = alertTitle
      alertController.message = message
      
      if let title = failureTitle {
        let failureAction = UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: failure)
        alertController.addAction(failureAction)
      }
      let successAction = UIAlertAction(title: successTitle, style: UIAlertAction.Style.default, handler: success)
      alertController.addAction(successAction)
      controller?.present(alertController, animated: true, completion: nil)
    }
  }
    
    func showAlertWithActions(vc: UIViewController, title: String? = nil, message: String? = nil, actions: [(String, UIAlertAction.Style)],
                                    completion: @escaping(_ index: Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (index, (title, style)) in actions.enumerated() {
            let alertAction = UIAlertAction(title: title, style: style) { (_) in
                completion(index)
            }
            alertController.addAction(alertAction)
        }
        vc.present(alertController, animated: true)
    }
    
}
