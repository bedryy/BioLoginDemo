//
//  AnimationView.swift
//  AmaniUI
//
//  Created by Bedri Doğan on 29.05.2024.
//

import UIKit
import AmaniSDK


class AnimationViewDocConfirmation: UIVisualEffectView {
  var spinner = UIActivityIndicatorView(style: .large)

//    var infoLabel = UILabel()
//    var config: DocumentVersion?
  
  func bind(config:DocumentVersion){
//    self.config = config
    self.setupUI()

  }

  deinit {
    self.spinner.stopAnimating()
  }
  
    private func setupUI() {
      DispatchQueue.main.async {
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        self.contentView.addSubview(self.spinner)

        self.spinner.center = self.center
        self.spinner.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.spinner.color = .white
        self.spinner.hidesWhenStopped = true
//        self.spinner.translatesAutoresizingMaskIntoConstraints = false
//        
////        self.infoLabel.text = "Your ID's informations are checking. Please wait..."
////        self.infoLabel.textColor = .white
////        self.infoLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
////        self.addSubview(self.infoLabel)
////        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//          self.spinner.heightAnchor.constraint(equalToConstant: 80),
//          self.spinner.widthAnchor.constraint(equalToConstant: 80),
//          self.spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//          self.spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor)
////          self.infoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
////          self.infoLabel.topAnchor.constraint(equalTo: self.spinner.bottomAnchor, constant: 24)
//        ])
        self.contentView.bringSubviewToFront(self.spinner)
        self.spinner.startAnimating()

      }
    }
}



