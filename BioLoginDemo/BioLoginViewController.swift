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
  
  private let selfieButton: UIButton = {
    let b = UIButton(type: .system)
    b.setTitle("Start Biologin", for: .normal)
    b.setTitleColor(.white, for: .normal)
    b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    b.backgroundColor = UIColor(red: 1.00, green: 0.72, blue: 0.82, alpha: 1.0) // açık pembe
    b.layer.cornerRadius = 20
    b.layer.masksToBounds = true
    b.translatesAutoresizingMaskIntoConstraints = false
    return b
  }()
  
  var amaniSDK: Amani = Amani.sharedInstance
  var viewContainer: UIView?
  
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
      stack.widthAnchor.constraint(greaterThanOrEqualToConstant: 220), // çok dar ekranlarda bile
      selfieButton.heightAnchor.constraint(equalToConstant: 56),
      
    ])
    
    let customer:CustomerRequestModel = CustomerRequestModel(name: "", email: "", phone: "", idCardNumber: "")
    amaniSDK.setUploadSource(uploadSource: .BIOLOGIN)
    
      //      self.amani.setUploadSource(uploadSource: .BIOLOGIN)
    amaniSDK.initAmani(server: "", token: "s", customer: customer, apiVersion: .v1) { result, error in
      
    }
    

    
  }
  
  @objc func didTapSelfieButton() {
    do {
      
      let selfie: AutoSelfie = self.amaniSDK.autoSelfie()
      selfie.setType(type: "XXX_SE_0")
      selfie.setManualCropTimeout(Timeout: 5)
    
      
      guard let selfieVC:UIView = try selfie.start(completion: { [weak self](previewImage) in
        DispatchQueue.main.async {
          debugPrint(previewImage)
            //          self?.startConfirm(image: previewImage)
          selfie.upload { [weak self] isSuccess in
            debugPrint("auto selfie isSuccess sonucu: \(isSuccess)")
            DispatchQueue.main.async {
              self?.dismiss(animated: true)
            }
           
          }
          self?.viewContainer?.removeFromSuperview()
        }
      }) else {return}
      self.viewContainer = selfieVC
      DispatchQueue.main.async {
        self.view.addSubview(selfieVC)
      }
      
    }
    catch  {
      print("Unexpected error: \(error).")
      
    }
  }
  
}
