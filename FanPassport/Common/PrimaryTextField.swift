//
//  PrimaryTextField.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

@IBDesignable class PrimaryTextField: UITextField {
    
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
   
   
   func setupView() {
        backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9764705882, alpha: 1)
        layer.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9764705882, alpha: 1)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9254901961, blue: 0.9490196078, alpha: 1)
        font = UIFont.SVP.semibold(size: 14)
        textColor = UIColor.svpMainText
   }
}
