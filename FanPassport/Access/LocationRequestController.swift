//
//  LocationRequestController.swift
//  FanPassport
//
//  Created by Vadim on 18.12.2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit

class LocationRequestController: AuthorisationBaseViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activationButton: RedRoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
    }
    
    func UISettings() {

    }
    
    @IBAction func activateButtonAction(_ sender: RedRoundedButton) {
       
    }
    
}

