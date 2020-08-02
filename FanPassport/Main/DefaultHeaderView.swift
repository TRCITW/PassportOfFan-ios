//
//  DefaultHeaderView.swift
//  FanPassport
//
//  Created by Vadim on 25.12.2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit

class DefaultHeaderView: UIView {

    let titleLabel = UILabel()
    let showButton = UIButton()
    var viewAsFooter = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupView()
    }

    func setupView() {
        backgroundColor = .clear
        titleLabel.isHidden = viewAsFooter
        showButton.isHidden = !viewAsFooter

        titleLabel.textColor = UIColor.svpMainText
        titleLabel.font = UIFont.SVP.regular(size: 16)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        
        showButton.tintColor = UIColor(hex: 0xD002D4)
        showButton.setTitleColor(UIColor(hex: 0xD002D4), for: .normal)
        showButton.titleLabel?.font = UIFont.SVP.semibold(size: 13)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        showButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(showButton)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            showButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 8),
            showButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -8),
            showButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

}
