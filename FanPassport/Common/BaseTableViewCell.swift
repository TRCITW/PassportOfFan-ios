//
//  BaseTableViewCell.swift
//  center-city
//
//  Created by Abdul Tawfik on 28/08/2019.
//  Copyright © 2019 tawfik. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }

    // MARK: - LifeCycle 🌏
    override func awakeFromNib() {
        super.awakeFromNib()
           
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.layer.cornerRadius = 10
    }        
}
