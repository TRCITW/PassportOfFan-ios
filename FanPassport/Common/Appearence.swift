//
//  Appearence.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

struct Appearence {
    
    // MARK: - Global UI Constants
    
    // Others UI Customization Constants
    static let cornerRadius: CGFloat = 25
    static let defaultCellHeight: CGFloat = 50
    static let sectionHeaderHeight: CGFloat = 30
    static let segmentedControlHeight: CGFloat = 28
    static let basicCellImageSize: CGFloat = 44
    static let defaultButtonHeight: CGFloat = 44
    
    
    // MARK: - Global Appearence
    
    static func customizeAppearence() {
        // NavigationBar
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.svpDeepBlue
        UINavigationBar.appearance().barTintColor = UIColor.svpPureWhite
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.svpDeepBlue,
                                                            .font: UIFont.SVP.bold(size: 17)]
        if #available(iOS 11.0, *) {
           UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.svpDeepBlue,
                                                                    .font: UIFont.SVP.bold(size: 32)]
        } else {
            // workaround: this remove black line under the NavBar on iOS 10
            UINavigationBar.appearance().barStyle = .black
        }
        
        // SearchBar
        UISearchBar.appearance().tintColor = UIColor.svpDeepBlue
        UISearchBar.appearance().barTintColor = UIColor.svpPureWhite
        UISearchBar.appearance().backgroundColor = UIColor.svpPureWhite
        UISearchBar.appearance().backgroundImage = UIImage()
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .svpLinkWater
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes =
            [.foregroundColor: UIColor.svpDeepBlue,
             .font: UIFont.SVP.regular(size: 14)]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder =
            NSAttributedString(string: "Найти", attributes: [.foregroundColor: UIColor.svpGreyChateau, .font: UIFont.SVP.regular(size: 14)])
        
        // UITableView
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = UIColor.svpLinkWater
        
        // Others
        UIRefreshControl.appearance().tintColor = UIColor.svpDeepBlue
    }
    
}


// MARK: - Font Styles

extension UIFont {
    
    struct SVP {
        
        static let fontName = "SFProDisplay"
        
        static func regular(size fontSize: CGFloat) -> UIFont {
            return UIFont(name: "\(fontName)-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }
        
        static func bold(size fontSize: CGFloat) -> UIFont {
            return UIFont(name: "\(fontName)-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        }
        
        static func light(size fontSize: CGFloat) -> UIFont {
            return UIFont(name: "\(fontName)-Light", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .light)
        }
        
        static func medium(size fontSize: CGFloat) -> UIFont {
            return UIFont(name: "\(fontName)-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .light)
        }
        
        static func semibold(size fontSize: CGFloat) -> UIFont {
            return UIFont(name: "\(fontName)-Semibold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .light)
        }
    }
    
}


// MARK: - Colors Library

extension UIColor {
    
    // Main colors (greyscale)
    static let svpPitchBlack = UIColor(hex: 0x000000)
    static let svpDeepBlue = UIColor(hex: 0x001424)
    static let svpMidnightBlue = UIColor(hex: 0x202D3D)
    static let svpGreyRaven = UIColor(hex: 0x6E7782)
    static let svpGreyChateau = UIColor(hex: 0x9198A0)
    static let svpGreyHeather = UIColor(hex: 0xBBC1C7)
    static let svpLinkWater = UIColor(hex: 0xE2E5EB)
    static let svpWhiteSmoke = UIColor(hex: 0xF2F3F7)
    static let svpPureWhite = UIColor(hex: 0xFFFFFF)
    
    static let svpPlaceholderText = UIColor(hex: 0x8595B2)
    static let svpMainText = UIColor(hex: 0x414D63)
    static let svpReferenceText = UIColor(hex: 0xF9593A)
    static let svpGrayLabelText = UIColor(hex: 0x8595B2)
    static let svpErrorLabelText = UIColor(hex: 0xFF0000)
    static let svpGreenLabelText = UIColor(hex: 0x00913B)
    static let svpRedLabelText = UIColor(hex: 0xED1350)
}
