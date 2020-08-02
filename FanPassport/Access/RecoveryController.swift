//
//  RecoveryController.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

class RecoveryController: AuthorisationBaseViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var codeInputTextField: BaseTextField!
    
    var isLoginAction = true
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
    }
    
    func UISettings() {
        codeInputTextField.type = .codeConfirm
        codeInputTextField.attributedPlaceholder = NSAttributedString(string: codeInputTextField.placeholder ?? "",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.heatherGray])
        resendButton.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(showResendButton), userInfo: nil, repeats: false)
    }
    
    @objc func showResendButton() {
        resendButton.isHidden = false
    }
    
    func recovery() {
        guard GlobalConstants.apiService.isInternetAvailable(vc: self) else { return }
        hideKeyboard()
        showProgressHUD()
        GlobalConstants.apiService.codeConfirm(code: codeInputTextField.text ?? "") { result in
            if result && self.isLoginAction {
                self.goToTabBar()
            } else if result && !self.isLoginAction {
                GlobalConstants.apiService.postUserRegistration() { result, error in
                    self.hideProgressHUD()
                    if result {
                        self.goToTabBar()
                    } else if let error = error {
                        print(error)
                        self.alertView.registerButton.addTarget(self, action: #selector(self.alertClose), for: .touchUpInside)
                        self.alertView.showAlert(caption: "Ошибка", info: error.messages?[0].text)
                    }
                }
            } else {
                self.hideProgressHUD()
                self.alertView.registerButton.addTarget(self, action: #selector(self.alertClose), for: .touchUpInside)
                self.alertView.showAlert(caption: "Ошибка", info: "Пожалуйста отправьте повторно код подтверждения")
            }
        }
    }
    
    func goToTabBar() {
        showProgressHUD()
        GlobalConstants.apiService.getUser() { result, error in
            self.hideProgressHUD()
            if result {
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! MainTabBarController
                appdelegate.window!.rootViewController = newVC
            } else if let error = error {
                print(error)
                self.alertView.registerButton.addTarget(self, action: #selector(self.alertClose), for: .touchUpInside)
                self.alertView.showAlert(caption: "Ошибка", info: error.messages?[0].text)
            }
        }
        
    }
    
    @IBAction func recoveryButtonAction(_ sender: RedRoundedButton) {

        var isCancel = false
        if codeInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
           codeInputTextField.isInvalidTextField()
           isCancel = true
        } else {
           codeInputTextField.isValidTextField()
        }

        if isCancel { return }
        goToTabBar()
    }
    
    @IBAction func resendButtonAction(_ sender: UIButton) {
        guard GlobalConstants.apiService.isInternetAvailable(vc: self) else { return }
        GlobalConstants.apiService.firebaseAuthorization(phone: UserDefaults.standard.string(forKey: UserKeys.phone) ?? "") { result, error in
            print("Resend action: \(result)")
        }
        resendButton.isHidden = true
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(showResendButton), userInfo: nil, repeats: false)
    }
}

