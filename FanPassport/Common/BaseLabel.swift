//
//  BaseLabel.swift
//  center-city
//
//  Created by Abdul Tawfik on 28/08/2019.
//  Copyright © 2019 tawfik. All rights reserved.
//

import UIKit

final class BaseLabel: UILabel {
    
    // MARK: - Properties
    var labelColor: UIColor = .gunPowder {
        didSet { self.textColor = labelColor }
    }
    
    @IBInspectable
    var isHeader: Bool = false {
        didSet {
            if isHeader {
                guard let customFont = UIFont(name: CustomFonts.robotaBlack, size: 24.0) else { return }
                self.font = customFont
            } else {
                guard let customFont = UIFont(name: CustomFonts.robotaBold, size: 14.0) else { return }
                self.font = customFont
            }
        }
    }
    
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
        
        self.numberOfLines = 0 
        self.textColor = labelColor
    }
}

// MARK: - Setup 🛠
extension BaseLabel {
    func setup() {
        
    }
}
