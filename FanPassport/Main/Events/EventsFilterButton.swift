//
//  EventsFilterButton.swift
//  FanPassport
//
//  Created by Vadim on 27.12.2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit

@IBDesignable class EventsFilterButton: UIButton {
     
     private var gradientLayer: CAGradientLayer!
     
     // MARK: - Constructor 🏗
     override init(frame: CGRect) {
         super.init(frame: frame)
         
         sharedInit()
     }
     
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         
         sharedInit()
     }
     
     // MARK: - LifeCycle 🌏
     override func prepareForInterfaceBuilder() {
         sharedInit()
     }
     
     //
     func sharedInit() {
        layer.cornerRadius = 20
        backgroundColor = .clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.svpMainText.cgColor
         clipsToBounds = true
         titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
         setTitle(self.titleLabel?.text)
     }
    
    func selectedStyle(isSelected: Bool) {
        
        if isSelected {
            setTitleColor(.white)
            backgroundColor = UIColor(red: 0.981, green: 0, blue: 0.999, alpha: 1)
//            setGradientLayer()
        } else {
//            if var sl = layer.sublayers {
//                sl.removeAll()
//            }
            setTitleColor(.svpMainText)
            backgroundColor = .clear
        }
    }

    
    func setTitle(_ title: String?) {
        setTitle(title, for: .normal)
        setTitle(title, for: .disabled)
        setTitle(title, for: .selected)
        setTitle(title, for: .highlighted)
    }
    
    func setTitleColor(_ color: UIColor) {
        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .focused)
        setTitleColor(color, for: .disabled)
        setTitleColor(color, for: .selected)
        setTitleColor(color, for: .application)
        setTitleColor(color, for: .highlighted)
    }
    
    func setGradientLayer() {
        guard self.gradientLayer == nil else { return }
        self.gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [
            UIColor(red: 0.659, green: 0.016, blue: 0.671, alpha: 1).cgColor,
            UIColor(red: 0.981, green: 0, blue: 0.999, alpha: 1).cgColor,
            UIColor(red: 0.88, green: 0, blue: 0.896, alpha: 1).cgColor
        ]
        
        gradientLayer?.locations = [0, 1, 1]
        gradientLayer?.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer?.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientLayer?.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 1, c: -1, d: 19.58, tx: 0.5, ty: -9.79))
        gradientLayer?.bounds = layer.bounds.insetBy(dx: -0.5 * layer.bounds.size.width, dy: -0.5 * layer.bounds.size.height)
        layer.insertSublayer(self.gradientLayer!, at: 0)
    }
}
