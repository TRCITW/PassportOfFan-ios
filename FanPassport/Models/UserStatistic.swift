//
//  UserStatistic.swift
//  FanPassport
//
//  Created by Vadim on 09.01.2020.
//  Copyright © 2020 yorich. All rights reserved.
//

import Foundation

class UserStatistic {
    
    var idaction: Int?
    var totaltime: Int?
    
    init() {}
    
    init(dictionary: [String: AnyObject]) {
        idaction = dictionary["idaction"] as? Int
        totaltime = dictionary["totaltime"] as? Int
    }
}
