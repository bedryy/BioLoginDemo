//
//  BioLoginViewController.swift
//  BioLoginDemo
//
//  Created by Bedri Doğan on 27.08.2025.
//

import UIKit
import Foundation
import AmaniSDK


class BioLoginViewController: UIViewController {
  

  var amaniSDK: Amani = Amani.sharedInstance
  private var bioLoginView: UIView?
  private var biologin: BioLogin?
  private var isStartingBioLogin = false
  private var didCompleteBioLogin = false
  private var token: String?
  private var customerId: String?
  
  
  private let selfieButton: UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("Start Biologin Selfie", for: .normal)
    b.setTitleColor(.white, for: .normal)
    b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    b.backgroundColor = UIColor(red: 0.75, green: 0.24, blue: 0.36, alpha: 1.0)
    b.layer.cornerRadius = 20
    b.layer.masksToBounds = true
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    
    selfieButton.addTarget(self, action: #selector(didTapSelfieButton), for: .touchUpInside)
    
    let stack = UIStackView(arrangedSubviews: [selfieButton])
    stack.axis = .vertical
    stack.alignment = .fill
    stack.spacing = 30
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)
    
    NSLayoutConstraint.activate([
      
      stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
      stack.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
      stack.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, constant: -48),
      stack.widthAnchor.constraint(greaterThanOrEqualToConstant: 220),
      selfieButton.heightAnchor.constraint(equalToConstant: 56),
      
    ])
    
  
    initAmani()
    
  }
  
  @objc func didTapSelfieButton() {
    startBioLoginSelfie()
     

  }
  
  func initAmani() {
    let customer = CustomerRequestModel(name: "", email: "", phone: "", idCardNumber: "")
    amaniSDK.initAmani(server: "server_url",
                       token: "token",
                       customer: customer,
                       apiVersion: .v2) { [weak self] result, error in
      
      guard let self = self else { return }
      self.token = result?.token
      self.customerId = result?.id
      
    }
  }
  
  func startBioLoginSelfie() {

    guard !isStartingBioLogin else { return }
    isStartingBioLogin = true
    didCompleteBioLogin = false
    
    
    do {
      let bioLogin = amaniSDK.bioLogin()
      self.biologin = bioLogin
      bioLogin.setParams(server: "server_url",
                              token: "\(self.token)", //burada amani init edildikten sonraki token değeri girilmeli
                              customer_id: "\(self.customerId)", // yine amani initten sonra result'tan dönen customerId değeri(bu değer kalkabilir!!!)
                               attempt_id: "3",
                               biologintype: .autoSelfie)
      
      
      guard let view = try bioLogin.start(completion: { [weak self] previewImage in
        guard let self = self else { return }
   
        guard !self.didCompleteBioLogin else { return }
        self.didCompleteBioLogin = true
        
        DispatchQueue.main.async {
      
          Loader.shared.start()
          bioLogin.upload { [weak self] isSuccess in
            DispatchQueue.main.async {
              Loader.shared.stop()
              self?.showAlert(isUploaded: isSuccess ?? false)
            }
          }
 
          if let v = self.bioLoginView, v.superview != nil {
            v.removeFromSuperview()
          }
          self.bioLoginView = nil
          self.biologin = nil
          self.isStartingBioLogin = false
        }
      }) else {
        isStartingBioLogin = false
        return
      }
      
      if view.superview == nil {
        view.frame = self.view.bounds
        self.view.addSubview(view)
        self.bioLoginView = view
      }
    } catch {
      isStartingBioLogin = false
      print("Unexpected error: \(error)")
    }
  }
  
}
extension BioLoginViewController {
  private func showAlert(isUploaded: Bool) {
    DispatchQueue.main.async {
      var actions: [(String, UIAlertAction.Style)] = []
      
      actions.append(("\("Ok")", UIAlertAction.Style.default))
      
      AlertDialogueUtility.shared.showAlertWithActions(vc: self, title: "Biologin Selfie Upload Response", message: "response: \(isUploaded)", actions: actions) { index in
        if index == 0 {
          DispatchQueue.main.async {
            Loader.shared.stop()
            self.dismiss(animated: true)
          }
        }
      }
    }
  }
}
