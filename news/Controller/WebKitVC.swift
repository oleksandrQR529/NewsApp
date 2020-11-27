//
//  WebKitVCViewController.swift
//  news
//
//  Created by Саша Дранчук on 26.11.2020.
//

import UIKit
import WebKit

class WebKitVC: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView?
    
    override func loadView() {
        webView?.navigationDelegate = self
        //view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initWeb()
    }
    
    func initWeb() {
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView?.load(URLRequest(url: url))
        webView?.allowsBackForwardNavigationGestures = true
    }

}
