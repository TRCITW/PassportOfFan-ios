//
//  MaskTextField.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit
    
@IBDesignable open class MaskTextField: UITextField {

        // damn, maskView is just mask in Swift
        public private(set) var stringMask: JMStringMask?
        fileprivate weak var realDelegate: UITextFieldDelegate?
        
        override weak open var delegate: UITextFieldDelegate? {
            get {
                return self.realDelegate
            }
            
            set (newValue) {
                self.realDelegate = newValue
                super.delegate = self
            }
        }
        
        public var unmaskedText: String? {
            get {
                return self.stringMask?.unmask(string: self.text) ?? self.text
            }
        }
        
        @IBInspectable open var maskString: String? {
            didSet {
                guard let maskString = self.maskString else { return }
                self.stringMask = JMStringMask(mask: maskString)
            }
        }
        
        override public init(frame: CGRect) {
            super.init(frame: frame)
            
            self.commonInit()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            
            self.commonInit()
        }
        
        override open func awakeFromNib() {
            super.awakeFromNib()
            
            self.commonInit()
        }
        
        func commonInit() {
            super.delegate = self
            backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9764705882, alpha: 1)
            layer.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9764705882, alpha: 1)
            layer.cornerRadius = 5
            layer.borderWidth = 1
            layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9254901961, blue: 0.9490196078, alpha: 1)
            font = UIFont.SVP.semibold(size: 14)
            textColor = UIColor.svpMainText
        }
        
    }

    extension MaskTextField: UITextFieldDelegate {
        
        public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            return self.realDelegate?.textFieldShouldBeginEditing?(textField) ?? true
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.realDelegate?.textFieldDidBeginEditing?(textField)
        }
        
        public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            return self.realDelegate?.textFieldShouldEndEditing?(textField) ?? true
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField) {
            self.realDelegate?.textFieldDidEndEditing?(textField)
        }
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            let previousMask = self.stringMask
            let currentText: NSString = textField.text as NSString? ?? ""
            
            if let realDelegate = self.realDelegate, realDelegate.responds(to: #selector(textField(_:shouldChangeCharactersIn:replacementString:))) {
                let delegateResponse = realDelegate.textField!(textField, shouldChangeCharactersIn: range, replacementString: string)
                
                if !delegateResponse {
                    return false
                }
            }
            
            guard let mask = self.stringMask else { return true }
            
            let newText = currentText.replacingCharacters(in: range, with: string)
            var formattedString = mask.mask(string: newText)
            
            // if the mask changed or if the text couldn't be formatted,
            // unmask the newText and mask it again
            if (previousMask != nil && mask != previousMask!) || formattedString == nil {
                let unmaskedString = mask.unmask(string: newText)
                formattedString = mask.mask(string: unmaskedString)
            }
            
            guard let finalText = formattedString as NSString? else { return false }
            
            // if the cursor is not at the end and the string hasn't changed
            // it means the user tried to delete a mask character, so we'll
            // change the range to include the character right before it
            if finalText == currentText && range.location < currentText.length && range.location > 0 {
                return self.textField(textField, shouldChangeCharactersIn: NSRange(location: range.location - 1, length: range.length + 1) , replacementString: string)
            }
            
            if finalText != currentText {
                textField.text = finalText as String
                
                // the user is trying to delete something so we need to
                // move the cursor accordingly
                if range.location < currentText.length {
                    var cursorLocation = 0
                    
                    if range.location > finalText.length {
                        cursorLocation = finalText.length
                    } else if currentText.length > finalText.length {
                        cursorLocation = range.location
                    } else {
                        cursorLocation = range.location + 1
                    }
                    
                    guard let startPosition = textField.position(from: textField.beginningOfDocument, offset: cursorLocation) else { return false }
                    guard let endPosition = textField.position(from: startPosition, offset: 0) else { return false }
                    textField.selectedTextRange = textField.textRange(from: startPosition, to: endPosition)
                }
                
                return false
            }
            
            return true
        }
        
        public func textFieldShouldClear(_ textField: UITextField) -> Bool {
            return self.realDelegate?.textFieldShouldClear?(textField) ?? true
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            return self.realDelegate?.textFieldShouldReturn?(textField) ?? true
        }
        
    }



fileprivate struct Constants {
    static let letterMaskCharacter: Character = "A"
    static let numberMaskCharacter: Character = "0"
    static let alphanumericMaskCharacter: Character = "*"
}

public struct JMStringMask: Equatable {
    
    var mask: String = ""
    
    private init() { }
    
    public init(mask: String) {
        self.init()
        
        self.mask = mask
    }
    
    public static func ==(lhs: JMStringMask, rhs: JMStringMask) -> Bool {
        return lhs.mask == rhs.mask
    }
    
    public func mask(string: String?) -> String? {
        
        guard let string = string else { return nil }

        if string.count > self.mask.count {
            return nil
        }
        
        var formattedString = ""
        
        var currentMaskIndex = 0
        for i in 0..<string.count {
            if currentMaskIndex >= self.mask.count {
                return nil
            }
            
            let currentCharacter = string[string.index(string.startIndex, offsetBy: i)]
            var maskCharacter = self.mask[self.mask.index(string.startIndex, offsetBy: currentMaskIndex)]
            
            if currentCharacter == maskCharacter {
                formattedString.append(currentCharacter)
            } else {
                while (maskCharacter != Constants.letterMaskCharacter
                    && maskCharacter != Constants.numberMaskCharacter
                    && maskCharacter != Constants.alphanumericMaskCharacter) {
                    formattedString.append(maskCharacter)
                    
                    currentMaskIndex += 1
                    maskCharacter = self.mask[self.mask.index(string.startIndex, offsetBy: currentMaskIndex)]
                }
                
                if maskCharacter != Constants.alphanumericMaskCharacter {
                    let isValidLetter = maskCharacter == Constants.letterMaskCharacter && self.isValidLetterCharacter(currentCharacter)
                    let isValidNumber = maskCharacter == Constants.numberMaskCharacter && self.isValidNumberCharacter(currentCharacter)
                    
                    if !isValidLetter && !isValidNumber {
                        return nil
                    }
                }
                
                formattedString.append(currentCharacter)
            }
            
            currentMaskIndex += 1
        }
        
        return formattedString
    }
    
    public func unmask(string: String?) -> String? {
        
        guard let string = string else { return nil }
        var unmaskedValue = ""
        
        for character in string {
            if self.isValidLetterCharacter(character) || self.isValidNumberCharacter(character) {
                unmaskedValue.append(character)
            }
        }
        
        return unmaskedValue
    }
    
    private func isValidLetterCharacter(_ character: Character) -> Bool {

        let string = String(character)
        if string.unicodeScalars.count > 1 {
            return false
        }
        
        let lettersSet = NSCharacterSet.letters
        let unicodeScalars = string.unicodeScalars
        return lettersSet.contains(unicodeScalars[unicodeScalars.startIndex])
    }
    
    private func isValidNumberCharacter(_ character: Character) -> Bool {
        
        let string = String(character)
        if string.unicodeScalars.count > 1 {
            return false
        }
        
        let lettersSet = NSCharacterSet.decimalDigits
        let unicodeScalars = string.unicodeScalars
        return lettersSet.contains(unicodeScalars[unicodeScalars.startIndex])
    }
    
}
