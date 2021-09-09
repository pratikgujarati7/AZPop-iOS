//
//  User_StoreListViewController.swift
//  AgendaZap
//
//  Created by Dipen on 12/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RangeSeekSlider
import iOSDropDown

class User_StoreListViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, RangeSeekSliderDelegate, UIGestureRecognizerDelegate, UITextViewDelegate
{
    
    //MARK:- IBOutlet
    //NAVIGATION BAR
    @IBOutlet var navigationBarView: UIView?
    @IBOutlet var searchViewContainer: UIViewX!
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var btnFilter: UIButton!
    
    //SliderContainerView
    @IBOutlet var sliderViewContainer: UIView!
    @IBOutlet var Slider: RangeSeekSlider?
    @IBOutlet var btnSelectDistance: UIButton?
    @IBOutlet var btnOrderbyProximity: UIButton? //Remove
    @IBOutlet var sliderViewHeightConstraint: NSLayoutConstraint! //130
    
    //SegementContainerView
    @IBOutlet var segmentedControl: UISegmentedControl! //3
    
    //Result and Sortby view
    @IBOutlet var lblResults: UILabel!
    @IBOutlet var viewSortBy: UIView!
    
    @IBOutlet var lblOrderBy: UILabel!
    @IBOutlet var lblSortByName: UILabel!
    @IBOutlet var btnArrow: UIButton!
    @IBOutlet var txtSortBy: DropDown!
    @IBOutlet var txtProductSortBy: DropDown!
        
    @IBOutlet var mainTableView: UITableView? {
        didSet {
            self.mainTableView?.register(UINib(nibName: "StoreTVCell", bundle: nil), forCellReuseIdentifier: "StoreTVCell")
            self.mainTableView?.register(UINib(nibName: "ProductTVCell", bundle: nil), forCellReuseIdentifier: "ProductTVCell")
        }
    }
    
    //HEADER VIEW
    @IBOutlet var headerContainerView: UIView?
    @IBOutlet var txtFilterContainerView: UIView?
    @IBOutlet var txtFilter: UITextField?
    //CHECKBOX
    @IBOutlet var checkboxContainerView: UIView?
    @IBOutlet var imageViewCheckbox: UIImageView?
    @IBOutlet var lblCheckbox: UILabel?
    @IBOutlet var btnCheckbox: UIButton?
    
    //HEADER TWO
    @IBOutlet var headerTwoContainerView: UIView?
        
    //HEADER THREE
    @IBOutlet var headerThreeContainerView: UIView?
    @IBOutlet var btnToggle: UIButton?
    
    //SEND BULK MESSAGE
    @IBOutlet var topTenBulkMessageContainerView: UIView?
    @IBOutlet var btnTopTenBulkMessage: UIButton?
    
    //SEND BULK MESSAGE
    @IBOutlet var bulkMessagePopupContainerView: UIView?
    @IBOutlet var bulkMessageInnerContainerView: UIView?
    @IBOutlet var btnCloseBulkMessage: UIButton?
    @IBOutlet var lblBulkMessage: UILabel?
    @IBOutlet var lblBulkMessageTitle: UILabel?
    @IBOutlet var txtViewBulkMessageContainerView: UIView?
    @IBOutlet var txtViewBulkMessage: UITextView?
    @IBOutlet var btnSendBulkMessage: UIButton?
    
    //SEND TOP TEN BULK MESSAGE
    @IBOutlet var topTenBulkMessagePopupContainerView: UIView?
    @IBOutlet var topTenBulkMessageInnerContainerView: UIView?
    @IBOutlet var btnCloseTopTenBulkMessage: UIButton?
    @IBOutlet var lblTopTenBulkMessage: UILabel?
    @IBOutlet var lblTopTenBulkMessagePhoneNumber: UILabel?
    @IBOutlet var txtTopTenBulkMessagePhoneNumberContainerView: UIView?
    @IBOutlet var txtPhoneNumber: UITextField?
    @IBOutlet var lblTopTenBulkMessageTitle: UILabel?
    @IBOutlet var txtViewTopTenBulkMessageContainerView: UIView?
    @IBOutlet var txtViewTopTenBulkMessage: UITextView?
    @IBOutlet var btnSendTopTenBulkMessage: UIButton?
    
    //MY STORE
    @IBOutlet var myStoreContainerView: UIView?
    @IBOutlet var imageViewMyStore: UIImageViewX?
    @IBOutlet var lblMyStoreName: UILabel?
    @IBOutlet var freeDeliveryView: UIViewX?
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var strScreenID: String!
    
    var boolIsFilterOpen: Bool = false
    var boolIsCheckboxSelected: Bool = false
    
    var boolIsOpenedFromSearch: Bool!
    var strSearchText: String!
    var objSelectedCategory: ObjCategory!
    var objSelectedSubCategory: ObjSubCategory!
    
    var dataRows = [ObjStorePromotion]()
    
    var boolIsToggleOn: Bool = false
    var strSelectedDistance: String = ""
    
    //
    var arrSortByIds = [0,1]
    var arrSortByNames = ["Populares","Distância"]
    var arrProductSortByIds = [0,1,2]
    var arrProductSortByNames = ["Populares","Menor Preço","Maior Preço"]
    
    var arrStores = [ObjStorePromotion]()
    var arrProducts = [ObjStoreProduct]()
    var arrReadMoreLess = [Int]()
    var pageNumber = 1
    
    var isStoreApiCalled = false
    var isProductApiCalled = false
    var isFromHome = true // matters if it is from sub categories
    
    var boolIsOpenedFromList: Bool = true
    
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
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bulkMessagePopupContainerView?.frame.size = self.view.frame.size
        let strBulkMessage: String = "\(UserDefaults.standard.value(forKey: "bulk_message") ?? "")"
        txtViewBulkMessage?.text = strBulkMessage
        
        topTenBulkMessagePopupContainerView?.frame.size = self.view.frame.size
        let strPhoneNumber = "\(UserDefaults.standard.value(forKey: "phone_number") ?? "")"
        txtPhoneNumber?.text = strPhoneNumber
        txtPhoneNumber?.isUserInteractionEnabled = false
        txtViewTopTenBulkMessage?.text = ""
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
        dataManager.arrayAllWhatsappGroups.removeAll()
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
                selector: #selector(self.user_GetAllStoresBySubCategoriesEvent),
                name: Notification.Name("user_GetAllStoresBySubCategoriesEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetAllStoresBySearchEvent),
                name: Notification.Name("user_GetAllStoresBySearchEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetProductsBySearchEvent),
                name: Notification.Name("user_GetProductsBySearchEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_sendBulkMessageEvent),
                name: Notification.Name("user_sendBulkMessageEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllStoresBySubCategoriesEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.dataRows = dataManager.arrayAllStores
            self.arrStores = dataManager.arrayAllStores
            
            let strCountString: String = String(format:NSLocalizedString("result_for", value:"%@ itens para %@", comment: ""), "\(self.dataRows.count)", self.objSelectedSubCategory.strSubCategoryName)
            //self.navigationTitle?.text = strCountString
            
            self.lblResults.text = "\(self.dataRows.count) resultados"
            
            self.isStoreApiCalled = true
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
        })
    }
    
    @objc func user_GetAllStoresBySearchEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.dataRows = dataManager.arrayAllStores
            self.arrStores = dataManager.arrayAllStores
            
            let strCountString : String = String(format:NSLocalizedString("result_for", value:"%@ itens para %@", comment: ""), "\(self.dataRows.count)", self.strSearchText)
            //self.navigationTitle?.text = strCountString
            
            self.lblResults.text = "\(self.dataRows.count) resultados"
            
            self.isStoreApiCalled = true
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
        })
    }
    
    @objc func user_GetProductsBySearchEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.arrProducts = dataManager.arrayProductsBySearch
            
            self.lblResults.text = "\(dataManager.strProductCounts) resultados"
            
            self.mainTableView?.isHidden = false
                        
            self.isProductApiCalled = true
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
        })
    }
    
    @objc func user_sendBulkMessageEvent()
    {
        DispatchQueue.main.async(execute: {
            
            if self.boolIsOpenedFromList
            {
                UserDefaults.standard.setValue((self.txtViewBulkMessage?.text)!, forKey: "bulk_message")
                UserDefaults.standard.synchronize()
                
                self.bulkMessagePopupContainerView?.removeFromSuperview()
                
                var originalString = ""
                
                if (self.txtViewBulkMessage?.text == "")
                {
                    originalString = "https://wa.me/55\(self.arrStores[self.btnSendBulkMessage?.tag ?? 0].strPhoneNumber)?text=(via AZpop) \("Gostaria de mais informações.")"
                }
                else
                {
                    originalString = "https://wa.me/55\(self.arrStores[self.btnSendBulkMessage?.tag ?? 0].strPhoneNumber)?text=(via AZpop) \((self.txtViewBulkMessage?.text)!)"
                }
                
                let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

                guard let url = URL(string: escapedString!) else {
                  return //be safe
                }

                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else
            {
                
                self.topTenBulkMessagePopupContainerView?.removeFromSuperview()
                
                self.appDelegate?.showAlertViewWithTitle(title: "", detail: "Sucesso! Enviamos sua mensagem para nossos parceiros. Aguarde o contato por WhatsApp.!")
            }
            
            
            //self.appDelegate?.showAlertViewWithTitle(title: "", detail: "Sucesso! Enviamos sua mensagem para nossos parceiros. Aguarde o contato por WhatsApp.!")
            
        })
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        //navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        //navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        //navigationTitle?.text = ""
        
    }
    
    @IBAction func btnFilterClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if (boolIsFilterOpen)
        {
            boolIsFilterOpen = false
            
            boolIsCheckboxSelected = false
            imageViewCheckbox?.image = UIImage(named: "ic_grey_tick.png")
            txtFilter?.text = ""
            self.txtFilterClicked(txtFilter!)
        }
        else
        {
            boolIsFilterOpen = true
        }
        mainTableView?.reloadData()
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView()
    {
        //mainTableView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        mainTableView?.isHidden = false //true
        mainTableView?.separatorStyle = .none
        //mainTableView?.tableFooterView = UIView()
        mainTableView?.separatorColor = .clear
        
        //HEADER VIEW
        headerContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        txtFilterContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        txtFilter?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtFilter?.delegate = self
        txtFilter?.backgroundColor = .clear
        txtFilter?.tintColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtFilter?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("filter_results", value: "Filtrar por nome", comment: ""),
                                                              attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtFilter?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtFilter?.textAlignment = .left
        txtFilter?.autocorrectionType = UITextAutocorrectionType.no
        txtFilter?.addTarget(self, action: #selector(self.txtFilterClicked(_:)), for: .editingChanged)
        
        checkboxContainerView?.backgroundColor = .clear
        imageViewCheckbox?.image = UIImage(named: "ic_grey_tick.png")
        lblCheckbox?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblCheckbox?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblCheckbox?.text = NSLocalizedString("order_by_proximity", value: "Ordernar por proximidade", comment: "")
        
        btnCheckbox?.addTarget(self, action: #selector(self.btnCheckboxClicked(_:)), for: .touchUpInside)
        
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
        
        //HEADER 2
        Slider?.delegate = self
        Slider?.tintColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        Slider?.initialColor = MySingleton.sharedManager().themeGlobalLightGreenColor//themeGlobalDarkGreyColor
        Slider?.handleColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        Slider?.selectedHandleDiameterMultiplier = 1.0
        Slider?.colorBetweenHandles = MySingleton.sharedManager().themeGlobalLightGreenColor
        //Slider?.minLabelFont  = MySingleton.sharedManager().themeFontFourteenSizeLight!
        Slider?.maxLabelFont  =  MySingleton.sharedManager().themeFontFourteenSizeLight!
        Slider?.minLabelColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        Slider?.maxLabelColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        Slider?.minValue = 3
        Slider?.maxValue = 150
        Slider?.disableRange = true
        Slider?.enableStep = true
        Slider?.step = 1
        
        btnSelectDistance?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSelectDistance?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSelectDistance?.setTitle("REFAZER BUSCA - ATÉ 20 KM", for: .normal)
        self.strSelectedDistance = "20"
        btnSelectDistance?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSelectDistance?.clipsToBounds = true
        btnSelectDistance?.layer.cornerRadius = 5
        btnSelectDistance?.addTarget(self, action: #selector(self.btnSelectDistanceClicked(_:)), for: .touchUpInside)
        
        //HEADER 3
        headerThreeContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        //btnToggle?.backgroundColor = .clear
        btnToggle?.titleLabel?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular!
        btnToggle?.setTitleColor(MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnToggle?.backgroundColor = MySingleton.sharedManager().themeGlobalButtonLightGrayColor
        btnToggle?.setTitle(NSLocalizedString("change_distance_off", value:"Alterar raio", comment: ""), for: .normal)
        btnToggle?.addTarget(self, action: #selector(self.btnToggleClicked(_:)), for: .touchUpInside)
        
        //  btnOrderbyProximity?.backgroundColor = .clear
        btnOrderbyProximity?.titleLabel?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular!
        btnOrderbyProximity?.setTitleColor(MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnOrderbyProximity?.backgroundColor = MySingleton.sharedManager().themeGlobalButtonLightGrayColor
        btnOrderbyProximity?.setTitle(NSLocalizedString("order_by_proximity", value:"Ordenar p/ distância", comment: ""), for: .normal)
        btnOrderbyProximity?.addTarget(self, action:
            #selector(self.btnOrderByDistanceClicked(_:)), for: .touchUpInside)
        
        if self.isFromHome {
            if !self.isStoreApiCalled {
                if (boolIsOpenedFromSearch)
                {
                    dataManager.user_GetAllStoresBySearch(strSearchText: self.strSearchText, strDistanceRange: "")
                    self.txtSearch.text = self.strSearchText
                }
                else
                {
                    if self.isFromHome {
                        //API CALL
                        dataManager.user_GetAllStoresBySubCategories(strCategoryID: "", strSubCategoryID: self.objSelectedSubCategory.strSubCategoryID, strDistanceRange: "")
                        //self.objSelectedCategory.strCategoryID
                        self.txtSearch.text = self.objSelectedSubCategory.strSubCategoryName
                    }
                    else {
                        //API CALL
                        dataManager.user_GetAllStoresBySubCategories(strCategoryID: self.objSelectedCategory.strCategoryID, strSubCategoryID: "", strDistanceRange: "")
                        self.txtSearch.text = self.objSelectedCategory.strCategoryName
                    }
                    
                    //dataManager.user_GetAllStoresBySubCategories(strCategoryID: "", strSubCategoryID: self.objSelectedSubCategory.strSubCategoryID, strDistanceRange: "")
                }
            }
            
        } else {
            self.segmentedControl.selectedSegmentIndex = 1
            self.btnFilter.isHidden = true
            self.sliderViewHeightConstraint.constant = 0.0
            self.viewSortBy.isHidden = true
            
            //guard !boolIsSetupNotificationEventCalledOnce else { return }
            
            if !self.isProductApiCalled {
                pageNumber = pageNumber + 1
                
                var strShorting: String!
                if (txtSortBy.selectedIndex == 0)
                {
                    strShorting = "Populares"
                }
                else if (txtSortBy.selectedIndex == 1)
                {
                    strShorting = "price_lowest"
                }
                else
                {
                    strShorting = "price_highest"
                }
                if (boolIsOpenedFromSearch) {
                    //Get all promotions details
                    dataManager.user_GetProductsBySearch(
                        strStoreID: "",
                        strSearchText: self.strSearchText,
                        strOrderBy: strShorting,
                        strPageNumber: "\(pageNumber)")
                    
                    self.txtSearch.text = self.strSearchText
                }
                else {
                    if self.isFromHome {
                        //API CALL Get all products details
                        dataManager.user_GetProductsBySearch(
                            strStoreID: "",
                            strSearchText: self.objSelectedSubCategory.strSubCategoryName,
                            strOrderBy: strShorting,
                            strPageNumber: "\(pageNumber)")
                        
                        self.txtSearch.text = self.objSelectedSubCategory.strSubCategoryName
                    }
                    else {
                        //API CALL Get all promotions details
                        dataManager.user_GetProductsBySearch(
                            strStoreID: "",
                            strSearchText: self.objSelectedSubCategory.strSubCategoryName,
                            strOrderBy: strShorting,
                            strPageNumber: "\(pageNumber)")
                        
                        self.txtSearch.text = self.objSelectedCategory.strCategoryName
                    }
                }
                
                self.isProductApiCalled = true
            }
            
            self.txtSearch.text = self.objSelectedCategory.strCategoryName
            
            self.mainTableView?.reloadData()
        }
        
        // Initially hide slider view
        self.sliderViewHeightConstraint.constant = 0.0
        
        // Setup Dropdown
        self.setupDropDown()
        
        btnTopTenBulkMessage?.titleLabel?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular!
        btnTopTenBulkMessage?.setTitleColor(MySingleton.sharedManager().themeGlobalDarkGreyColor, for: .normal)
        btnTopTenBulkMessage?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        btnTopTenBulkMessage?.clipsToBounds = true
        btnTopTenBulkMessage?.layer.cornerRadius = 10
        btnTopTenBulkMessage?.addTarget(self, action: #selector(self.btnTopTenBulkMessageClicked(_:)), for: .touchUpInside)
        
        //BULK MESSAGE POPUP
        bulkMessagePopupContainerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        btnCloseBulkMessage?.addTarget(self, action: #selector(self.btnCancelBulkMessageClicked(_:)), for: .touchUpInside)
        
        txtViewBulkMessage?.delegate = self
        
        btnSendBulkMessage?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSendBulkMessage?.backgroundColor = MySingleton.sharedManager().themeGlobalGreen2Color
        btnSendBulkMessage?.setTitleColor( MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnSendBulkMessage?.clipsToBounds = true
        btnSendBulkMessage?.layer.cornerRadius = 5
        btnSendBulkMessage?.addTarget(self, action: #selector(self.btnSendBulkMessageClicked(_:)), for: .touchUpInside)
        
        //TOP TEN BULK MESSAGE POPUP
        topTenBulkMessagePopupContainerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        btnCloseTopTenBulkMessage?.addTarget(self, action: #selector(self.btnCancelTopTenBulkMessageClicked(_:)), for: .touchUpInside)
        
        txtPhoneNumber?.delegate = self
        txtPhoneNumber?.keyboardType = .numberPad
        txtViewTopTenBulkMessage?.delegate = self
        
        btnSendTopTenBulkMessage?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSendTopTenBulkMessage?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSendTopTenBulkMessage?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSendTopTenBulkMessage?.clipsToBounds = true
        btnSendTopTenBulkMessage?.layer.cornerRadius = 5
        btnSendTopTenBulkMessage?.addTarget(self, action: #selector(self.btnSendTopTenBulkMessageClicked(_:)), for: .touchUpInside)
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilterTapped(_ sender: UIButton) {
        self.sliderViewHeightConstraint.constant = self.sliderViewHeightConstraint.constant == 130.0 ? 0.0 : 130.0
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.btnFilter.isHidden = false
            self.viewSortBy.isHidden = false
            self.txtSortBy.isHidden = false
            self.txtProductSortBy.isHidden = true
            
            if !self.isStoreApiCalled {
                if (boolIsOpenedFromSearch)
                {
                    dataManager.user_GetAllStoresBySearch(strSearchText: self.strSearchText, strDistanceRange: "")
                    self.txtSearch.text = self.strSearchText
                }
                else
                {
                    if self.isFromHome {
                        //API CALL
                        dataManager.user_GetAllStoresBySubCategories(strCategoryID: "", strSubCategoryID: self.objSelectedSubCategory.strSubCategoryID, strDistanceRange: "")
                        //self.objSelectedCategory.strCategoryID
                        self.txtSearch.text = self.objSelectedSubCategory.strSubCategoryName
                    }
                    else {
                        //API CALL
                        //dataManager.user_GetAllStoresBySubCategories(strCategoryID: self.objSelectedCategory.strCategoryID, strSubCategoryID: "", strDistanceRange: "")
                        
                        dataManager.user_GetAllStoresBySearch(strSearchText: self.objSelectedCategory.strCategoryName, strDistanceRange: "")
                        
                        self.txtSearch.text = self.objSelectedCategory.strCategoryName
                    }
                    
                    //dataManager.user_GetAllStoresBySubCategories(strCategoryID: "", strSubCategoryID: self.objSelectedSubCategory.strSubCategoryID, strDistanceRange: "")
                }
                
                self.isStoreApiCalled = true
            }
            
            self.lblResults.text = "\(self.dataRows.count) resultados"
            
            self.mainTableView?.reloadData()
        case 1:
            self.btnFilter.isHidden = true
            self.sliderViewHeightConstraint.constant = 0.0
            self.viewSortBy.isHidden = false
            self.txtSortBy.isHidden = true
            self.txtProductSortBy.isHidden = false
            
            
            
            //guard !boolIsSetupNotificationEventCalledOnce else { return }
            
            if !self.isProductApiCalled {
                pageNumber = 1
                
                var strShorting: String!
                if (txtSortBy.selectedIndex == 0)
                {
                    strShorting = "Populares"
                }
                else if (txtSortBy.selectedIndex == 1)
                {
                    strShorting = "price_lowest"
                }
                else
                {
                    strShorting = "price_highest"
                }
                
                if (boolIsOpenedFromSearch) {
                    //Get all promotions details
                    dataManager.user_GetProductsBySearch(
                        strStoreID: "",
                        strSearchText: self.strSearchText,
                        strOrderBy: strShorting,
                        strPageNumber: "1")
                    
                    self.txtSearch.text = self.strSearchText
                }
                else {
                    if self.isFromHome {
                        //API CALL Get all products details
                        dataManager.user_GetProductsBySearch(
                            strStoreID: "",
                            strSearchText: self.objSelectedSubCategory.strSubCategoryName,
                            strOrderBy: strShorting,
                            strPageNumber: "1")
                        
                        self.txtSearch.text = self.objSelectedSubCategory.strSubCategoryName
                    }
                    else {
                        //API CALL Get all promotions details
                        dataManager.user_GetProductsBySearch(
                            strStoreID: "",
                            strSearchText: self.objSelectedSubCategory.strSubCategoryName,
                            strOrderBy: strShorting,
                            strPageNumber: "1")
                        
                        self.txtSearch.text = self.objSelectedCategory.strCategoryName
                    }
                }
                
                self.isProductApiCalled = true
            }
                        
            self.mainTableView?.reloadData()
        default:
            break
        }
    }
    
    @IBAction func btnDropDownTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnCheckboxClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if (boolIsCheckboxSelected)
        {
            boolIsCheckboxSelected = false
            imageViewCheckbox?.image = UIImage(named: "ic_grey_tick.png")
        }
        else
        {
            boolIsCheckboxSelected = true
            imageViewCheckbox?.image = UIImage(named: "ic_green_tick.png")
        }
        self.txtFilterClicked(txtFilter!)
        mainTableView?.reloadData()
    }
    
    @IBAction func txtFilterClicked(_ sender: UITextField)
    {
        self.dataRows = [ObjStorePromotion]()
        
        if ((txtFilter?.text?.count)! <= 0)
        {
            if (boolIsCheckboxSelected)
            {
                //BUBBLE SHORTING
                var arrayMain = dataManager.arrayAllStores
                
                for i in 0..<arrayMain.count {
                    for j in 1..<arrayMain.count - i {
                        
                        if (Double(arrayMain[j].strDistance) ?? 0) < (Double(arrayMain[j-1].strDistance) ?? 0) {
                            let tmp = arrayMain[j-1]
                            arrayMain[j-1] = arrayMain[j]
                            arrayMain[j] = tmp
                        }
                    }
                }
                
                self.dataRows = arrayMain
                //
                //                for objStorePromotion in dataManager.arrayAllStores
                //                {
                //
                //
                //                    if (objStorePromotion.strPromo != "")
                //                    {
                //                        self.dataRows.append(objStorePromotion)
                //                    }
                //                }
            }
            else
            {
                self.dataRows = dataManager.arrayAllStores
            }
        }
        else
        {
            var arrayTemp  = [ObjStorePromotion]()
            
            for objStorePromotion in dataManager.arrayAllStores
            {
                if objStorePromotion.strName.lowercased().containsIgnoringCase(find: (txtFilter?.text?.lowercased())!)
                {
                    arrayTemp.append(objStorePromotion)
                }
            }
            
            if (boolIsCheckboxSelected)
            {
                //BUBBLE SHORTING
                var arrayMain = arrayTemp
                
                for i in 0..<arrayMain.count {
                    for j in 1..<arrayMain.count - i {
                        
                        if (Double(arrayMain[j].strDistance) ?? 0) < (Double(arrayMain[j-1].strDistance) ?? 0) {
                            let tmp = arrayMain[j-1]
                            arrayMain[j-1] = arrayMain[j]
                            arrayMain[j] = tmp
                        }
                    }
                }
                
                self.dataRows = arrayMain
            }
            else
            {
                self.dataRows = arrayTemp
            }
        }
        
        mainTableView?.reloadData()
    }
    
    @IBAction func btnSelectDistanceClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        self.strSelectedDistance = "\(Int(Slider?.selectedMaxValue ?? 0))"
        
        //API CALL
        if (boolIsOpenedFromSearch)
        {
            dataManager.user_GetAllStoresBySearch(strSearchText: self.strSearchText, strDistanceRange: self.strSelectedDistance)
        }
        else
        {
            if self.isFromHome {
                //API CALL
                dataManager.user_GetAllStoresBySubCategories(strCategoryID: "", strSubCategoryID: self.objSelectedSubCategory.strSubCategoryID, strDistanceRange: self.strSelectedDistance)
                //self.objSelectedCategory.strCategoryID
                //self.txtSearch.text = self.objSelectedSubCategory.strSubCategoryName
            }
            else {
                //API CALL
                dataManager.user_GetAllStoresBySubCategories(strCategoryID: self.objSelectedCategory.strCategoryID, strSubCategoryID: "", strDistanceRange: self.strSelectedDistance)
                //self.txtSearch.text = self.objSelectedCategory.strCategoryName
            }
        }
        
        
    }
    
    @IBAction func btnToggleClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (boolIsToggleOn)
        {
            btnToggle?.backgroundColor = MySingleton.sharedManager().themeGlobalButtonLightGrayColor
            boolIsToggleOn = false
            btnToggle?.setTitle(NSLocalizedString("change_distance_off", value:"Alterar raio", comment: ""), for: .normal)
        }
        else
        {
            boolIsToggleOn = true
            btnToggle?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
            
            btnToggle?.setTitle(NSLocalizedString("change_distance_on", value:"Alterar raio", comment: ""), for: .normal)
        }
        
        mainTableView?.reloadData()
    }
    
    @IBAction func btnOrderByDistanceClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if !sender.isSelected
        {
            sender.isSelected = true
            boolIsCheckboxSelected = true
            btnOrderbyProximity?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
            btnOrderbyProximity?.setTitleColor(MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        }
        else {
            sender.isSelected = false
            boolIsCheckboxSelected = false
            btnOrderbyProximity?.backgroundColor = MySingleton.sharedManager().themeGlobalButtonLightGrayColor
            btnOrderbyProximity?.setTitleColor(MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        }
        
        print(txtFilter as Any)
        self.txtFilterClicked(txtFilter!)
        mainTableView?.reloadData()
    }
    
    @IBAction func btnTopTenBulkMessageClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        self.boolIsOpenedFromList = false
        self.view.addSubview(topTenBulkMessagePopupContainerView!)
    }
    
    @IBAction func btnCancelBulkMessageClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        bulkMessagePopupContainerView?.removeFromSuperview()
    }
    
    @IBAction func btnSendBulkMessageClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
//        if (txtViewBulkMessage?.text == "")
//        {
//            AppDelegate.showToast(message : "Please enter message", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
//        }
//        else
        if ((txtViewBulkMessage?.text.count)! > 140)
        {
            AppDelegate.showToast(message : "Máximo 140 caracteres", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
        }
        else
        {
            //API CALL
            dataManager.user_sendBulkMessage(strType: "2", strStoreID: dataRows[sender.tag].strID, strMessage: "\((txtViewBulkMessage?.text)!)")
        }
        
    }
    
    @IBAction func btnCancelTopTenBulkMessageClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        topTenBulkMessagePopupContainerView?.removeFromSuperview()
    }
    
    @IBAction func btnSendTopTenBulkMessageClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        
        if (txtViewTopTenBulkMessage?.text == "")
        {
            AppDelegate.showToast(message : "Please enter message", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
        }
        else if ((txtViewTopTenBulkMessage?.text.count)! > 140)
        {
            AppDelegate.showToast(message : "Máximo 140 caracteres", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
        }
        else
        {
            
            var strStoreIDs: String = ""
            if self.arrStores.count >= 10
            {
                for objIndex in self.arrStores
                {
                    if strStoreIDs == ""
                    {
                        strStoreIDs = objIndex.strID
                    }
                    else
                    {
                        strStoreIDs = "\(strStoreIDs),\(objIndex.strID)"
                    }
                }
            }
            else
            {
                for objIndex in self.arrStores
                {
                    if strStoreIDs == ""
                    {
                        strStoreIDs = objIndex.strID
                    }
                    else
                    {
                        strStoreIDs = "\(strStoreIDs),\(objIndex.strID)"
                    }
                }
            }
    
            //API CALL
            dataManager.user_sendTopTenBulkMessage(strType: "1", strCategoryID: boolIsOpenedFromSearch == false ? objSelectedCategory.strCategoryID : "", strStoreID: strStoreIDs, strMessage: "(via AZpop) \((txtViewTopTenBulkMessage?.text)!)")
        }
        
    }
    
    @IBAction func btnMyStoreClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (dataManager.arrayAllMyStores.count > 0)
        {
            let objStore = dataManager.arrayAllMyStores[0]
            
            let viewController: User_PurchasePremiumViewController = User_PurchasePremiumViewController()
            viewController.boolIsOpendFromAddStore = false
            viewController.intSelectedStoreID = Int(objStore.strID)
            viewController.strSelectedStoreName = objStore.strName
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    //MARK:- Functions
    func setupDropDown() {
        
        self.txtSortBy?.optionArray = self.arrSortByNames
        self.txtSortBy?.optionIds = self.arrSortByIds
        self.txtSortBy?.selectedRowColor = (MySingleton.sharedManager().themeGlobalLightGreenColor?.withAlphaComponent(0.5))!
        self.txtSortBy?.selectedIndex = 0
        self.txtSortBy?.text = self.arrSortByNames[0]
        
        //self.txtSortBy?.listHeight =  (self.view?.frame.size.height)! / 3
        
        self.txtSortBy?.didSelect{(selectedText , index ,id) in
            
            //Perform Action
            if index == 0 {
                //self.boolIsCheckboxSelected = true
                
                self.arrStores = dataManager.arrayAllStores
            } else {
                //self.boolIsCheckboxSelected = false
                
                //BUBBLE SHORTING
                var arrayMain = dataManager.arrayAllStores
                
                for i in 0..<arrayMain.count {
                    for j in 1..<arrayMain.count - i {
                        
                        if (Double(arrayMain[j].strDistance) ?? 0) < (Double(arrayMain[j-1].strDistance) ?? 0) {
                            let tmp = arrayMain[j-1]
                            arrayMain[j-1] = arrayMain[j]
                            arrayMain[j] = tmp
                        }
                    }
                }
                
                self.arrStores = arrayMain
            }
            
            //self.txtFilterClicked(self.txtFilter!)
            self.mainTableView?.reloadData()
        }
        
        //PRODUCT
        self.txtProductSortBy?.optionArray = self.arrProductSortByNames
        self.txtProductSortBy?.optionIds = self.arrProductSortByIds
        self.txtProductSortBy?.selectedRowColor = (MySingleton.sharedManager().themeGlobalLightGreenColor?.withAlphaComponent(0.5))!
        self.txtProductSortBy?.selectedIndex = 0
        self.txtProductSortBy?.text = self.arrProductSortByNames[0]
        
        //self.txtSortBy?.listHeight =  (self.view?.frame.size.height)! / 3
        
        self.txtProductSortBy?.didSelect{(selectedText , index ,id) in
            
            self.pageNumber = 1
            
            var strShorting: String!
            //Perform Action
            if index == 0 {
                strShorting = "Populares"
            }
            else if index == 1 {
                strShorting = "price_lowest"
            }
            else {
                strShorting = "price_highest"
            }
            
            //API CALL
            if !self.isProductApiCalled {
                if (self.boolIsOpenedFromSearch) {
                    //Get all promotions details
                    dataManager.user_GetProductsBySearch(
                        strStoreID: "",
                        strSearchText: self.strSearchText,
                        strOrderBy: strShorting,
                        strPageNumber: "1")
                    
                    self.txtSearch.text = self.strSearchText
                }
                else {
                    if self.isFromHome {
                        //API CALL Get all products details
                        dataManager.user_GetProductsBySearch(
                            strStoreID: "",
                            strSearchText: self.objSelectedSubCategory.strSubCategoryName,
                            strOrderBy: strShorting,
                            strPageNumber: "1")
                        
                        self.txtSearch.text = self.objSelectedSubCategory.strSubCategoryName
                    }
                    else {
                        //API CALL Get all promotions details
                        dataManager.user_GetProductsBySearch(
                            strStoreID: "",
                            strSearchText: self.objSelectedSubCategory.strSubCategoryName,
                            strOrderBy: strShorting,
                            strPageNumber: "1")
                        
                        self.txtSearch.text = self.objSelectedCategory.strCategoryName
                    }
                }
                
                self.isProductApiCalled = true
            }
            
            self.mainTableView?.reloadData()
        }
    }
}

//MARK:- Textfield Delegates
extension User_StoreListViewController {
    
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
                if self.segmentedControl.selectedSegmentIndex == 0 {
                    dataManager.user_GetAllStoresBySearch(strSearchText: self.txtSearch.text!, strDistanceRange: "")
                    self.strSearchText = self.txtSearch.text
                    self.boolIsOpenedFromSearch = true
                    self.isStoreApiCalled = false
                    self.isProductApiCalled = false
                }
                else
                {
                    pageNumber = 1
                    
                    var strShorting: String!
                    if (txtSortBy.selectedIndex == 0)
                    {
                        strShorting = "Populares"
                    }
                    else if (txtSortBy.selectedIndex == 1)
                    {
                        strShorting = "price_lowest"
                    }
                    else
                    {
                        strShorting = "price_highest"
                    }
                    dataManager.user_GetProductsBySearch(
                        strStoreID: "",
                        strSearchText: self.txtSearch.text!,
                        strOrderBy: strShorting,
                        strPageNumber: "1")
                    self.strSearchText = self.txtSearch.text
                    self.boolIsOpenedFromSearch = true
                    self.isStoreApiCalled = false
                    self.isProductApiCalled = false
                }
            }
        }
        
        return true
    }
    
}

//MARK:- RangeSeekSlider Delegate Methods
extension User_StoreListViewController {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
        print("Currency slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        //        dataManager.floatMinLowestBid = minValue
        //        dataManager.floatMaxLowestBid = maxValue
        
        self.strSelectedDistance = "\(Int(Slider?.selectedMaxValue ?? 0))"
        
        btnSelectDistance?.setTitle("REFAZER BUSCA - ATÉ \(self.strSelectedDistance) KM", for: .normal)
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
    
}

//MARK:- Tableview Methods
extension User_StoreListViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            if section == 0
            {
                return topTenBulkMessageContainerView
            }
            else
            {
                if (dataManager.arrayAllMyStores.count > 0)
                {
                    let objStore = dataManager.arrayAllMyStores[0]
                    if objStore.strIsStoreVisible == "1" && objStore.strType == "0"
                    {
                        imageViewMyStore?.sd_setImage(with: URL(string: objStore.strImages), placeholderImage: UIImage(named: "no_image_to_show.png"))
                        lblMyStoreName?.text = objStore.strName
                        if objStore.strIsFreeDelivery == "1"
                        {
                            freeDeliveryView?.isHidden = false
                        }
                        else
                        {
                            freeDeliveryView?.isHidden = true
                        }
                        return myStoreContainerView
                    }
                    else
                    {
                        return nil
                    }
                }
                else
                {
                    return nil
                }
            }
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.segmentedControl.selectedSegmentIndex == 0 { //Storelist
            //return self.arrStores.count > 0 ? self.arrStores.count : 0
            if section == 0
            {
                return 0
            }
            else
            {
                if self.arrStores.count == 0 {
                    self.mainTableView!.showNoDataLabel(NSLocalizedString("no_store_found", value:"Nenhum negócio encontrado.", comment: ""), isScrollable: true)
                    return 0
                }
                else {
                    self.mainTableView!.removeNoDataLabel()
                    return self.arrStores.count
                }
            }
        } else { //Promotions
            //return self.arrStoresPromotion.count > 0 ? self.arrStoresPromotion.count : 0
            
            if self.arrProducts.count == 0 {
                self.mainTableView!.showNoDataLabel(NSLocalizedString("no_promotion_found", value:"Não há nenhuma promoção encontrada de nenhuma loja.", comment: ""), isScrollable: true)
                return 0
            }
            else {
                self.mainTableView!.removeNoDataLabel()
                return self.arrProducts.count
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            
            let objStore = self.arrStores[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTVCell") as! StoreTVCell
            
            cell.lblStoreName.text = objStore.strName
            cell.lblDistance.text = "\(objStore.strDistance) km"
            cell.lblCategoryType.text = objStore.strTags
            
            cell.btnViewProfile.isUserInteractionEnabled = false
            
            if objStore.strType == "1" {
                cell.viewPriorityContainer.isHidden = false
                cell.lblPriority.text = "Em Alta"
            } else {
                cell.viewPriorityContainer.isHidden = true
                cell.lblPriority.text = ""
            }
            
            if objStore.strIsFreeDelivery == "1" {
                cell.viewFreeDeliveryContainer.isHidden = false
                cell.lblFreeDelivery.text = "Entrega grátis"
            } else {
                cell.viewFreeDeliveryContainer.isHidden = true
                cell.lblFreeDelivery.text = ""
            }
            
            if objStore.strTaxIdStatus == "1" {
                cell.imageViewIsVerified.isHidden = false
            }
            else
            {
                cell.imageViewIsVerified.isHidden = true
            }
            
            cell.btnWhatsappClick = {(_ aCell: StoreTVCell) -> Void in
                
                self.boolIsOpenedFromList = true
                self.btnSendBulkMessage?.tag = indexPath.row
                self.view.addSubview(self.bulkMessagePopupContainerView!)
                
            }
            
            return cell
        }
        else {
            
            let objProduct = self.arrProducts[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTVCell") as! ProductTVCell
            
            
            if (objProduct.arrayProductImages.count > 0)
            {
                cell.imageviewProduct.sd_setImage(with: URL(string: objProduct.arrayProductImages[0]), placeholderImage: UIImage(named: "no_image_to_show.png"))
            }
            else
            {
                cell.imageviewProduct.image = UIImage(named: "no_image_to_show.png")
                
            }
            
            cell.lblProductName.text = objProduct.strTitle
            //cell.lblPricePoints.text = "R$\(objProduct.strMoneyPrice) ou\(objProduct.strPointPrice) Pontos"
            
            let strMoney: String = String(format: "%.02f", Float(objProduct.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
            
            cell.lblPricePoints.text = "R$ \(strMoney.replacingOccurrences(of: ".", with: ","))"
            
            let sectionsAmount = tableView.numberOfSections
            let rowsAmount = tableView.numberOfRows(inSection: indexPath.section)
            if ((indexPath.section == sectionsAmount - 1) && (indexPath.row == rowsAmount - 1))
            {
                // This is the last cell in the table
                if (pageNumber < dataManager.totalPageNumberForProducts)
                {
                    pageNumber = pageNumber + 1
                    
                    var strShorting: String!
                    if (txtSortBy.selectedIndex == 0)
                    {
                        strShorting = "Populares"
                    }
                    else if (txtSortBy.selectedIndex == 1)
                    {
                        strShorting = "price_lowest"
                    }
                    else
                    {
                        strShorting = "price_highest"
                    }
                    //API CALL
                    if !self.isProductApiCalled {
                        if (boolIsOpenedFromSearch) {
                            //Get all promotions details
                            dataManager.user_GetProductsBySearch(
                                strStoreID: "",
                                strSearchText: self.strSearchText,
                                strOrderBy: strShorting,
                                strPageNumber: "\(pageNumber)")
                            
                            self.txtSearch.text = self.strSearchText
                        }
                        else {
                            if self.isFromHome {
                                //API CALL Get all products details
                                dataManager.user_GetProductsBySearch(
                                    strStoreID: "",
                                    strSearchText: self.objSelectedSubCategory.strSubCategoryName,
                                    strOrderBy: strShorting,
                                    strPageNumber: "\(pageNumber)")
                                
                                self.txtSearch.text = self.objSelectedSubCategory.strSubCategoryName
                            }
                            else {
                                //API CALL Get all promotions details
                                dataManager.user_GetProductsBySearch(
                                    strStoreID: "",
                                    strSearchText: self.objSelectedSubCategory.strSubCategoryName,
                                    strOrderBy: strShorting,
                                    strPageNumber: "\(pageNumber)")
                                
                                self.txtSearch.text = self.objSelectedCategory.strCategoryName
                            }
                        }
                        
                        self.isProductApiCalled = true
                    }
                }
                
            }
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            
            if (arrStores.count > 0)
            {
                if (arrStores[indexPath.row].strIsBlocked == "0")
                {
                    let viewController: User_StoreDetailsViewController = User_StoreDetailsViewController()
                    print(arrStores[indexPath.row].strID)
                    viewController.strSelectedStoreID = arrStores[indexPath.row].strID
                    self.navigationController?.pushViewController(viewController, animated: false)
                }
                else
                {
                    appDelegate?.showAlertViewWithTitle(title: arrStores[indexPath.row].strBlockedTitle, detail: arrStores[indexPath.row].strBlockedMessage)
                }
            }
        }
        else {
            
            let objProduct = self.arrProducts[indexPath.row]
            
            let viewController: ProductDetailsVC = ProductDetailsVC()
            viewController.strSelectedStoreProductID = objProduct.strID
            self.navigationController?.pushViewController(viewController, animated: false)
        }
        
    }
    
}
