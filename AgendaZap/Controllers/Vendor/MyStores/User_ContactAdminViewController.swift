//
//  User_ContactAdminViewController.swift
//  AgendaZap
//
//  Created by Dipen on 21/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class User_ContactAdminViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate
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
    
    @IBOutlet var txtMessageContainerView: UIView?
    @IBOutlet var txtMessage: UITextView?
    
    @IBOutlet var btnSubmit: UIButton?
    
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
            selector: #selector(self.user_ContactAdministratorEvent),
            name: Notification.Name("user_ContactAdministratorEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_ContactAdministratorEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.txtMessage?.text = ""
            self.appDelegate?.showAlertViewWithTitle(title: NSLocalizedString("activity_store_details_add_reviews_success_title", value:"Success", comment: ""), detail: dataManager.strServerMessage)
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //MOBILE NUMBER
        txtMessageContainerView?.layer.masksToBounds = false
        txtMessageContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        txtMessageContainerView?.layer.shadowPath = UIBezierPath(roundedRect: txtMessageContainerView!.bounds, cornerRadius: (txtMessageContainerView?.layer.cornerRadius)!).cgPath
        txtMessageContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        txtMessageContainerView?.layer.shadowOpacity = 0.5
        txtMessageContainerView?.layer.shadowRadius = 1.0
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("menu_contact_us", value:"Contatar os administradores", comment: "")
        
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
        
        lblInstructions?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblInstructions?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblInstructions?.text = NSLocalizedString("report_a_problem", value: "Neste espaço, você pode relatar qualquer tipo de problema, desde bugs e sugestões, até WhatsApp inexistentes ou que não fornecem mais determinados serviços.", comment: "")
        
        txtMessageContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtMessageContainerView?.layer.cornerRadius = 5.0
        
        let txtTemp: SATextField = SATextField()
        
        txtMessage?.font = txtTemp.font
        txtMessage?.textColor = txtTemp.textColor
        txtMessage?.placeholderColor = txtTemp.placeholderColor
        txtMessage?.placeholder = NSLocalizedString("type_here", value: "Escreva aqui", comment: "")
                
        btnSubmit?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSubmit?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        
        btnSubmit?.setTitle(NSLocalizedString("send", value:"Enviar", comment: ""), for: .normal)
        btnSubmit?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSubmit?.clipsToBounds = true
        btnSubmit?.layer.cornerRadius = 5
        btnSubmit?.addTarget(self, action: #selector(self.btnSubmitClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if ((txtMessage?.text.count)! <= 0)
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("error_required", value:"Campo obrigatório!", comment: ""))
        }
        else
        {
            //API CALL
            dataManager.user_ContactAdministrator(strMessage: (txtMessage?.text)!)
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
