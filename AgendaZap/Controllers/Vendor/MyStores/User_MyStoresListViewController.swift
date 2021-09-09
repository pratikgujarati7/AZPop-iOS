//
//  User_MyStoresListViewController.swift
//  AgendaZap
//
//  Created by Dipen on 02/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift
import StoreKit
import NYAlertViewController
import LGSideMenuController
import FirebaseDynamicLinks
import iOSDropDown

class User_MyStoresListViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate//, UITableViewDelegate, UITableViewDataSource
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
    
    @IBOutlet var lblStoreName: UILabel?
    @IBOutlet var imageViewUsVerified: UIImageView?
    @IBOutlet var btnEditStoreName: UIButton!
    @IBOutlet var lblStoreNumber: UILabel?
    @IBOutlet var btnEditStoreNumber: UIButton!
    @IBOutlet var lblPremium: UILabel?
        
    //@IBOutlet var lblStoreName: UILabel!
    @IBOutlet var btnEditStoreSlug: UIButton!
    @IBOutlet var lblStoreURL: UILabel!
    
    @IBOutlet var btnSetVisibleContainer: UIViewX?
    @IBOutlet var btnEditStoreContainer: UIViewX?
    @IBOutlet var btnPremiumContainer: UIViewX?
    @IBOutlet var btnViewStoreContainer: UIViewX?
    @IBOutlet var btnViewProductsContainer: UIViewX?
    @IBOutlet var btnViewRatingsContainer: UIViewX?
    @IBOutlet var btnVerifyContainer: UIViewX?
    @IBOutlet var btnSupportContainer: UIViewX?
//    @IBOutlet var txtStore: DropDown!
    
    @IBOutlet var showStoreContainerView: UIView!
    @IBOutlet var btnShowOnWeb: UIButton!
    @IBOutlet var btnShowOnApp: UIButton!
    
    //POPUP
    @IBOutlet var editNamePopupContainerView: UIView?
    @IBOutlet var editNameInnerContainerView: UIView?
    @IBOutlet var btnCloseEditName: UIButton?
    @IBOutlet var lblEditName: UILabel?
    @IBOutlet var txtEditNameContainerView: UIView?
    @IBOutlet var txtEditName: UITextField?
    @IBOutlet var btnSaveEditName: UIButton?
    
    //POPUP
    @IBOutlet var editNumberPopupContainerView: UIView?
    @IBOutlet var editNumberInnerContainerView: UIView?
    @IBOutlet var btnCloseEditNumber: UIButton?
    @IBOutlet var lblEditNumber: UILabel?
    @IBOutlet var txtEditNumberContainerView: UIView?
    @IBOutlet var txtEditNumber: UITextField?
    @IBOutlet var btnSaveEditNumber: UIButton?
    
    //POPUP
    @IBOutlet var editSlugPopupContainerView: UIView?
    @IBOutlet var editSlugInnerContainerView: UIView?
    @IBOutlet var btnCloseEditSlug: UIButton?
    @IBOutlet var lblEditSlug: UILabel?
    @IBOutlet var txtEditSlugContainerView: UIView?
    @IBOutlet var txtEditSlug: UITextField?
    @IBOutlet var lblEditedSlug: UILabel?
    @IBOutlet var btnSaveEditSlug: UIButton?
    
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var dataRows = [MyStore]()
    var arrayMyStoreIDs = [Int]()
    var arrayMyStoreNames = [String]()
    var objSelectedStore: MyStore = MyStore()
    
    var boolIsNotPremiumStoreAvailableInList: Bool = false
    var boolIsOpenFromPurchaseController: Bool = false
    var boolIsLoadedFromPasswordScreen: Bool = false
    
    var boolIsWayBack: Bool = false
    
    // MARK: - UIViewController Delegate Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNotificationEvent()
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        let realm = try! Realm()
        
        self.dataRows = [MyStore]()
        self.arrayMyStoreIDs = [Int]()
        self.arrayMyStoreNames = [String]()
        boolIsNotPremiumStoreAvailableInList = false
        for obj in realm.objects(MyStore.self)
        {
            if (Int(obj.strType) ?? 0 == 0)
            {
                boolIsNotPremiumStoreAvailableInList = true
            }
            self.dataRows.append(obj)
            self.arrayMyStoreIDs.append(Int(obj.strID) ?? 0)
            self.arrayMyStoreNames.append(obj.strName)
        }
        
        if (self.arrayMyStoreIDs.count > 0)
        {
//            txtStore.optionIds = self.arrayMyStoreIDs
//            txtStore.optionArray = self.arrayMyStoreNames
            
            if (UserDefaults.standard.value(forKey: "selected_store_id") != nil)
            {
                for index in 0...(self.arrayMyStoreIDs.count - 1)
                {
                    if ("\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")" == "\(self.arrayMyStoreIDs[index])")
                    {
                        lblStoreName?.text = self.dataRows[index].strName
                        lblStoreNumber?.text = self.dataRows[index].strPhoneNumber
                        objSelectedStore = self.dataRows[index]
                        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                        let underlineAttributedString = NSAttributedString(string: "\(ServerIPForWebsite)\(objSelectedStore.strSlug)", attributes: underlineAttribute)
                        self.lblStoreURL.attributedText = underlineAttributedString
                        if (self.objSelectedStore.strIsStoreVisible == "1")
                        {
                            self.btnSetVisibleContainer?.isHidden = true
                            self.btnViewStoreContainer?.isHidden = false
                            self.btnViewRatingsContainer?.isHidden = true
                            
                            if (self.objSelectedStore.strType == "0")
                            {
                                self.lblPremium?.isHidden = true
                                self.btnPremiumContainer?.isHidden = false
                                
                            }
                            else
                            {
                                self.lblPremium?.isHidden = false
                                self.btnPremiumContainer?.isHidden = true
                            }
                            
                            if (self.objSelectedStore.strTaxIdStatus == "1")
                            {
                                self.imageViewUsVerified?.isHidden = true//false
                                self.btnVerifyContainer?.isHidden = true
                            }
                            else
                            {
                                self.imageViewUsVerified?.isHidden = true
                                self.btnVerifyContainer?.isHidden = false
                            }
                        }
                        else
                        {
                            self.btnSetVisibleContainer?.isHidden = false
                            self.btnViewStoreContainer?.isHidden = true
                            self.lblPremium?.isHidden = true
                            self.btnPremiumContainer?.isHidden = true
                            self.btnViewRatingsContainer?.isHidden = true
                            self.btnVerifyContainer?.isHidden = true
                        }
                    }
                }
            }
            else
            {
                lblStoreName?.text = self.dataRows[0].strName
                lblStoreNumber?.text = self.dataRows[0].strPhoneNumber
                objSelectedStore = self.dataRows[0]
                let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                let underlineAttributedString = NSAttributedString(string: "\(ServerIPForWebsite)\(objSelectedStore.strSlug)", attributes: underlineAttribute)
                self.lblStoreURL.attributedText = underlineAttributedString
                if (self.objSelectedStore.strIsStoreVisible == "1")
                {
                    self.btnSetVisibleContainer?.isHidden = true
                    self.btnViewStoreContainer?.isHidden = false
                    self.btnViewRatingsContainer?.isHidden = true
                    
                    if (self.objSelectedStore.strType == "0")
                    {
                        self.lblPremium?.isHidden = true
                        self.btnPremiumContainer?.isHidden = false
                        
                    }
                    else
                    {
                        self.lblPremium?.isHidden = false
                        self.btnPremiumContainer?.isHidden = true
                    }
                    
                    if (self.objSelectedStore.strTaxIdStatus == "1")
                    {
                        self.imageViewUsVerified?.isHidden = true//false
                        self.btnVerifyContainer?.isHidden = true
                    }
                    else
                    {
                        self.imageViewUsVerified?.isHidden = true
                        self.btnVerifyContainer?.isHidden = false
                    }
                }
                else
                {
                    self.btnSetVisibleContainer?.isHidden = false
                    self.btnViewStoreContainer?.isHidden = true
                    self.lblPremium?.isHidden = true
                    self.btnPremiumContainer?.isHidden = true
                    self.btnViewRatingsContainer?.isHidden = true
                    self.btnVerifyContainer?.isHidden = true
                }
                UserDefaults.standard.setValue(self.dataRows[0].strID, forKey: "selected_store_id")
                UserDefaults.standard.setValue(self.dataRows[0].strName, forKey: "selected_store_name")
                UserDefaults.standard.setValue(self.dataRows[0].strSlug, forKey: "selected_store_slug")
                UserDefaults.standard.setValue(self.dataRows[0].strIsStoreVisible, forKey: "selected_store_visible")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //API CALL
        dataManager.user_GetAllMyStores()
        
//        let strPassword: String = "\(UserDefaults.standard.value(forKey: "password") ?? "")"
//        //NOT AUTHORIZED
//        if(strPassword != "" && strPassword.count > 0)
//        {
//
//        }
//        else
//        {
//            // Visible Store Screen
//        }
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
        
        showStoreContainerView.frame.size = self.view.frame.size
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
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_UpdateNameOfStoreEvent),
                name: Notification.Name("user_UpdateNameOfStoreEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_UpdateNumberOfStoreEvent),
                name: Notification.Name("user_UpdateNumberOfStoreEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_UpdateSlugOfStoreEvent),
                name: Notification.Name("user_UpdateSlugOfStoreEvent"),
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
            
            let realm = try! Realm()
            try! realm.write({
                realm.delete(realm.objects(MyStore.self))
                realm.add(dataManager.arrayAllMyStores)
            })
            
            self.dataRows = [MyStore]()
            self.arrayMyStoreIDs = [Int]()
            self.arrayMyStoreNames = [String]()
            self.boolIsNotPremiumStoreAvailableInList = false
            for obj in realm.objects(MyStore.self)
            {
                if (Int(obj.strType) ?? 0 == 0)
                {
                    self.boolIsNotPremiumStoreAvailableInList = true
                }
                self.dataRows.append(obj)
                self.arrayMyStoreIDs.append(Int(obj.strID) ?? 0)
                self.arrayMyStoreNames.append(obj.strName)
            }
            
            if (self.arrayMyStoreIDs.count > 0)
            {
                if (UserDefaults.standard.value(forKey: "selected_store_id") != nil)
                {
                    for index in 0...(self.arrayMyStoreIDs.count - 1)
                    {
                        if ("\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")" == "\(self.arrayMyStoreIDs[index])")
                        {
                            UserDefaults.standard.setValue(self.dataRows[index].strSlug, forKey: "selected_store_slug")
                            UserDefaults.standard.setValue(self.dataRows[index].strIsStoreVisible, forKey: "selected_store_visible")
                            UserDefaults.standard.synchronize()
                            self.lblStoreName?.text = self.dataRows[index].strName
                            self.lblStoreNumber?.text = self.dataRows[index].strPhoneNumber
                            self.objSelectedStore = self.dataRows[index]
                            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                            let underlineAttributedString = NSAttributedString(string: "\(ServerIPForWebsite)\(self.objSelectedStore.strSlug)", attributes: underlineAttribute)
                            self.lblStoreURL.attributedText = underlineAttributedString
                            if (self.objSelectedStore.strIsStoreVisible == "1")
                            {
                                self.btnSetVisibleContainer?.isHidden = true
                                self.btnViewStoreContainer?.isHidden = false
                                self.btnViewRatingsContainer?.isHidden = true
                                
                                if (self.objSelectedStore.strType == "0")
                                {
                                    self.lblPremium?.isHidden = true
                                    self.btnPremiumContainer?.isHidden = false
                                    
                                }
                                else
                                {
                                    self.lblPremium?.isHidden = false
                                    self.btnPremiumContainer?.isHidden = true
                                }
                                
                                if (self.objSelectedStore.strTaxIdStatus == "1")
                                {
                                    self.imageViewUsVerified?.isHidden = true//false
                                    self.btnVerifyContainer?.isHidden = true
                                }
                                else
                                {
                                    self.imageViewUsVerified?.isHidden = true
                                    self.btnVerifyContainer?.isHidden = false
                                }
                            }
                            else
                            {
                                self.btnSetVisibleContainer?.isHidden = false
                                self.btnViewStoreContainer?.isHidden = true
                                self.lblPremium?.isHidden = true
                                self.btnPremiumContainer?.isHidden = true
                                self.btnViewRatingsContainer?.isHidden = true
                                self.btnVerifyContainer?.isHidden = true
                            }
                        }
                    }
                }
                else
                {
                    self.lblStoreName?.text = self.dataRows[0].strName
                    self.lblStoreNumber?.text = self.dataRows[0].strPhoneNumber
                    self.objSelectedStore = self.dataRows[0]
                    let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
                    let underlineAttributedString = NSAttributedString(string: "\(ServerIPForWebsite)\(self.objSelectedStore.strSlug)", attributes: underlineAttribute)
                    self.lblStoreURL.attributedText = underlineAttributedString
                    if (self.objSelectedStore.strIsStoreVisible == "1")
                    {
                        self.btnSetVisibleContainer?.isHidden = true
                        self.btnViewStoreContainer?.isHidden = false
                        self.btnViewRatingsContainer?.isHidden = true
                        
                        if (self.objSelectedStore.strType == "0")
                        {
                            self.lblPremium?.isHidden = true
                            self.btnPremiumContainer?.isHidden = false
                            
                        }
                        else
                        {
                            self.lblPremium?.isHidden = false
                            self.btnPremiumContainer?.isHidden = true
                        }
                        
                        if (self.objSelectedStore.strTaxIdStatus == "1")
                        {
                            self.imageViewUsVerified?.isHidden = true//false
                            self.btnVerifyContainer?.isHidden = true
                        }
                        else
                        {
                            self.imageViewUsVerified?.isHidden = true
                            self.btnVerifyContainer?.isHidden = false
                        }
                    }
                    else
                    {
                        self.btnSetVisibleContainer?.isHidden = false
                        self.btnViewStoreContainer?.isHidden = true
                        self.lblPremium?.isHidden = true
                        self.btnPremiumContainer?.isHidden = true
                        self.btnViewRatingsContainer?.isHidden = true
                        self.btnVerifyContainer?.isHidden = true
                    }
                    
                    UserDefaults.standard.setValue(self.dataRows[0].strID, forKey: "selected_store_id")
                    UserDefaults.standard.setValue(self.dataRows[0].strName, forKey: "selected_store_name")
                    UserDefaults.standard.setValue(self.dataRows[0].strSlug, forKey: "selected_store_slug")
                    UserDefaults.standard.setValue(self.dataRows[0].strIsStoreVisible, forKey: "selected_store_visible")
                    UserDefaults.standard.synchronize()
                }
            }
        })
    }
    
    @objc func user_UpdateNameOfStoreEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let realm = try! Realm()
            try! realm.write({
                self.objSelectedStore.strName = dataManager.strStoreName
                self.objSelectedStore.strPhoneNumber = dataManager.strStoreNumber
                self.objSelectedStore.strSlug = dataManager.strStoreSlug
            })
            
            
            self.lblStoreName?.text = self.objSelectedStore.strName
            self.lblStoreNumber?.text = self.objSelectedStore.strPhoneNumber
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let underlineAttributedString = NSAttributedString(string: "\(ServerIPForWebsite)\(self.objSelectedStore.strSlug)", attributes: underlineAttribute)
            self.lblStoreURL.attributedText = underlineAttributedString
            
            self.editNamePopupContainerView?.removeFromSuperview()
            
            self.appDelegate?.showAlertViewWithTitle(title: "Success", detail: "Store name updated successfully")
            
        })
    }
    
    @objc func user_UpdateNumberOfStoreEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let realm = try! Realm()
            try! realm.write({
                self.objSelectedStore.strName = dataManager.strStoreName
                self.objSelectedStore.strPhoneNumber = dataManager.strStoreNumber
                self.objSelectedStore.strSlug = dataManager.strStoreSlug
            })
            
            self.lblStoreName?.text = self.objSelectedStore.strName
            self.lblStoreNumber?.text = self.objSelectedStore.strPhoneNumber
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let underlineAttributedString = NSAttributedString(string: "\(ServerIPForWebsite)\(self.objSelectedStore.strSlug)", attributes: underlineAttribute)
            self.lblStoreURL.attributedText = underlineAttributedString
            
            self.editNumberPopupContainerView?.removeFromSuperview()
            
            self.appDelegate?.showAlertViewWithTitle(title: "Success", detail: "Store number updated successfully")
        })
    }
    
    @objc func user_UpdateSlugOfStoreEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let realm = try! Realm()
            try! realm.write({
                self.objSelectedStore.strName = dataManager.strStoreName
                self.objSelectedStore.strPhoneNumber = dataManager.strStoreNumber
                self.objSelectedStore.strSlug = dataManager.strStoreSlug
            })
            
            self.lblStoreName?.text = self.objSelectedStore.strName
            self.lblStoreNumber?.text = self.objSelectedStore.strPhoneNumber
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let underlineAttributedString = NSAttributedString(string: "\(ServerIPForWebsite)\(self.objSelectedStore.strSlug)", attributes: underlineAttribute)
            self.lblStoreURL.attributedText = underlineAttributedString
            
            self.editSlugPopupContainerView?.removeFromSuperview()
            
            self.appDelegate?.showAlertViewWithTitle(title: "Success", detail: "Store slug updated successfully")
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        editNamePopupContainerView?.frame.size = self.view.frame.size
        editNumberPopupContainerView?.frame.size = self.view.frame.size
        editSlugPopupContainerView?.frame.size = self.view.frame.size
        
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = "Meu Perfil"//NSLocalizedString("menu_manage_stores", value:"Cadastrar meu negócio", comment: "")
        
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        if( boolIsOpenFromPurchaseController)
        {
            self.view.endEditing(true)
            appDelegate?.setTabBarVC()
        }
        else if(boolIsLoadedFromPasswordScreen)
        {
            self.view.endEditing(true)
            appDelegate?.setTabBarVC()
        }
        else
        {
            self.navigationController?.popViewController(animated: false)
        }
        
        
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        masterContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
//        txtStore.isSearchEnable = false
              
        showStoreContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        showStoreContainerView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        showStoreContainerView.addGestureRecognizer(tap)
        
        btnShowOnWeb.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnShowOnWeb.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnShowOnWeb.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnShowOnWeb.clipsToBounds = true
        btnShowOnWeb.layer.cornerRadius = 5
        
        btnShowOnApp.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnShowOnApp.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnShowOnApp.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnShowOnApp.clipsToBounds = true
        btnShowOnApp.layer.cornerRadius = 5
        
        //POPUP
        editNamePopupContainerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        txtEditName?.delegate = self
        
        btnSaveEditName?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSaveEditName?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSaveEditName?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSaveEditName?.clipsToBounds = true
        btnSaveEditName?.layer.cornerRadius = 5
        
        editNumberPopupContainerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        txtEditNumber?.delegate = self
        txtEditNumber?.keyboardType = .numberPad
        
        btnSaveEditNumber?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSaveEditNumber?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSaveEditNumber?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSaveEditNumber?.clipsToBounds = true
        btnSaveEditNumber?.layer.cornerRadius = 5
        
        editSlugPopupContainerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        txtEditSlug?.delegate = self
        txtEditSlug?.addTarget(self, action: #selector(self.txtEditSlugTextDidChange(_:)), for: .editingChanged)
        
        btnSaveEditSlug?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSaveEditSlug?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSaveEditSlug?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSaveEditSlug?.clipsToBounds = true
        btnSaveEditSlug?.layer.cornerRadius = 5
        
        //API CALL
        dataManager.user_GetAllCategories()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        showStoreContainerView.removeFromSuperview()
    }
    
    @IBAction func btnAddStoreClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController: User_AddStoreViewController = User_AddStoreViewController()
        viewController.objMyStore = MyStore()
        viewController.boolIsOpenForEdit = false
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func btnSubscriptionClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController: User_PurchasePremiumViewController = User_PurchasePremiumViewController()
        viewController.boolIsOpendFromAddStore = false
        self.navigationController?.pushViewController(viewController, animated: false)
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
    
    // MARK: - EDIT NAME NUMBER SLUG Methods
    
    @IBAction func btnEditStoreNameClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        txtEditName?.text = lblStoreName?.text
        self.view.addSubview(editNamePopupContainerView!)
    }
        
    @IBAction func btnCloseEditNameClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        editNamePopupContainerView?.removeFromSuperview()
    }
    
    @IBAction func btnSaveEditNameClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (txtEditName?.text?.isEmpty == true)
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter name")
        }
        else
        {
            //API CALL
            dataManager.user_UpdateNameNumberOfStore(strStoreName: (txtEditName?.text)!, strStoreNumber: "")
        }
    }
    
    @IBAction func btnEditStoreNumberClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        txtEditNumber?.text = lblStoreNumber?.text
        self.view.addSubview(editNumberPopupContainerView!)
    }
    
    @IBAction func btnCloseEditNumberClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        editNumberPopupContainerView?.removeFromSuperview()
    }
    
    @IBAction func btnSaveEditNumberClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (txtEditNumber?.text?.isEmpty == true)
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter number")
        }
        else
        {
            //API CALL
            dataManager.user_UpdateNameNumberOfStore(strStoreName: "", strStoreNumber: (txtEditNumber?.text)!)
        }
    }
    
    @objc func txtEditSlugTextDidChange(_ textField: UITextField) {

        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "\(ServerIPForWebsite)\(self.txtEditSlug?.text ?? "")", attributes: underlineAttribute)
        self.lblEditedSlug?.attributedText = underlineAttributedString
        
    }
    
    @IBAction func btnEditStoreSlugClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        txtEditSlug?.text = ""
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "\(ServerIPForWebsite)\(self.txtEditSlug?.text ?? "")", attributes: underlineAttribute)
        self.lblEditedSlug?.attributedText = underlineAttributedString
        self.view.addSubview(editSlugPopupContainerView!)
    }
    
    @IBAction func btnCloseEditSlugClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        editSlugPopupContainerView?.removeFromSuperview()
    }
    
    @IBAction func btnSaveEditSlugClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (txtEditSlug?.text?.isEmpty == true)
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter slug")
        }
        else
        {
            //API CALL
            dataManager.user_UpdateSlugOfStore(strStoreSlug: (txtEditSlug?.text)!)
        }
    }
    
    // MARK: - Other Methods
    
    @IBAction func btnSetVisibleClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController: RegisterStoreVC = RegisterStoreVC()
        viewController.objSelectedStore = self.objSelectedStore
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnEditClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (Int(objSelectedStore.strIsEditUnderApproval) ?? 0 > 0)
        {
            appDelegate?.showAlertViewWithTitle(title: NSLocalizedString("activity_manage_store_already_approval_title", value:"Aguardando aprovação da solicitação anterior", comment: ""), detail: NSLocalizedString("activity_manage_store_already_approval_description", value:"Você poderá fazer novas modificações assim que a sua alteração anterior for aprovada", comment: ""))
        }
//        else if (Int(objSelectedStore.strStatus) ?? 0 == 0)
//        {
//            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("activity_manage_store_add_approval_description", value:"Negócio aguardando aprovação dos administradores", comment: ""))
//        }
        else
        {
            //EDIT STORE
            let viewController: User_AddStoreViewController = User_AddStoreViewController()
            viewController.objMyStore = objSelectedStore
            
            if (viewController.objMyStore.strImages != "")
            {
                viewController.objMyStore.arrayStoreImages = viewController.objMyStore.strImages.components(separatedBy: ",")
            }
            
            //TIMINGS
            if (viewController.objMyStore.strStoreTime != "")
            {
                let arrayStoreTimingsTemp = viewController.objMyStore.strStoreTime.components(separatedBy: ",")
                viewController.objMyStore.arrayStoreTimings = [String]()
                viewController.objMyStore.arrayStoreTimingsFormated = [String]()
                for strTiming in arrayStoreTimingsTemp
                {
                    viewController.objMyStore.arrayStoreTimings.append(strTiming)
                    let arrayTimingTemp = strTiming.components(separatedBy: "#")
                    
                    if (arrayTimingTemp.count == 3)
                    {
                        let strFinalTime: String = "\(objCommonUtility.arrayWeakDays[Int(arrayTimingTemp[0]) ?? 0]) das \(arrayTimingTemp[1]) até \(arrayTimingTemp[2])"
                        
                        viewController.objMyStore.arrayStoreTimingsFormated.append(strFinalTime)
                    }
                    else
                    {
                        viewController.objMyStore.arrayStoreTimingsFormated.append(strTiming)
                    }
                }
            }
            
            viewController.boolIsOpenForEdit = true
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @IBAction func btnReportsClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (Int(objSelectedStore.strType) ?? 0 == 0)
        {
            //NOT PREMIUM
            self.showReportsAlert(strStoreID: objSelectedStore.strID, strStoreName: objSelectedStore.strName)
        }
        else
        {
            //PREMIUM
            //REPORTS
            let viewController: User_MyStoreReportsViewController = User_MyStoreReportsViewController()
            viewController.objMyStore = objSelectedStore
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @IBAction func btnWebsiteClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (Int(objSelectedStore.strStatus) ?? 0 == 0)
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("activity_manage_store_add_approval_description", value:"Negócio aguardando aprovação dos administradores", comment: ""))
        }
        else
        {
            self.view.addSubview(showStoreContainerView)
        }
    }
    
    @IBAction func btnShowStoreProductsClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController: MyStoreProductListVC = MyStoreProductListVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnShowOnWebClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        showStoreContainerView.removeFromSuperview()
        
        //WEBSITE
        let strWebsiteURL = ServerIPForWebsite + objSelectedStore.strSlug
        guard let url = URL(string: strWebsiteURL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnShowOnAppClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        showStoreContainerView.removeFromSuperview()
        
        let viewController: User_StoreDetailsViewController = User_StoreDetailsViewController()
        viewController.strSelectedStoreID = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func btnVerifyClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if self.objSelectedStore.strTaxIdStatus == "0" || self.objSelectedStore.strTaxIdStatus == "2"
        {
            let viewController: VerifyStoreVC = VerifyStoreVC()
            viewController.objSelectedStore = self.objSelectedStore
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            self.appDelegate?.showAlertViewWithTitle(title: "", detail: "CPF/CNPJ  já enviado e aguardando aprovação")
        }
    }
    
    @IBAction func btnSupportClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let viewController: User_ContactAdminViewController = User_ContactAdminViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showPromotionAlert(strStoreID: String, strStoreName: String)
    {
        //show Rating alert
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = ""
        alertViewController.message = NSLocalizedString("promotion_alert_message", value:"Somente cadastros Premium podem cadastrar promoções. Deseja ativar o plano Premium?", comment: "")
        
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
        let cancelAction = NYAlertAction(
            title: "Não",
            style: .cancel,
            handler: { (action: NYAlertAction!) -> Void in
                
                self.navigationController!.dismiss(animated: true, completion: nil)
        })
        
        // Add alert actions
        let okAction = NYAlertAction(
            title: "Sim",
            style: .default,
            handler: { (action: NYAlertAction!) -> Void in
                
                self.navigationController!.dismiss(animated: true, completion: nil)
                
                let viewController: User_PurchasePremiumViewController = User_PurchasePremiumViewController()
                viewController.boolIsOpendFromAddStore = false
                viewController.intSelectedStoreID = Int(strStoreID)
                viewController.strSelectedStoreName = strStoreName
                self.navigationController?.pushViewController(viewController, animated: false)
                
        })
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(okAction)
        
        self.navigationController!.present(alertViewController, animated: true, completion: nil)
    }
    
    func showReportsAlert(strStoreID: String, strStoreName: String)
    {
        //show Rating alert
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = ""
        alertViewController.message = NSLocalizedString("reports_alert_message", value:"Somente cadastros Premium podem ver o relatório de cliques. Deseja ativar o plano Premium?", comment: "")
        
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
        let cancelAction = NYAlertAction(
            title: "Não",
            style: .cancel,
            handler: { (action: NYAlertAction!) -> Void in
                
                self.navigationController!.dismiss(animated: true, completion: nil)
        })
        
        // Add alert actions
        let okAction = NYAlertAction(
            title: "Sim",
            style: .default,
            handler: { (action: NYAlertAction!) -> Void in
                
                self.navigationController!.dismiss(animated: true, completion: nil)
                
                let viewController: User_PurchasePremiumViewController = User_PurchasePremiumViewController()
                viewController.boolIsOpendFromAddStore = false
                viewController.intSelectedStoreID = Int(strStoreID)
                viewController.strSelectedStoreName = strStoreName
                self.navigationController?.pushViewController(viewController, animated: false)
                
        })
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(okAction)
        
        self.navigationController!.present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnShareClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let originalString = "https://wa.me/?text=Olá! Convido você a deixar uma avaliação do meu negócio (leva 10 segundos) no link abaixo:\n\(ServerIPForWebsite)\(self.objSelectedStore.strSlug)\nMuito obrigado!"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        guard let url = URL(string: escapedString!) else {
          return //be safe
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    //OPRIONS
    @IBAction func btnURLCopyTapped(_ sender: UIButton)
    {
        UIPasteboard.general.string = self.lblStoreURL.text
        AppDelegate.showToast(message : NSLocalizedString("Copy_to_ClipBoard", value:"Link copiado", comment: ""), font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
    }
    
    @IBAction func btnURLShareTapped(_ sender: UIButton)
    {
        let originalString = "https://wa.me/?text=\(self.lblStoreURL.text ?? "")"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: escapedString!) else {
          return //be safe
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

