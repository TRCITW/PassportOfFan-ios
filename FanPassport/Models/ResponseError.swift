//
//  ResponseError.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import Foundation

class ResponseError {
    
    var status: Int?
    var meta: AnyObject?
    var messages: [Messages]?
    var code: Int?
    
    init() {}
    
    init(dictionary: [String: AnyObject]) {
        status = dictionary["status"] as? Int
        meta = dictionary["meta"] as AnyObject
        code = dictionary["code"] as? Int
        
        if let tempArray = dictionary["messages"] as? Array<AnyObject> {
            messages = [Messages]()
            for elem in tempArray {
                let newElem = Messages(dictionary: elem as? Dictionary<String, AnyObject> ?? [:])
                messages?.append(newElem)
            }
        }
    }
}

class Messages {
    var type: String?
    var text: String?
    
    init() {}
    
    init(dictionary: [String: AnyObject]) {
        type = dictionary["type"] as? String
        text = dictionary["text"] as? String
    }
}

