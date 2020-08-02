//
//  UIView.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

extension UIView {
    
    func dropShadow(color: UIColor = .black, opacity: Float = 0.3, offSet: CGSize = .zero, radius: CGFloat = 3) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
    
    func layerGradient(colors: [CGColor]) {
        let glayer : CAGradientLayer = CAGradientLayer()
        glayer.frame.size = self.frame.size
        glayer.frame.origin = .zero
        glayer.colors = colors
        layer.addSublayer(glayer)
    }
    
    func rounded() {
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.height/2
    }

    func bordered(color: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), borderWidth: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
    }
    
//    class func instantiateFromNib<T: UIView>(viewType: T.Type) -> T {
//        return Bundle.main.loadNibNamed(String(describing: viewType), owner: nil, options: nil)!.first as! T
//    }
//    
//    class func instantiateFromNib() -> Self {
//        return instantiateFromNib(viewType: self)
//    }
//    
//    class func fromNib<T: UIView>() -> T {
//        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first as! T
//    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
}
