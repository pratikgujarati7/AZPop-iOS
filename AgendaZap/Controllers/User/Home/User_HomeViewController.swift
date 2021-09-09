//
//  User_HomeViewController.swift
//  AgendaZap
//
//  Created by Dipen on 10/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift
import iOSDropDown
import SDWebImage
import CoreLocation
import NYAlertViewController
import FirebaseCrashlytics

class User_HomeViewController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate
{
    
    //MARK:- Outlets
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var navigationBarView: UIView!
    @IBOutlet var btnCreateStoreContainerView: UIViewX!
    @IBOutlet var btnCreateStore: UIButton!
            
    @IBOutlet var searchViewContainer: UIView!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var lblSelectedCity: UILabel!
    @IBOutlet var btnFreeDeliveryStoresContainerView: UIView!
    @IBOutlet var btnFreeDeliveryStores: UIButton!
    //TableView
    @IBOutlet var tblHeaderContainerView: UIView!
    @IBOutlet var scrollViewBanner: UIScrollView!
    @IBOutlet var imageViewBanner1: UIImageView!
    @IBOutlet var btnBanner1: UIButton!
    @IBOutlet var imageViewBanner2: UIImageView!
    @IBOutlet var btnBanner2: UIButton!
    @IBOutlet var imageViewBanner3: UIImageView!
    @IBOutlet var btnBanner3: UIButton!
    @IBOutlet var tblCategories: UITableView! {
        didSet {
            self.tblCategories.register(UINib(nibName: "CategoryTVCell", bundle: nil), forCellReuseIdentifier: "CategoryTVCell")
        }
    }
    @IBOutlet var btnNumberPad: UIButton!
    
    //MARK:- Variables
    var locManager = CLLocationManager()
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var intSelectedCategoryID: Int?
    var strSelectedCategoryName: String?
    var arrayStorePromotionsLocal = [ObjStorePromotion]()
    
    var strCityString = ""
    var strCityRange = ""
    
    //To Store Collection views' offsets
    var storedOffsets = [Int: CGFloat]()
    
    let bannerImage1 = UIImage(named: "home_banner.png")
    let bannerImage2 = UIImage(named: "home_banner_1.png")
    let bannerImage3 = UIImage(named: "home_banner_2.png")
    var timer = Timer()
    var counter = 0
    
    //MARK:- UIViewController Delegate Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        let intLastBannerIndex: Int  = Int("\(UserDefaults.standard.value(forKey: "last_banner_index") ?? "0")") ?? 0
        if intLastBannerIndex == 0
        {
            imageViewBanner1.image = bannerImage2
            imageViewBanner2.image = bannerImage3
            imageViewBanner3.image = bannerImage1
            UserDefaults.standard.setValue("1", forKey: "last_banner_index")
        }
        else if intLastBannerIndex == 1
        {
            imageViewBanner1.image = bannerImage3
            imageViewBanner2.image = bannerImage1
            imageViewBanner3.image = bannerImage2
            UserDefaults.standard.setValue("2", forKey: "last_banner_index")
        }
        else
        {
            imageViewBanner1.image = bannerImage1
            imageViewBanner2.image = bannerImage2
            imageViewBanner3.image = bannerImage3
            UserDefaults.standard.setValue("0", forKey: "last_banner_index")
        }
        
        let intHashedUserID: Int  = Int("\(UserDefaults.standard.value(forKey: "hashed_user_id") ?? "0")") ?? 0
        
        if (intHashedUserID == 0)
        {
            let intHashedUserID: Int  = ((Int("\(UserDefaults.standard.value(forKey: "user_id") ?? "0")") ?? 0) * 97131) % 100000
            
            UserDefaults.standard.setValue("\(intHashedUserID)", forKey: "hashed_user_id")
            UserDefaults.standard.synchronize()
        }
        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways) {
            locManager.startUpdatingLocation()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnFreeDeliveryStoresContainerView.isHidden = dataManager.boolIsHideFreeDelivery
        
        
        self.setupNotificationEvent()
        
        let intCount: Int  = Int("\(UserDefaults.standard.value(forKey: "home_counter") ?? "0")") ?? 0
        
        if (intCount < 43)
        {
            UserDefaults.standard.setValue("\(intCount + 1)", forKey: "home_counter")
            UserDefaults.standard.synchronize()
        }
        else
        {
            UserDefaults.standard.setValue("0", forKey: "home_counter")
            UserDefaults.standard.synchronize()
            
            if ("\(UserDefaults.standard.value(forKey: "is_user_rated_app") ?? "")" != "1") && ("\(UserDefaults.standard.value(forKey: "is_user_shared_app") ?? "")" != "1") && ("\(UserDefaults.standard.value(forKey: "is_user_updated_user_details") ?? "")" != "1")
            {
//                let strAlertToggle: String = "\(UserDefaults.standard.value(forKey: "alert_toggle") ?? "")"
//                print("strAlertToggle:\(strAlertToggle)")
                
                if ("\(UserDefaults.standard.value(forKey: "alert_toggle") ?? "")" == "0")
                {
                    UserDefaults.standard.setValue("1", forKey: "alert_toggle")
                    UserDefaults.standard.synchronize()
                    
                    self.showReviewAlert()
                }
                else if ("\(UserDefaults.standard.value(forKey: "alert_toggle") ?? "")" == "1")
                {
                    UserDefaults.standard.setValue("2", forKey: "alert_toggle")
                    UserDefaults.standard.synchronize()
                    
                    self.showShareAlert()
                }
//                else if ("\(UserDefaults.standard.value(forKey: "alert_toggle") ?? "")" == "2")
                else
                {
                    UserDefaults.standard.setValue("0", forKey: "alert_toggle")
                    UserDefaults.standard.synchronize()
                    
                    //self.showUpdateUserDetailsAlert()
                }
            }
            else if ("\(UserDefaults.standard.value(forKey: "is_user_rated_app") ?? "")" != "1") || ("\(UserDefaults.standard.value(forKey: "is_user_shared_app") ?? "")" != "1")  || ("\(UserDefaults.standard.value(forKey: "is_user_updated_user_details") ?? "")" != "1")
            {
                if ("\(UserDefaults.standard.value(forKey: "is_user_rated_app") ?? "")" != "1")
                {
                    self.showReviewAlert()
                }
                else if ("\(UserDefaults.standard.value(forKey: "is_user_shared_app") ?? "")" != "1")
                {
                    self.showShareAlert()
                }
                else if ("\(UserDefaults.standard.value(forKey: "is_user_updated_user_details") ?? "")" != "1")
                {
                    self.showUpdateUserDetailsAlert()
                }
            }
        }
        
        //City String Configurations
        self.setCityString()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //API CALL
        dataManager.user_GetAllMyStores()
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
        
        searchViewContainer?.layer.masksToBounds = false
        searchViewContainer?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        searchViewContainer?.layer.shadowPath = UIBezierPath(roundedRect: searchViewContainer!.bounds, cornerRadius: (searchViewContainer?.layer.cornerRadius)!).cgPath
        searchViewContainer?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        searchViewContainer?.layer.shadowOpacity = 0.5
        searchViewContainer?.layer.shadowRadius = 1.0
        
    }
    
    override func viewDidLayoutSubviews() {
        //self.searchViewContainer.layer.cornerRadius = 15.0
        self.tblCategories.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeNotificationEventObserver()
        
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Setup Notification Methods
    
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
            
//            let realm = try! Realm()
//            try! realm.write({
//                realm.delete(realm.objects(MyStore.self))
//                realm.add(dataManager.arrayAllMyStores)
//            })
            
            if (dataManager.arrayAllMyStores.count > 0)
            {
                if (UserDefaults.standard.value(forKey: "selected_store_id") == nil)
                {
                    UserDefaults.standard.setValue(dataManager.arrayAllMyStores[0].strID, forKey: "selected_store_id")
                    UserDefaults.standard.setValue(dataManager.arrayAllMyStores[0].strName, forKey: "selected_store_name")
                    UserDefaults.standard.setValue(dataManager.arrayAllMyStores[0].strSlug, forKey: "selected_store_slug")
                    UserDefaults.standard.setValue(dataManager.arrayAllMyStores[0].strIsStoreVisible, forKey: "selected_store_visible")
                    UserDefaults.standard.synchronize()
                    
                    if (dataManager.arrayAllMyStores[0].strIsStoreVisible == "1")
                    {
                        self.btnCreateStoreContainerView.isHidden = true
                    }
                    else
                    {
                        self.btnCreateStoreContainerView.isHidden = false
                    }
                }
                else
                {
                    if ("\(UserDefaults.standard.value(forKey: "selected_store_visible") ?? "0")" == "1")
                    {
                        self.btnCreateStoreContainerView.isHidden = true
                    }
                    else
                    {
                        self.btnCreateStoreContainerView.isHidden = false
                    }
                }
            }
            else
            {
                UserDefaults.standard.removeObject(forKey: "selected_store_id")
                UserDefaults.standard.removeObject(forKey: "selected_store_name")
                UserDefaults.standard.removeObject(forKey: "selected_store_slug")
                UserDefaults.standard.removeObject(forKey: "selected_store_visible")
                UserDefaults.standard.synchronize()
                self.btnCreateStoreContainerView.isHidden = false
            }
        })
    }
    
    //MARK:- Layout Subviews Methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
    }
    
    @IBAction func btnCreateStoreClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (dataManager.arrayAllMyStores.count > 0)
        {
            let viewController: RegisterStoreVC = RegisterStoreVC()
            viewController.objSelectedStore = dataManager.arrayAllMyStores[0]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func btnFreeDeliveryStoresClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController: User_StoreListFreeDeliveryVC = User_StoreListFreeDeliveryVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK:- Setting Initial Views Methods
    func setupInitialView()
    {
        /*
        masterContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundLightGreenColor
        mainScrollView?.delegate = self
        mainScrollView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundLightGreenColor
        scrollContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundLightGreenColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundLightGreenColor
        */
        
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        searchViewContainer?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        searchViewContainer?.layer.cornerRadius = 15.0
        
        txtSearch?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtSearch?.delegate = self
        txtSearch?.backgroundColor = .clear
        txtSearch?.tintColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtSearch?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("search_here", value: "Digite o que está buscando", comment: ""),
                                                                attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        
        
        //txtSelectCity?.placeholder = NSLocalizedString("select_city_title", value: "Choose City:", comment: "")
        txtSearch?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtSearch?.textAlignment = .left
        txtSearch?.autocorrectionType = UITextAutocorrectionType.no
        txtSearch?.clearButtonMode = .whileEditing
        txtSearch?.returnKeyType = .search
        
        //btnSearch?.addTarget(self, action: #selector(self.btnSearchClicked(_:)), for: .touchUpInside)
        
        btnFreeDeliveryStores.clipsToBounds = true
        btnFreeDeliveryStores.layer.cornerRadius = 10
        
        /*
        //City String Configurations
        self.setCityString()
        */
        
        scrollViewBanner.delegate = self
        scrollViewBanner.isPagingEnabled = true
        DispatchQueue.main.async {
              self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
           }
    }
    
    @objc func changeImage()
    {
        if counter == 2
        {
            self.scrollViewBanner.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            counter = 0
        }
        else
        {
            counter += 1
            self.scrollViewBanner.setContentOffset(CGPoint(x: (self.scrollViewBanner.frame.size.width * CGFloat(counter)), y: 0), animated: true)
        }
    }
    
    @IBAction func btnSearchClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if ((txtSearch?.text!.count)! <= 0)
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("error_required", value:"Campo obrigatório!", comment: ""))
        }
        else
        {
            let viewController: User_StoreListViewController = User_StoreListViewController()
            viewController.strScreenID = "1"
            viewController.boolIsOpenedFromSearch = true
            viewController.strSearchText = txtSearch?.text
            viewController.objSelectedCategory = ObjCategory()
            viewController.objSelectedSubCategory = ObjSubCategory()
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @IBAction func btnTblHeaderImageClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let intLastBannerIndex: Int  = Int("\(UserDefaults.standard.value(forKey: "last_banner_index") ?? "0")") ?? 0
        if intLastBannerIndex == 0
        {
            if sender == btnBanner1      { navigateToPromocodes() }
            else if sender == btnBanner2 { navigateToPlanPremium() }
            else                         { navigateToBoostOnGoogleInstagram() }
        }
        else if intLastBannerIndex == 1
        {
            if sender == btnBanner1      { navigateToPlanPremium() }
            else if sender == btnBanner2 { navigateToBoostOnGoogleInstagram() }
            else                         { navigateToPromocodes() }
        }
        else
        {
            if sender == btnBanner1      { navigateToBoostOnGoogleInstagram() }
            else if sender == btnBanner2 { navigateToPromocodes() }
            else                         { navigateToPlanPremium() }
        }
    }
    
    func navigateToPromocodes()
    {
        appDelegate?.openTabBarVCScreenPromotions()
    }
    
    func navigateToPlanPremium()
    {
        if (dataManager.arrayAllMyStores.count > 0)
        {
            if (UserDefaults.standard.value(forKey: "selected_store_id") == nil)
            {
                let objStore = dataManager.arrayAllMyStores[0]
                if objStore.strIsStoreVisible == "1" && objStore.strType == "0"
                {
                    navigateToPurchaseScreen(objMyStore: objStore)
                }
            }
            else
            {
                let strSelectedStoreID = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
                let attayNormal = dataManager.arrayAllMyStores
                let arrayFilter = dataManager.arrayAllMyStores.filter({$0.strID == strSelectedStoreID})
                if let objStore = arrayFilter.first
                {
                    if objStore.strIsStoreVisible == "1" && objStore.strType == "0"
                    {
                        navigateToPurchaseScreen(objMyStore: objStore)
                    }
                }
                else
                {
                    let objStore = dataManager.arrayAllMyStores[0]
                    if objStore.strIsStoreVisible == "1" && objStore.strType == "0"
                    {
                        navigateToPurchaseScreen(objMyStore: objStore)
                    }
                    
                    UserDefaults.standard.setValue(objStore.strID, forKey: "selected_store_id")
                    UserDefaults.standard.setValue(objStore.strName, forKey: "selected_store_name")
                    UserDefaults.standard.setValue(objStore.strSlug, forKey: "selected_store_slug")
                    UserDefaults.standard.setValue(objStore.strIsStoreVisible, forKey: "selected_store_visible")
                    UserDefaults.standard.synchronize()
                }
            }
        }
        else
        {
            //no stores
        }
    }
    
    func navigateToPurchaseScreen(objMyStore: MyStore)
    {
        let viewController: User_PurchasePremiumViewController = User_PurchasePremiumViewController()
        viewController.boolIsOpendFromAddStore = false
        viewController.intSelectedStoreID = Int(objMyStore.strID)
        viewController.strSelectedStoreName = objMyStore.strName
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func navigateToBoostOnGoogleInstagram()
    {
        let viewController: BoostViewController = BoostViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK:- IBActions
    /*
    @IBAction func btnCreateTapped(_ sender: Any) {

        let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
        let strPassword: String = "\(UserDefaults.standard.value(forKey: "password") ?? "")"
        if(strIsAuthorized != "1")
        {
            //NOT AUTHORIZED
            if(strPassword != "" && strPassword.count > 0)
            {
                let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
                viewController.boolIsLoadedFromSplashScreen = false
                viewController.boolIsNoWayBack = false
                self.navigationController?.pushViewController(viewController, animated: false)
            }
            else
            {
                let viewController: User_RegisterUsingPasswordViewController = User_RegisterUsingPasswordViewController()
                viewController.boolIsLoadedFromSplashScreen = false
                viewController.boolIsNoWayBack = false
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
        else
        {
            let viewController: User_AddStoreViewController = User_AddStoreViewController()
            viewController.objMyStore = MyStore()
            viewController.boolIsOpenForEdit = false
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        
    }
    
    
    @IBAction func btnModeTapped(_ sender: Any) {
        
        let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
        if(strIsAuthorized != "1")
        {
            let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
            viewController.boolIsLoadedFromSplashScreen = true
            viewController.boolIsLoadedForVendorMode = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            UserDefaults.standard.setValue("1", forKey: "is_show_vendor_mode")
            UserDefaults.standard.synchronize()
//            AppDelegate().Delegate().setVendorTabBarVC()
        }
    }
    */
    
    @IBAction func btnNumberPadTapped(_ sender: Any) {
        //ContactlessZap
        let viewController: User_ContactlessZapViewController = User_ContactlessZapViewController()
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        dataManager.user_UpdateStoreClicks(strStoreID: arrayStorePromotionsLocal[sender.tag].strID, strScreenID: "6")
        
        if (arrayStorePromotionsLocal[sender.tag].strPhoneNumber != "")
        {
            let originalString = "https://wa.me/55\(arrayStorePromotionsLocal[sender.tag].strPhoneNumber)?text=Quero a promoção AgendaZap. Meu código: \(objCommonUtility.fourDigitNumber) &source=&data="
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            print(escapedString)
            
            guard let url = URL(string: escapedString!) else {
              return //be safe
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //MARK:- Functions
    func setCityString() {
        
        let strCountString = String(format:NSLocalizedString("negocios_cadastrados_em_lndaiatuba", value:"%@ negócios cadastrados em %@", comment: ""), dataManager.strStoreCountsInCity, "\(UserDefaults.standard.value(forKey: "city_name") ?? "")")
        lblSelectedCity?.text = strCountString
        
        let text = strCountString
        lblSelectedCity?.text = text
        self.strCityString = text
        self.lblSelectedCity.textColor =  UIColor.white
        
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of:  (UserDefaults.standard.value(forKey: "city_name")) as! String)
        self.strCityRange = "\(UserDefaults.standard.value(forKey: "city_name") ?? "")"
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: MySingleton.sharedManager().themeFontFourteenSizeRegular!, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range1)
        
        lblSelectedCity.attributedText = underlineAttriString
        lblSelectedCity.isUserInteractionEnabled = true
        lblSelectedCity.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
       let termsRange = (self.strCityString as NSString).range(of: self.strCityRange)
       // comment for now
       //let privacyRange = (text as NSString).range(of: "Privacy Policy")

        if gesture.didTapAttributedTextInLabel(label: self.lblSelectedCity, inRange: termsRange) {
            let viewController: User_SelectCityViewController = User_SelectCityViewController()
            viewController.backContainerView?.isHidden = false
            viewController.isFromHomeScreen = true
            self.navigationController?.pushViewController(viewController, animated: false)
       } else {
           print("Tapped none")
       }
    }
    
    func showReviewAlert()
    {
        //show Rating alert
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = ""
        alertViewController.message = NSLocalizedString("give_reviews", value:"Pelo visto está gostando do AgendaZap! Poderia nos ajudar com uma avaliação no App Store?", comment: "")
        
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
                
                UserDefaults.standard.setValue("1", forKey: "is_user_rated_app")
                UserDefaults.standard.synchronize()
                
                //OPEN URL
                guard let url = URL(string: "https://apps.apple.com/app/agendazap/id1496435175") else { return }
                UIApplication.shared.open(url)
                
        })
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(okAction)
                            
        self.navigationController!.present(alertViewController, animated: true, completion: nil)
    }
    
    func showShareAlert()
    {
        //show share app alert
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = ""
        alertViewController.message = NSLocalizedString("share_app", value:"Que tal ajudar seus amigos e recomendar o AgendaZap para eles? São só dois cliques!", comment: "")
        
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
                
                self.navigationController!.dismiss(animated: false, completion: nil)
        })
        
        // Add alert actions
        let okAction = NYAlertAction(
            title: "Sim",
            style: .default,
            handler: { (action: NYAlertAction!) -> Void in
                
                self.navigationController!.dismiss(animated: true, completion: nil)
                
                UserDefaults.standard.setValue("1", forKey: "is_user_shared_app")
                UserDefaults.standard.synchronize()
                
                //OPEN URL
                let text = "AgendaZap - App para Achar o WhatsApp de Qualquer Negócio https://apps.apple.com/app/agendazap/id1496435175"
                let textShare = [text]
                let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
        })
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(okAction)
                            
        self.navigationController!.present(alertViewController, animated: true, completion: nil)
    }
    
    func showUpdateUserDetailsAlert()
    {
        //show Rating alert
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = ""
        alertViewController.message = NSLocalizedString("update_user_details_alert_message", value:"Não se esqueça de atualizar o seu email para receber as novidades do AgendaZap!", comment: "")
        
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
            title: NSLocalizedString("no", value:"Agora não", comment: ""),
            style: .cancel,
            handler: { (action: NYAlertAction!) -> Void in
                
                self.navigationController!.dismiss(animated: true, completion: nil)
        })
        
        // Add alert actions
        let okAction = NYAlertAction(
            title: NSLocalizedString("OK!", value:"OK!", comment: ""),
            style: .default,
            handler: { (action: NYAlertAction!) -> Void in
                
                self.navigationController!.dismiss(animated: true, completion: nil)
                
                UserDefaults.standard.setValue("1", forKey: "is_user_updated_user_details")
                UserDefaults.standard.synchronize()
                
                let viewController: User_MyProfileViewController = User_MyProfileViewController()
                self.sideMenuController?.navigationController?.pushViewController(viewController, animated: false)
                
        })
        
        alertViewController.addAction(cancelAction)
        alertViewController.addAction(okAction)
                            
        self.navigationController!.present(alertViewController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if scrollView == self.scrollViewBanner
        {
            let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
            counter = Int(pageNumber)
        }
    }
    
}

//MARK:- Textfield Delegates
extension User_HomeViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField == txtSearch)
        {
            if ((txtSearch?.text!.count)! <= 0)
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("error_required", value:"Campo obrigatório!", comment: ""))
            }
            else
            {
                let viewController: User_StoreListViewController = User_StoreListViewController()
                viewController.strScreenID = "1"
                viewController.boolIsOpenedFromSearch = true
                viewController.strSearchText = txtSearch?.text
                viewController.objSelectedCategory = ObjCategory()
                viewController.objSelectedSubCategory = ObjSubCategory()
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
        
        return true
    }
    
}

//MARK:- Location Manager Delegate
extension User_HomeViewController {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (locations.count > 0) {
            dataManager.currentLocation = locations[0]
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
}

//MARK:- TableView Methods
extension User_HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return tblHeaderContainerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.arrayAllCategories.count > 0 ? dataManager.arrayAllCategories.count : 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.tblCategories {
            guard let tableViewCell = cell as? CategoryTVCell else { return }
            tableViewCell.setCollectionViewDataSourceDelegate(self, forrow: indexPath.row)
            tableViewCell.collSubCategoriesOffset = storedOffsets[indexPath.row] ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if tableView == self.tblCategories {
            //guard cell is CategoryTVCell else { return }
            guard let tableViewCell = cell as? CategoryTVCell else { return }
            storedOffsets[indexPath.row] = tableViewCell.collSubCategoriesOffset
            //0 //tableViewCell.collectionViewOffset
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let mainCatObj = dataManager.arrayAllCategories[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVCell") as! CategoryTVCell
        
        cell.lblCatName.text = mainCatObj.strCategoryName
        
        /*
         cell.collSubCategories.tag = indexPath.row
         cell.collSubCategories.dataSource = self
         cell.collSubCategories.delegate = self
         cell.collSubCategories.reloadData()
         cell.collSubCategories.contentOffset = .zero
         */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((UIScreen.main.bounds.width - 16)/3.5) + (25+40+8)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//MARK:- CollectionView Methods
extension User_HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.arrayAllCategories[collectionView.tag].arraySubCategories.count > 0 ? (dataManager.arrayAllCategories[collectionView.tag].arraySubCategories.count + 1) : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCVCell", for: indexPath) as! SubCategoryCVCell
        
        if indexPath.item == dataManager.arrayAllCategories[collectionView.tag].arraySubCategories.count {
            cell.imgSubCategory.image = UIImage(named: "right.png")
            cell.lblSubCatName.textAlignment = .center
            cell.lblSubCatName.text = "Ver todos"
        } else {
            let subCatObj = dataManager.arrayAllCategories[collectionView.tag].arraySubCategories[indexPath.item]
            cell.imgSubCategory.image = UIImage(named: "ic_sub_\(subCatObj.intSubCategoryID)")
            cell.lblSubCatName.textAlignment = .left
            cell.lblSubCatName.text = subCatObj.strSubCategoryName
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.size.width-16)/3.5), height: ((collectionView.frame.size.width-16)/3.5) + 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == dataManager.arrayAllCategories[collectionView.tag].arraySubCategories.count {
                        
            let mainCatObj = dataManager.arrayAllCategories[collectionView.tag]
            let vc = User_SubCategoryViewController()
            vc.strSelectedCategoryID = mainCatObj.strCategoryID
            vc.objSelectedCategory = mainCatObj
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            
            let mainCatObj = dataManager.arrayAllCategories[collectionView.tag]
            let subCatObj = dataManager.arrayAllCategories[collectionView.tag].arraySubCategories[indexPath.item]
            
            let viewController: User_StoreListViewController = User_StoreListViewController()
            viewController.strScreenID = "0"
            viewController.boolIsOpenedFromSearch = false
            viewController.strSearchText = ""
            viewController.objSelectedCategory = mainCatObj
            viewController.objSelectedSubCategory = subCatObj
            viewController.isFromHome = true
            self.navigationController?.pushViewController(viewController, animated: false)
            
        }
        
        /*
        let objCategory: ObjCategory = ObjCategory()
        objCategory.strCategoryID = dataManager.arrayAllCategories[indexPath.item].strCategoryID
        objCategory.strCategoryName = dataManager.arrayAllMainScreenSearch[indexPath.item].strCategoryName
        
        let objSubCategory: ObjSubCategory = ObjSubCategory()
        objSubCategory.strSubCategoryID = dataManager.arrayAllMainScreenSearch[indexPath.item].strCategoryID
        objSubCategory.strSubCategoryName = dataManager.arrayAllMainScreenSearch[indexPath.item].strCategoryName
        
        let viewController: User_StoreListViewController = User_StoreListViewController()
        viewController.strScreenID = "0"
        viewController.boolIsOpenedFromSearch = false
        viewController.strSearchText = ""
        viewController.objSelectedCategory = objCategory
        viewController.objSelectedSubCategory = objSubCategory
        self.navigationController?.pushViewController(viewController, animated: false)
        */
        
    }
    
}

//MARK:- UITapGestureRecognizer Extension
extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}
