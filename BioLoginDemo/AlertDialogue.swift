//
//  AlertDialogue.swift
//  BioLoginDemo
//
//  Created by Bedri Doğan on 28.08.2025.
//

import UIKit


class AlertDialogueUtility {
  
  static var shared: AlertDialogueUtility = AlertDialogueUtility()
  
  
  private init() {}
  
  
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
