//
//  Rating.swift
//  FanPassport
//
//  Created by Vadim on 09.01.2020.
//  Copyright © 2020 yorich. All rights reserved.
//

import Foundation

class Rating {
    
    var idfun: Int?
    var totaltime: Int?
    var name: String?
    var lastname: String?
    var secondname: String?
    var gender: String?
    var phone: String?
    var avatar: String?
    
    init() {}
    
    init(dictionary: [String: AnyObject]) {
        idfun = dictionary["idfun"] as? Int
        totaltime = dictionary["totaltime"] as? Int
        name = dictionary["name"] as? String
        lastname = dictionary["lastname"] as? String
        secondname = dictionary["secondname"] as? String
        gender = dictionary["gender"] as? String
        phone = dictionary["phone"] as? String
        avatar = dictionary["avatar"] as? String
    }
}
