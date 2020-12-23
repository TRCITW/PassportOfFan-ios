//
//  PrimaryTextView.swift
//  GameOfMinds
//
//  Created by Vadim on 30/09/2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit

@IBDesignable class PrimaryTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
