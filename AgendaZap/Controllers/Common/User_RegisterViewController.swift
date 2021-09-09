//
//  User_RegisterViewController.swift
//  AgendaZap
//
//  Created by Dipen Lad on 25/03/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class User_RegisterViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate
{
    // MARK: - IBOutlet
    @IBOutlet var statusBarContainerView: UIView?
    @IBOutlet var homeBarContainerView: UIView?
    @IBOutlet var masterContainerView: UIView?
    
    //NAVIGATION BAR
    @IBOutlet var navigationBarView: UIView?
    @IBOutlet var logoImageView: UIImageView?
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var scrollContainerView: UIView?
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var txtNameContainerView: UIView?
    @IBOutlet var txtName: UITextField?
    
    @IBOutlet var lblMobileNumber: UILabel!
    @IBOutlet var txtMobileNumberContainerView: UIView?
    @IBOutlet var txtMobileNumber: UITextField?
    
    @IBOutlet var btnRegister: UIButton?
    
    @IBOutlet var lblAlreadyRegistered: UILabel!
    @IBOutlet var btnLogin: UIButton?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNotificationEvent()
        self.setUpNavigationBar()
        self.setupInitialView()
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(true)
        
    }
    
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
            selector: #selector(self.user_RegisterEvent),
            name: Notification.Name("user_RegisterEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_RegisterEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let viewController: User_SelectCityViewController = User_SelectCityViewController()
            viewController.boolIsLoadedFromSplashScreen = true
            self.navigationController?.pushViewController(viewController, animated: true)
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        txtNameContainerView?.layer.masksToBounds = false
        txtNameContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        txtNameContainerView?.layer.shadowPath = UIBezierPath(roundedRect: txtNameContainerView!.bounds, cornerRadius: (txtNameContainerView?.layer.cornerRadius)!).cgPath
        txtNameContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        txtNameContainerView?.layer.shadowOpacity = 0.5
        txtNameContainerView?.layer.shadowRadius = 1.0
        
        txtMobileNumberContainerView?.layer.masksToBounds = false
        txtMobileNumberContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        txtMobileNumberContainerView?.layer.shadowPath = UIBezierPath(roundedRect: txtMobileNumberContainerView!.bounds, cornerRadius: (txtMobileNumberContainerView?.layer.cornerRadius)!).cgPath
        txtMobileNumberContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        txtMobileNumberContainerView?.layer.shadowOpacity = 0.5
        txtMobileNumberContainerView?.layer.shadowRadius = 1.0
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        if #available(iOS 11.0, *)
        {
            mainScrollView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        mainScrollView?.delegate = self
        mainScrollView?.backgroundColor = .clear
        scrollContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        lblName.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblName?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblName?.text = NSLocalizedString("seu_nome_ou_de_seu_neboar", value:"Seu nome (ou de seu negócio)", comment: "")
        
        txtNameContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtNameContainerView?.layer.cornerRadius = 5.0
        
        txtName?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtName?.delegate = self
        txtName?.backgroundColor = .clear
        txtName?.tintColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtName?.attributedPlaceholder = NSAttributedString(string: "",
                                                                attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtName?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtName?.textAlignment = .left
        txtName?.autocorrectionType = UITextAutocorrectionType.no
        
        lblMobileNumber.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblMobileNumber?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblMobileNumber?.text = NSLocalizedString("seu_telephone_com_ddd", value:"Seu Telefone Com DDD", comment: "")
        
        txtMobileNumberContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtMobileNumberContainerView?.layer.cornerRadius = 5.0
        
        txtMobileNumber?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtMobileNumber?.delegate = self
        txtMobileNumber?.backgroundColor = .clear
        txtMobileNumber?.tintColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtMobileNumber?.attributedPlaceholder = NSAttributedString(string: "",
                                                                attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtMobileNumber?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtMobileNumber?.textAlignment = .left
        txtMobileNumber?.autocorrectionType = UITextAutocorrectionType.no
        txtMobileNumber?.keyboardType = .numberPad
        
        btnRegister?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnRegister?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnRegister?.setTitle(NSLocalizedString("create_free_account", value:"Criar Conta Gratuita", comment: "").uppercased(), for: .normal)
        btnRegister?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnRegister?.clipsToBounds = true
        btnRegister?.layer.cornerRadius = 5
        btnRegister?.addTarget(self, action: #selector(self.btnRegisterClicked(_:)), for: .touchUpInside)
        
        lblAlreadyRegistered.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblAlreadyRegistered?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblAlreadyRegistered?.text = NSLocalizedString("already_have_an_account", value:"Já Tem Cadastro?", comment: "")
        
        btnLogin?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnLogin?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnLogin?.setTitle(NSLocalizedString("login", value:"Login", comment: "").uppercased(), for: .normal)
        btnLogin?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnLogin?.clipsToBounds = true
        btnLogin?.layer.cornerRadius = 5
        btnLogin?.addTarget(self, action: #selector(self.btnLoginClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnRegisterClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if(txtName?.text?.count == 0 || ((txtName?.text?.isEmpty) == nil)){
            
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("error_invalid_username", value:"Invalid username!", comment: ""))
        }
        else if(txtMobileNumber?.text?.count == 0 || ((txtMobileNumber?.text?.isEmpty) == nil)){
            
             appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
            
        }
        else {
            
            let intMobileNumber = Int(txtMobileNumber!.text!) ?? 0
            if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
            {
                dataManager.user_Register(strName: (txtName?.text)!, strMobileNumber: (txtMobileNumber?.text)!)
            }
                else
                {
                    appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
                }
            }
    
     }
    
    @IBAction func btnLoginClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController: User_MobileNumberViewController = User_MobileNumberViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
