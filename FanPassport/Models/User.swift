//
//  User.swift
//
//  Created by Vadim on 29/09/2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import Foundation

class User {
    
    var id: Int?
    var lastname: String?
    var name: String?
    var secondname: String?
    var mail: String?
    var phone: String?
    var avatar: String?
    var gender: String?
    
    var token: String?
    var uid: String?
    var birthday: String?
    
    var password: String?
    var apiToken: String?
    
    init() {}
    
    init(dictionary: [String: Any]) {
        id = dictionary["id"] as? Int
        lastname = dictionary["lastname"] as? String
        name = dictionary["name"] as? String
        secondname = dictionary["secondname"] as? String
        phone = dictionary["phone"] as? String
        uid = dictionary["uid"] as? String
        token = dictionary["token"] as? String
        mail = dictionary["mail"] as? String
        
        avatar = dictionary["avatar"] as? String
        birthday = dictionary["birthday"] as? String
        gender = dictionary["gender"] as? String

        password = dictionary["password"] as? String
        apiToken = dictionary["api_token"] as? String
    }
}

