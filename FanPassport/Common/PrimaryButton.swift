//
//  PrimaryButton.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

@IBDesignable class PrimaryButton: UIButton {
    
    var buttonTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var buttonDisabledColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    var buttonDisabledTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private var gradientLayer: CAGradientLayer!

    var shadowOpacity: Float = 0.25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    override var isEnabled: Bool {
        didSet {
            isEnabled ? setEnabledStyle() : setDisabledStyle()
        }
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        if let title = title?.trimmingCharacters(in: .whitespacesAndNewlines), title != "OK", title != "ОК" {
            super.setTitle(title.capitalizingFirstLetter, for: state)
        } else {
            super.setTitle(title, for: state)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        isEnabled ? setEnabledStyle() : setDisabledStyle()
    }

    func setupView() {
        adjustsImageWhenHighlighted = false
        layer.cornerRadius = 10
        
        tintColor = buttonTextColor
        setTitleColor(buttonTextColor, for: .normal)
        setTitleColor(buttonDisabledTextColor, for: .disabled)
        titleLabel?.font = UIFont.SVP.regular(size: 14)

        addTarget(self, action: #selector(buttonPressAction), for: .touchDown)
        addTarget(self, action: #selector(buttonReleaseAction), for: .touchUpOutside)
        addTarget(self, action: #selector(buttonReleaseAction), for: .touchUpInside)
    }
    
    func setEnabledStyle() {
        //backgroundColor = buttonColor
        setGradientLayer()
        setShadow()
    }
    
    func setDisabledStyle() {
        backgroundColor = buttonDisabledColor
        dropShadow()
    }
    
    func setShadow() {
        layer.shadowColor = buttonDisabledColor.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: layer.bounds.origin.x + cornerRadius,
                                                            y: layer.bounds.origin.y + layer.bounds.height / 2 + cornerRadius,
                                                            width: layer.bounds.width - cornerRadius * 2,
                                                            height: layer.bounds.height / 2),
                                        cornerRadius: cornerRadius).cgPath
        layer.shadowOpacity = shadowOpacity
    }
    
    func dropShadow() {
        layer.shadowOpacity = 0.0
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
        layer.addSublayer(gradientLayer)

        gradientLayer?.frame = layer.bounds
    //        view.layer.addSublayer(gradientLayer!)
        layer.insertSublayer(self.gradientLayer!, at: 0)
        }
    
    @objc func buttonPressAction() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        }
    }
    
    @objc func buttonReleaseAction() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform.identity
        }
    }
    
}
