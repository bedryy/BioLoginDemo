//
//  ActivityIndicator.swift
//  BioLoginDemo
//
//  Created by Bedri Doğan on 28.08.2025.
//

import UIKit

final class Loader {
  static let shared = Loader()
  private var box: UIView?
  private var spinner: UIActivityIndicatorView?
  
  private init() {}
  
    /// view verilmezse key window'a ekler
  func start(in view: UIView? = nil) {
    DispatchQueue.main.async {
      guard self.box == nil else { return } // zaten açık
      
      let hostView = view ?? Self.keyWindow ?? UIApplication.shared.windows.first!
      let box = UIView()
      box.translatesAutoresizingMaskIntoConstraints = false
      box.backgroundColor = UIColor.black.withAlphaComponent(0.7)
      box.layer.cornerRadius = 14
      box.alpha = 0
      
      let spinner = UIActivityIndicatorView(style: .medium)
      spinner.translatesAutoresizingMaskIntoConstraints = false
      spinner.startAnimating()
      
      hostView.addSubview(box)
      box.addSubview(spinner)
      
      NSLayoutConstraint.activate([
        box.centerXAnchor.constraint(equalTo: hostView.centerXAnchor),
        box.centerYAnchor.constraint(equalTo: hostView.centerYAnchor),
        box.widthAnchor.constraint(equalToConstant: 64),
        box.heightAnchor.constraint(equalToConstant: 64),
        
        spinner.centerXAnchor.constraint(equalTo: box.centerXAnchor),
        spinner.centerYAnchor.constraint(equalTo: box.centerYAnchor),
      ])
      
      box.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
        box.alpha = 1
        box.transform = .identity
      }
      
      self.box = box
      self.spinner = spinner
    }
  }
  
  func stop() {
    DispatchQueue.main.async {
      guard let box = self.box else { return }
      UIView.animate(withDuration: 0.15, animations: {
        box.alpha = 0
        box.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
      }, completion: { _ in
        self.spinner?.stopAnimating()
        self.spinner?.removeFromSuperview()
        box.removeFromSuperview()
        self.spinner = nil
        self.box = nil
      })
    }
  }
  
  private static var keyWindow: UIWindow? {
    UIApplication.shared
      .connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
  }
}
