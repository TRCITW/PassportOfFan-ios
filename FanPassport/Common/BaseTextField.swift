//
//  CustomTextField.swift
//  center-city
//
//  Created by Abdul Tawfik on 02/09/2019.
//  Copyright © 2019 tawfik. All rights reserved.
//

import UIKit
import SwiftMaskTextfield

final class BaseTextField: SwiftMaskTextfield {
    
    // MARK: - Visible Properties 👓    
    var isValid: Bool = false
    var type: BaseTextFieldType = .email {
        didSet { setPlaceholder() }
    }
    
    // MARK: - Private Properties 🕶
    private let padding = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 30)
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    // Paddings for text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let edges = UIEdgeInsets(top: 0, left: self.bounds.width - 30, bottom: 0, right: 0)
        return bounds.inset(by: edges)
    }
    
    //
    func sharedInit() {
        setup()
        
        self.delegate = self
    }

}

// MARK: - Delegate
extension BaseTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setDefaultStyle()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch type {
        case .phone:
            self.prefix = type.prefix
            self.formatPattern = type.mask
        case .codeConfirm:
            self.formatPattern = type.mask
        default: break
        }
        
        return true
    }
}

// MARK: - Setup 🛠
extension BaseTextField {
    func setup() {
        textFieldAppearanceConfigure()
    }
    
    func setPlaceholder() {
        self.placeholder = type.placeHolder
        switch type {
        case .email:
            self.keyboardType = .emailAddress
        case .name, .password, .clear:
            self.keyboardType = .default
        case .phone, .codeConfirm:
            self.keyboardType = .decimalPad
        }
    }
    
    func setDefaultStyle() {
        self.isValid = false
        self.rightView = nil
        textFieldAppearanceConfigure()
    }
    
    func isInvalidTextField() {
        self.rightView = nil
        self.isValid = false
        self.layer.borderColor = UIColor.redRounded.cgColor
    }
    
    func isValidTextField() {
        self.isValid = true
        self.rightViewMode = .always
        
        let isValidImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 11))
        isValidImageView.image = UIImage.Icons.greenCheck
        self.layer.borderColor = UIColor.northTexasGreen.cgColor
        isValidImageView.contentMode = .left
        // self.layer.sublayerTransform = CATransform3DMakeTranslation(0.0, 0.0, 20.0)
        self.rightView = isValidImageView
    }        
    
    func textFieldAppearanceConfigure() {
        self.borderStyle = .none
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.backgroundColor = .white
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.heatherGray.cgColor
        self.layer.backgroundColor = UIColor.heatherGray.cgColor
        switch type {
        case .phone:
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        default:
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.heatherGray])
        }
        
    }
}
