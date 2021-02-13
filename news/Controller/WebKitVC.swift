//
//  WebKitVCViewController.swift
//  news
//
//  Created by Саша Дранчук on 26.11.2020.
//

import UIKit
import WebKit

class WebKitVC: UIViewController, WKNavigationDelegate {
    private var webView: WKWebView!
    var urlString: String?
    
    
    override func loadView() {
        webView = WKWebView()
        webView?.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadView()
        initWeb()
    }
    
    func initWeb() {
        let url = URL(string: urlString ?? "https://jobs.dou.ua/companies/pecode-software/vacancies/147254/")!
        webView?.load(URLRequest(url: url))
        webView?.allowsBackForwardNavigationGestures = true
    }

}
