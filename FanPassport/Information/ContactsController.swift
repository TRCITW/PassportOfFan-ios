//
//  Contacts.swift
//  GameOfMinds
//
//  Created by Vadim on 27/09/2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit

class ContactsController: BaseViewController {
    
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var sileLabel: UILabel!
    @IBOutlet weak var phoneLabel: CardView!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    var headerIsHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
    }
    
    func UISettings() {
        title = NSLocalizedString("Contacts", comment: "")
        headerStackView.isHidden = headerIsHidden
        scrollViewTopConstraint.constant = headerIsHidden ? -45.0 : 0
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadButtonAction(_ sender: Any) {
    }
    
    @IBAction func viberButtonAction(_ sender: Any) {
    }
    
    @IBAction func telegramButtonAction(_ sender: Any) {
    }
    
    @IBAction func facebookButtonAction(_ sender: Any) {
    }
    
    @IBAction func instagramButtonAction(_ sender: Any) {
    }
    
    
}
