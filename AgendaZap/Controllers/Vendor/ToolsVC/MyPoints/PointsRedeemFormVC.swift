//
//  PointsRedeemFormVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 24/05/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController

class PointsRedeemFormVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblEmail: UILabel?
    @IBOutlet var txtEmailContainerView: UIViewX?
    @IBOutlet var txtEmail: UITextField?
    
    @IBOutlet var lblName: UILabel?
    @IBOutlet var txtNameContainerView: UIViewX?
    @IBOutlet var txtName: UITextField?
    
    @IBOutlet var lblID: UILabel?
    @IBOutlet var txtIDContainerView: UIViewX?
    @IBOutlet var txtID: UITextField?
    
    @IBOutlet var btnSubmit: UIButton?
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var boolIsAPICalledOnce: Bool = false
    
    var intType: Int!
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        if intType == 1
        {
            lblID?.text = "Seu CPF ou CNPJ (somente números)"
            txtID?.placeholder = "Seu CPF ou CNPJ (somente números)"
        }
        else if intType == 2
        {
            lblID?.text = "Chave Pix"
            txtID?.placeholder = "Chave"
        }
        else
        {
            lblID?.text = "Endereço completo para envio"
            txtID?.placeholder = "Endereço completo para envio"
        }
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
    
    //MARK:- Setup Notification Methods
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_addPaymentRequestEvent),
                name: Notification.Name("user_addPaymentRequestEvent"),
                object: nil)
        }
    }
        
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_addPaymentRequestEvent()
    {
        DispatchQueue.main.async(execute: {
            
            //show Rating alert
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = ""
            alertViewController.message = "Dados enviados! Em até 3 dias faremos a análise e efetuaremos o pagamento via PIX."
            
            // Customize appearance as desired
            alertViewController.view.tintColor = UIColor.white
            alertViewController.backgroundTapDismissalGestureEnabled = true
            alertViewController.swipeDismissalGestureEnabled = true
            alertViewController.transitionStyle = NYAlertViewControllerTransitionStyle.fade
            
            alertViewController.titleFont = MySingleton.sharedManager().alertViewTitleFont
            alertViewController.messageFont = MySingleton.sharedManager().alertViewMessageFont
            alertViewController.buttonTitleFont = MySingleton.sharedManager().alertViewButtonTitleFont
            alertViewController.cancelButtonTitleFont = MySingleton.sharedManager().alertViewCancelButtonTitleFont
            alertViewController.buttonTitleColor = MySingleton.sharedManager().themeGlobalBlackColor
            alertViewController.cancelButtonTitleColor = MySingleton.sharedManager().themeGlobalBlackColor
            
            alertViewController.buttonColor = MySingleton.sharedManager().alertViewLeftButtonBackgroundColor
            
            alertViewController.cancelButtonColor = MySingleton.sharedManager().themeGlobalRedColor
            
            // Add alert actions
            let okAction = NYAlertAction(
                title: "Ok",
                style: .default,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.navigationController!.dismiss(animated: true, completion: nil)
                    
                    self.navigationController?.popViewController(animated: false)
                    
            })
            
            alertViewController.addAction(okAction)
                                
            self.navigationController!.present(alertViewController, animated: true, completion: nil)
            
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        self.view.endEditing(true)
                
        if (txtEmail?.text?.isEmpty == true || txtName?.text?.isEmpty == true || txtID?.text?.isEmpty == true)
        {
            if (txtEmail?.text?.isEmpty == true)
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter email.")
            }
            else if (txtName?.text?.isEmpty == true)
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter store name.")
            }
            else
            {
                if intType == 1
                {
                    appDelegate?.showAlertViewWithTitle(title: "", detail: "Seu CPF ou CNPJ (somente números)")
                }
                else if intType == 2
                {
                    appDelegate?.showAlertViewWithTitle(title: "", detail: "Chave Pix")
                }
                else
                {
                    appDelegate?.showAlertViewWithTitle(title: "", detail: "Endereço completo para envio")
                }
                
            }
        }
        else if (objCommonUtility.isValidEmailAddress(strEmailString: (txtEmail?.text)!) == false)
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Invalid Email.")
        }
        else
        {
            //API CALL
            dataManager.user_addPaymentRequest(strEmail: (txtEmail?.text)!,
                                               strName: (txtName?.text)!,
                                               strType: "\(intType ?? 0)",
                                               strID: (txtID?.text)!)
        }
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        viewNavigation?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        //navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        //navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        //navigationTitle?.text = ""
        
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        txtEmail?.delegate = self
        txtName?.delegate = self
        txtID?.delegate = self
        
        btnSubmit?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSubmit?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSubmit?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSubmit?.clipsToBounds = true
        btnSubmit?.layer.cornerRadius = 5
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
