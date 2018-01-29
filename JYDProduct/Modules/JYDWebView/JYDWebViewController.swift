//
//  JYDWebViewController.swift
//  FXDProduct
//
//  Created by admin on 2017/8/3.
//  Copyright © 2017年 admin. All rights reserved.
//

import UIKit
import WebKit

class JYDWebViewController: BaseViewController,WKNavigationDelegate,WKUIDelegate{
    
    var urlStr : String? = nil
    let shareContent : String? = nil
    let isZhima :Bool? = false
    
   lazy var progressView : UIProgressView = {
        [weak self] in
        let progressBarHeight : CGFloat = 0.7
        let navigationBarBounds = self?.navigationController?.navigationBar.bounds
        let progressBarFrame = CGRect.init(x: 0, y: (navigationBarBounds?.size.height)! - progressBarHeight, width: (navigationBarBounds?.size.width)!, height: progressBarHeight)
        let  progressView = UIProgressView.init(frame: progressBarFrame)
        progressView.tintColor = webViewProgressBarTintColor
        progressView.trackTintColor = UIColor.white
        return progressView
    
    }()
    
   lazy var contentWebview : WKWebView = {
        [weak self] in
        let config = WKWebViewConfiguration.init()
        config.preferences = WKPreferences.init()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.userContentController = WKUserContentController.init()
        let webView = WKWebView.init(frame: CGRect.zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.contentSize = (self?.view.bounds.size)!
        return webView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        addBackItem()
        addWebViewKVO()
        
        //加载Url
        let request = URLRequest.init(url: URL.init(string: (urlStr?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed))!)!)
        contentWebview.load(request)
    }
    
    func setupUI() -> Void {
        
        self.view.addSubview(contentWebview)
        contentWebview.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        self.navigationController?.navigationBar.addSubview(progressView)
        
    }
    
    //MARK: 增加属性监听
    func addWebViewKVO() ->  Void{
        contentWebview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        contentWebview.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        contentWebview.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }
    //MARK: KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard (object as AnyObject? === contentWebview) else {
            return
        }
        //进度条
        if  (keyPath == "estimatedProgress") {
            let newProgress = ((change as AnyObject).object(forKey: "new") as AnyObject).floatValue
            if newProgress == 1 {
                progressView.isHidden = true
                progressView.setProgress(0, animated: false)
            }else{
                progressView.isHidden = false
                progressView.setProgress(newProgress!, animated: false)
            }
        }
        
        if (keyPath == "title") {
            if let title = contentWebview.title {
                self.navigationItem.title = title
            }
        }
        
        if (keyPath == "URL") {
            print("\(String(describing: contentWebview.url?.absoluteString))")
        }
    }
    
    //MARK: WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        if request.url?.host == "itunes.apple.com" && UIApplication.shared.canOpenURL(navigationAction.request.url!){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            }else{
                UIApplication.shared.openURL(navigationAction.request.url!)
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("加载失败")
    }
    
    //MARK: WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("alert")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("confim")
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("inputPanel")
    }
    
    deinit {
        contentWebview.removeObserver(self, forKeyPath: "estimatedProgress")
        contentWebview.removeObserver(self, forKeyPath: "title")
        contentWebview.removeObserver(self, forKeyPath: "URL")
        contentWebview.navigationDelegate = nil
        contentWebview.uiDelegate = nil
    }
    
    func deleteWebCache() -> Void {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deleteWebCache()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
