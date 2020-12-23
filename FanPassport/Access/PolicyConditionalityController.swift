//
//  PolicyConditionalityController.swift
//  center-city
//
//  Created by Vadim on 27/10/2019.
//  Copyright © 2019 svp. All rights reserved.
//

import UIKit

class PolicyConditionalityController: AuthorisationBaseViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var privacyTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
    }
    
    func UISettings() {
        privacyTextView.layer.cornerRadius = 5
        privacyTextView.layer.masksToBounds = true
        
    }
}
