//
//  ViewController.swift
//  Project 4 - EasyBrowser
//
//  Created by Zeeshan Waheed on 26/01/2024.
//

import UIKit
import WebKit



class ViewController: UIViewController, WKNavigationDelegate, UIAlertViewDelegate {

    var webView: WKWebView!
    var progressView: UIProgressView!
//  array to store all websites
//  var websites = ["apple.com", "hackingwithswift.com"]

//  the data was assigned in the previous viewcontroller file
    var websites: [String]!
    var SelectedSites: String!

//  to display website
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
//      adding a refresh button and progress bar, as well as forward and back buttons for page navigation in ToolBar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                   style: .plain,
                                   target: webView,
                                   action: #selector(webView.goBack))
        let forward = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"),
                                      style: .plain,
                                      target: webView,
                                      action: #selector(webView.goForward))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
//      adding variblae in toolbaritems using an array such that it displays it
        toolbarItems = [progressButton, spacer, back, forward, spacer, refresh]
        navigationController?.isToolbarHidden = false
//      for progress bar
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
//      URL is the datatype for urls
        let url = URL(string: "https://" + SelectedSites)!
        webView.load(URLRequest(url: url))
//      swipe left and right for previous page aur next page
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
//  open bar button functionality
    @objc func openTapped() {
        
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openPage(action: UIAlertAction) {
//        let url = URL(string: "https://" + action.title!)!
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
//  for progress bar to load (function correctly)
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
//  to check whether the website is safe or not
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                } else {
                    let alert = UIAlertController(title: "Error", message: "Site is not safe", preferredStyle: .alert)
//                    print("site wasn't safe")
                    alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
                    decisionHandler(.cancel)
                    present(alert, animated: true)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
    }
}

