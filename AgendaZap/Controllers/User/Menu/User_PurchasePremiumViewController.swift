//
//  User_PurchasePremiumViewController.swift
//  AgendaZap
//
//  Created by Dipen on 21/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import LGSideMenuController
import iOSDropDown
import StoreKit

class User_PurchasePremiumViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate
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
    
    @IBOutlet var detailsContainerView: UIView?
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var imageViewHorn: UIImageView?
    @IBOutlet var lblPrice: UILabel?
    
    @IBOutlet var imageViewOne: UIImageView?
    @IBOutlet var lblOne: UILabel?
    @IBOutlet var imageViewTwo: UIImageView?
    @IBOutlet var lblTwo: UILabel?
    @IBOutlet var imageViewThree: UIImageView?
    @IBOutlet var lblThree: UILabel?
    @IBOutlet var imageViewFour: UIImageView?
    @IBOutlet var lblFour: UILabel?
    
    @IBOutlet var txtSelectStoreContainerView: UIView?
    @IBOutlet var txtSelectStore: DropDown?
    
    @IBOutlet var tncAndPrivacyPolicyContainerView: UIView?
    @IBOutlet var btnTermsOfService: UIButton?
    @IBOutlet var separatorView: UIView?
    @IBOutlet var btnPrivacyPolicy: UIButton?
    
    @IBOutlet var lblAlreadyPurchase: UILabel?
    @IBOutlet var btnPurchase: UIButton?
    
    @IBOutlet var lblCanceledAtAnyTime: UILabel?
    
  
    // IN APP PURCHASE
    public static let productIdentifiers: Set<ProductIdentifier> = ["\(UserDefaults.standard.value(forKey: "sku_subscription") ?? "")"]
    public static let store = IAPHelper(productIds: User_PurchasePremiumViewController.productIdentifiers)
    
    var products: [SKProduct] = []
    var buyButtonHandler: ((_ product: SKProduct) -> Void)?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var boolIsOpendFromAddStore: Bool = false
    var boolIsCalledForPurchase: Bool = false
    
    var dataRows = [MyStore]()
    var dataRowsIDs = [Int]()
    var dataRowsNames = [String]()
    
    var intSelectedStoreID: Int?
    var strSelectedStoreName: String?
    
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
            selector: #selector(self.user_GetAllMyStoresEvent),
            name: Notification.Name("user_GetAllMyStoresEvent"),
            object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_MarkStoreAsPermiumEvent),
                name: Notification.Name("user_MarkStoreAsPermiumEvent"),
                object: nil)
                        
            NotificationCenter.default.addObserver(self, selector: #selector(User_PurchasePremiumViewController.handlePurchaseNotification(_:)),
                                                   name: .IAPHelperPurchaseNotification,
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
            
            self.dataRows = dataManager.arrayNotPremiumStores
            self.dataRowsIDs = dataManager.arrayNotPremiumStoreIDs
            self.dataRowsNames = dataManager.arrayNotPremiumStoreNames
            
            self.txtSelectStore?.isUserInteractionEnabled = true
            self.txtSelectStore?.optionArray = self.dataRowsNames
            self.txtSelectStore?.optionIds = self.dataRowsIDs
            self.txtSelectStore?.handleKeyboard = false
            self.txtSelectStore?.isSearchEnable = false
            self.txtSelectStore?.hideOptionsWhenSelect = true
            self.txtSelectStore?.checkMarkEnabled = false
            self.txtSelectStore?.selectedRowColor = (MySingleton.sharedManager().themeGlobalLightGreenColor?.withAlphaComponent(0.5))!
            
            self.txtSelectStore?.listHeight = (self.mainScrollView?.frame.size.height)! - 150
            
            self.txtSelectStore?.didSelect{(selectedText , index ,id) in
                
                self.intSelectedStoreID = id
                self.strSelectedStoreName = selectedText
            }
            
            //========== DIPEN LAD CODE ==========//
//            self.txtSelectStore?.selectedIndex = 0
//            self.intSelectedStoreID = self.dataRowsIDs[0]
//            self.strSelectedStoreName = self.dataRowsNames[0]
//            self.txtSelectStore?.text = self.strSelectedStoreName
            
//            if (self.dataRows.count) == 1
//            {
//                self.txtSelectStoreContainerView?.isHidden = true
//                self.txtSelectStoreContainerView?.heightConstaint?.constant = 0
//            }
//            else
//            {
//                self.txtSelectStoreContainerView?.isHidden = false
//            }
            //========== DIPEN LAD CODE ==========//
            
            //========== PRATIK GUJARATI CODE ==========//
            if (self.dataRows.count == 1)
            {
                self.intSelectedStoreID = self.dataRowsIDs[0]
                self.strSelectedStoreName = self.dataRowsNames[0]
                
                self.txtSelectStoreContainerView?.isHidden = true
                self.txtSelectStoreContainerView?.heightConstaint?.constant = 0
            }
            else if(self.intSelectedStoreID != nil)
            {
                let indexOfSelectedStore = self.dataRowsIDs.firstIndex(of:self.intSelectedStoreID ?? 0)
                
                self.txtSelectStore?.selectedIndex = indexOfSelectedStore
                self.txtSelectStore?.text = self.strSelectedStoreName
                
                self.txtSelectStoreContainerView?.isHidden = true
                self.txtSelectStoreContainerView?.heightConstaint?.constant = 0
            }
            else
            {
                self.intSelectedStoreID = self.dataRowsIDs[0]
                self.strSelectedStoreName = self.dataRowsNames[0]
                
                let indexOfSelectedStore = 0
                self.txtSelectStore?.text = self.strSelectedStoreName
            }
            //========== PRATIK GUJARATI CODE ==========//
            
            
            self.appDelegate!.showGlobalProgressHUDWithTitle(title: "Loading...")
            User_PurchasePremiumViewController.store.requestProducts{ [weak self] success, products in
                guard let self = self else { return }
                DispatchQueue.main.async(execute: {
                    if success
                    {
                        self.products = products!
                        self.appDelegate!.dismissGlobalHUD()
                        if (self.products.count > 0)
                        {
                            var header: String = "\(UserDefaults.standard.value(forKey: "subscription_header") ?? "")".html2String
                            
                            header = header.replacingOccurrences(of: "[price]", with: "\(self.products[0].priceLocale.currencySymbol ?? "") \(self.products[0].price)")
                            
                            if (self.dataRows.count > 0)
                            {
                                if (self.dataRows.count == 1)
                                {
                                    header = header.replacingOccurrences(of: "[name]", with: "\(self.dataRows[0].strName)")
                                }
                                else
                                {
                                    header = header.replacingOccurrences(of: "[name]", with: "seu negócio")
                                }
                            }
                            
                            self.lblPrice?.text = header
                            
                            //CHECK IF PURCHASED EARLIER
                            print(UserDefaults.standard.bool(forKey: self.products[0].productIdentifier))
                            let purchased = UserDefaults.standard.bool(forKey: self.products[0].productIdentifier)
                            if purchased
                            {
                                self.btnPurchase?.isHidden = true
                                self.lblAlreadyPurchase?.isHidden = false
                                self.lblCanceledAtAnyTime?.isHidden = true
                            }
                            else
                            {
                                self.btnPurchase?.isHidden = false
                                self.lblAlreadyPurchase?.isHidden = true
                                self.lblCanceledAtAnyTime?.isHidden = false
                            }
                        }
                    }
                    else
                    {
                        self.appDelegate!.dismissGlobalHUD()
                    }
                })
            }
        })
    }
    
    @objc func user_MarkStoreAsPermiumEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = NSLocalizedString("activity_store_details_add_reviews_success_title", value:"Success", comment: "")
            alertViewController.message = NSLocalizedString("subscription_alert_success", value:"Plano premium ativado com sucesso.", comment: "")
            
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
            
            // Add alert actions
            let okAction = NYAlertAction(
                title: "Ok",
                style: .default,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.navigationController!.dismiss(animated: true, completion: nil)
                    
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
                    
                    //self.navigationController?.popViewController(animated: false)
            })
            
            alertViewController.addAction(okAction)
                                
            self.navigationController!.present(alertViewController, animated: true, completion: nil)
            
            self.navigationController?.popViewController(animated: false)
            
        })
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        let transactionID: String = "\(notification.object ?? "")"
        
        if (boolIsCalledForPurchase)
        {
            //API CALL
            dataManager.user_MarkStoreAsPermium(strStoreID: "\(self.intSelectedStoreID ?? 0)", strProductID: self.products[0].productIdentifier, strTransactionID: transactionID, strToken: "", strProductPrice: "\(self.products[0].price)")
        }
        
        self.boolIsCalledForPurchase = false
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //MOBILE NUMBER
        txtSelectStoreContainerView?.layer.masksToBounds = false
        txtSelectStoreContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        txtSelectStoreContainerView?.layer.shadowPath = UIBezierPath(roundedRect: txtSelectStoreContainerView!.bounds, cornerRadius: (txtSelectStoreContainerView?.layer.cornerRadius)!).cgPath
        txtSelectStoreContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        txtSelectStoreContainerView?.layer.shadowOpacity = 0.5
        txtSelectStoreContainerView?.layer.shadowRadius = 1.0
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("subscription_activity_title", value:"Plano Premium", comment: "")
        
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (boolIsOpendFromAddStore)
        {
            appDelegate?.openTabBarVCScreenMyProfile()
//            let viewController: User_MyStoresListViewController = User_MyStoresListViewController()
//            viewController.boolIsOpenFromPurchaseController = true
//            self.navigationController?.pushViewController(viewController, animated: false)
        }
        else
        {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        mainScrollView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        scrollContainerView?.backgroundColor = .clear
        
        detailsContainerView?.clipsToBounds = true
        detailsContainerView?.layer.cornerRadius = 5
        detailsContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        lblTitle?.font = MySingleton.sharedManager().themeFontEighteenSizeBold
        lblTitle?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblTitle?.text = "\(UserDefaults.standard.value(forKey: "subscription_title") ?? "")"
        
        lblPrice?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblPrice?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblPrice?.text = ""//"\(UserDefaults.standard.value(forKey: "subscription_header") ?? "")"
        
        lblOne?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblOne?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblOne?.text = "\(UserDefaults.standard.value(forKey: "subscription_point_1") ?? "")"
        if ("\(UserDefaults.standard.value(forKey: "subscription_point_1") ?? "")" == "")
        {
            imageViewOne?.isHidden = true
        }
        
        lblTwo?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblTwo?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblTwo?.text = "\(UserDefaults.standard.value(forKey: "subscription_point_2") ?? "")"
        if ("\(UserDefaults.standard.value(forKey: "subscription_point_2") ?? "")" == "")
        {
            imageViewTwo?.isHidden = true
        }
        
        lblThree?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblThree?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblThree?.text = "\(UserDefaults.standard.value(forKey: "subscription_point_3") ?? "")"
        if ("\(UserDefaults.standard.value(forKey: "subscription_point_3") ?? "")" == "")
        {
            imageViewThree?.isHidden = true
        }
        
        lblFour?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblFour?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblFour?.text = "\(UserDefaults.standard.value(forKey: "subscription_point_4") ?? "")"
        if ("\(UserDefaults.standard.value(forKey: "subscription_point_4") ?? "")" == "")
        {
            imageViewFour?.isHidden = true
        }
        
        txtSelectStoreContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtSelectStoreContainerView?.layer.cornerRadius = 5.0
        
        txtSelectStore?.isUserInteractionEnabled = false
        txtSelectStore?.placeholder = "Select Store"
        
        tncAndPrivacyPolicyContainerView?.backgroundColor = .clear
        
        btnTermsOfService?.titleLabel?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        btnTermsOfService?.setTitleColor( MySingleton.sharedManager() .themeGlobalDarkGreyColor, for: .normal)
        btnTermsOfService?.clipsToBounds = true
        btnTermsOfService?.addTarget(self, action: #selector(self.btnTermsOfServiceClicked(_:)), for: .touchUpInside)
        btnTermsOfService?.titleLabel?.adjustsFontSizeToFitWidth = true
        
        btnPrivacyPolicy?.titleLabel?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        btnPrivacyPolicy?.setTitleColor( MySingleton.sharedManager() .themeGlobalDarkGreyColor, for: .normal)
        btnPrivacyPolicy?.clipsToBounds = true
        btnPrivacyPolicy?.addTarget(self, action: #selector(self.btnPrivacyPolicyClicked(_:)), for: .touchUpInside)
        btnPrivacyPolicy?.titleLabel?.adjustsFontSizeToFitWidth = true
                
        btnPurchase?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnPurchase?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        
        btnPurchase?.setTitle(NSLocalizedString("go_premium", value:"Ativar plano Premium", comment: "").uppercased(), for: .normal)
        btnPurchase?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnPurchase?.clipsToBounds = true
        btnPurchase?.layer.cornerRadius = 5
        btnPurchase?.addTarget(self, action: #selector(self.btnPurchaseClicked(_:)), for: .touchUpInside)
        
        lblAlreadyPurchase?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblAlreadyPurchase?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblAlreadyPurchase?.text = "Para ativar mais de um plano Premium entre em contato com os administradores."
        lblAlreadyPurchase?.isHidden = true
        
        lblAlreadyPurchase?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
               lblAlreadyPurchase?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
               lblAlreadyPurchase?.text = "Para ativar mais de um plano Premium entre em contato com os administradores."
               lblAlreadyPurchase?.isHidden = true
        
        lblCanceledAtAnyTime?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblCanceledAtAnyTime?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
       
        lblCanceledAtAnyTime?.text = NSLocalizedString("Plan_without_fidelity_and_can_be_canceled_at_any_time", value:"Plano sem fidelidade, podendo ser cancelado a qualquer momento.", comment: "")
        //API CALL
        dataManager.user_GetAllMyStores()
    }
    
    @IBAction func btnTermsOfServiceClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController: Common_WebViewController = Common_WebViewController()
        viewController.strTitle = "Termos de Serviço"
        viewController.strUrl = "https://agendazap.com/premium/termos.html"
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func btnPrivacyPolicyClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController: Common_WebViewController = Common_WebViewController()
        viewController.strTitle = "Política de Privacidade"
        viewController.strUrl = "https://agendazap.com/premium/privacidade.html"
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func btnPurchaseClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (self.products.count > 0)
        {
            if IAPHelper.canMakePayments()
            {
                self.boolIsCalledForPurchase = true
                User_PurchasePremiumViewController.store.buyProduct(self.products[0])
            }
        }
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
