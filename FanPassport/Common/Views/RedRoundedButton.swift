//
//  RedRoundedButton.swift
//  center-city
//
//  Created by Abdul Tawfik on 28/08/2019.
//  Copyright © 2019 tawfik. All rights reserved.
//

import UIKit

@IBDesignable class RedRoundedButton: UIButton {
    
    // MARK: - Properties
    var buttonCorner: CGFloat = 5 {
        didSet { layer.cornerRadius = buttonCorner }
    }
    
    var titleColor: UIColor = .white {
        didSet { self.tintColor = titleColor }
    }
    
    var buttonBackgroundColor: UIColor = .clear {
        didSet { backgroundColor = buttonBackgroundColor }
    }
    
    var buttonDisableBackgroundColor: UIColor = UIColor(red: 0.93, green: 0.07, blue: 0.31, alpha: 0.5) {
        didSet { backgroundColor = buttonDisableBackgroundColor }
    }
    
    //var view = UILabel()
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
        
        clipsToBounds = true
        layer.cornerRadius = buttonCorner
        backgroundColor = buttonBackgroundColor
        
        setTitleColor(titleColor)
        setTitle(self.titleLabel?.text)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        setup()
    }
    
    override var isEnabled: Bool {
        didSet {
            isEnabled ? (backgroundColor = buttonBackgroundColor) : (backgroundColor = buttonDisableBackgroundColor)
        }
    }
}

// MARK: - Setup 🛠
extension RedRoundedButton {
    func setup() {
        setGradientLayer()
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

// MARK: - Button Tapped animation
extension RedRoundedButton {
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
        }
    }
}
