//
//  FirebaseService.swift
//  center-city
//
//  Created by Vadim on 27/10/2019.
//  Copyright © 2019 svp. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService {
    
    init() {
    }
    
    func authorization(with phone: String, completion: @escaping ((Bool, Error?) -> Void)) {
        if phone == GlobalConstants.testPhone {
            print("Test user authorization")
            UserDefaults.standard.set(GlobalConstants.testPhone, forKey: UserKeys.phone)
            UserDefaults.standard.synchronize()
            completion(true, nil)
        } else {
            PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
                guard error == nil else {
                    print(error ?? "error authorization")
                    completion(false, error)
                    return
                }
                
                DispatchQueue.main.async {
                    UserDefaults.standard.set(phone, forKey: UserKeys.phone)
                    UserDefaults.standard.set(verificationID, forKey: UserKeys.verificationID)
                    UserDefaults.standard.synchronize()
                    completion(true, nil)
                }
            }
        }
    }
    
    func codeValidate(code: String, completion: @escaping ((Bool) -> Void)) {
        if UserDefaults.standard.string(forKey: UserKeys.phone) == GlobalConstants.testPhone && code == GlobalConstants.testCode {
            print("Test user code validate")
            UserDefaults.standard.set(GlobalConstants.testUID, forKey: UserKeys.firebaseUID)
            UserDefaults.standard.set(true, forKey: UserKeys.isLogged)
            UserDefaults.standard.synchronize()
            completion(true)
        } else {
            guard let verificationID = UserDefaults.standard.object(forKey: UserKeys.verificationID) as? String else { return }
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    completion(false)
                    print(error ?? "error codeValidate")
                    return
                }
                
                // User is signed in
                UserDefaults.standard.set(result?.user.uid, forKey: UserKeys.firebaseUID)
                UserDefaults.standard.set(true, forKey: UserKeys.isLogged)
                UserDefaults.standard.synchronize()
                completion(true)
            }
        }
    }
}
