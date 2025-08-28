//
//  QuestionnaireHeaderView.swift
//  AmaniUI
//
//  Created by Deniz Can on 5.02.2024.
//

import Foundation
import UIKit
import AmaniSDK

class QuestionnaireHeaderView: UIStackView {
    
    var genConfig: GeneralConfig? {
        didSet {
            setupUI()
        }
    }
  
  private lazy var descriptionLabel: UILabel = {
    let descriptionLabel = UILabel()
    descriptionLabel.text = "Please answer the following simple questions to help us serve you better."
    descriptionLabel.textColor = hextoUIColor(hexString: "#20202F")
    descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
    descriptionLabel.numberOfLines = 0
    return descriptionLabel
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setupUI() {
    self.axis = .vertical
    self.spacing = 12
    
    self.addArrangedSubview(descriptionLabel)
    self.backgroundColor = hextoUIColor(hexString: genConfig?.appBackground ?? "#EEF4FA")
    
    self.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    self.isLayoutMarginsRelativeArrangement = true
  }
  
  func setDescriptionLabelText(_ text: String) {
    DispatchQueue.main.async {
      self.descriptionLabel.text = text
    }
  }
  
}
