//
//  CardView.swift
//  center-city
//
//  Created by Abdul Tawfik on 28/08/2019.
//  Copyright © 2019 tawfik. All rights reserved.
//

import UIKit

final class AuthCardView: UIView {
    
    // MARK: - Private Properties 🕶
    
    // MARK: - Properties
    var viewCorner: CGFloat = 10.0 {
        didSet { layer.cornerRadius = viewCorner }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //
    func sharedInit() {

        backgroundColor = .clear
        cornerRadius = viewCorner
    }
}

// MARK: - Setup 🛠
extension AuthCardView {
    func setup() {
        
    }    
}
