//
//  CheckSMSViewController.swift
//  AmaniUI
//
//  Created by Deniz Can on 26.12.2023.
//

import Foundation
import UIKit
import AmaniSDK

class CheckSMSViewController: KeyboardAvoidanceViewController {
  private var checkSMSView: CheckSMSView!
  private var checkSMSViewModel: CheckSMSViewModel!
  private var docVersion: DocumentVersion?
  
  override init() {
    super.init()
    checkSMSView = CheckSMSView()
    checkSMSViewModel = CheckSMSViewModel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationItem.hidesBackButton = false
  }
  
  override func viewDidLoad() {
      guard let appConfig = try? Amani.sharedInstance.appConfig().getApplicationConfig() else {
          print("AppConfigError")
          return
      }
      
    self.title = docVersion?.steps?.first?.confirmationTitle ?? "Check your SMS"
    checkSMSView.appConfig = appConfig
    checkSMSView.bind(withViewModel: checkSMSViewModel, withDocument: docVersion)
    addPoweredByIcon()
    view.backgroundColor = hextoUIColor(hexString: "#EEF4FA")
    contentView.addSubview(checkSMSView)
    checkSMSView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      checkSMSView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      checkSMSView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
      checkSMSView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
    ])
  }
  
  func setupCompletionHandler(_ handler: @escaping (() -> Void)) {
    checkSMSView.setCompletionHandler(handler)
  }
  
  func bind(with stepModel: KYCStepViewModel) {
    self.docVersion = stepModel.documents.first?.versions?.first
    self.checkSMSViewModel.setRuleID(stepModel.getRuleModel().id!)
  }
  
}
