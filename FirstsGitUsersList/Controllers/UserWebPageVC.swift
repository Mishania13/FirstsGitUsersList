//
//  UserWebPageVC.swift
//  FirstsGitUsersList
//
//  Created by Mr. Bear on 21.04.2020.
//  Copyright © 2020 Mr. Bear. All rights reserved.
//

import UIKit
import WebKit

class UserWebPageVC: UIViewController {
    
    var userLinkUrl: String!
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
        webView.load(urlRequest())
        webView.allowsBackForwardNavigationGestures = true
        
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
        
       
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
               
               if keyPath == "estimatedProgress" {
                   progressView.progress = Float(webView.estimatedProgress)
               }
           }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func goBack () {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func goForward () {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    private func showProgressView() {
           UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
               self.progressView.alpha = 1
           }, completion: nil)
       }
       
       private func hideProgressView() {
           UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
               self.progressView.alpha = 0
           }, completion: nil)
       }
    
    func urlRequest() -> URLRequest {
        guard let url = URL(string: self.userLinkUrl) else {
            return URLRequest(url: URL(string: "https://github.com/")!)}
        return URLRequest(url: url)
    }
    
}

extension UserWebPageVC: WKNavigationDelegate {
     func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        hideProgressView()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressView()
    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressView()
    }
}
