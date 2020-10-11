//
//  RegistrationController.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import UIKit

class RegistrationController: AuthorisationBaseViewController {
    
    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var privacyRulesLabel: UILabel!
    @IBOutlet private weak var nameTextField: BaseTextField!
    @IBOutlet private weak var fNameTextField: BaseTextField!
    @IBOutlet private weak var oNameTextField: BaseTextField!
    @IBOutlet private weak var phoneTextField: BaseTextField!
    @IBOutlet private weak var policyConditionalLabel: UILabel!
    @IBOutlet private weak var userSubscribeLabel: UILabel!
    
    @IBOutlet private weak var privacyRulesButton: UIButton!
    @IBOutlet private weak var userSubscribeButton: UIButton!
    @IBOutlet private weak var privacyRulesTappableStackView: UIStackView!
    @IBOutlet private weak var userSubscribeTappableStackView: UIStackView!
       
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var isPrivacyCheck: Bool = true
    var isSubscribeCheck: Bool = true
    
    override func viewDidLoad() {
       super.viewDidLoad()
       UISettings()
        keyboardObservation()
    }

    func UISettings() {
        nameTextField.type = .name
        fNameTextField.type = .name
        oNameTextField.type = .name
        phoneTextField.type = .phone
        phoneTextField.attributedPlaceholder = NSAttributedString(string: "+7",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        registerButton.isEnabled = true
        privacyRulesButton.setBackgroundImage(UIImage.Icons.tickIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        privacyRulesButton.backgroundColor = .redRounded
        privacyRulesButton.layer.cornerRadius = 3
        privacyRulesButton.tintColor = .white
        userSubscribeButton.setBackgroundImage(UIImage.Icons.tickIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        userSubscribeButton.backgroundColor = .redRounded
        userSubscribeButton.layer.cornerRadius = 3
        userSubscribeButton.tintColor = .white
        privacyTapped()
        privacyLabelConfigure()
        policyConditionalLabelConfigure()
        userSubscribeLabelConfigure()
        #if DEBUG
        phoneTextField.text = "9235749076"
//        phoneTextField.text = "9091234567"
        #endif
    }
    
    @objc func privacyLabelTapped(_ gesture: UITapGestureRecognizer) {
        let text = privacyRulesLabel.text!
        let termsRange = (text as NSString).range(of: "с обработкой персональных данных")
        
        if gesture.didTapAttributedTextInLabel(label: privacyRulesLabel, inRange: termsRange) {
            let newVC = UIStoryboard(name: "Access", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            newVC.loadingType = .policy
            self.navigationController?.show(newVC, sender: self)
        }
    }
    
    @objc func userSubscribeLabelTapped(_ gesture: UITapGestureRecognizer) {
        let text = userSubscribeLabel.text!
        let termsRange = (text as NSString).range(of: "получение рекламных рассылок и уведомлений")
        
        if gesture.didTapAttributedTextInLabel(label: userSubscribeLabel, inRange: termsRange) {
            let newVC = UIStoryboard(name: "Access", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            newVC.loadingType = .premission
            self.navigationController?.show(newVC, sender: self)
        }
    }
    
    @objc func policyConditionalLabelTapped(_ gesture: UITapGestureRecognizer) {
        let text = policyConditionalLabel.text!
        let termsRange = (text as NSString).range(of: "правилами пользования")
        
        if gesture.didTapAttributedTextInLabel(label: policyConditionalLabel, inRange: termsRange) {
            let newVC = UIStoryboard(name: "Access", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            newVC.loadingType = .rules
            self.navigationController?.show(newVC, sender: self)
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true)
    }

    func policyConditionalLabelConfigure() {
        policyConditionalLabel.isUserInteractionEnabled = true
        policyConditionalLabel.textColor = .black
        let registerButtonTitle = policyConditionalLabel.text ?? ""
        let underlineAttributedString = NSMutableAttributedString(string: registerButtonTitle)
        let rangeText = (registerButtonTitle as NSString).range(of: "правилами пользования")
        
        if let robotoFont = UIFont(name: CustomFonts.robotaBlack, size: 15.0) {
            underlineAttributedString.addAttributes([
                NSAttributedString.Key.font : robotoFont,
                NSAttributedString.Key.foregroundColor: UIColor.redRounded], range: rangeText)
        }
        underlineAttributedString.addAttribute(.foregroundColor, value: UIColor.redRounded, range: rangeText)
        policyConditionalLabel.attributedText = underlineAttributedString
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(policyConditionalLabelTapped))
        policyConditionalLabel.addGestureRecognizer(tapAction)
    }
    
    func privacyLabelConfigure() {
        privacyRulesLabel.isUserInteractionEnabled = true
        privacyRulesLabel.textColor = .black
        let registerButtonTitle = privacyRulesLabel.text ?? ""
        let underlineAttributedString = NSMutableAttributedString(string: registerButtonTitle)
        let rangeText = (registerButtonTitle as NSString).range(of: "с обработкой персональных данных")
        
        if let robotoFont = UIFont(name: CustomFonts.robotaMedium, size: 14.0) {
            underlineAttributedString.addAttributes([
                NSAttributedString.Key.font : robotoFont,
                NSAttributedString.Key.foregroundColor: UIColor.redRounded], range: rangeText)
        }
        underlineAttributedString.addAttribute(.foregroundColor, value: UIColor.redRounded, range: rangeText)
        privacyRulesLabel.attributedText = underlineAttributedString
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(privacyLabelTapped))
        privacyRulesLabel.addGestureRecognizer(tapAction)
    }
    
    func userSubscribeLabelConfigure() {
        userSubscribeLabel.isUserInteractionEnabled = true
        userSubscribeLabel.textColor = .black
        let registerButtonTitle = userSubscribeLabel.text ?? ""
        let underlineAttributedString = NSMutableAttributedString(string: registerButtonTitle)
        let rangeText = (registerButtonTitle as NSString).range(of: "получение рекламных рассылок и уведомлений")
        
        if let robotoFont = UIFont(name: CustomFonts.robotaMedium, size: 14.0) {
            underlineAttributedString.addAttributes([
                NSAttributedString.Key.font : robotoFont,
                NSAttributedString.Key.foregroundColor: UIColor.redRounded], range: rangeText)
        }
        underlineAttributedString.addAttribute(.foregroundColor, value: UIColor.redRounded, range: rangeText)
        userSubscribeLabel.attributedText = underlineAttributedString
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(userSubscribeLabelTapped))
        userSubscribeLabel.addGestureRecognizer(tapAction)
    }

    func registration() {
        hideKeyboard()
        guard GlobalConstants.apiService.isInternetAvailable(vc: self) else { return }
        showProgressHUD()
        guard var phone = phoneTextField.text else { return }
        //phone = phone.replacingOccurrences(of: "+", with: "")
//        phone = phone.replacingOccurrences(of: "(", with: "")
//        phone = phone.replacingOccurrences(of: ")", with: "")
//        phone = phone.replacingOccurrences(of: "-", with: "")
        phone = "+" + phone.digits
        GlobalConstants.apiService.postIsset(phone: phone) { result, data, error in
            if result {
                if data?.status ?? false {
                    self.hideProgressHUD()
                    self.alertView.registerButton.addTarget(self, action: #selector(self.goToAuth), for: .touchUpInside)
                    self.alertView.showAlert(caption: "Телефонный номер уже зарегистрирован.", info: "")
                } else {
                    GlobalConstants.apiService.firebaseAuthorization(phone: phone) { result, error in
                        self.hideProgressHUD()
                        if result {
                            UserDefaults.standard.set(self.nameTextField.text, forKey: UserKeys.name)
                            UserDefaults.standard.set(self.fNameTextField.text, forKey: UserKeys.surname)
                            UserDefaults.standard.set(self.oNameTextField.text, forKey: UserKeys.secondName)
                            UserDefaults.standard.set((self.phoneTextField.text ?? "").digits, forKey: UserKeys.phone)
                            UserDefaults.standard.synchronize()
                            let newVC = UIStoryboard(name: "Access", bundle: nil).instantiateViewController(withIdentifier: "RecoveryController") as! RecoveryController
                            newVC.isLoginAction = false
//                            self.navigationController?.show(newVC, sender: self)
                            self.present(newVC, animated: true)
                        } else {
                            self.show(title: "Ошибка firebase", message: error.debugDescription)
                        }
                    }
                }
            } else if let error = error {
                print(error)
                self.hideProgressHUD()
                self.show(title: "Ошибка", message: error.messages?[0].text)
            }
        }
    }
    
    @objc func goToAuth() {
        self.alertView.isHidden = true
        self.alertView.registerButton.removeTarget(self, action: #selector(alertClose), for: .touchUpInside)
        let newVC = UIStoryboard(name: "Access", bundle: nil).instantiateViewController(withIdentifier: "AuthController") as! AuthController
        newVC.registeredPhone = self.phoneTextField.text ?? ""
        let p = self.presentingViewController
        self.dismiss(animated: true) {
          p?.present(newVC, animated: true, completion: nil)
        }
    }

    @IBAction func registrationButtonAction(_ sender: RedRoundedButton) {
  
        var isCancel = false
        
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            nameTextField.isInvalidTextField()
            isCancel = true
        } else {
            nameTextField.isValidTextField()
        }
        
        if fNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            fNameTextField.isInvalidTextField()
            isCancel = true
        } else {
            fNameTextField.isValidTextField()
        }
        
        if oNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            oNameTextField.isInvalidTextField()
            isCancel = true
        } else {
            oNameTextField.isValidTextField()
        }
        
        if phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            phoneTextField.isInvalidTextField()
            isCancel = true
        } else {
            phoneTextField.isValidTextField()
        }
        
        if isCancel { return }
        registration()
    }
    
    func privacyTapped() {
        let privateTapGesture = UITapGestureRecognizer(target: self, action: #selector(setCheckForPrivacyRules))
        privacyRulesTappableStackView.addGestureRecognizer(privateTapGesture)
        
        let subscribeTapGesture = UITapGestureRecognizer(target: self, action: #selector(setCheckForSubscribe))
        userSubscribeTappableStackView.addGestureRecognizer(subscribeTapGesture)
    }
    
    @objc func setCheckForPrivacyRules() {
        print("privacy tapped")
        privacyRulesButton.layer.masksToBounds = true

        if isPrivacyCheck {
            privacyRulesButton.backgroundColor = .clear
            privacyRulesButton.setBackgroundImage(UIImage.Icons.checkRectangle, for: .normal)
        } else {
           privacyRulesButton.setBackgroundImage(UIImage.Icons.tickIcon.withRenderingMode(.alwaysTemplate), for: .normal)
           privacyRulesButton.backgroundColor = .redRounded
        }

        isPrivacyCheck = !isPrivacyCheck
        registerButtonEnabled()
    }
       
    @objc func setCheckForSubscribe() {
        print("subscribe tapped")
        userSubscribeButton.layer.masksToBounds = true

        if isSubscribeCheck {
           userSubscribeButton.backgroundColor = .clear
           userSubscribeButton.setBackgroundImage(UIImage.Icons.checkRectangle, for: .normal)
        } else {
            userSubscribeButton.setBackgroundImage(UIImage.Icons.tickIcon.withRenderingMode(.alwaysTemplate), for: .normal)
            userSubscribeButton.backgroundColor = .redRounded
        }
        isSubscribeCheck = !isSubscribeCheck
        registerButtonEnabled()
    }
    
    func registerButtonEnabled() {
        if isSubscribeCheck && isPrivacyCheck { 
            registerButton.isEnabled = true
        } else {
            registerButton.isEnabled = false
        }
    }
    
    func keyboardObservation() {
       NotificationCenter.default.addObserver(self, selector: #selector(kbwWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(kbwWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func kbwWillHide(_ notification: NSNotification) {
       UIView.animate(withDuration: 0.5) {
           self.scrollViewBottomConstraint.constant = 0
           self.view.layoutIfNeeded()
       }
    }

    @objc func kbwWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(withDuration: 0.5) {
                self.scrollViewBottomConstraint.constant = keyboardRectangle.height - 30
                self.view.layoutIfNeeded()
            }
        }
    }
}

