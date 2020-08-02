//
//  InfoAlertView.swift
//  center-city
//
//  Created by Vadim on 07/11/2019.
//  Copyright © 2019 svp. All rights reserved.
//

import UIKit

class InfoAlertView: UIView {
    

    // MARK: - IBOutlets 🔌

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var registerButton: RedRoundedButton!

    // MARK: - LifeCycle 🌏
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    

    func setupView() {
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
    
    class func instanceFromNib() -> InfoAlertView {
        return UINib(nibName: "InfoAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! InfoAlertView
    }
    
    func addInView(view: UIView) {
        frame = view.bounds
        isHidden = true
        view.addSubview(self)
    }
    
    func showAlert(caption: String?, info: String?, buttonText: String = "OK") {
        self.captionLabel.text = caption
        self.infoLabel.text = info
        self.registerButton.setTitle(buttonText, for: .normal)
        self.isHidden = false
    }
}
