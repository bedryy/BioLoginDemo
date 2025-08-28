//
//  MainViewController.swift
//  BioLoginDemo
//
//  Created by Bedri Doğan on 27.08.2025.
//

import UIKit
import Foundation
import AmaniUI
import AmaniSDK

class MainViewController: UIViewController {
  var customer:CustomerRequestModel?
  var amani: AmaniUI?

  
  
  
  private let kycButton: UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("KYC Process", for: .normal)
    b.setTitleColor(.white, for: .normal)
    b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    b.backgroundColor = UIColor(red: 1.00, green: 0.72, blue: 0.82, alpha: 1.0) // açık pembe
    b.layer.cornerRadius = 20
    b.layer.masksToBounds = true
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()
  
  private let bioLoginButton: UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("BioLogin Process", for: .normal)
    b.setTitleColor(.white, for: .normal)
    b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    b.backgroundColor = UIColor(red: 1.00, green: 0.72, blue: 0.82, alpha: 1.0) // açık pembe
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
    
    kycButton.addTarget(self, action: #selector(didTapKYC), for: .touchUpInside)
    bioLoginButton.addTarget(self, action: #selector(didTapBioLogin), for: .touchUpInside)
    
    self.amani = AmaniUI.sharedInstance
    self.amani?.setDelegate(delegate: self)
    
    let stack = UIStackView(arrangedSubviews: [kycButton, bioLoginButton])
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
      stack.widthAnchor.constraint(greaterThanOrEqualToConstant: 220), // çok dar ekranlarda bile
      kycButton.heightAnchor.constraint(equalToConstant: 56),
      bioLoginButton.heightAnchor.constraint(equalToConstant: 56)
    ])
  }
  
  private func startBioLogin() {
    DispatchQueue.main.async {
      let vc = BioLoginViewController()
      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .fullScreen
      
      self.present(vc, animated: true)
    }
   
    
    
  }
  
  private func startAmaniKYC() {
    customer = CustomerRequestModel(idCardNumber: "")
    
    guard let amani = self.amani else { return }
    
      // Configure SDK

    amani.setIdVideoRecord(enable: false)
    
    amani.set(server: "", token: "", customer: customer!, apiVersion: .v1)
    
    
    DispatchQueue.main.async {
      amani.showSDK(on: self) { customerResponse, error in
        debugPrint(customerResponse)
        debugPrint(error)
      }
    }
    
  }
  
  
  
  @objc private func didTapKYC() {
    startAmaniKYC()
  }
  
  @objc private func didTapBioLogin() {
    startBioLogin()
  }
  
  
}


  extension MainViewController:AmaniUIDelegate{
    func onKYCSuccess(CustomerId: String) {
      debugPrint(CustomerId)
    }
  
    func onKYCFailed(CustomerId: String, Rules: [[String : String]]?) {
      debugPrint(CustomerId, Rules)
    }
  
    func onError(type: String, Error: [AmaniSDK.AmaniError]) {
      debugPrint(type, Error)
    }
  
  
  }
