//
//  RoundedTextInput.swift
//  AmaniDemoApp
//
//  Created by Deniz Can on 6.12.2023.
//

import Combine
import Foundation
import UIKit

class RoundedTextInput: UIView {
  private var hasRenderedInitial = false

  var textPublisher: AnyPublisher<String, Never> {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: field)
      .compactMap { ($0.object as? UITextField)?.text }
      .eraseToAnyPublisher()
  }

  private let passwordToggleButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    button.setImage(UIImage(systemName: "eye"), for: .selected)
    button.tintColor = .lightGray
    button.contentMode = .scaleAspectFit
    return button
  }()

  // Escape hatch.
  public let field: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false

    return textField
  }()

  private let errorLabel: UILabel = {
    let label = UILabel()
    label.textColor = hextoUIColor(hexString: "#FF0000")
    label.text = "Default Error Message"
    label.font = UIFont.systemFont(ofSize: 12.0, weight: .bold)
    return label
  }()

  convenience init(
    placeholderText: String,
    borderColor: UIColor,
    placeholderColor: UIColor,
    isPasswordToggleEnabled: Bool,
    keyboardType: UIKeyboardType
  ) {
    self.init()
    commonInit(
      placeHolderText: placeholderText,
      borderColor: borderColor,
      placeholderColor: placeholderColor,
      keyboardType: keyboardType,
      isPasswordToggleEnabled: isPasswordToggleEnabled
    )
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit(
    placeHolderText: String = "",
    borderColor: UIColor = .lightGray,
    placeholderColor: UIColor = .lightGray,
    backgroundColor: UIColor = .white,
    keyboardType: UIKeyboardType = .default,
    isPasswordToggleEnabled: Bool = false) {
    self.backgroundColor = backgroundColor
    layer.cornerRadius = 24
    layer.cornerCurve = .continuous
    layer.borderWidth = 1
    layer.borderColor = hextoUIColor(hexString: "#C0C0C0").cgColor

    let insets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: insets.left, height: frame.height))
    field.leftViewMode = .never
    field.keyboardType = keyboardType
    field.returnKeyType = .done
    field.delegate = self

    if isPasswordToggleEnabled {
      field.isSecureTextEntry = true
      field.rightView = passwordToggleButton
      field.rightViewMode = .always

      // Add target for the password toggle button
      passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }

    addSubview(field)
    field.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: 50),
    ])

    NSLayoutConstraint.activate([
      field.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      field.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
      field.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      field.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
    ])

    field.attributedPlaceholder =
      NSAttributedString(string: placeHolderText,
                         attributes:
                         [NSAttributedString.Key.foregroundColor: placeholderColor,
                         ]
      )
    field.textColor = .black
    field.font = UIFont.systemFont(ofSize: 16)

    addSubview(errorLabel)
    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      errorLabel.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 12.0),
      errorLabel.leadingAnchor.constraint(equalTo: field.leadingAnchor),
      errorLabel.trailingAnchor.constraint(equalTo: field.trailingAnchor),
    ])
    errorLabel.isHidden = true

    field.addTarget(self, action: #selector(postEditing), for: .editingDidBegin)
    field.addTarget(self, action: #selector(postEditing), for: .editingDidEnd)
  }

  @objc private func togglePasswordVisibility() {
    field.isSecureTextEntry.toggle()
    passwordToggleButton.isSelected = !field.isSecureTextEntry
  }

  func showError(message: String) {
    errorLabel.text = message
    errorLabel.isHidden = false
    layer.borderColor = hextoUIColor(hexString: "#FF0000").cgColor
  }

  func hideError() {
    errorLabel.isHidden = true
    // TODO: Add special case for focused
    layer.borderColor = hextoUIColor(hexString: "#C0C0C0").cgColor
  }

  func updatePlaceHolder(text: String, color: UIColor = .lightGray) {
    field.attributedPlaceholder =
      NSAttributedString(string: text,
                         attributes:
                         [NSAttributedString.Key.foregroundColor: color,
                         ]
      )
  }

  @objc
  private func postEditing() {
    setFocusBorderColors(isFocused: field.isFirstResponder)
  }

  func setFocusBorderColors(isFocused: Bool) {
    hasRenderedInitial = true
    if isFocused {
      layer.borderColor = hextoUIColor(hexString: "#515166").cgColor
    } else {
      layer.borderColor = hextoUIColor(hexString: "#C0C0C0").cgColor
    }
    setNeedsDisplay()
  }

  func setDelegate(delegate: UITextFieldDelegate) {
    field.delegate = delegate
  }
}

extension RoundedTextInput: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder() // Dismiss the keyboard
    return true
  }
}
