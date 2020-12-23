//
//  MainTabBarController.swift
//  center-city
//
//  Created by Vadim on 30/10/2019.
//  Copyright © 2019 svp. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var isLoginAction = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
    }
    
    func UISettings() {
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .clear
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = true
    }
}
