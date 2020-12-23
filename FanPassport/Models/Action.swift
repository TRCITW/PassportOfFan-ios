//
//  Action.swift
//  FanPassport
//
//  Created by Vadim on 09.01.2020.
//  Copyright © 2020 yorich. All rights reserved.
//

import Foundation

class Action {
    
    var id: Int?
    var mtype: Int?
    var startdate: String?
    var enddate: String?
    var name: String?
    var descr: String?
    var lat: Double?
    var lon: Double?
    var radius: Int?
    var avatar: String?
    var totaltime: Int?
    var getStarted: Bool? = false
    var isSented: Bool? = false
    
    init() {}
    
    init(dictionary: [String: Any]) {
        id = dictionary["id"] as? Int
        mtype = dictionary["mtype"] as? Int
        startdate = dictionary["startdate"] as? String
        enddate = dictionary["enddate"] as? String
        name = dictionary["name"] as? String
        descr = dictionary["descr"] as? String
        lat = Double(dictionary["lat"] as? String ?? "0")
        lon = Double(dictionary["lon"] as? String ?? "0")
        radius = dictionary["radius"] as? Int
        avatar = dictionary["avatar"] as? String
        totaltime = dictionary["totaltime"] as? Int
        getStarted = dictionary["getStarted"] as? Bool
        isSented = dictionary["isSented"] as? Bool
    }
    
    func dictionaryRepresentation() -> [String: String] {
        var dictionary = [String: String]()
        dictionary["id"] = id?.description
        dictionary["mtype"] = mtype?.description
        dictionary["startdate"] = startdate
        dictionary["enddate"] = enddate
        dictionary["name"] = name
        dictionary["descr"] = descr
        dictionary["lat"] = lat?.description
        dictionary["lon"] = lon?.description
        dictionary["radius"] = radius?.description
        dictionary["avatar"] = avatar
        dictionary["totaltime"] = totaltime?.description
        dictionary["getStarted"] = getStarted?.description
        dictionary["isSented"] = isSented?.description

       return dictionary
    }
}
