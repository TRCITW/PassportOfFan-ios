//
//  LoginResponse.swift
//  center-city
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import Foundation

class LoginResponse {
    
    var success: Bool?
    var error: String?
    var user: User?
    
    init() {}
    
    init(dictionary: [String: AnyObject]) {
        success = dictionary["status"] as? Bool
        error = dictionary["error"] as? String
        if let dict = dictionary["user"] as? [String: AnyObject] {
            user = User(dictionary: dict)
        }
    }
}

