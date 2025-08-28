//
//  OvalOverlayView.swift
//  AmaniUIv1
//
//  Created by Deniz Can on 6.10.2022.
//

import UIKit

internal class OvalOverlayView: UIView {
  
  var screenBounds:CGRect!
  var overlayFrame: CGRect?
  var bgColor: UIColor!
  var strokeColor: UIColor!
  let ovalLayer = CAShapeLayer()
  var heightofbuttom:CGFloat = 0
  var color:UIColor = .green
  var animationEndCB:(()->())? = nil
  
  
  internal init(bgColor: UIColor,strokeColor:UIColor, bottomOuterViewHeight: CGFloat = 0, screenBounds:CGRect) {
    super.init(frame: screenBounds)
    self.screenBounds = screenBounds
    backgroundColor = UIColor.clear
    accessibilityIdentifier = "takeASelfieOvalOverlayView"
    self.bgColor = bgColor
    self.strokeColor = strokeColor
    self.heightofbuttom = bottomOuterViewHeight
    
    
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    let overlayPath = UIBezierPath(rect: bounds)
    let ovalPath = UIBezierPath(ovalIn: self.getOvalOverlayFrame())
    overlayPath.append(ovalPath)
    overlayPath.usesEvenOddFillRule = true
    // draw oval layer
    ovalLayer.path = ovalPath.cgPath
    ovalLayer.fillColor = UIColor.clear.cgColor
    ovalLayer.strokeColor = strokeColor.cgColor
    ovalLayer.lineWidth = 5.0
    // draw layer that fills the view
    let fillLayer = CAShapeLayer()
    fillLayer.path = overlayPath.cgPath
    fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
    fillLayer.fillColor = bgColor.cgColor
    // add layers
    layer.addSublayer(fillLayer)
    layer.addSublayer(ovalLayer)
  }
  
  func changeColor(color:UIColor,callback:@escaping ()->()){
    self.color = color
    self.animationEndCB = callback
    DispatchQueue.main.async {
      let colorAnimation = CABasicAnimation(keyPath: "ovalLayer")
      colorAnimation.toValue = color.cgColor
      colorAnimation.keyPath = #keyPath(CAShapeLayer.strokeColor)
      colorAnimation.duration = 1
      colorAnimation.repeatCount = 0
      colorAnimation.delegate = self
      colorAnimation.fillMode = .forwards
      colorAnimation.isRemovedOnCompletion = false
      self.ovalLayer.add(colorAnimation, forKey: "ovalLayer")
    }
  }
  func getOvalOverlayFrame() -> CGRect {
    let ovalHeight:CGFloat = 350
    let ovalWidth = (ovalHeight*3)/4
    
    let frame = CGRect(x: (screenBounds.midX - ovalWidth / 2),
                       y: (screenBounds.midY - (ovalHeight)  / 2) ,
                       width: ovalWidth,
                       height: ovalHeight)
    return frame
    
  }
  
  
  
}

extension OvalOverlayView:CAAnimationDelegate{
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    self.animationEndCB?()
  }
}
