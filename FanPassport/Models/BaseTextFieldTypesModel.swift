//
//  BaseTextFieldTypesModel.swift
//  center-city
//
//  Created by Abdul Tawfik on 25/09/2019.
//  Copyright © 2019 tawfik. All rights reserved.
//

import Foundation

enum BaseTextFieldType {
    case name
    case email
    case phone
    case codeConfirm
    case password
    case clear
    
    var mask: String {
        switch self {
        case .phone: return "(###)###-##-##"
        case .codeConfirm: return "######"
        default: return ""
        }
    }
    
    var prefix: String {
        switch self {
        case .phone: return "+7"
        default: return ""
        }
    }
    
    var placeHolder: String {
        switch self {
        case .name: return "введите ваше имя"
        case .email: return "введите ваш email (необязательно)"
        case .phone: return "+7"
        case .codeConfirm: return "Введите 6-значный код"
        case .password: return "введите пароль"
        case .clear: return "укажите данные"
        }
    }
}
