//
//  LoyaltyProgramVC.swift
//  AgendaZap
//
//  Created by Shashank Bansal on 28/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import iOSDropDown

class LoyaltyProgramVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblConfigure: UILabel!
    
    @IBOutlet var viewConfigurationContainer: UIView!
    @IBOutlet var lblConfigure1: UILabel!
    @IBOutlet var dropDownPoints: DropDown!
    @IBOutlet var lblConfigure2: UILabel!
    @IBOutlet var txtMessage: UITextField!
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet var viewConfigurationValueContainer: UIView!
    @IBOutlet var lblConfigurationValue: UILabel!
    @IBOutlet var btnEditConfiguration: UIButton!
    
    @IBOutlet var viewPhoneNumberContainer: UIView!
    @IBOutlet var nslcViewPhoneNumberContainerHeigth: NSLayoutConstraint!//120
    @IBOutlet var lblTitlePhoneNumber: UILabel!
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var btnEnter: UIButton!
    
    @IBOutlet var viewClientDetailsContainer: UIView!
    @IBOutlet var nslcViewClientDetailsContainerHeight: NSLayoutConstraint!//320
    @IBOutlet var lblNameTitle: UILabel!
    @IBOutlet var lblNameValue: UILabel!
    @IBOutlet var lblPointsTitle: UILabel!
    @IBOutlet var lblPointsValue: UILabel!
    @IBOutlet var btnAddPoint: UIButton!
    @IBOutlet var btnDiscount: UIButton!
    @IBOutlet var btnWhatsapp: UIButton!
    @IBOutlet var btnViewHistory: UIButton!
    
    @IBOutlet var lblTotleClients: UILabel!
    @IBOutlet var btnViewClients: UIButton!
    
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var arrayPurchaseIDs = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
    var arrayPurchaseStrings = ["2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    
    var boolIsCalledForReward: Bool = true
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        //INITIAL SETUP
        viewConfigurationContainer.isHidden = false
        viewConfigurationValueContainer.isHidden = true
        viewPhoneNumberContainer.isHidden = true
        nslcViewPhoneNumberContainerHeigth.constant = 0
        viewClientDetailsContainer.isHidden = true
        nslcViewClientDetailsContainerHeight.constant = 0
        lblTotleClients.isHidden = true
        btnViewClients.isHidden = true
        
        //API CALL
        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        dataManager.user_CheckLoyaltyReward(strStoreID: strSelectedStoreID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if (dataManager.objSelectedRewardUser != nil)
        {
            txtPhoneNumber.text = dataManager.objSelectedRewardUser?.strPhoneNumner
            self.btnEnterTapped(btnEnter!)
        }
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
                selector: #selector(self.user_CheckLoyaltyRewardEvent),
                name: Notification.Name("user_CheckLoyaltyRewardEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_AddLoyaltyRewardEvent),
                name: Notification.Name("user_AddLoyaltyRewardEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_CheckNewUserEvent),
                name: Notification.Name("user_CheckNewUserEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_AddUserRewardPurchaseEvent),
                name: Notification.Name("user_AddUserRewardPurchaseEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_CheckLoyaltyRewardEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.dropDownPoints.isUserInteractionEnabled = true
            self.dropDownPoints.optionIds = self.arrayPurchaseIDs
            self.dropDownPoints.optionArray = self.arrayPurchaseStrings
            self.dropDownPoints.selectedIndex = 0
            self.dropDownPoints.text = self.arrayPurchaseStrings[0]
            
            self.dropDownPoints.didSelect{(selectedText , index ,id) in
                                
            }
            
            if dataManager.boolIsLoyaltyProgramExist
            {
                self.viewConfigurationContainer.isHidden = true
                self.viewConfigurationValueContainer.isHidden = false
                self.viewPhoneNumberContainer.isHidden = false
                self.nslcViewPhoneNumberContainerHeigth.constant = 120
                self.viewClientDetailsContainer.isHidden = true
                self.nslcViewClientDetailsContainerHeight.constant = 0
                self.lblTotleClients.isHidden = false
                self.btnViewClients.isHidden = false
                                
                let titleAttribute = [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().themeGlobalBlackColor!, NSAttributedString.Key.font: MySingleton.sharedManager().themeFontSixteenSizeRegular!] as [NSAttributedString.Key : Any]
                let valueAttribute = [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().themeGlobalBlackColor!, NSAttributedString.Key.font: MySingleton.sharedManager().themeFontSixteenSizeBold!] as [NSAttributedString.Key : Any]
                let editAttribute = [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().themeGlobalGreenColor!, NSAttributedString.Key.font: MySingleton.sharedManager().themeFontSixteenSizeBold!] as [NSAttributedString.Key : Any]
                
                let mainString = NSMutableAttributedString(string: "", attributes: titleAttribute)
                
                let str1 = NSAttributedString(string: "Quando o cliente atingir ", attributes: titleAttribute)
                mainString.append(str1)
                let str2 = NSAttributedString(string: "\(dataManager.strPurchaseRequired)", attributes: valueAttribute)
                mainString.append(str2)
                let str3 = NSAttributedString(string: " compras ele ganhará ", attributes: titleAttribute)
                mainString.append(str3)
                let str4 = NSAttributedString(string: "\(dataManager.strReward)", attributes: valueAttribute)
                mainString.append(str4)
                let str5 = NSAttributedString(string: " [Editar]", attributes: editAttribute)
                mainString.append(str5)
                
                //self.lblConfigurationValue.text = "Quando o cliente atingir \(dataManager.strPurchaseRequired) compras ele ganhará \(dataManager.strReward) [Editar]"
                self.lblConfigurationValue.attributedText = mainString
                
                for index in 0...(self.arrayPurchaseStrings.count - 1)
                {
                    if (dataManager.strPurchaseRequired == self.arrayPurchaseStrings[index])
                    {
                        self.dropDownPoints.selectedIndex = index
                        self.dropDownPoints.text = self.arrayPurchaseStrings[index]
                    }
                }
                self.txtMessage.text = dataManager.strReward
                
                let mainClientString = NSMutableAttributedString(string: "", attributes: titleAttribute)
                
                let strClient1 = NSAttributedString(string: "Total de clientes cadastrados: ", attributes: valueAttribute)
                mainClientString.append(strClient1)
                let strClient2 = NSAttributedString(string: "\(dataManager.strTotalRewardUsers)", attributes: editAttribute)
                mainClientString.append(strClient2)
                
                self.lblTotleClients.attributedText = mainClientString
                //self.lblTotleClients.text = "Total de clientes cadastrados: \(dataManager.strTotalRewardUsers)"
                
                if (dataManager.objSelectedRewardUser != nil)
                {
                    self.txtPhoneNumber.text = dataManager.objSelectedRewardUser?.strPhoneNumner
                    self.btnEnterTapped(self.btnEnter!)
                }
            }
            else
            {
                self.viewConfigurationContainer.isHidden = false
                self.viewConfigurationValueContainer.isHidden = true
                self.viewPhoneNumberContainer.isHidden = true
                self.nslcViewPhoneNumberContainerHeigth.constant = 0
                self.viewClientDetailsContainer.isHidden = true
                self.nslcViewClientDetailsContainerHeight.constant = 0
                self.lblTotleClients.isHidden = true
                self.btnViewClients.isHidden = true
            }
            
        })
    }
    
    @objc func user_AddLoyaltyRewardEvent()
    {
        DispatchQueue.main.async(execute: {
            
            //API CALL
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            dataManager.user_CheckLoyaltyReward(strStoreID: strSelectedStoreID)
            
        })
    }
    
    @objc func user_CheckNewUserEvent()
    {
        DispatchQueue.main.async(execute: {
            
            if dataManager.boolIsLoyaltyProgramExist
            {
                if dataManager.boolIsNewUser
                {
                    //NAVIGATE TO CREATE NEW USER
                    let viewController: CreateNewUserVC = CreateNewUserVC()
                    viewController.strPhoneNumber = (self.txtPhoneNumber.text)!
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else
                {
                    self.viewClientDetailsContainer.isHidden = false
                    self.nslcViewClientDetailsContainerHeight.constant = 320
                    self.lblNameValue.text = dataManager.objSelectedRewardUser?.strFullName
                    self.lblPointsValue.text = dataManager.objSelectedRewardUser?.strPurchases != "<null>" ? dataManager.objSelectedRewardUser?.strPurchases : "0"
                    self.btnAddPoint.setTitle("Adicionar 1 Compra", for: .normal)
                    self.btnDiscount.setTitle("Descontar -\(dataManager.intUserPurchaseRequired) Compras", for: .normal)
                }
            }
            else
            {
                self.viewClientDetailsContainer.isHidden = true
                self.nslcViewClientDetailsContainerHeight.constant = 0
            }
        })
    }
    
    @objc func user_AddUserRewardPurchaseEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let alertViewController = NYAlertViewController()
            
            alertViewController.title = "Sucesso!"
            if self.boolIsCalledForReward
            {
                alertViewController.message = "Compra adicionada!"
            }
            else
            {
                alertViewController.message = "Compras descontadas. Pode dar a recompensa ao cliente."
            }
            
            // Customize appearance as desired
            alertViewController.view.tintColor = UIColor.white
            alertViewController.backgroundTapDismissalGestureEnabled = false
            alertViewController.swipeDismissalGestureEnabled = false
            alertViewController.transitionStyle = NYAlertViewControllerTransitionStyle.fade
            
            alertViewController.titleFont = MySingleton.sharedManager().alertViewTitleFont
            alertViewController.messageFont = MySingleton.sharedManager().alertViewMessageFont
            alertViewController.buttonTitleFont = MySingleton.sharedManager().alertViewButtonTitleFont
            alertViewController.cancelButtonTitleFont = MySingleton.sharedManager().alertViewCancelButtonTitleFont
            alertViewController.buttonTitleColor = MySingleton.sharedManager().themeGlobalBlackColor
            alertViewController.cancelButtonTitleColor = MySingleton.sharedManager().themeGlobalBlackColor
            
            alertViewController.buttonColor = MySingleton.sharedManager().alertViewLeftButtonBackgroundColor
            
            // Add alert actions
            let okAction = NYAlertAction(
                title: "Ok",
                style: .default,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.navigationController!.dismiss(animated: true, completion: nil)
                    
                    self.btnEnterTapped(self.btnEnter!)
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
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        if txtMessage.text?.isEmpty == true
        {
            AppDelegate.showToast(message : "Please enter reward", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
        }
        else
        {
            //API CALL
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            dataManager.user_AddLoyaltyReward(strStoreID: strSelectedStoreID, strPurchases: (dropDownPoints.text)!, strReward: (txtMessage.text)!)
        }
        
    }
    
    @IBAction func btnEditConfigurationTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        self.viewConfigurationContainer.isHidden = false
        self.viewConfigurationValueContainer.isHidden = true
        
    }
    
    @IBAction func btnEnterTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        if(txtPhoneNumber.text?.count == 0 || ((txtPhoneNumber.text?.isEmpty) == nil)){
            
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
        }else{
            let intMobileNumber = Int(txtPhoneNumber.text!) ?? 0
            if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
            {
                //API CALL
                let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
                dataManager.user_CheckNewUser(strStoreID: strSelectedStoreID, strPhoneNumber: "\(intMobileNumber)")
                
            }
            else
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
            }
        }
        
    }
    
    @IBAction func btnAddPointTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        boolIsCalledForReward = true
        //API CALL
        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        dataManager.user_AddUserRewardPurchase(strStoreID: strSelectedStoreID, strRewardUserID: dataManager.objSelectedRewardUser?.strID ?? "0", strValue: "1")
        
    }
    
    @IBAction func btnDiscountTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        if (dataManager.intUserPurchase >= dataManager.intUserPurchaseRequired)
        {
            boolIsCalledForReward = false
            //API CALL
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            dataManager.user_AddUserRewardPurchase(strStoreID: strSelectedStoreID, strRewardUserID: dataManager.objSelectedRewardUser?.strID ?? "0", strValue: "-\(dataManager.intUserPurchaseRequired)")
        }
        else
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Saldo insuficiente")
        }
        
    }
    
    @IBAction func btnWhatsappTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        if(txtPhoneNumber.text?.count == 0 || ((txtPhoneNumber.text?.isEmpty) == nil)){
            
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
        }else{
            let intMobileNumber = Int(txtPhoneNumber.text!) ?? 0
            if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
            {
                print("self.objStoreDetails.strPhoneNumber :\(intMobileNumber)")
                
                let originalString = "https://wa.me/55\(intMobileNumber)?text=Olá \(dataManager.objSelectedRewardUser?.strFullName ?? "")\nSeu saldo atual é de \(dataManager.objSelectedRewardUser?.strPurchases ?? "0")\nAo atingir \(dataManager.strPurchaseRequired) você ganhará \(dataManager.strReward)."
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
        
    }
    
    @IBAction func btnViewHistoryTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let viewController: ViewRewardHistoryVC = ViewRewardHistoryVC()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnViewClientsTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let viewController: ViewClientsVC = ViewClientsVC()
        self.navigationController?.pushViewController(viewController, animated: true)
        
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
        
        btnSave.layer.borderWidth = 1
        btnSave.layer.borderColor = UIColor.init(named: "Color1_ThemeBlack")?.cgColor
        
        btnEnter.layer.cornerRadius = 10
        
        btnAddPoint.backgroundColor = MySingleton.sharedManager().themeGlobalGreen2Color
        btnAddPoint.layer.cornerRadius = 10
        
        btnDiscount.backgroundColor = MySingleton.sharedManager().themeGlobalRed2Color
        btnDiscount.layer.cornerRadius = 10
        
        btnViewHistory.backgroundColor = MySingleton.sharedManager().themeGlobalDarkGrey2Color
        btnViewHistory.layer.cornerRadius = 10
        
        btnViewClients.layer.cornerRadius = 10
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
