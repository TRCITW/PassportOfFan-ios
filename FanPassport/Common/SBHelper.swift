//
//  SBHelper.swift
//  FanPassport
//
//  Created by tox on 9/7/20.
//  Copyright © 2020 yorich. All rights reserved.
//

import UIKit

class SBHelper {
    class Auth {
        class func accessVC() -> UIViewController {
            return UIStoryboard(name: "Access", bundle: nil).instantiateViewController(withIdentifier: "AccessVC")
        }
    }
    
    class Main {
        class func mainTabBar() -> MainTabBarController {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! MainTabBarController
        }
    }
}
