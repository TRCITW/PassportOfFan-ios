//
//  UIImage.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    enum Icons {
        static var edit: UIImage {
            return UIImage(named: "editIcon")!
        }
        
        static var menuList: UIImage {
            return UIImage(named: "menuList")!
        }
        
        static var location: UIImage {
            return UIImage(named: "locationIcon")!
        }
        
        static var notification: UIImage {
            return UIImage(named: "notification")!
        }
        
        static var notificationsList: UIImage {
            return UIImage(named: "notificationListIcon")!
        }
        
        static var logout: UIImage {
            return UIImage(named: "logoutIcon")!
        }
        
        static var backButton: UIImage {
            return UIImage(named: "backButton")!
        }
        
        static var checkRectangle: UIImage {
            return UIImage(named: "check_rectangle")!
        }
        
        static var logo: UIImage {
            return UIImage(named: "logo")!
        }
        
        static var titleLogo: UIImage {
            return UIImage(named: "titleLogo")!
        }
        
        static var greenCheck: UIImage {
            return UIImage(named: "greenCheck")!
        }
        
        static var flashOff: UIImage {
            return UIImage(named: "flashOff")!
        }
        
        static var flashOn: UIImage {
            return UIImage(named: "flashOn")!
        }
        
        static var tickIcon: UIImage {
            return UIImage(named: "tick")!
        }
    }
    
    enum TabBarIcons {
        static var profile: UIImage {
            return UIImage(named: "profile")!
        }
        
        static var profileSelect: UIImage {
            return UIImage(named: "profile_select")!
        }
        
        static var stocks: UIImage {
            return UIImage(named: "stocks")!
        }
        
        static var stocksSelect: UIImage {
            return UIImage(named: "stocks_select")!
        }
        
        static var newsList: UIImage {
            return UIImage(named: "newsList")!
        }
        
        static var newsListSelect: UIImage {
            return UIImage(named: "newsList_select")!
        }
        
        static var checks: UIImage {
            return UIImage(named: "checks")!
        }
        
        static var checksSelect: UIImage {
            return UIImage(named: "checks_select")!
        }
    }
}
