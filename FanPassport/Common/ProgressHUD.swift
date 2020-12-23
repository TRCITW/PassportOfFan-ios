//
//  ProgressHUD.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

class ProgressHUD {
    
    let boxSize: CGFloat = 100
    
    let containerView = UIView()
    let boxView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    weak var presenter: UIView?
    
    init() {
        setupUI()
    }
    
    func setupUI() {
        containerView.backgroundColor = UIColor.svpDeepBlue.withAlphaComponent(0.3)
        
        boxView.backgroundColor = UIColor.svpDeepBlue.withAlphaComponent(0.8)
        boxView.layer.cornerRadius = Appearence.cornerRadius
        boxView.clipsToBounds = true
        boxView.frame = CGRect(x: 0, y: 0, width: boxSize, height: boxSize)
        
        boxView.addSubview(activityIndicator)
        containerView.addSubview(boxView)
    }

    func show(on presenter: UIView) {
        self.presenter = presenter
        
        containerView.frame = presenter.frame
        containerView.center = presenter.center
        boxView.center = containerView.center
        activityIndicator.center = CGPoint(x: boxView.bounds.midX, y: boxView.bounds.midY)
            
        presenter.addSubview(containerView)
        presenter.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    func hide() {
        activityIndicator.stopAnimating()
        presenter?.isUserInteractionEnabled = true
        containerView.removeFromSuperview()
    }

}
