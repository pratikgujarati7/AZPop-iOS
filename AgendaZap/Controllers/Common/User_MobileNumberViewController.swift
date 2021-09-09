//
//  User_MobileNumberViewController.swift
//  AgendaZap
//
//  Created by Dipen on 06/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class User_MobileNumberViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate
{
    // MARK: - IBOutlet
    @IBOutlet var statusBarContainerView: UIView?
    @IBOutlet var homeBarContainerView: UIView?
    @IBOutlet var masterContainerView: UIView?
    
    //NAVIGATION BAR
    @IBOutlet var navigationBarView: UIView?
    @IBOutlet var logoImageView: UIImageView?
    //BACK
    @IBOutlet var backContainerView: UIView?
    @IBOutlet var imageViewBack: UIImageView?
    @IBOutlet var btnBack: UIButton?
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var scrollContainerView: UIView?
    
    @IBOutlet var lblInstruction: UILabel!
    @IBOutlet var txtMobileNumberContainerView: UIView?
    @IBOutlet var txtMobileNumber: UITextField?
    @IBOutlet var btnConfirm: UIButton?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(true)
        
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
            selector: #selector(self.user_RegisterMobileNumberEvent),
            name: Notification.Name("user_RegisterMobileNumberEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_RegisterMobileNumberEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let strPassword: String = "\(UserDefaults.standard.value(forKey: "password") ?? "")"
            if(strPassword != "" && strPassword.count > 0)
            {
                let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
                viewController.boolIsLoadedFromSplashScreen = false
                self.navigationController?.pushViewController(viewController, animated: false)
            }
            else
            {
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
            }
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
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
        
        lblInstruction.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblInstruction?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblInstruction?.text = NSLocalizedString("login_using_mobile_instruction", value:"Digite o número do celular para começar", comment: "")
        
        txtMobileNumberContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtMobileNumberContainerView?.layer.cornerRadius = 5.0
        
        txtMobileNumber?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtMobileNumber?.delegate = self
        txtMobileNumber?.backgroundColor = .clear
        txtMobileNumber?.tintColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtMobileNumber?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("phone_hint", value: "Celular com DDD", comment: ""),
                                                                attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtMobileNumber?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtMobileNumber?.textAlignment = .left
        txtMobileNumber?.autocorrectionType = UITextAutocorrectionType.no
        txtMobileNumber?.keyboardType = .numberPad
        
        btnConfirm?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnConfirm?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        
        btnConfirm?.setTitle(NSLocalizedString("begins", value:"começar", comment: "").uppercased(), for: .normal)
        btnConfirm?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnConfirm?.clipsToBounds = true
        btnConfirm?.layer.cornerRadius = 5
        btnConfirm?.addTarget(self, action: #selector(self.btnConfirmClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnConfirmClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if(txtMobileNumber?.text?.count == 0 || ((txtMobileNumber?.text?.isEmpty) == nil)){
            
             appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
            
        }else{
           
         //   let intMobileNumber: Int = Int(txtMobileNumber!.text ?? "0")!
                  let intMobileNumber = Int(txtMobileNumber!.text!) ?? 0
               if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
               {
                   dataManager.user_RegisterMobileNumber(strMobileNumber: (txtMobileNumber?.text)!, strReferralCode: "")
                  // let first4 = String("\(intMobileNumber)".prefix(2))
                   
//                  dataManager.user_RegisterMobileNumber(strMobileNumber: (txtMobileNumber?.text)!)
//                   if (first4 == "55")
//                   {
//                       appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: ""))
//                   }
//                   else
//                   {
//                       dataManager.user_RegisterMobileNumber(strMobileNumber: (txtMobileNumber?.text)!)
//                   }
                   
               }
               else
               {
                   appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
               }
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 11
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
