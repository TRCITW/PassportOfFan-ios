//
//  CustomTitleview.swift
//  center-city
//
//  Created by Abdul Tawfik on 28/08/2019.
//  Copyright © 2019 tawfik. All rights reserved.
//

import UIKit

final class CustomTitleView: UIView {
    
    // MARK: - Private Properties 🕶
    private let logoImageView = UIImageView()
    private let titleLogoImageView = UIImageView()

    
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
        setup()
        frame = CGRect(x: 0, y: 0, width: 92, height: 60)
        clipsToBounds = true
        layer.cornerRadius = 10
        backgroundColor = .white
    }
}

// MARK: - Setup 🛠
private extension CustomTitleView {
    func setup() {
       setImages()
    }
    
    func setImages() {
        let topPadding: Int = 5
        let leftPadding: Int = 10
        let imageHeight: Int = 35
        let logoImageViewWidth: Int = 12
        let titleLogoImageViewWidth: Int = 55
    
        addSubview(logoImageView)
        // x - горизонтально, y - вертикально
        logoImageView.image = UIImage.Icons.logo
        logoImageView.frame = CGRect(x: leftPadding, y: topPadding, width: logoImageViewWidth, height: imageHeight)

        addSubview(titleLogoImageView)
        titleLogoImageView.image = UIImage.Icons.titleLogo
        titleLogoImageView.frame = CGRect(x: (leftPadding + logoImageViewWidth) + 3, y: topPadding,
                                          width: titleLogoImageViewWidth, height: imageHeight)
    }
}
