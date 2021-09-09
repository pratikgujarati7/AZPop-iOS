//
//  AddProductVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 08/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import iOSDropDown
import SDWebImage
import MWPhotoBrowser
import MBProgressHUD
import Firebase
import Photos
import TLPhotoPicker

class AddProductVC: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UIActionSheetDelegate, TLPhotosPickerViewControllerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblType: UILabel!
    //PRODUCT
    @IBOutlet var imageViewProduct: UIImageView!
    @IBOutlet var lblProduct: UILabel!
    @IBOutlet var btnProduct: UIButton!
    //SERVICE
    @IBOutlet var imageViewService: UIImageView!
    @IBOutlet var lblService: UILabel!
    @IBOutlet var btnService: UIButton!
    
    //PROMOCODE
    @IBOutlet var btnPromocodeContainerView: UIView!
    @IBOutlet var imageViewPromocode: UIImageView!
    @IBOutlet var lblPromocode: UILabel!
    @IBOutlet var btnPromocode: UIButton!
    
    //PROMOCODE OFFER TYPE
    @IBOutlet var promocodeOfferTypeContainerView: UIView!
    @IBOutlet var lblPromocodeType: UILabel!
    //DISCOUNT PROMOCODE
    @IBOutlet var imageViewDiscountPromocode: UIImageView!
    @IBOutlet var lblDiscountPromocode: UILabel!
    @IBOutlet var btnDiscountPromocode: UIButton!
    //GIFT PROMOCODE
    @IBOutlet var imageViewGiftPromocode: UIImageView!
    @IBOutlet var lblGiftPromocode: UILabel!
    @IBOutlet var btnGiftPromocode: UIButton!
    
    @IBOutlet var txtProductNameContainerView: UIView!
    @IBOutlet var txtProductName: SATextField!
    @IBOutlet var lblProdyctNameValidation: UILabel!
    
    @IBOutlet var viewPriceTypeContainer: UIView!
    @IBOutlet var lblProdctPrice: UILabel!
    //FIXED PRICE
    @IBOutlet var imageViewFixedPrice: UIImageView!
    @IBOutlet var lblFixedPrice: UILabel!
    @IBOutlet var btnFixedPrice: UIButton!
    //VARIABLE PRICE
    @IBOutlet var imageViewVariablePrice: UIImageView!
    @IBOutlet var lblVariablePrice: UILabel!
    @IBOutlet var btnVariablePrice: UIButton!
    
    @IBOutlet var viewPriceContainer: UIView!
    @IBOutlet var lblPriceTitle: UILabel!
    @IBOutlet var lblPriceUnit: UILabel!
    @IBOutlet var txtPrice: UITextField!
    
    @IBOutlet var viewDiscountContainer: UIView!
    @IBOutlet var lblDiscountTitle: UILabel!
    @IBOutlet var lblDiscountUnit: UILabel!
    @IBOutlet var txtDiscount: UITextField!
    @IBOutlet var lblDiscountValue: UILabel!
    
    @IBOutlet var viewGiftContainer: UIView!
    @IBOutlet var lblGiftTitle: UILabel!
    @IBOutlet var txtGiftText: UITextField!
    
    @IBOutlet var lblDescriptionTitle: UILabel!
    @IBOutlet var txtViewDescription: UITextView!
    
    @IBOutlet var imageScrollView: UIScrollView!
    @IBOutlet var imagePageControl: UIPageControl!
    @IBOutlet var btnAddImage: UIButton!
    
    @IBOutlet var txtSelectCity: DropDown!
    
    @IBOutlet var lblProductAvailability: UILabel!
    @IBOutlet var lblDeliveryOption: UILabel!
    //ADDRESS NEEDED
    @IBOutlet var imageViewAddNeeded: UIImageView!
    @IBOutlet var lblAddNeeded: UILabel!
    @IBOutlet var btnAddNeeded: UIButton!
    //ADDRESS NOT NEEDED
    @IBOutlet var imageViewAddNotNeeded: UIImageView!
    @IBOutlet var lblAddNotNeeded: UILabel!
    @IBOutlet var btnAddNotNeeded: UIButton!
    
    @IBOutlet var btnSave: UIButton!
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
        
    var boolIsProduct: Bool = true
    var boolIsPromocode: Bool = true
    var boolIsFixedPrice: Bool = true
    var boolIsPromocodeTypeDiscount: Bool = true
    var boolIsAddressNeeded: Bool = true
    
    var arraySelectedAttachments = [Data]()
    var arraySelectedNewAttachments = [Data]()
    var arrayDeletedImages = [String]()
    
    var browser : MWPhotoBrowser!
    var photos = [MWPhoto]()
    var photosData = [UIImage]()
    
    //CITY
    var dataRowsCity = [ObjCity]()
    var dataRowsCityIDs = [Int]()
    var dataRowsCityNames = [String]()
    
    var intSelectedCityID: Int?
    var strSelectedCityName: String?
    var strSelectedStateID: String?
    
    //FOR EDIT
    var objMyStoreProduct: ObjStoreProduct!
    var boolIsOpenForEdit: Bool!
    var arrayTempAlteredStoreImages = [String]()
    var isSliderImageLoaded : Bool!
    
    fileprivate var selectedImageIndex: Int = 0
    
    // MARK: - UIViewController Delegate Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isSliderImageLoaded = false
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        if (self.boolIsOpenForEdit)
        {
            arraySelectedAttachments = [Data]()
            arrayTempAlteredStoreImages = [String]()
            
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading product images.")
            
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                print("self.objMyStore.arrayStoreImages.count: \(self.objMyStoreProduct.arrayProductImages.count)")
                
                for strImageURL in self.objMyStoreProduct.arrayProductImages
                {
                    let url:NSURL = NSURL(string: strImageURL)!
                    print("url: \(url)")
                    
                    let data = try? Data(contentsOf: url as URL)
                    
                    if (data != nil)
                    {
                        self.arraySelectedAttachments.append(data ?? Data())
                    }
                }
                
                if(self.objMyStoreProduct.arrayProductImages.count > 0)
                {
                    for index in 0...(self.objMyStoreProduct.arrayProductImages.count - 1)
                    {
                        self.arrayTempAlteredStoreImages.append(self.objMyStoreProduct.arrayProductImages[index])
                    }
                }
                
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                    
                    self.appDelegate?.dismissGlobalHUD()
                    self.loadSiderImages()
                }
            }
            
//            txtProdyctName.font = MySingleton.sharedManager().themeFontSixteenSizeBold
//            txtProdyctName.lineColor = .clear
            
            if self.objMyStoreProduct.strProductType == "1"
            {
                self.btnProductServiceTapped(btnProduct)
            }
            else
            {
                self.btnProductServiceTapped(btnService)
            }
            
            if self.objMyStoreProduct.strGift == ""
            {
                self.btnPromocodeTypeTapped(btnDiscountPromocode)
                self.txtDiscount.text = self.objMyStoreProduct.strDiscountedPrice
            }
            else
            {
                self.btnPromocodeTypeTapped(btnGiftPromocode)
                self.txtGiftText.text = self.objMyStoreProduct.strGift
            }
            
            if self.objMyStoreProduct.strIsPromo == "1"
            {
                self.boolIsPromocode = true
                imageViewPromocode.image = UIImage(named: "checkbox_square_black_selected")
                
                promocodeOfferTypeContainerView.isHidden = false
                viewPriceTypeContainer.isHidden = true
                viewPriceContainer.isHidden = false
                
            }
            else
            {
                self.boolIsPromocode = false
                imageViewPromocode.image = UIImage(named: "checkbox_square_black_normal")
                
                promocodeOfferTypeContainerView.isHidden = true
                viewPriceTypeContainer.isHidden = false
                
                if (boolIsFixedPrice == true)
                {
                    viewPriceContainer.isHidden = false
                }
                else
                {
                    viewPriceContainer.isHidden = true
                }
                
                viewDiscountContainer.isHidden = true
                viewGiftContainer.isHidden = true
            }
            
            txtProductName.text = self.objMyStoreProduct.strTitle
            
            let price: Float = Float(self.objMyStoreProduct.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
            
            if price == 0
            {
                self.btnFixedVariablePriceTapped(btnVariablePrice)
                self.txtPrice.text = self.objMyStoreProduct.strMoneyPrice
            }
            else
            {
                self.btnFixedVariablePriceTapped(btnFixedPrice)
                self.txtPrice.text = self.objMyStoreProduct.strMoneyPrice
            }
            
            txtViewDescription.text = self.objMyStoreProduct.strDescription
            
            if self.objMyStoreProduct.strNeedAddress == "1"
            {
                self.btnAddressNeededNotNeededTapped(btnAddNeeded)
            }
            else
            {
                self.btnAddressNeededNotNeededTapped(btnAddNotNeeded)
            }
            self.validationCheck()
        }
        else
        {
            self.isSliderImageLoaded = true
            //API CALL
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            dataManager.user_GetStoreDetails(strStoreID: strSelectedStoreID)
            //INNITIAL SETTINGS
            self.btnProductServiceTapped(btnProduct)
                        
            if ("\(UserDefaults.standard.value(forKey: "selected_store_visible") ?? "0")" == "1")
            {
                btnPromocodeContainerView.isHidden = false
                
                self.boolIsPromocode = true
                imageViewPromocode.image = UIImage(named: "checkbox_square_black_selected")
                
                promocodeOfferTypeContainerView.isHidden = false
                viewPriceTypeContainer.isHidden = true
                viewPriceContainer.isHidden = false
            }
            else
            {
                btnPromocodeContainerView.isHidden = true
                
                self.boolIsPromocode = false
                imageViewPromocode.image = UIImage(named: "checkbox_square_black_normal")
                
                promocodeOfferTypeContainerView.isHidden = true
                viewPriceTypeContainer.isHidden = false
                
                if (boolIsFixedPrice == true)
                {
                    viewPriceContainer.isHidden = false
                }
                else
                {
                    viewPriceContainer.isHidden = true
                }
                
                viewDiscountContainer.isHidden = true
                viewGiftContainer.isHidden = true
            }
        }
        
        self.validationCheck()
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
                selector: #selector(self.user_GetAllCountriesEvent),
                name: Notification.Name("user_GetAllCountriesEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetStoreDetailsEvent),
                name: Notification.Name("user_GetStoreDetailsEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_AddStoreProductEvent),
                name: Notification.Name("user_AddStoreProductEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_EditStoreProductEvent),
                name: Notification.Name("user_EditStoreProductEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllCountriesEvent()
    {
        DispatchQueue.main.async(execute: {
            self.dataRowsCity = dataManager.arrayAllCities
            self.dataRowsCityIDs = dataManager.arrayCityIDs
            self.dataRowsCityNames = dataManager.arrayCityNames
            
            self.txtSelectCity.optionArray = self.dataRowsCityNames
            self.txtSelectCity.optionIds = self.dataRowsCityIDs
            self.txtSelectCity.handleKeyboard = false
            self.txtSelectCity.isSearchEnable = false
            self.txtSelectCity.hideOptionsWhenSelect = true
            self.txtSelectCity.checkMarkEnabled = false
            self.txtSelectCity.selectedRowColor = (MySingleton.sharedManager().themeGlobalLightGreenColor?.withAlphaComponent(0.5))!
            
            self.txtSelectCity.listHeight =  (self.view.frame.size.height) / 3.5
            
            self.txtSelectCity.didSelect{(selectedText , index ,id) in
                
                self.intSelectedCityID = id
                self.strSelectedCityName = selectedText
                
                for index in 0...(self.dataRowsCity.count - 1)
                {
                    if (self.dataRowsCity[index].intCityID == id)
                    {
                        self.strSelectedStateID = self.dataRowsCity[index].strStateID
                    }
                }
                
                self.validationCheck()
            }
            
            for index in 0...(self.dataRowsCity.count - 1)
            {
                if (self.boolIsOpenForEdit)
                {
                    self.txtSelectCity?.isUserInteractionEnabled = false
                    
                    if (self.dataRowsCity[index].strCityID == self.objMyStoreProduct.strCityID)
                    {
                        self.txtSelectCity.selectedIndex = index
                        self.txtSelectCity.text = self.dataRowsCityNames[index]
                        self.intSelectedCityID = self.dataRowsCityIDs[index]
                        self.strSelectedCityName = self.dataRowsCityNames[index]
                        self.strSelectedStateID = self.dataRowsCity[index].strStateID
                    }
                }
                else
                {
                    self.txtSelectCity.isUserInteractionEnabled = true
                    
                    let strPrefCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
                    
                    if (self.dataRowsCity[index].strCityID == strPrefCityID)
                    {
                        self.txtSelectCity.selectedIndex = index
                        self.txtSelectCity.text = self.dataRowsCityNames[index]
                        self.intSelectedCityID = self.dataRowsCityIDs[index]
                        self.strSelectedCityName = self.dataRowsCityNames[index]
                        self.strSelectedStateID = self.dataRowsCity[index].strStateID
                    }
                }
            }
            self.validationCheck()
        })
    }
    
    @objc func user_GetStoreDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let intProductCount: Int = Int(dataManager.strProductCounts) ?? 0
            
            if (intProductCount == 10 && dataManager.objSelectedStoreDetails.strType != "1")
            {
                //show alert for 10
                let alertViewController = NYAlertViewController()
                
                // Set a title and message
                alertViewController.title = ""
                alertViewController.message = "Você atingiu o limite de 10 produtos do plano gratuito. Que tal ativar o plano Premium para ter mais destaque e poder cadastrar até 50 produtos?"
                
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
                
                alertViewController.cancelButtonColor = MySingleton.sharedManager().themeGlobalRedColor
                
                // Add alert actions
                let cancelAction = NYAlertAction(
                    title: "Não, obrigado",
                    style: .cancel,
                    handler: { (action: NYAlertAction!) -> Void in
                        
                        self.navigationController!.dismiss(animated: true, completion: {
                            
                            self.navigationController?.popViewController(animated: false)
                            
                        })
                })
                
                // Add alert actions
                let okAction = NYAlertAction(
                    title: "Ok",
                    style: .default,
                    handler: { (action: NYAlertAction!) -> Void in
                        
                        //NAVIGATE TO PURCHASE
                        let viewController: User_PurchasePremiumViewController = User_PurchasePremiumViewController()
                        viewController.boolIsOpendFromAddStore = false
                        self.navigationController?.pushViewController(viewController, animated: false)
                        
                })
                
                alertViewController.addAction(cancelAction)
                alertViewController.addAction(okAction)
                                    
                self.navigationController!.present(alertViewController, animated: true, completion: nil)
                
            }
            else if (intProductCount == 50)
            {
                //show alert for 50
                let alertViewController = NYAlertViewController()
                
                // Set a title and message
                alertViewController.title = ""
                alertViewController.message = "O plano Premium permite até 50 produtos cadastrados. Deseja ativar o plano Gold para poder ter até 200 produtos cadastrados ao mesmo tempo?"
                
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
                
                alertViewController.cancelButtonColor = MySingleton.sharedManager().themeGlobalRedColor
                
                // Add alert actions
                let cancelAction = NYAlertAction(
                    title: "Não",
                    style: .cancel,
                    handler: { (action: NYAlertAction!) -> Void in
                        
                        self.navigationController!.dismiss(animated: true, completion: {
                            
                            self.navigationController?.popViewController(animated: false)
                            
                        })
                })
                
                // Add alert actions
                let okAction = NYAlertAction(
                    title: "Sim",
                    style: .default,
                    handler: { (action: NYAlertAction!) -> Void in
                        
                        //NAVIGATE TO WHATSAPP
                        let originalString = "https://wa.me/5519983582177?text=I want to activate the Gold plan"
                        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                        
                        guard let url = URL(string: escapedString!) else {
                          return //be safe
                        }
                        
                        UIApplication.shared.open(url, options: [:], completionHandler: {_ in
                            
                        })
                        
                })
                
                alertViewController.addAction(cancelAction)
                alertViewController.addAction(okAction)
                                    
                self.navigationController!.present(alertViewController, animated: true, completion: nil)
            }
        })
    }
    
    @objc func user_AddStoreProductEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.navigationController?.popViewController(animated: false)
            
        })
    }
    
    @objc func user_EditStoreProductEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.navigationController?.popViewController(animated: false)
            
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnProductServiceTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if sender == btnProduct
        {
            boolIsProduct = true
            imageViewProduct.image = UIImage(named: "checkbox_selected_black.png")
            imageViewService.image = UIImage(named: "checkbox_normal.png")
            txtProductName.placeholder = "Nome do Produto"
            lblPriceTitle.text = "Preço do Produto"
        }
        else
        {
            boolIsProduct = false
            imageViewProduct.image = UIImage(named: "checkbox_normal.png")
            imageViewService.image = UIImage(named: "checkbox_selected_black.png")
            txtProductName.placeholder = "Nome do Serviço"
            lblPriceTitle.text = "Preço do Serviço"
        }
    }
    
    @IBAction func btnPromocodeTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if (boolIsPromocode == true)
        {
            boolIsPromocode = false
            imageViewPromocode.image = UIImage(named: "checkbox_square_black_normal")
            
            promocodeOfferTypeContainerView.isHidden = true
            viewPriceTypeContainer.isHidden = false
            if (boolIsFixedPrice == true)
            {
                viewPriceContainer.isHidden = false
            }
            else
            {
                viewPriceContainer.isHidden = true
            }
            viewDiscountContainer.isHidden = true
            viewGiftContainer.isHidden = true
        }
        else
        {
            boolIsPromocode = true
            imageViewPromocode.image = UIImage(named: "checkbox_square_black_selected")
            
            promocodeOfferTypeContainerView.isHidden = false
            viewPriceTypeContainer.isHidden = true
            viewPriceContainer.isHidden = false
            if (boolIsPromocodeTypeDiscount == true)
            {
                viewDiscountContainer.isHidden = false
                viewGiftContainer.isHidden = true
            }
            else
            {
                viewDiscountContainer.isHidden = true
                viewGiftContainer.isHidden = false
            }
        }
    }
    
    @IBAction func btnPromocodeTypeTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if sender == btnDiscountPromocode
        {
            boolIsPromocodeTypeDiscount = true
            imageViewDiscountPromocode.image = UIImage(named: "checkbox_selected_black.png")
            imageViewGiftPromocode.image = UIImage(named: "checkbox_normal.png")
            viewDiscountContainer.isHidden = false
            viewGiftContainer.isHidden = true
        }
        else
        {
            boolIsPromocodeTypeDiscount = false
            imageViewDiscountPromocode.image = UIImage(named: "checkbox_normal.png")
            imageViewGiftPromocode.image = UIImage(named: "checkbox_selected_black.png")
            viewDiscountContainer.isHidden = true
            viewGiftContainer.isHidden = false
        }
    }
    
    @IBAction func btnFixedVariablePriceTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if sender == btnFixedPrice
        {
            boolIsFixedPrice = true
            imageViewFixedPrice.image = UIImage(named: "checkbox_selected_black.png")
            imageViewVariablePrice.image = UIImage(named: "checkbox_normal.png")
            viewPriceContainer.isHidden = false
        }
        else
        {
            boolIsFixedPrice = false
            imageViewFixedPrice.image = UIImage(named: "checkbox_normal.png")
            imageViewVariablePrice.image = UIImage(named: "checkbox_selected_black.png")
            viewPriceContainer.isHidden = true
        }
    }
    
    @IBAction func btnAddressNeededNotNeededTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if sender == btnAddNeeded
        {
            boolIsAddressNeeded = true
            imageViewAddNeeded.image = UIImage(named: "checkbox_selected_black.png")
            imageViewAddNotNeeded.image = UIImage(named: "checkbox_normal.png")
        }
        else
        {
            boolIsAddressNeeded = false
            imageViewAddNeeded.image = UIImage(named: "checkbox_normal.png")
            imageViewAddNotNeeded.image = UIImage(named: "checkbox_selected_black.png")
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if txtProductName.text?.isEmpty == true
        {
            
        }
        else if (boolIsPromocode && txtPrice.text?.isEmpty == true) || (boolIsPromocode == false && boolIsFixedPrice && txtPrice.text?.isEmpty == true)
        {
            AppDelegate.showToast(message : "Please enter price", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
        }
        else if (boolIsPromocode && boolIsPromocodeTypeDiscount && txtDiscount.text?.isEmpty == true)
        {
            AppDelegate.showToast(message : "Please enter discount", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
        }
        else
        {
            
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            var txtValue: String = txtPrice.text ?? "0,00"
            txtValue = txtValue.replacingOccurrences(of: ".", with: "")
            txtValue = txtValue.replacingOccurrences(of: ",", with: ".")
            
            var txtDiscountValue: String = txtDiscount.text ?? "0,00"
            txtDiscountValue = txtDiscountValue.replacingOccurrences(of: ".", with: "")
            txtDiscountValue = txtDiscountValue.replacingOccurrences(of: ",", with: ".")
            
            //API CALL
            if (boolIsOpenForEdit)
            {
                dataManager.user_EditStoreProduct(
                    arrayProductImages: self.arraySelectedAttachments,
                    strStoreID: strSelectedStoreID,
                    strProductType: boolIsProduct ? "1" : "2",
                    strProductTitle: (txtProductName.text)!,
                    strDescription: (txtViewDescription.text)!,
                    strMoneyPrice: txtValue,
                    strCityID: "\(intSelectedCityID ?? 0)",
                    strIsNational: "0",
                    strIsNeedAddress: "1",//boolIsAddressNeeded ? "1" : "0",
                    strIsPromo: boolIsPromocode ? "1" : "0",
                    strDiscountedPrice: boolIsPromocodeTypeDiscount ? txtDiscountValue : "0",
                    strGift: boolIsPromocodeTypeDiscount ? "" : (txtGiftText.text)!,
                    strProductID: self.objMyStoreProduct.strID,
                    strDeletedImages: self.arrayDeletedImages.count > 0 ? self.arrayDeletedImages.joined(separator: ","): "")
            }
            else
            {
                dataManager.user_AddStoreProduct(
                    arrayProductImages: self.arraySelectedAttachments,
                    strStoreID: strSelectedStoreID,
                    strProductType: boolIsProduct ? "1" : "2",
                    strProductTitle: (txtProductName.text)!,
                    strDescription: (txtViewDescription.text)!,
                    strMoneyPrice: txtValue,
                    strCityID: "\(intSelectedCityID ?? 0)",
                    strIsNational: "0",
                    strIsNeedAddress: "1",//boolIsAddressNeeded ? "1" : "0"),
                    strIsPromo: boolIsPromocode ? "1" : "0",
                    strDiscountedPrice: boolIsPromocodeTypeDiscount ? txtDiscountValue : "0",
                    strGift: boolIsPromocodeTypeDiscount ? "" : (txtGiftText.text)!)
            }
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
        
        
        //IMAGE SLIDER
        imageScrollView.delegate = self
        imageScrollView.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        imageScrollView.clipsToBounds = true
        imageScrollView.isPagingEnabled = true
        
        //SETUP PAGE CONTROLL
        imagePageControl.isUserInteractionEnabled = false
        imagePageControl.currentPage = 0
        imagePageControl.numberOfPages = 0
        imagePageControl.pageIndicatorTintColor = MySingleton.sharedManager().themeGlobalWhiteColor
        imagePageControl.currentPageIndicatorTintColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        
        btnAddImage.titleLabel?.font = MySingleton.sharedManager().themeFontTwelveSizeBold
        btnAddImage.titleLabel?.textAlignment = .center
        btnAddImage.setTitle(NSLocalizedString("add_photo", value:"Adicionar foto", comment: ""), for: .normal)
        btnAddImage.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnAddImage.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnAddImage.clipsToBounds = true
        btnAddImage.layer.cornerRadius = 5
        btnAddImage.addTarget(self, action: #selector(self.btnAddImageClicked(_:)), for: .touchUpInside)
        
        txtProductName.delegate = self
        txtProductName.placeholder = "Nome do Produto"
        txtProductName.title = ""
        
        lblProdyctNameValidation?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblProdyctNameValidation?.textColor = MySingleton.sharedManager().themeGlobalRedColor
        
        txtPrice.delegate = self
        txtPrice.keyboardType = .numberPad
        txtPrice.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        txtDiscount.delegate = self
        txtDiscount.keyboardType = .numberPad
        txtDiscount.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        btnSave.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSave.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSave.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSave.clipsToBounds = true
        btnSave.layer.cornerRadius = 5
        
        //CITY
        txtSelectCity.isUserInteractionEnabled = false
        txtSelectCity.placeholder = NSLocalizedString("pick_city", value: "Escolha a cidade", comment: "")
        
        //DESCRIPTION
        txtViewDescription.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtViewDescription.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtViewDescription.placeholderColor = MySingleton.sharedManager().textfieldPlaceholderColor
        txtViewDescription.placeholder = "Inclua uma descrição (opcional)"
        
        //API CALL
        dataManager.user_GetAllCountries()
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func validationCheck()
    {
        if txtProductName.text?.isEmpty == true
        {
            btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
            lblProdyctNameValidation.text = "Preencher o nome do produto"
        }
        else if boolIsFixedPrice && txtPrice.text?.isEmpty == true
        {
            btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        }
        else
        {
            btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
            lblProdyctNameValidation.text = ""
        }
    }
    
    // MARK: - PRODUCT IMAGES METHODS
    
    func loadSiderImages()
    {
        //RELOAD SCROLL VIEW
        let subViews = self.imageScrollView?.subviews
        for subview in subViews!{
            subview.removeFromSuperview()
        }
        
        if (self.arraySelectedAttachments.count > 0)
        {
            self.photos = [MWPhoto]()
            self.photosData = [UIImage]()
            var i: Int = 0
            for imageData in self.arraySelectedAttachments
            {
                let width: CGFloat = (self.imageScrollView?.frame.size.width)!
                let height: CGFloat = (self.imageScrollView?.frame.size.height)!
                
                let imageView: UIImageView = UIImageView(frame: CGRect(x: (CGFloat(i) * width), y: 0, width: width, height: height))
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.image = UIImage(data: imageData)
                imageView.isUserInteractionEnabled = true
                imageView.tag = i
                
                self.photos.append(MWPhoto(image: UIImage(data: imageData)))
                self.photosData.append(UIImage(data: imageData)!)
                
                let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
                imageView.addGestureRecognizer(gesture)
                i = i + 1
                
                let btnCancel: UIButton = UIButton(frame: CGRect(x: (CGFloat(i) * width) - 40, y: 10, width: 30, height: 30))
                btnCancel.setBackgroundImage(UIImage(named: "ic_close_button.png"), for: .normal)
                btnCancel.tag = i - 1
                btnCancel.addTarget(self, action: #selector(self.btnCancelClicked(_:)), for: .touchUpInside)
                
                self.imageScrollView?.addSubview(imageView)
                self.imageScrollView?.addSubview(btnCancel)
            }
            
            self.imageScrollView?.contentSize = CGSize(width: (self.imageScrollView?.frame.size.width)! * CGFloat(self.arraySelectedAttachments.count), height: (self.imageScrollView?.frame.size.height)!)
            
            self.imagePageControl?.numberOfPages = self.arraySelectedAttachments.count
        }
        else
        {
            let width: CGFloat = (self.imageScrollView?.frame.size.width)!
            let height: CGFloat = (self.imageScrollView?.frame.size.height)!
            
            let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: "no_image_to_show.png")
            self.imageScrollView?.addSubview(imageView)
            
            self.imageScrollView?.contentSize = CGSize(width: (self.imageScrollView?.frame.size.width)!, height: (self.imageScrollView?.frame.size.height)!)
            
            self.imagePageControl?.numberOfPages = 0
        }
        
        if(self.imagePageControl?.numberOfPages == self.objMyStoreProduct.arrayProductImages.count)
        {
            self.isSliderImageLoaded = true
        }
    }
    
    @IBAction func btnAddImageClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if(self.isSliderImageLoaded)
        {
            if (arraySelectedAttachments.count < 6)
            {
                let viewController = TLPhotosPickerViewController(withPHAssets: {(assets) in // PHAssets
                    
                    let imageManager = PHImageManager.init()
                    let options = PHImageRequestOptions.init()
                    options.deliveryMode = .highQualityFormat
                    options.resizeMode = .exact
                    options.isSynchronous = true
                    options.isNetworkAccessAllowed = true
                                        
                    for asset: PHAsset in assets
                    {
                        let identifier = asset.value(forKey: "uniformTypeIdentifier") as! String
                        print("identifier: \(identifier)")
                        
                        print("image width before resizing: \(asset.pixelWidth)")
                        print("image height before resizing: \(asset.pixelHeight)")
                        
                        var targetWidth: CGFloat = 0
                        var targetHeight: CGFloat = 0
                        
                        if(asset.pixelWidth > asset.pixelHeight)
                        {
                            targetWidth = 1000
                            targetHeight = self.getProportionalHeightAccordingToWidth(widthToBeResizedIn: targetWidth, oldWidth: CGFloat(asset.pixelWidth), oldHeight: CGFloat(asset.pixelHeight))
                        }
                        else
                        {
                            targetHeight = 1000
                            targetWidth = self.getProportionalWidthAccordingToHeight(heightToBeResizedIn: targetHeight, oldWidth: CGFloat(asset.pixelWidth), oldHeight: CGFloat(asset.pixelHeight))
                        }
                        
                        let targetSize = CGSize(width: targetWidth, height: targetHeight)
                        
                        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                            
//                            print("image width after resizing: \(image!.size.width)")
//                            print("image height after resizing: \(image!.size.height)")
                            
                            if(identifier == "public.jpeg")
                            {
                                self.arraySelectedAttachments.append(image!.jpegData(compressionQuality: 1)!)
                                if (self.boolIsOpenForEdit)
                                {
                                    self.arraySelectedNewAttachments.append(image!.jpegData(compressionQuality: 1)!)
                                }
                            }
                            else
                            {
                                self.arraySelectedAttachments.append(image!.pngData()!)
                                if (self.boolIsOpenForEdit)
                                {
                                    self.arraySelectedNewAttachments.append(image!.pngData()!)
                                }
                            }
                        })
                    }
                    
                    print("\(self.arraySelectedAttachments.count)")
                    
                    //RELOAD SCROLL VIEW
                    let subViews = self.imageScrollView?.subviews
                    for subview in subViews!{
                        subview.removeFromSuperview()
                    }
                    
                    if (self.arraySelectedAttachments.count > 0)
                    {
                        self.photos = [MWPhoto]()
                        self.photosData = [UIImage]()
                        var i: Int = 0
                        for imageData in self.arraySelectedAttachments
                        {
                            let width: CGFloat = (self.imageScrollView?.frame.size.width)!
                            let height: CGFloat = (self.imageScrollView?.frame.size.height)!
                            
                            let imageView: UIImageView = UIImageView(frame: CGRect(x: (CGFloat(i) * width), y: 0, width: width, height: height))
                            imageView.contentMode = .scaleAspectFit
                            imageView.clipsToBounds = true
                            imageView.image = UIImage(data: imageData)
                            imageView.isUserInteractionEnabled = true
                            imageView.tag = i
                            
                            self.photos.append(MWPhoto(image: UIImage(data: imageData)))
                            self.photosData.append(imageView.image!)
                            
                            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
                            imageView.addGestureRecognizer(gesture)
                            i = i + 1
                            
                            let btnCancel: UIButton = UIButton(frame: CGRect(x: (CGFloat(i) * width) - 40, y: 10, width: 30, height: 30))
                            btnCancel.setBackgroundImage(UIImage(named: "ic_close_button.png"), for: .normal)
                            btnCancel.tag = i - 1
                            btnCancel.addTarget(self, action: #selector(self.btnCancelClicked(_:)), for: .touchUpInside)
                            
                            self.imageScrollView?.addSubview(imageView)
                            self.imageScrollView?.addSubview(btnCancel)
                        }
                        
                        self.imageScrollView?.contentSize = CGSize(width: (self.imageScrollView?.frame.size.width)! * CGFloat(self.arraySelectedAttachments.count), height: (self.imageScrollView?.frame.size.height)!)
                        
                        self.imagePageControl?.numberOfPages = self.arraySelectedAttachments.count
                    }
                    else
                    {
                        let width: CGFloat = (self.imageScrollView?.frame.size.width)!
                        let height: CGFloat = (self.imageScrollView?.frame.size.height)!
                        
                        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                        imageView.contentMode = .scaleAspectFill
                        imageView.clipsToBounds = true
                        imageView.image = UIImage(named: "no_image_to_show.png")
                        self.imageScrollView?.addSubview(imageView)
                        
                        self.imageScrollView?.contentSize = CGSize(width: (self.imageScrollView?.frame.size.width)!, height: (self.imageScrollView?.frame.size.height)!)
                        
                        self.imagePageControl?.numberOfPages = 0
                    }
                    
                }, didCancel: nil)
                viewController.didExceedMaximumNumberOfSelection = {(picker) in
                    //exceed max selection
                }
                viewController.handleNoAlbumPermissions = {(picker) in
                    // handle denied albums permissions case
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: false, completion: nil)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            let alertController = UIAlertController(title: "Allow photo album access?", message: "Need your permission to access photo albums", preferredStyle: .alert)
                            let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }
                            alertController.addAction(dismissAction)
                            alertController.addAction(settingsAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        })
                    }
                }
                viewController.handleNoCameraPermissions = {(picker) in
                    // handle denied camera permissions case
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: false, completion: nil)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            let alertController = UIAlertController(title: "Allow camera album access?", message: "Need your permission to take a photo", preferredStyle: .alert)
                            let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }
                            alertController.addAction(dismissAction)
                            alertController.addAction(settingsAction)

                            // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
                            picker.present(alertController, animated: true, completion: nil)
                        })
                    }
                }

                
//                viewController.selectedAssets = self.selectedAssets
                viewController.delegate = self
//                viewController.logDelegate = self
                
                var configure = TLPhotosPickerConfigure()
                configure.mediaType = .image
                configure.numberOfColumn = 3
                configure.maxSelectedAssets = 6 - arraySelectedAttachments.count
                configure.selectedColor = MySingleton.sharedManager().themeGlobalGreenColor!
                viewController.configure = configure
                
                self.present(viewController, animated: true, completion: nil)
            }
            else
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("maximum_number_of_images_selected", value:"Você já selecionou o número máximo de fotos", comment: ""))
            }
        }
        else
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("please_wait_while_we_are_still_loading_uploaded_images_store", value:"Por favor aguarde enquanto enviamos as fotos.", comment: ""))
        }
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {

          let vc=ImagePreviewViewController()
          vc.imgArray = self.photosData
            let indexPath = IndexPath(item: selectedImageIndex, section: 0)
           vc.passedContentOffset = indexPath
          self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        print("\(sender.tag)")
        
        self.arraySelectedAttachments.remove(at: sender.tag)
        
        if (self.boolIsOpenForEdit)
        {
            if (sender.tag < self.arrayTempAlteredStoreImages.count)
            {
                self.arrayDeletedImages.append(self.arrayTempAlteredStoreImages[sender.tag])
                self.arrayTempAlteredStoreImages.remove(at: sender.tag)
            }
        }
        
        //RELOAD SCROLL VIEW
        let subViews = self.imageScrollView?.subviews
        for subview in subViews!{
            subview.removeFromSuperview()
        }
        
        if (self.arraySelectedAttachments.count > 0)
        {
            self.photos = [MWPhoto]()
            self.photosData = [UIImage]()
            var i: Int = 0
            for imageData in self.arraySelectedAttachments
            {
                let width: CGFloat = (self.imageScrollView?.frame.size.width)!
                let height: CGFloat = (self.imageScrollView?.frame.size.height)!
                
                let imageView: UIImageView = UIImageView(frame: CGRect(x: (CGFloat(i) * width), y: 0, width: width, height: height))
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.image = UIImage(data: imageData)
                imageView.isUserInteractionEnabled = true
                imageView.tag = i
                
                self.photos.append(MWPhoto(image: UIImage(data: imageData)))
                self.photosData.append(imageView.image!)
                
                let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
                imageView.addGestureRecognizer(gesture)
                i = i + 1
                
                let btnCancel: UIButton = UIButton(frame: CGRect(x: (CGFloat(i) * width) - 40, y: 10, width: 30, height: 30))
                btnCancel.setBackgroundImage(UIImage(named: "ic_close_button.png"), for: .normal)
                btnCancel.tag = i - 1
                btnCancel.addTarget(self, action: #selector(self.btnCancelClicked(_:)), for: .touchUpInside)
                
                self.imageScrollView?.addSubview(imageView)
                self.imageScrollView?.addSubview(btnCancel)
            }
            
            self.imageScrollView?.contentSize = CGSize(width: (self.imageScrollView?.frame.size.width)! * CGFloat(self.arraySelectedAttachments.count), height: (self.imageScrollView?.frame.size.height)!)
            
            self.imagePageControl?.numberOfPages = self.arraySelectedAttachments.count
        }
        else
        {
            let width: CGFloat = (self.imageScrollView?.frame.size.width)!
            let height: CGFloat = (self.imageScrollView?.frame.size.height)!
            
            let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: "no_image_to_show.png")
            self.imageScrollView?.addSubview(imageView)
            
            self.imageScrollView?.contentSize = CGSize(width: (self.imageScrollView?.frame.size.width)!, height: (self.imageScrollView?.frame.size.height)!)
            
            self.imagePageControl?.numberOfPages = 0
        }
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.validationCheck()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView == imageScrollView)
        {
            let pageWidth : CGFloat = imageScrollView!.frame.size.width
            let page : Int = Int((imageScrollView?.contentOffset.x)!/pageWidth)
            imagePageControl?.currentPage = page
            selectedImageIndex = page
        }
    }
    
    // MARK: - Other Methods
    
    func getProportionalHeightAccordingToWidth(widthToBeResizedIn: CGFloat, oldWidth: CGFloat, oldHeight: CGFloat) -> CGFloat!
    {
        let scaleFactor:CGFloat = widthToBeResizedIn/oldWidth
        
        let newHeight:CGFloat = oldHeight * scaleFactor
        let newWidth:CGFloat = oldWidth * scaleFactor
        
        return newHeight
    }
    
    func getProportionalWidthAccordingToHeight(heightToBeResizedIn: CGFloat, oldWidth: CGFloat, oldHeight: CGFloat) -> CGFloat!
    {
        let scaleFactor:CGFloat = heightToBeResizedIn/oldHeight
        
        let newWidth:CGFloat = oldWidth * scaleFactor
        let newHeight:CGFloat = oldHeight * scaleFactor
        
        return newWidth
    }
    
    func resizeImageWithWidth(sourceImage: UIImage, widthToBeResizedIn: CGFloat) -> UIImage!
    {
        let oldWidth:CGFloat = sourceImage.size.width
        let scaleFactor:CGFloat = widthToBeResizedIn/oldWidth
        
        let newHeight:CGFloat = sourceImage.size.height * scaleFactor
        let newWidth:CGFloat = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeImageWithHeight(sourceImage: UIImage, heightToBeResizedIn: CGFloat) -> UIImage!
    {
        let oldHeight:CGFloat = sourceImage.size.height
        let scaleFactor:CGFloat = heightToBeResizedIn/oldHeight
        
        let newWidth:CGFloat = sourceImage.size.width * scaleFactor
        let newHeight:CGFloat = oldHeight * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}
