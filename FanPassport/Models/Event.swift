//
//  Event.swift
//  FanPassport
//
//  Created by Vadim on 26.12.2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import Foundation

class Event {
    var name: String?
    var image: String?
    var date: String?
    var time: String?
    var place: String?
    
    init() {}
    
    init(dictionary: [String: AnyObject]) {
        name = dictionary["name"] as? String
        image = dictionary["image"] as? String
        date = dictionary["date"] as? String
        time = dictionary["time"] as? String
        place = dictionary["place"] as? String
    }
}
