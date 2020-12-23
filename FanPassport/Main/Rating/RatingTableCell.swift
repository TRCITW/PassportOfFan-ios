//
//  RatingTableCell.swift
//  GameOfMinds
//
//  Created by Vadim on 06/10/2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit

class RatingTableCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var medalImage: UIImageView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var initialsLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.backgroundColor = .white
        
        avatarImage.layer.cornerRadius = 25
        
        nameLabel.font = UIFont.SVP.semibold(size: 14)
        nameLabel.textColor = UIColor.svpMainText
        
        placeLabel.font = UIFont.SVP.bold(size: 18)
        placeLabel.layer.cornerRadius = 4
        
        moneyLabel.font = UIFont.SVP.regular(size: 14)
        moneyLabel.textColor = UIColor.svpPlaceholderText
    }
}
