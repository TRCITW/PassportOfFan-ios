//
//  CardView.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {

    let shadowRadius: CGFloat = 10
    let shadowOffsetWidth = 0
    let shadowOffsetHeight = 2
    let shadowColor = UIColor.init(red: 0.05, green: 0.5, blue: 1, alpha: 0.15)
    let shadowOpacity: Float = 1

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupView()
    }

    private func setupView() {
        backgroundColor = .white
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
    }

}
