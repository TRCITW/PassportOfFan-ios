//
//  EventsTableCell.swift
//  FanPassport
//
//  Created by Vadim on 26.12.2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit

class EventsTableCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventPlaceLabel: UILabel!
    @IBOutlet weak var eventButton: EventCellButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.backgroundColor = .white
        
        eventImage.layer.cornerRadius = 25
        
        eventNameLabel.font = UIFont.SVP.bold(size: 18)
        eventNameLabel.textColor = UIColor.svpMainText
        
        eventDateLabel.font = UIFont.SVP.bold(size: 14)
        eventDateLabel.textColor = UIColor.svpMainText
        
        eventTimeLabel.font = UIFont.SVP.regular(size: 14)
        eventTimeLabel.textColor = UIColor.svpPlaceholderText
        
        eventPlaceLabel.font = UIFont.SVP.regular(size: 12)
        eventPlaceLabel.textColor = UIColor.svpPlaceholderText
    }
}
