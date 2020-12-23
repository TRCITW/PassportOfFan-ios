//
//  UserAgreement.swift
//  GameOfMinds
//
//  Created by Vadim on 27/09/2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit

class UserAgreementController: BaseViewController {
    
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var infoTextView: UITextView!
    
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    var headerIsHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
    }
    
    func UISettings() {
        title = NSLocalizedString("User agreement", comment: "")
        headerStackView.isHidden = headerIsHidden
        scrollViewTopConstraint.constant = headerIsHidden ? -45.0 : 0
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
