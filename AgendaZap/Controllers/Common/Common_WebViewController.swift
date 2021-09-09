//
//  Common_WebViewController.swift
//  AgendaZap
//
//  Created by Dipen on 28/02/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import WebKit

class Common_WebViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, WKUIDelegate, WKNavigationDelegate, UIGestureRecognizerDelegate
{
    // MARK: - IBOutlet
    @IBOutlet var statusBarContainerView: UIView?
    @IBOutlet var homeBarContainerView: UIView?
    @IBOutlet var masterContainerView: UIView?
    
    //NAVIGATION BAR
    @IBOutlet var navigationBarView: UIView?
    @IBOutlet var navigationTitle: UILabel?
    //BACK
    @IBOutlet var backContainerView: UIView?
    @IBOutlet var imageViewBack: UIImageView?
    @IBOutlet var btnBack: UIButton?
    
    @IBOutlet var mainWebView: WKWebView?
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var strTitle : String?
    var strUrl : String?
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNotificationEvent()
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .lightContent
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
        self.removeNotificationEventObserver()
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        
//        self.view.endEditing(true)
//        
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.user_GetAllMyStoresEvent),
            name: Notification.Name("user_GetAllMyStoresEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllMyStoresEvent()
    {
        DispatchQueue.main.async(execute: {
            
            
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = strTitle
        
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        mainWebView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        
        activityIndicatorView?.center = CGPoint.init(x: (mainWebView?.bounds.size.width)!/2, y: (mainWebView?.bounds.size.height)!/2)
        self.activityIndicatorView?.hidesWhenStopped = true
        //mainWebView?.addSubview(activityIndicatorView!)
        

        mainWebView?.navigationDelegate = self
        let myURL = URL(string:strUrl!)
        let myRequest = URLRequest(url: myURL!)
        mainWebView!.load(myRequest)
        
        DispatchQueue.main.async {
            self.activityIndicatorView?.startAnimating()
        }
        
    }
    
    // MARK: - UIWebView Delegate Methods
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print("Finished navigating to url \(webView.url)");
        
        DispatchQueue.main.async {
            self.activityIndicatorView?.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    {
        DispatchQueue.main.async {
            self.activityIndicatorView?.stopAnimating()
        }
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
