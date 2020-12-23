//
//  BaseViewController.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import Foundation
import UIKit

protocol BaseViewControllerProtocol {
    func updateController(string: String?, int: Int?, bool: Bool?)
}

class BaseViewController: UIViewController, BaseViewControllerProtocol, UIGestureRecognizerDelegate {
    
    private var gradientLayer: CAGradientLayer?
    let alertView = InfoAlertView.instanceFromNib()
    
    static var vcId: String {
        return String(describing: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.view.backgroundColor = .clear
            
            navigationController?.navigationBar.largeTitleTextAttributes =
                [NSAttributedString.Key.foregroundColor: UIColor.svpMainText,
                 NSAttributedString.Key.font: UIFont.SVP.bold(size: 24) ]
            navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.svpMainText,
             NSAttributedString.Key.font: UIFont.SVP.bold(size: 13) ]
            navigationItem.largeTitleDisplayMode = .automatic
        } else {
            tabBarController?.tabBar.isHidden = hidesBottomBarWhenPushed
        }
        self.view.backgroundColor = UIColor(hex: 0xE5E5E5)
        hideKeyboardWhenTappedAround()
        alertView.addInView(view: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.bringSubviewToFront(alertView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    func addRightButton() {
        let button = UIButton.init(type: .custom)
        button.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        button.addTarget(self, action:#selector(rightButtonShowAction), for: .touchUpInside)
        button.cornerRadius = button.frame.width / 2
        
        if let avatarName = UserDefaults.standard.string(forKey: UserKeys.avatar) {
            let avatarImage = GlobalConstants.apiService.getImageFromCache(imageName: avatarName)
            button.setImage(avatarImage, for: .normal)
            button.setImage(avatarImage, for: .selected)
            button.setImage(avatarImage, for: .focused)
            button.setImage(avatarImage, for: .highlighted)
            button.setImage(avatarImage, for: .reserved)
        } else {
            let letterN = UserDefaults.standard.string(forKey: UserKeys.name)?.prefix(1) ?? "X"
            let letterS = UserDefaults.standard.string(forKey: UserKeys.surname)?.prefix(1) ?? "X"
            let abr = "\(letterN)\(letterS)".uppercased()
            button.setTitle(abr, for: .normal)
            button.setTitle(abr, for: .selected)
            button.setTitle(abr, for: .focused)
            button.setTitle(abr, for: .highlighted)
            button.setTitle(abr, for: .reserved)
            button.titleLabel?.font = UIFont.SVP.bold(size: 20)
            button.titleLabel?.textColor = UIColor.svpMainText
            button.backgroundColor = UIColor.svpWhiteSmoke
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
    }
    
    @objc func rightButtonShowAction() {
//        let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserNotificationsController") as! UserNotificationsController
//        self.navigationController?.show(newVC, sender: self)
    }
    
    // MARK: - Keyboard
    func hideKeyboardWhenTappedAround() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Spinner
    lazy var hud: ProgressHUD = {
        return ProgressHUD()
    }()
    
    func showProgressHUD() {
        let presenter: UIView = navigationController?.view ?? view
        hud.show(on: presenter)
    }
    
    func hideProgressHUD() {
        hud.hide()
    }
    
    // MARK: - Messages
    func show(image: UIImage? = nil, title: String? = nil, message: String? = nil, buttonText: String = "OK" ) {
        self.alertView.registerButton.addTarget(self, action: #selector(self.alertClose), for: .touchUpInside)
        self.alertView.showAlert(caption: title, info: message, buttonText: buttonText)
    }
    
    func show(title: String? = nil, error: ResponseError) {
        if let errorMessage = error.messages?[0].text {
            show(title: title ?? errorMessage, message: title == nil ? nil : errorMessage)
        }
    }
    
    func completion(title: String? = nil, error: ResponseError) {
        show(title: title, error: error)
    }
    
    func completion(error: ResponseError) {
        if error.code == 401 {
            self.alertView.registerButton.addTarget(self, action: #selector(self.alertCloseLogout), for: .touchUpInside)
            self.alertView.showAlert(caption: "Ошибка", info: "Проверка пользователя на сервере не выполнена")
        } else if error.code == 429 {
            self.alertView.registerButton.addTarget(self, action: #selector(self.alertCloseLogout), for: .touchUpInside)
            self.alertView.showAlert(caption: "Ошибка", info: "Превышено количество запросов, подождите 1 минуту")
        } else {
            completion(title: nil, error: error)
        }
    }
    
    @objc func alertCloseLogout() {
        self.alertView.isHidden = true
        self.alertView.registerButton.removeTarget(self, action: #selector(alertCloseLogout), for: .touchUpInside)
        self.logOut()
    }
    
    @objc func alertClose() {
        self.alertView.isHidden = true
        self.alertView.registerButton.removeTarget(self, action: #selector(alertClose), for: .touchUpInside)
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: UserKeys.firebaseUID)
        UserDefaults.standard.removeObject(forKey: UserKeys.phone)
        UserDefaults.standard.removeObject(forKey: UserKeys.isLogged)
        UserDefaults.standard.removeObject(forKey: UserKeys.verificationID)
        UserDefaults.standard.removeObject(forKey: UserKeys.fcmToken)
        UserDefaults.standard.removeObject(forKey: UserKeys.id)
        UserDefaults.standard.removeObject(forKey: UserKeys.name)
        UserDefaults.standard.removeObject(forKey: UserKeys.email)
        UserDefaults.standard.removeObject(forKey: UserKeys.apiToken)
        UserDefaults.standard.removeObject(forKey: UserKeys.avatar)
        UserDefaults.standard.removeObject(forKey: UserKeys.surname)
        UserDefaults.standard.removeObject(forKey: UserKeys.secondName)
        UserDefaults.standard.removeObject(forKey: UserKeys.birthday)
        UserDefaults.standard.removeObject(forKey: UserKeys.sex)
        UserDefaults.standard.removeObject(forKey: UserKeys.query)
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let newVC = UIStoryboard(name: "Access", bundle: nil).instantiateViewController(withIdentifier: "RegistrationController") as! RegistrationController
        appdelegate.window!.rootViewController = UINavigationController(rootViewController: newVC)
    }
    
    func updateController(string: String?, int: Int?, bool: Bool?) {
    }
}
