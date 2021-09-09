//
//  User_ContactlessZapViewController.swift
//  AgendaZap
//
//  Created by Dipen on 21/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class User_ContactlessZapViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate
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
    
    @IBOutlet var scrollContainerView: UIView?
    
    @IBOutlet var lblInstructions: UILabel?
    
    @IBOutlet var txtMobileNumberContainerView: UIView?
    @IBOutlet var txtMobileNumber: UITextField?
    
    @IBOutlet var btnSendMessage: UIButton?
    @IBOutlet var btnViewConstraint: NSLayoutConstraint!
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    //MARK:- UIViewController Delegate Methods
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
        
        self.txtMobileNumber?.becomeFirstResponder()
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
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //self.view.endEditing(true)
        
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
            selector: #selector(self.user_UpdateMyProfileDetailsEvent),
            name: Notification.Name("user_UpdateMyProfileDetailsEvent"),
            object: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_UpdateMyProfileDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            
        })
    }
    
    /*
    func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()

        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    */
    
    @objc func keyboardWillShow(sender: NSNotification) {
        //self.view.frame.origin.y = -150 // Move view 150 points upward
        
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.btnViewConstraint.constant = keyboardFrame.size.height
        })
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         //self.view.frame.origin.y = 0 // Move view to original position
        self.btnViewConstraint.constant = 20
    }
    
    //MARK:- Layout Subviews Methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //MOBILE NUMBER
        txtMobileNumberContainerView?.layer.masksToBounds = false
        txtMobileNumberContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        txtMobileNumberContainerView?.layer.shadowPath = UIBezierPath(roundedRect: txtMobileNumberContainerView!.bounds, cornerRadius: (txtMobileNumberContainerView?.layer.cornerRadius)!).cgPath
        txtMobileNumberContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        txtMobileNumberContainerView?.layer.shadowOpacity = 0.5
        txtMobileNumberContainerView?.layer.shadowRadius = 1.0
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("menu_zap_sam_contact", value:"WhatsApp sem contato", comment: "")
        
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
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        scrollContainerView?.backgroundColor = .clear
        
        lblInstructions?.font = MySingleton.sharedManager().themeFontNineteenSizeRegular
        lblInstructions?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblInstructions?.text = "Digite abaixo o numero para chamar no WhatsApp sem precisar salvar na agenda"
        
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
        
        /*
        btnSendMessage?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSendMessage?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        
        btnSendMessage?.setTitle(NSLocalizedString("enviar_mensagem", value:"Enviar Mensagem", comment: "").uppercased(), for: .normal)
        btnSendMessage?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSendMessage?.clipsToBounds = true
        btnSendMessage?.layer.cornerRadius = 5
        */
        btnSendMessage?.addTarget(self, action: #selector(self.btnSendMessageClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnSendMessageClicked(_ sender: UIButton)
    {
        //self.view.endEditing(true)
        
//        let intMobileNumber: Int = Int(txtMobileNumber!.text ?? "0")!
//
//        if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
//        {
//            let originalString = "https://wa.me/55\((self.txtMobileNumber?.text)!)?text=&source=&data="
//          let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//
//          guard let url = URL(string: escapedString!) else {
//            return //be safe
//          }
//
//          UIApplication.shared.open(url, options: [:], completionHandler: nil)
////            let first4 = String("\(intMobileNumber)".prefix(2))
////
////            if (first4 == "55")
////            {
////                appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: ""))
////            }
////            else
////            {
////                let originalString = "https://wa.me/55\((self.txtMobileNumber?.text)!)?text=&source=&data="
////                let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
////
////                guard let url = URL(string: escapedString!) else {
////                  return //be safe
////                }
////
////                UIApplication.shared.open(url, options: [:], completionHandler: nil)
////
////                //dataManager.user_RegisterMobileNumber(strMobileNumber: (txtMobileNumber?.text)!)
////            }
//        }
//        else
//        {
//            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
//        }
        
        let intMobileNumber: Int = Int(txtMobileNumber?.text == "" ? "0" : txtMobileNumber?.text ?? "0")!
        
        print("intMobileNumber :\(intMobileNumber)")
        
        if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
        {
            let originalString = "https://wa.me/55\((self.txtMobileNumber?.text)!)?text=&source=&data="
          let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
          
          guard let url = URL(string: escapedString!) else {
            return //be safe
          }
          
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
        }
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
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
