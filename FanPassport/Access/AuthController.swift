//
//  AuthController.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

class AuthController: AuthorisationBaseViewController {
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var phoneNumberTextField: BaseTextField!

    var registeredPhone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
    }
    
    func UISettings() {
        phoneNumberTextField.type = .phone
        phoneNumberTextField.text = registeredPhone
        phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: "+7",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        #if DEBUG
        //https://smska.us
        phoneNumberTextField.text = "+79091234567"
        phoneNumberTextField.text = "+79235749076"
        #endif
    }
    
    func autorisation() {
        guard GlobalConstants.apiService.isInternetAvailable(vc: self) else { return }
        hideKeyboard()
        showProgressHUD()
        guard var phone = phoneNumberTextField.text else { return }
        //phone = phone.replacingOccurrences(of: "+", with: "")
        phone = phone.replacingOccurrences(of: "(", with: "")
        phone = phone.replacingOccurrences(of: ")", with: "")
        phone = phone.replacingOccurrences(of: "-", with: "")
        GlobalConstants.apiService.firebaseAuthorization(phone: phone) { result, error in
            self.hideProgressHUD()
            if result {
                let newVC = UIStoryboard(name: "Access", bundle: nil).instantiateViewController(withIdentifier: "RecoveryController") as! RecoveryController
                self.present(newVC, animated: true)
//                self.navigationController?.show(newVC, sender: self)
            } else {
                self.show(title: "Ошибка firebase", message: error.debugDescription)
            }
        }
//        GlobalConstants.apiService.postIsset(phone: phone) { result, data, error in
//            if result {
//                if data?.success ?? false {
//
//                } else {
//                    self.hideProgressHUD()
//                    self.show(title: "Не верный номер", message: "Номер не зарегистрирован в системе")
//                }
//            } else if let error = error {
//                print(error)
//                self.hideProgressHUD()
//                self.show(title: "Ошибка", message: error.messages?[0].text)
//            }
//        }
    }
    
    func goToTabBar() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! MainTabBarController
        appdelegate.window!.rootViewController = newVC
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func loginButtonAction(_ sender: RedRoundedButton) {
//        var isCancel = false
//        if phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
//            phoneNumberTextField.isInvalidTextField()
//            isCancel = true
//        } else {
//            phoneNumberTextField.isValidTextField()
//        }
//
//        if isCancel {
//            hideKeyboard()
//            return
//        }
        
        autorisation()
    }
    
}

