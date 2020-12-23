//
//  SecondaryButton.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

@IBDesignable class SecondaryButton: UIButton {
    
    var buttonColor = UIColor(red: 0.98, green: 0.35, blue: 0.23, alpha: 0.2)
    var buttonTextColor = #colorLiteral(red: 0.9904158711, green: 0.4409633279, blue: 0.2889467776, alpha: 1)
    var buttonDisabledColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    var buttonDisabledTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

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
        backgroundColor = buttonColor
        setShadow()
    }
    
    func setDisabledStyle() {
        backgroundColor = buttonDisabledColor
        dropShadow()
    }
    
    func setShadow() {
        layer.shadowColor = buttonColor.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: layer.bounds.origin.x + cornerRadius,
                                                            y: layer.bounds.origin.y + layer.bounds.height / 2 + cornerRadius,
                                                            width: layer.bounds.width - 20,
                                                            height: layer.bounds.height / 2),
                                        cornerRadius: cornerRadius).cgPath
        layer.shadowOpacity = shadowOpacity
    }
    
    func dropShadow() {
        layer.shadowOpacity = 0.0
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
