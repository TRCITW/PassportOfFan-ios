//
//  WebViewController.swift
//  center-city
//
//  Created by Vadim on 02/11/2019.
//  Copyright © 2019 svp. All rights reserved.
//

import WebKit

class WebViewController: BaseViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var loadingType: LoadingType = .urlLoad
    var urlString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
    }
    
    func UISettings() {
//        webView.navigationDelegate = self
//        webView.allowsBackForwardNavigationGestures = true
//
//        switch loadingType {
//        case .premission:
//            if let url = Bundle.main.url(forResource: "SMSconsent", withExtension: "html") {
//                webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
//            }
//        case .policy:
//            if let url = Bundle.main.url(forResource: "privacyPolicy", withExtension: "html") {
//                webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
//            }
//        case .rules:
//            if let url = Bundle.main.url(forResource: "termsOfUse", withExtension: "html") {
//                webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
//            }
//        case .urlLoad:
//            if let url = URL(string: urlString) {
//                webView.load(URLRequest(url: url))
//                //setToolBar()
//            }
//        }
        
        webView.delegate = self
        webView.backgroundColor = .clear
        
        switch loadingType {
        case .premission:
            if let url = Bundle.main.url(forResource: "SMSconsent", withExtension: "html") {
                webView.loadRequest(URLRequest(url: url))
            }
        case .policy:
            if let url = Bundle.main.url(forResource: "privacyPolicy", withExtension: "html") {
                webView.loadRequest(URLRequest(url: url))
            }
        case .rules:
            if let url = Bundle.main.url(forResource: "termsOfUse", withExtension: "html") {
                webView.loadRequest(URLRequest(url: url))
            }
        case .urlLoad:
            if let url = URL(string: urlString) {
                webView.loadRequest(URLRequest(url: url))
            }
        }
    }
}

extension WebViewController: UIWebViewDelegate {

}
