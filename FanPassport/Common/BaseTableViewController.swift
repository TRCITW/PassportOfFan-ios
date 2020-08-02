//
//  BaseTableViewController.swift
//
//  Created by Vadim on 04/09/2019.
//  Copyright © 2019 Vadim-S. All rights reserved.
//

import Foundation
import UIKit

class BaseTableViewController: UITableViewController {
    
    let emptyView = EmptyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyView.isHidden = true
        tableView.backgroundView = emptyView
        tableView.tableFooterView = UIView()
        
        refreshControl = UIRefreshControl()
        
        view.backgroundColor = .svpWhiteSmoke
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            if navigationController?.viewControllers.first == self {
                navigationItem.largeTitleDisplayMode = .automatic
            } else {
                navigationItem.largeTitleDisplayMode = .never
            }
            navigationController?.navigationBar.largeTitleTextAttributes =
                [NSAttributedString.Key.foregroundColor: UIColor.svpMainText,
                 NSAttributedString.Key.font: UIFont.SVP.bold(size: 24) ]
        } else {
            tabBarController?.tabBar.isHidden = hidesBottomBarWhenPushed
        }
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
    func show(image: UIImage? = nil, title: String? = nil, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: handler))
        present(alert, animated: true)
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
        completion(title: nil, error: error)
    }
}
