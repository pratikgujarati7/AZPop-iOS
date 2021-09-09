//
//  User_LoginUsingPasswordViewController.swift
//  AgendaZap
//
//  Created by Innovative Iteration on 05/06/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import LGSideMenuController

class User_LoginUsingPasswordViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate
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
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var scrollContainerView: UIView?
    
    @IBOutlet var lblInstructions: UILabel?
    
    @IBOutlet var txtPasswordContainerView: UIView?
    @IBOutlet var txtPassword: UITextField?
    
    @IBOutlet var btnForgotPassword: UIButton?
    @IBOutlet var btnSubmit: UIButton?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var boolIsLoadedFromSplashScreen: Bool = false
    
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
        return .lightContent
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
            selector: #selector(self.forgotPasswordEvent),
            name: Notification.Name("forgotPasswordEvent"),
            object: nil)
            
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.loggedinUsingPasswordEvent),
            name: Notification.Name("loggedinUsingPasswordEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func forgotPasswordEvent()
    {
        
    }
    
    @objc func loggedinUsingPasswordEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let objUser: ObjUser = dataManager.objUser
            if (objUser.strCityID == "")
            {
                let viewController: User_SelectCityViewController = User_SelectCityViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                AppDelegate().Delegate().setTabBarVC()
            }
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //PASSWORD
        txtPasswordContainerView?.layer.masksToBounds = false
        txtPasswordContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        txtPasswordContainerView?.layer.shadowPath = UIBezierPath(roundedRect: txtPasswordContainerView!.bounds, cornerRadius: (txtPasswordContainerView?.layer.cornerRadius)!).cgPath
        txtPasswordContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        txtPasswordContainerView?.layer.shadowOpacity = 0.5
        txtPasswordContainerView?.layer.shadowRadius = 1.0
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("login_using_password_title", value:"Insira sua senha", comment: "")
        
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
        
        if(boolIsLoadedFromSplashScreen)
        {
            backContainerView?.isHidden = true
        }
        else
        {
            backContainerView?.isHidden = false
        }
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        mainScrollView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        scrollContainerView?.backgroundColor = .clear
        
        lblInstructions?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblInstructions?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblInstructions?.text = NSLocalizedString("confirm_your_password", value:"Confirme sua senha", comment: "")
        
        txtPasswordContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtPasswordContainerView?.layer.cornerRadius = 5.0
        
        txtPassword?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtPassword?.delegate = self
        txtPassword?.backgroundColor = .clear
        txtPassword?.tintColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtPassword?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("password_placeholder_for_forget_password", value: "Sua senha", comment: ""),
                                                                attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtPassword?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtPassword?.textAlignment = .left
        txtPassword?.autocorrectionType = UITextAutocorrectionType.no
        txtPassword?.isSecureTextEntry = true
        
        //For Underline
        var attrs = [
            NSAttributedString.Key.font : MySingleton.sharedManager().themeFontFourteenSizeRegular!,
            NSAttributedString.Key.foregroundColor : MySingleton.sharedManager() .themeGlobalDarkGreyColor!,
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]

        var attributedString = NSMutableAttributedString(string:"")
        
        let buttonTitleStr = NSMutableAttributedString(string:NSLocalizedString("forgot_password", value:"Esqueci minha senha", comment: ""), attributes:attrs)
        attributedString.append(buttonTitleStr)
        
        btnForgotPassword?.titleLabel?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        //btnForgotPassword?.setTitle(NSLocalizedString("forgot_password", value:"Esqueci minha senha", comment: ""), for: .normal)
        btnForgotPassword?.setAttributedTitle(attributedString, for: .normal)
        btnForgotPassword?.setTitleColor( MySingleton.sharedManager() .themeGlobalDarkGreyColor, for: .normal)
        btnForgotPassword?.clipsToBounds = true
        btnForgotPassword?.addTarget(self, action: #selector(self.btnForgotPasswordClicked(_:)), for: .touchUpInside)
        
        btnSubmit?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSubmit?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSubmit?.setTitle(NSLocalizedString("submit", value:"Enviar", comment: "").uppercased(), for: .normal)
        btnSubmit?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSubmit?.clipsToBounds = true
        btnSubmit?.layer.cornerRadius = 5
        btnSubmit?.addTarget(self, action: #selector(self.btnSubmitClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: UIButton)
    {
        dataManager.forgotPassword()
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if((txtPassword?.text?.count)! <= 0)
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("password_can_not_be_blank", value:"a senha precisa conter no mínimo 6 caracteres", comment: ""))
        }
        else
        {
            dataManager.loginUsingPassword(strPassword: (txtPassword?.text)!)
        }
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
