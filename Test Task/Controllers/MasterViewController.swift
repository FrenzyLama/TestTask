//
//  MasterViewController.swift
//  Test Task
//
//  Created by Gleb Ilchyshyn on 10.02.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import UIKit
import WebKit

class MasterViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    // MARK: Properties
    
    var textView = UITextView()
    var page : Int = 0 {
        willSet(currentPage) {
            print("page now is \(currentPage) ")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(goForward)),
            UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(goBack))
        ]
        fetchPostInfo()
    }
    
    private func fetchPostInfo() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.configureUI), name: NSNotification.Name(rawValue: notificationKey), object: nil)
        if let list = UserDefaults.standard.array(forKey: "IdList") as? [String] {
            let i = list[self.page]
            NetworkManager.sharedInstance.requestPost(post: i)
        }
    }
    
    // MARK: Next and Previous Buttons
    
    func nextPost() {
        if let posts = UserDefaults.standard.array(forKey: "IdList") as? [String] {
            var lastIndex = posts.endIndex
            lastIndex -= 1
            if self.page != lastIndex && page >= 0 {
                self.page += 1
            } else {
                self.page = 0
            }
        }
    }
    
    func previousPost() {
        if let posts = UserDefaults.standard.array(forKey: "IdList") as? [String] {
            let count = posts.count
            let lastIndex = count - 1
            let result = self.page
            if result == 0 {
                self.page = lastIndex
            } else if result == lastIndex {
                self.page = result - 1
            } else {
                self.page = result - 1
            }
        }
    }
    
    @IBAction func NextButtonPressed(_ sender: Any) {
        nextPost()
        fetchPostInfo()
    }
    
    @IBAction func PreviousButtonPressed(_ sender: Any) {
        previousPost()
        fetchPostInfo()
    }
    
    @objc func configureUI() {
        if let post = NetworkManager.sharedInstance.downloadedPost {
            switch post.type {
            case PostType.text:
                ConfigurePostWithText()
            case PostType.webpage:
                ConfigurePostwWithWebpage()
            }
        }
    }
    
    // MARK: Configure text
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    func ConfigurePostWithText() {
        var text = NetworkManager.sharedInstance.downloadedPost?.payload.text
        DispatchQueue.main.async {
            self.adjustUITextViewHeight(arg: self.textView)
            self.view.addSubview(self.textView)
            self.textView.frame = CGRect( x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 140 )
            self.textView.font = .systemFont(ofSize: 24)
            self.textView.text = text
        }
    }
    
    // MARK: Configure web
    
    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @objc func refresh() {
        webView.reload()
    }
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: CGRect( x: 0, y: 20, width: self.view.frame.width, height: self.view.frame.height - 100 ), configuration: WKWebViewConfiguration() )
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    func ConfigurePostwWithWebpage() {
        print("ConfigurePostwWithWebpage")
        let postURL = NetworkManager.sharedInstance.downloadedPost?.payload.url
        let myRequest = URLRequest(url: postURL!)
        DispatchQueue.main.async {
            self.setupUI()
            self.webView.load(myRequest)
        }
    }
    
}

extension MasterViewController {
    func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
    }
}
