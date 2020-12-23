//
//  Structures.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit
import CoreLocation

struct GlobalConstants {
    
    static var apiService = APIService()
    static let locationManager = CLLocationManager()
    static var actionTimer = Timer()
    static var counter: Int = 0
    static let testPhone = "+79091234567"
    static let testCode = "123456"
    static let testID = "122"
    static let testUID = "1234567"
}

enum UserKeys {
    static let firebaseUID = "kFirebaseUID"
    static let phone = "kPhone"
    static let isLogged = "isLogged"
    static let verificationID = "varificationID"
    static let fcmToken = "kFcmToken"
    static let id = "kId"
    static let name = "kName"
    static let email = "kEmail"
    static let apiToken = "kApiToken"
    static let avatar = "kAvatar"
    static let avatarData = "kAvatarData"
    static let surname = "kSurname"
    static let secondName = "kSecondName"
    static let birthday = "kBirthday"
    static let sex = "kSex"
    static let query = "kQuery"
    static let unviewedNotifications = "kUnviewedNotifications"
    static let actions = "kActions"
}

enum CustomFonts {
    static let robotaBold = "Roboto-Bold"
    static let robotaBlack = "Roboto-Black"
    static let robotaMedium = "Roboto-Medium"
    static let robotoRegular = "Roboto-Regular"
}

enum LoadingType {
    case rules, policy, premission, urlLoad
}

struct ImageData {
    var data: Data
    var withName: String
    var fileName: String
    var mimeType: String
}

