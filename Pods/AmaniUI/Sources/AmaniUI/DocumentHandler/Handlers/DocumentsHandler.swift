//
//  SelfieRunnable.swift
//  AmaniUIv1
//
//  Created by Deniz Can on 3.11.2022.
//

import AmaniSDK
import UIKit
import CoreServices
import VisionKit

class DocumentsHandler: NSObject, DocumentHandler{
  weak var topVC: UIViewController?
  var stepViewModel: KYCStepViewModel
  var docID: DocumentID
  var stepView: UIView?
  var files:[FileWithType]?
  var ContainerVC: ContainerViewController
  var callback:((Result<KYCStepViewModel, KYCStepError>) -> Void)?
  var scannedImages: [UIImage] = []
    
  let cameraContainerView = UIView()
  
  // Might be Selfie, AutoSelfie or PoseEstimation.
  private var documentsModule: Document!
  
  required init(topVC: UIViewController, stepVM: KYCStepViewModel, docID: DocumentID) {
    self.topVC = topVC
    self.stepViewModel = stepVM
    self.docID = docID

    self.ContainerVC = ContainerViewController()
    
    super.init()
    self.ContainerVC.docID = docID
      DispatchQueue.main.async { [weak self] in
          guard let self = self else { return }
          self.setupCameraContainerView()
          self.startDocumentScanning()
      }
  }
}
//MARK: Documents Handler Logics
extension DocumentsHandler {
    func start(docStep: AmaniSDK.DocumentStepModel, version: AmaniSDK.DocumentVersion, workingStepIndex: Int,completion: @escaping (Result<KYCStepViewModel, KYCStepError>) -> Void) {
      callback = completion
        
      guard let appConfig = try? Amani.sharedInstance.appConfig().getApplicationConfig().generalconfigs else {
        print("AppConfigError")
        return
      }
     
           
      self.topVC?.navigationController?.pushViewController(ContainerVC, animated: true)
            ContainerVC.setLeftNavBarButtonAction {
              DispatchQueue.main.async {
              let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String ], in: .import)
              documentPicker.delegate = self
              documentPicker.allowsMultipleSelection = false
              self.ContainerVC.present(documentPicker, animated: true)
              }
            }
           
            ContainerVC.setDisappearCallback {
              self.stepView?.removeFromSuperview()
            }
            
            ContainerVC.bind(animationName:nil, docStep: version.steps![steps.front.rawValue], step:steps.front, docID: docID) { [weak self] () in
              self?.stepView = self?.runDocumentsScan(
                step: docStep,
                version: version,
                completion: completion
              )!
              
  //            if let stepView = self.stepView {
  //              self.ContainerVC.view.addSubview(stepView)
  //              self.ContainerVC.view.bringSubviewToFront(stepView)
  //            }
              
            }
//        }
     
    }
    
    func upload(completion: @escaping ((Bool?, [String : Any]?) -> Void)) {
      guard let documentsModule = documentsModule else { return }
      if let files = files {
        documentsModule.upload(
          location: AmaniUI.sharedInstance.location,
          files: files,
          completion: completion)
        self.files = nil
      }
      else {
        documentsModule.upload(
          location: AmaniUI.sharedInstance.location){ [weak self] result in
            completion(result,nil)
          }

      }
    }

    
    private func runDocumentsScan(step: DocumentStepModel, version: DocumentVersion, completion: @escaping (Result<KYCStepViewModel, KYCStepError>) -> Void) -> UIView?{
      documentsModule = Amani.sharedInstance.document()
      do {
        guard let type = version.type else {
          print("Type is not setted")
          return nil
        }
        documentsModule.setType(type: type )
        stepView = try documentsModule.start { [weak self] image in
          self?.stepView?.removeFromSuperview()
          completion(.success(self!.stepViewModel))
          self?.topVC?.navigationController?.popToViewController(ofClass: HomeViewController.self)
        }
        return stepView
  //      self.showStepView(navbarHidden: false)
      } catch let err {
        print(err)
        
        completion(.failure(.moduleError))
        return nil
      }
    }
}

