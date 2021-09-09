//
//  User_MyProfileViewController.swift
//  AgendaZap
//
//  Created by Dipen on 21/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import LGSideMenuController

class User_MyProfileViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate
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
    
    @IBOutlet var btnAddStoreContainerView: UIView?
    @IBOutlet var imageViewStore: UIImageView?
    @IBOutlet var lblAddStore: UILabel?
    @IBOutlet var imageViewStoreArrow: UIImageView?
    @IBOutlet var btnAddStore: UIButton?
    
    @IBOutlet var lblName: UILabel?
    @IBOutlet var txtNameContainerView: UIView?
    @IBOutlet var txtName: UITextField?
    
    @IBOutlet var lblSurname: UILabel?
    @IBOutlet var txtSurnameContainerView: UIView?
    @IBOutlet var txtSurname: UITextField?
    
    @IBOutlet var lblEmail: UILabel?
    @IBOutlet var txtEmailContainerView: UIView?
    @IBOutlet var txtEmail: UITextField?
    
    @IBOutlet var lblMobileNumber: UILabel?
    @IBOutlet var txtMobileNumberContainerView: UIView?
    @IBOutlet var txtMobileNumber: UITextField?
    
    @IBOutlet var btnSave: UIButton?
    
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
        
//        //SET DATA
//        if ("\(UserDefaults.standard.value(forKey: "first_name") ?? "")" != "<null>")
//        {
//            txtName?.text = "\(UserDefaults.standard.value(forKey: "first_name") ?? "")"
//        }
//
//        if ("\(UserDefaults.standard.value(forKey: "last_name") ?? "")" != "<null>")
//        {
//            txtSurname?.text = "\(UserDefaults.standard.value(forKey: "last_name") ?? "")"
//        }
//
//        if ("\(UserDefaults.standard.value(forKey: "email") ?? "")" != "<null>")
//        {
//            txtEmail?.text = "\(UserDefaults.standard.value(forKey: "email") ?? "")"
//        }
//
//        if ("\(UserDefaults.standard.value(forKey: "phone_number") ?? "")" != "<null>")
//        {
//            txtMobileNumber?.text = "\(UserDefaults.standard.value(forKey: "phone_number") ?? "")"
//        }
        
        //API CALL
        dataManager.user_GetMyProfileDetails()
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
            selector: #selector(self.user_GetMyProfileDetailsEvent),
            name: Notification.Name("user_GetMyProfileDetailsEvent"),
            object: nil)
            
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.user_UpdateMyProfileDetailsEvent),
            name: Notification.Name("user_UpdateMyProfileDetailsEvent"),
            object: nil)

        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetMyProfileDetailsEvent()
    {
        //SET DATA
        if ("\(UserDefaults.standard.value(forKey: "first_name") ?? "")" != "<null>")
        {
            txtName?.text = "\(UserDefaults.standard.value(forKey: "first_name") ?? "")"
        }
        
        if ("\(UserDefaults.standard.value(forKey: "last_name") ?? "")" != "<null>")
        {
            txtSurname?.text = "\(UserDefaults.standard.value(forKey: "last_name") ?? "")"
        }
        
        if ("\(UserDefaults.standard.value(forKey: "email") ?? "")" != "<null>")
        {
            txtEmail?.text = "\(UserDefaults.standard.value(forKey: "email") ?? "")"
        }
        
        if ("\(UserDefaults.standard.value(forKey: "phone_number") ?? "")" != "<null>")
        {
            txtMobileNumber?.text = "\(UserDefaults.standard.value(forKey: "phone_number") ?? "")"
        }
    }
    
    @objc func user_UpdateMyProfileDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            /*
            //HOME
            let viewController: User_HomeViewController = User_HomeViewController()
            let user_SideMenuViewController: User_SideMenuViewController = User_SideMenuViewController()
            
            let navigationController = UINavigationController(rootViewController: viewController)
            
            let sideMenuController = LGSideMenuController(rootViewController: navigationController,
                                                          leftViewController: user_SideMenuViewController,
                                                          rightViewController: nil)
            
            sideMenuController.leftViewWidth = MySingleton.sharedManager().floatLeftSideMenuWidth!
            sideMenuController.leftViewPresentationStyle = MySingleton.sharedManager().leftViewPresentationStyle!
            
            sideMenuController.rightViewWidth = MySingleton.sharedManager().floatRightSideMenuWidth!
            sideMenuController.rightViewPresentationStyle = MySingleton.sharedManager().rightViewPresentationStyle!
            sideMenuController.isLeftViewSwipeGestureEnabled = false
            sideMenuController.isRightViewSwipeGestureEnabled = false
            
            self.navigationController?.pushViewController(sideMenuController, animated: false)
            */
            
            self.navigationController?.popViewController(animated:true)
        })
    }
    
    //MARK:- Layout Subviews Methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        btnAddStoreContainerView?.layer.masksToBounds = false
        btnAddStoreContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        btnAddStoreContainerView?.layer.shadowPath = UIBezierPath(roundedRect: btnAddStoreContainerView!.bounds, cornerRadius: (btnAddStoreContainerView?.layer.cornerRadius)!).cgPath
        btnAddStoreContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        btnAddStoreContainerView?.layer.shadowOpacity = 0.5
        btnAddStoreContainerView?.layer.shadowRadius = 1.0
        
        //NAME
        txtNameContainerView?.layer.masksToBounds = false
        txtNameContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        txtNameContainerView?.layer.shadowPath = UIBezierPath(roundedRect: txtNameContainerView!.bounds, cornerRadius: (txtNameContainerView?.layer.cornerRadius)!).cgPath
        txtNameContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        txtNameContainerView?.layer.shadowOpacity = 0.5
        txtNameContainerView?.layer.shadowRadius = 1.0
        
        //SURNAME
        txtSurnameContainerView?.layer.masksToBounds = false
        txtSurnameContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        txtSurnameContainerView?.layer.shadowPath = UIBezierPath(roundedRect: txtSurnameContainerView!.bounds, cornerRadius: (txtSurnameContainerView?.layer.cornerRadius)!).cgPath
        txtSurnameContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        txtSurnameContainerView?.layer.shadowOpacity = 0.5
        txtSurnameContainerView?.layer.shadowRadius = 1.0
        
        //EMAIL
        txtEmailContainerView?.layer.masksToBounds = false
        txtEmailContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        txtEmailContainerView?.layer.shadowPath = UIBezierPath(roundedRect: txtEmailContainerView!.bounds, cornerRadius: (txtEmailContainerView?.layer.cornerRadius)!).cgPath
        txtEmailContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        txtEmailContainerView?.layer.shadowOpacity = 0.5
        txtEmailContainerView?.layer.shadowRadius = 1.0
        
        //MOBILE NUMBER
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
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        //navigationTitle?.text = NSLocalizedString("profile", value:"Perfil", comment: "")
        
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
        mainScrollView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        scrollContainerView?.backgroundColor = .clear
        
        btnAddStoreContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        btnAddStoreContainerView?.layer.cornerRadius = 5.0
        lblAddStore?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblAddStore?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblAddStore?.text = NSLocalizedString("activity_manage_stores", value: "Cadastrar e gerenciar meu negócio", comment: "")
        btnAddStore?.addTarget(self, action: #selector(self.btnAddStoreClicked(_:)), for: .touchUpInside)
        
        //NAME
        lblName?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblName?.textColor = MySingleton.sharedManager().themeGlobalLightBlueColor
        lblName?.text = NSLocalizedString("first_name", value: "Nome", comment: "")
        
        txtNameContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtNameContainerView?.layer.cornerRadius = 5.0
        
        txtName?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtName?.delegate = self
        txtName?.backgroundColor = .clear
        txtName?.tintColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtName?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("first_name", value: "Nome", comment: ""),
                                                                attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtName?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtName?.textAlignment = .left
        txtName?.autocorrectionType = UITextAutocorrectionType.no
        
        //SURNAME
        lblSurname?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblSurname?.textColor = MySingleton.sharedManager().themeGlobalLightBlueColor
        lblSurname?.text = NSLocalizedString("last_name", value: "Sobrenome", comment: "")
        
        txtSurnameContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtSurnameContainerView?.layer.cornerRadius = 5.0
        
        txtSurname?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtSurname?.delegate = self
        txtSurname?.backgroundColor = .clear
        txtSurname?.tintColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtSurname?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("last_name", value: "Sobrenome", comment: ""),
                                                                attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtSurname?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtSurname?.textAlignment = .left
        txtSurname?.autocorrectionType = UITextAutocorrectionType.no
        
        //EMAIL
        lblEmail?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblEmail?.textColor = MySingleton.sharedManager().themeGlobalLightBlueColor
        lblEmail?.text = NSLocalizedString("email", value: "Email", comment: "")
        
        txtEmailContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtEmailContainerView?.layer.cornerRadius = 5.0
        
        txtEmail?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtEmail?.delegate = self
        txtEmail?.backgroundColor = .clear
        txtEmail?.tintColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtEmail?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("email", value: "Email", comment: ""),
                                                                attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtEmail?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtEmail?.textAlignment = .left
        txtEmail?.autocorrectionType = UITextAutocorrectionType.no
        txtEmail?.keyboardType = .emailAddress
        
        //MOBILE NUMBER
        lblMobileNumber?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblMobileNumber?.textColor = MySingleton.sharedManager().themeGlobalLightBlueColor
        lblMobileNumber?.text = NSLocalizedString("mobile_num", value: "Número de celular (com DDD)", comment: "")
        
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
        txtMobileNumber?.isUserInteractionEnabled = false
        
        btnSave?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        
        btnSave?.setTitle(NSLocalizedString("update", value:"Atualizar", comment: "").uppercased(), for: .normal)
        btnSave?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSave?.clipsToBounds = true
        //btnSave?.layer.cornerRadius = 5
        btnSave?.addTarget(self, action: #selector(self.btnSaveClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnAddStoreClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
//        let viewController: User_MyStoresListViewController = User_MyStoresListViewController()
//        self.navigationController?.pushViewController(viewController, animated: false)
        
        //MY STORES
        let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
        let strPassword: String = "\(UserDefaults.standard.value(forKey: "password") ?? "")"
        
        if(strIsAuthorized == "1")
        {
            //AUTHORIZED
            let viewController: User_MyStoresListViewController = User_MyStoresListViewController()
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else if(strPassword != "" && strPassword.count > 0)
        {
            //PASSWORD IS CREATED
            let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            //PASSWORD IS NOT CREATED
//            let viewController: User_RegisterEmailViewController = User_RegisterEmailViewController()
//            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func btnChangeNumberClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        appDelegate?.showAlertViewWithTitle(title: "", detail: "Contate os administradores para trocar seu telefone")
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if ((txtName?.text?.count)! <= 0 || (txtSurname?.text?.count)! <= 0 || (txtEmail?.text?.count)! <= 0)
        {
            if ((txtName?.text?.count)! <= 0)
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("error_required", value:"Campo obrigatório!", comment: ""))
            }
            else if ((txtSurname?.text?.count)! <= 0)
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("error_required", value:"Campo obrigatório!", comment: ""))
            }
            else if ((txtEmail?.text?.count)! <= 0)
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("error_required", value:"Campo obrigatório!", comment: ""))
            }
        }
        else if (objCommonUtility.isValidEmailAddress(strEmailString: (txtEmail?.text)!) == false)
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("error_invalid_email", value:"Invalid email address!", comment: ""))
        }
        else
        {
            //API CALL
            dataManager.user_UpdateMyProfileDetails(strFirstName: (txtName?.text)!, strLastName: (txtSurname?.text)!, strEmail: (txtEmail?.text)!, strMobileNumber: (txtMobileNumber?.text)!)
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
        
        if (textField == txtMobileNumber)
        {
            let maxLength = 11
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else
        {
            return true
        }
    }
}
