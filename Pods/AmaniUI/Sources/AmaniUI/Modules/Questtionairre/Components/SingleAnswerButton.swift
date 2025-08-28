//
//  SingleAnswerButton.swift
//  AmaniUI
//
//  Created by Deniz Can on 6.02.2024.
//

import Foundation
import UIKit
import AmaniSDK

class SingleAnswerButton: UIButton {
  private var question: QuestionAnswerModel?
  private var didPressCallback: ((String) -> Void)?
  private var isChecked: Bool = false {
    didSet {
      let image = isChecked ? UIImage(systemName: "square.fill") : UIImage(systemName: "square")
      setImage(image!, for: .normal)
    }
  }
  
  override var intrinsicContentSize: CGSize {
    guard let title = titleLabel else {
      return super.intrinsicContentSize
    }
    let size = title.intrinsicContentSize
    return CGSize(width: size.width + contentEdgeInsets.left + contentEdgeInsets.right, height: size.height + contentEdgeInsets.top + contentEdgeInsets.bottom)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    guard let title = titleLabel else { return }
    titleLabel?.preferredMaxLayoutWidth = title.frame.size.width
  }
  
  convenience init(with question: QuestionAnswerModel) {
    self.init()
    self.question = question
    
    let attributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 15.0, weight: .light),
      .foregroundColor: hextoUIColor(hexString: "#565656"),
    ]
    
    let attributedString = NSAttributedString(
      string: question.title,
      attributes: attributes
    )
    
    setAttributedTitle(attributedString, for: .normal)
    
    tintColor = .black
    
    setImage(UIImage(systemName: "square"), for: .normal)
    titleLabel?.numberOfLines = 0
    contentHorizontalAlignment = .leading
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(didPressAnswerFN: @escaping (String) -> Void) {
    self.didPressCallback = didPressAnswerFN
    self.addTarget(self, action: #selector(didTapAnswer), for: .touchUpInside)
  }
  
  @objc
  func didTapAnswer() {
    isChecked.toggle()
    
    if let cb = self.didPressCallback {
      cb(self.question!.id)
    }
  }
  
  func setSelected(_ isChecked: Bool) {
    self.isChecked = isChecked
  }
  
}
