//
//  User_AddStoreViewController.swift
//  AgendaZap
//
//  Created by Dipen on 03/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import iOSDropDown
import TagListView
import SDWebImage
import MWPhotoBrowser
import MBProgressHUD
import JDFTooltips
import Firebase
import Photos
import TLPhotoPicker

class User_AddStoreViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, TagListViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, TLPhotosPickerViewControllerDelegate, UITextViewDelegate
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
    @IBOutlet var scrollContaineView: UIView?
    
    @IBOutlet var imageScrollView: UIScrollView?
    @IBOutlet var imagePageControl: UIPageControl?
    @IBOutlet var btnAddImage: UIButton?
    
    @IBOutlet var txtStoreName: SATextField?
    @IBOutlet var lblStoreNameValidation: UILabel?
    @IBOutlet var lblStoreDetails: UILabel?
    @IBOutlet var txtWhatsappNumber: SATextField?
    @IBOutlet var lblWhatsappNumberValidation: UILabel?
    @IBOutlet var txtEmail: SATextField?
    @IBOutlet var lblEmailValidation: UILabel?
    @IBOutlet var txtRua: SATextField?
    @IBOutlet var lblRuaValidation: UILabel?
    @IBOutlet var txtNumber: SATextField?
    @IBOutlet var lblNumberValidation: UILabel?
    @IBOutlet var txtBairro: SATextField?
    @IBOutlet var lblBairroValidation: UILabel?
    
    @IBOutlet var checkboxContainerView: UIView?
    @IBOutlet var imageViewCheckbox: UIImageView?
    @IBOutlet var lblCheckbox: UILabel?
    @IBOutlet var btnCheckbox: UIButton?
    
    //CITY
    @IBOutlet var txtSelectCityContainerView: UIView?
    @IBOutlet var txtSelectCity: DropDown?
    
    @IBOutlet var lblSelectSubCategory: UILabel?
    @IBOutlet var btnSubCategoryInfo: UIButton?
    //CATEGORY
    @IBOutlet var txtSelectCategoryContainerView: UIView?
    @IBOutlet var txtSelectCategory: DropDown?
    //SUB CATEGORY
    @IBOutlet var txtSelectSubCategoryContainerView: UIView?
    @IBOutlet var txtSelectSubCategory: DropDown?
    @IBOutlet var btnSelectSubCategory: UIButton?
    
    //SUBCATEGORY POPUP
    @IBOutlet var subCategoryContainerView: UIView?
    @IBOutlet var subCategoryInnerContainerView: UIView?
    @IBOutlet var subCategoryTableView: UITableView?
    @IBOutlet var btnSubCategoryOk: UIButton?
    
    //TAGS
    @IBOutlet var lblSelectTags: UILabel?
    @IBOutlet var btnTagsInfo: UIButton?
    @IBOutlet var txtEnterTagsContainerView: UIView?
    @IBOutlet var selectedTagListView: TagListView?
    @IBOutlet var txtEnterTags: SATextField?
    
    //DESCRIPTION
    @IBOutlet var lblEnterDescription: UILabel?
    @IBOutlet var btnEnterDescription: UIButton?
    @IBOutlet var txtViewEnterDescriptionContainerView: UIView?
    @IBOutlet var txtViewEnterDescription: UITextView?
    
    //FACEBOOK
    @IBOutlet var lblFacebookTitle: UILabel?
    @IBOutlet var lblFacebook: UILabel?
    @IBOutlet var txtFacebookContainerView: UIView?
    @IBOutlet var txtFacebook: UITextField?
    
    //INSTAGRAM
    @IBOutlet var lblInstagramTitle: UILabel?
    @IBOutlet var txtInstagramContainerView: UIView?
    @IBOutlet var txtInstagram: UITextField?
    
    //TIMINGS
    @IBOutlet var lblEnterTimings: UILabel?
    @IBOutlet var btnEnterTimings: UIButton?
    @IBOutlet var timingsTagListView: TagListView?
    
    @IBOutlet var txtTimingsContainerView: UIView?
    @IBOutlet var lblFrom: UILabel?
    @IBOutlet var txtFrom: SATextField?
    @IBOutlet var lblTo: UILabel?
    @IBOutlet var txtTo: SATextField?
    @IBOutlet var selectedTimingsTagListView: TagListView?
    
    @IBOutlet var btnSave: UIButton?
    
    @IBOutlet var categoryIsVisibleConstraint: NSLayoutConstraint!
    @IBOutlet var categoryIsHiddenConstraint: NSLayoutConstraint!
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
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
    
    //CATEGORY
    var dataRowsCategory = [ObjCategory]()
    var dataRowsCategoryIDs = [Int]()
    var dataRowsCategoryNames = [String]()
    
    var intSelectedCategoryID: Int?
    var strSelectedCategoryName: String?
    //SUBCATEGORY
    var dataRowsSubCategory = [ObjSubCategory]()
    var arraySelectedSubCategoryIDs = [ObjSubCategory]()
    
    var boolIsCheckboxSelected: Bool = false
    
    var arraySelectedTags = [String]()
    
    var arrayTimingDats = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Dom"]
    var arraySelectedTimingDats = ["1", "1", "1", "1", "1", "0", "0"]
    
    let datePickerFromTime = UIDatePicker()
    let datePickerToTime = UIDatePicker()
    
    var arraySelectedTimings = [String]()
    var arraySelectedTimingsFormated = [String]()
    
    //FOR EDIT
    var objMyStore: MyStore!
    var boolIsOpenForEdit: Bool!
    var arrayTempAlteredStoreImages = [String]()
    var isSliderImageLoaded : Bool!
    
    fileprivate var selectedImageIndex: Int = 0
    // MARK: - UIViewController Delegate Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isSliderImageLoaded = false
        
        dataManager.user_GetAllCountries()
        
        self.dataRowsCategory = dataManager.arrayAllCategoriesForAdd
        self.dataRowsCategoryIDs = [Int]()
        self.dataRowsCategoryNames = [String]()
        for objCategory in dataManager.arrayAllCategoriesForAdd
        {
            dataRowsCategoryIDs.append(Int(objCategory.strCategoryID) ?? 0)
            dataRowsCategoryNames.append(objCategory.strCategoryName)
        }
        
        self.setupNotificationEvent()
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        categoryIsVisibleConstraint.isActive = true
        categoryIsHiddenConstraint.isActive = false
        categoryIsHiddenConstraint.constant = 20
        
        if (self.boolIsOpenForEdit)
        {
            categoryIsVisibleConstraint.isActive = false
            categoryIsHiddenConstraint.isActive = true
            categoryIsHiddenConstraint.constant = 80
            
            arraySelectedAttachments = [Data]()
            arrayTempAlteredStoreImages = [String]()
            
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading store images.")
            
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                print("self.objMyStore.arrayStoreImages.count: \(self.objMyStore.arrayStoreImages.count)")
                
                for strImageURL in self.objMyStore.arrayStoreImages
                {
                    let url:NSURL = NSURL(string: strImageURL)!
                    print("url: \(url)")
                    
                    let data = try? Data(contentsOf: url as URL)
                    
                    if (data != nil)
                    {
                        self.arraySelectedAttachments.append(data ?? Data())
                    }
                }
                
                if(self.objMyStore.arrayStoreImages.count>0)
                {
                    for index in 0...(self.objMyStore.arrayStoreImages.count - 1)
                    {
                        self.arrayTempAlteredStoreImages.append(self.objMyStore.arrayStoreImages[index])
                    }
                }
                
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                    
                    self.appDelegate?.dismissGlobalHUD()
                    self.loadSiderImages()
                }
            }
            
            txtStoreName?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
            if (Int(objMyStore.strStatus) ?? 0 == 0)
            {
                //txtStoreName?.lineColor = .clear
                txtStoreName?.isUserInteractionEnabled = true
                txtWhatsappNumber?.isUserInteractionEnabled = true
                txtWhatsappNumber?.isHidden = false
                lblStoreDetails?.isHidden = true
            }
            else
            {
                txtStoreName?.lineColor = .clear
                txtStoreName?.isUserInteractionEnabled = false
                txtWhatsappNumber?.isUserInteractionEnabled = true
                txtWhatsappNumber?.isHidden = false
                lblStoreDetails?.isHidden = true
            }
            
            txtSelectCity?.isUserInteractionEnabled = true
            txtSelectCategory?.isUserInteractionEnabled = false
            txtSelectSubCategory?.isUserInteractionEnabled = false
            btnSelectSubCategory?.isUserInteractionEnabled = false
            
            
            txtSelectCityContainerView?.isHidden = false//true
            lblSelectSubCategory?.isHidden = true
            btnSubCategoryInfo?.isHidden = true
            txtSelectCategoryContainerView?.isHidden = true
            txtSelectSubCategoryContainerView?.isHidden = true
            
            txtStoreName?.text = objMyStore.strName
            txtWhatsappNumber?.text = objMyStore.strPhoneNumber
            lblStoreDetails?.text = "\(objMyStore.strPhoneNumber)\n\n\(objMyStore.strCityName)"
            txtEmail?.text = objMyStore.strEmail
            
            let arrayAddress = objMyStore.strAddress.components(separatedBy: "@")
            
            if (arrayAddress.count >= 1)
            {
                txtRua?.text = arrayAddress[0]
            }
            if (arrayAddress.count >= 2)
            {
                txtNumber?.text = arrayAddress[1]
            }
            if (arrayAddress.count >= 3)
            {
                txtBairro?.text = arrayAddress[2]
            }
            
            if (objMyStore.strIsHideAddress == "1")
            {
                boolIsCheckboxSelected = true
                imageViewCheckbox?.image = UIImage(named: "ic_green_tick.png")
            }
            else
            {
                boolIsCheckboxSelected = false
                imageViewCheckbox?.image = UIImage(named: "ic_grey_tick.png")
            }
            
            //CATEGORY
            //            for index in 0...(self.dataRowsCategory.count - 1)
            //            {
            //                if (self.dataRowsCategory[index].strCategoryID == self.objMyStore.str)
            //                {
            //                    self.txtSelectCategory?.selectedIndex = index
            //                    self.intSelectedCategoryID = self.dataRowsCategoryIDs[index]
            //                    self.strSelectedCategoryName = self.dataRowsCategoryNames[index]
            //                    //API CALL
            //                    dataManager.user_GetAllSubCategories(strCategoryID: "\(self.intSelectedCategoryID)")
            //                }
            //            }
            
            arraySelectedTags = objMyStore.strStoreTags.components(separatedBy: ",")
            
            self.selectedTagListView?.removeAllTags()
            self.selectedTagListView?.addTags(self.arraySelectedTags)
            
            if (self.arraySelectedTags.count > 0)
            {
                let subcategoriesLastRow: UIView = (self.selectedTagListView?.subviews[(self.selectedTagListView?.subviews.count)! - 1])!
                
                selectedTagListView?.heightConstaint?.constant = subcategoriesLastRow.frame.origin.y + subcategoriesLastRow.frame.size.height
            }
            else
            {
                selectedTagListView?.heightConstaint?.constant = 0
            }
            self.view.layoutIfNeeded()
            
            txtViewEnterDescription?.text = objMyStore.strDescription
            
            //TIMINGS
            arraySelectedTimings = objMyStore.arrayStoreTimings
            arraySelectedTimingsFormated = objMyStore.arrayStoreTimingsFormated
            
            self.selectedTimingsTagListView?.removeAllTags()
            self.selectedTimingsTagListView?.addTags(self.arraySelectedTimingsFormated)
            
            if (self.arraySelectedTimingsFormated.count > 0)
            {
                let selectedTimingsLastRow: UIView = (self.selectedTimingsTagListView?.subviews[(self.selectedTimingsTagListView?.subviews.count)! - 1])!
                
                selectedTimingsTagListView?.heightConstaint?.constant = selectedTimingsLastRow.frame.origin.y + selectedTimingsLastRow.frame.size.height
            }
            else
            {
                selectedTimingsTagListView?.heightConstaint?.constant = 0
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
                selector: #selector(self.user_GetAllSubCategoriesEvent),
                name: Notification.Name("user_GetAllSubCategoriesEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_AddStoreEvent),
                name: Notification.Name("user_AddStoreEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_EditStoreEvent),
                name: Notification.Name("user_EditStoreEvent"),
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
            
            self.txtSelectCity?.optionArray = self.dataRowsCityNames
            self.txtSelectCity?.optionIds = self.dataRowsCityIDs
            self.txtSelectCity?.handleKeyboard = false
            self.txtSelectCity?.isSearchEnable = false
            self.txtSelectCity?.hideOptionsWhenSelect = true
            self.txtSelectCity?.checkMarkEnabled = false
            self.txtSelectCity?.selectedRowColor = (MySingleton.sharedManager().themeGlobalLightGreenColor?.withAlphaComponent(0.5))!
            
            self.txtSelectCity?.listHeight =  (self.mainScrollView?.frame.size.height)! / 3
            
            self.txtSelectCity?.didSelect{(selectedText , index ,id) in
                
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
                    
                    if (self.dataRowsCity[index].strCityID == self.objMyStore.strCityID)
                    {
                        self.txtSelectCity?.selectedIndex = index
                        self.txtSelectCity?.text = self.dataRowsCityNames[index]
                        self.intSelectedCityID = self.dataRowsCityIDs[index]
                        self.strSelectedCityName = self.dataRowsCityNames[index]
                        self.strSelectedStateID = self.dataRowsCity[index].strStateID
                    }
                }
                else
                {
                    self.txtSelectCity?.isUserInteractionEnabled = true
                    
                    let strPrefCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
                    
                    if (self.dataRowsCity[index].strCityID == strPrefCityID)
                    {
                        self.txtSelectCity?.selectedIndex = index
                        self.txtSelectCity?.text = self.dataRowsCityNames[index]
                        self.intSelectedCityID = self.dataRowsCityIDs[index]
                        self.strSelectedCityName = self.dataRowsCityNames[index]
                        self.strSelectedStateID = self.dataRowsCity[index].strStateID
                    }
                }
            }
            self.validationCheck()
        })
    }
    
    @objc func user_GetAllSubCategoriesEvent()
    {
        DispatchQueue.main.async(execute: {
            self.dataRowsSubCategory = dataManager.arrayAllSubCategories
            self.subCategoryTableView?.reloadData()
        })
    }
    
    @objc func user_AddStoreEvent()
    {
        DispatchQueue.main.async(execute: {
            
            print("SUCCESS")
            
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            //            alertViewController.title = NSLocalizedString("activity_add_your_store_success_dialog_title", value:"Your store was successfully received", comment: "")
            //            alertViewController.message = NSLocalizedString("activity_add_your_store_success_dialog_details", value:"We\'ll analyze all date you send and if your store got approved, it will be shown on our searches", comment: "")
            
            alertViewController.title = NSLocalizedString("store_creation_title", value:"Cadastro enviado! Aguardando aprovação", comment: "")
            alertViewController.message = NSLocalizedString("store_creation_Description", value:"Em até 48h enviaremos uma mensagem em seu WhatsApp para confirmação. O cadastro é gratuito!", comment: "")
            
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
                    
                    let viewController: User_PurchasePremiumViewController = User_PurchasePremiumViewController()
                    viewController.boolIsOpendFromAddStore = true
                    self.navigationController?.pushViewController(viewController, animated: false)
            })
            
            alertViewController.addAction(okAction)
            
            self.navigationController!.present(alertViewController, animated: true, completion: nil)
            
        })
    }
    
    @objc func user_EditStoreEvent()
    {
        DispatchQueue.main.async(execute: {
            
            print("SUCCESS")
            
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = NSLocalizedString("activity_edit_your_store_success_dialog_title", value:"Request sent successfully", comment: "")
            alertViewController.message = NSLocalizedString("activity_edit_your_store_success_dialog_details", value:"Once the modifications are approved they will appear in your store.", comment: "")
            
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
                    
                    self.navigationController?.popViewController(animated: false)
            })
            
            alertViewController.addAction(okAction)
            
            self.navigationController!.present(alertViewController, animated: true, completion: nil)
            
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.txtSelectCategory?.listHeight = (self.mainScrollView?.frame.size.height)! / 3
        
        subCategoryContainerView?.frame.size = self.view.frame.size
        
        txtSelectCityContainerView?.layer.masksToBounds = false
        txtSelectCityContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        txtSelectCityContainerView?.layer.shadowPath = UIBezierPath(roundedRect: txtSelectCityContainerView!.bounds, cornerRadius: (txtSelectCityContainerView?.layer.cornerRadius)!).cgPath
        txtSelectCityContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        txtSelectCityContainerView?.layer.shadowOpacity = 0.5
        txtSelectCityContainerView?.layer.shadowRadius = 1.0
        
        self.loadSiderImages()
    }
    
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
        
        if(self.imagePageControl?.numberOfPages == self.objMyStore.arrayStoreImages.count)
        {
            self.isSliderImageLoaded = true
        }
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("register_your_store", value:"Criar novo negócio", comment: "")
        
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
        
        scrollContaineView?.backgroundColor = .clear
        
        
        //IMAGE SLIDER
        imageScrollView?.delegate = self
        imageScrollView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        imageScrollView?.clipsToBounds = true
        imageScrollView?.isPagingEnabled = true
        
        //SETUP PAGE CONTROLL
        imagePageControl?.isUserInteractionEnabled = false
        imagePageControl?.currentPage = 0
        imagePageControl?.numberOfPages = 0
        imagePageControl?.pageIndicatorTintColor = MySingleton.sharedManager().themeGlobalWhiteColor
        imagePageControl?.currentPageIndicatorTintColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        
        btnAddImage?.titleLabel?.font = MySingleton.sharedManager().themeFontTwelveSizeBold
        btnAddImage?.titleLabel?.textAlignment = .center
        btnAddImage?.setTitle(NSLocalizedString("add_photo", value:"Adicionar foto", comment: ""), for: .normal)
        btnAddImage?.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnAddImage?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnAddImage?.clipsToBounds = true
        btnAddImage?.layer.cornerRadius = 5
        btnAddImage?.addTarget(self, action: #selector(self.btnAddImageClicked(_:)), for: .touchUpInside)
        
        
//        self.browser = MWPhotoBrowser(delegate: self)
//
//        // Set options
//        self.browser.displayActionButton = true//TRUE
//        self.browser.displayNavArrows = true
//        self.browser.displaySelectionButtons = false
//        self.browser.alwaysShowControls = false
//        self.browser.zoomPhotosToFill = false
//        self.browser.enableGrid = false
//        self.browser.startOnGrid = false
//        self.browser.enableSwipeToDismiss = false
//        self.browser.autoPlayOnAppear = false
//        self.browser.setCurrentPhotoIndex(0)
//
//        self.browser.showNextPhoto(animated: true)
//        self.browser.showPreviousPhoto(animated: true)
        
        
        //========== PRATIK GUJARATI TEMP DATA ==========//
        //        txtStoreName?.text = "a"
        //        txtWhatsappNumber?.text = "1234567890"
        //        txtEmail?.text = "a@a.com"
        //        txtRua?.text = "a"
        //        txtNumber?.text = "1"
        //        txtBairro?.text = "a"
        //========== PRATIK GUJARATI TEMP DATA ==========//
        
        txtStoreName?.delegate = self
        txtStoreName?.placeholder = NSLocalizedString("activity_edit_store_store_name_hint_1", value:"Nome do negócio (max 32 caracteres)", comment: "")
        txtStoreName?.title = ""
        txtStoreName!.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        lblStoreNameValidation?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblStoreNameValidation?.textColor = MySingleton.sharedManager().themeGlobalRedColor
        
        lblStoreDetails?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblStoreDetails?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblStoreDetails?.isHidden = true
        lblStoreDetails?.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionNew))
        lblStoreDetails?.addGestureRecognizer(gesture)
        
        txtWhatsappNumber?.delegate = self
        txtWhatsappNumber?.placeholder = NSLocalizedString("activity_edit_store_store_phone_number_hint", value:"Número do WhatsApp (com DDD)", comment: "")
        txtWhatsappNumber?.title = ""
        txtWhatsappNumber?.keyboardType = .phonePad
        txtWhatsappNumber!.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        lblWhatsappNumberValidation?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblWhatsappNumberValidation?.textColor = MySingleton.sharedManager().themeGlobalRedColor
        
        txtEmail?.delegate = self
        txtEmail?.placeholder = NSLocalizedString("activity_edit_store_store_email_address_hint", value:"Email", comment: "")
        txtEmail?.title = ""
        txtEmail?.keyboardType = .emailAddress
        txtEmail!.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        lblEmailValidation?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblEmailValidation?.textColor = MySingleton.sharedManager().themeGlobalRedColor
        
        txtRua?.delegate = self
        txtRua?.placeholder = NSLocalizedString("activity_edit_store_street_name_hint", value:"Rua", comment: "")
        txtRua?.title = ""
        txtRua!.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        lblRuaValidation?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblRuaValidation?.textColor = MySingleton.sharedManager().themeGlobalRedColor
        
        txtNumber?.delegate = self
        txtNumber?.placeholder = NSLocalizedString("activity_edit_store_street_number_hint", value:"Número", comment: "")
        txtNumber?.title = ""
        txtNumber?.keyboardType = .numberPad
        txtNumber!.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        lblNumberValidation?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblNumberValidation?.textColor = MySingleton.sharedManager().themeGlobalRedColor
        
        txtBairro?.delegate = self
        txtBairro?.placeholder = NSLocalizedString("activity_edit_store_neighbourhood_hint", value:"Bairro", comment: "")
        txtBairro?.title = ""
        txtBairro!.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        lblBairroValidation?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblBairroValidation?.textColor = MySingleton.sharedManager().themeGlobalRedColor
        
        //CHECKBOC
        checkboxContainerView?.backgroundColor = .clear
        
        imageViewCheckbox?.image = UIImage(named: "ic_grey_tick.png")
        lblCheckbox?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblCheckbox?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblCheckbox?.numberOfLines = 0
        lblCheckbox?.text = NSLocalizedString("activity_edit_store_chechbox_msg", value:"Esconder minha rua e número, mostrando somente o bairro", comment: "")
        btnCheckbox?.tintColor = .clear
        btnCheckbox?.addTarget(self, action: #selector(self.btnCheckboxClicked(_:)), for: .touchUpInside)
        
        //CITY
        txtSelectCityContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtSelectCityContainerView?.layer.cornerRadius = 5.0
        
        txtSelectCity?.isUserInteractionEnabled = false
        txtSelectCity?.placeholder = NSLocalizedString("pick_city", value: "Escolha a cidade", comment: "")
        
        //SUBCATEGORY
        lblSelectSubCategory?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblSelectSubCategory?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblSelectSubCategory?.text = NSLocalizedString("select_subcategory_hint", value: "Subcategoria do seu negócio:", comment: "")
        
        btnSubCategoryInfo?.addTarget(self, action: #selector(self.btnInfoClicked(_:)), for: .touchUpInside)
        
        txtSelectCategoryContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtSelectCategoryContainerView?.layer.cornerRadius = 5.0
        
        txtSelectCategory?.placeholder = NSLocalizedString("pick_category", value: "Escolha a Categoria", comment: "")
        
        self.txtSelectCategory?.isUserInteractionEnabled = true
        self.txtSelectCategory?.optionArray = self.dataRowsCategoryNames
        self.txtSelectCategory?.optionIds = self.dataRowsCategoryIDs
        self.txtSelectCategory?.handleKeyboard = false
        self.txtSelectCategory?.isSearchEnable = false
        self.txtSelectCategory?.hideOptionsWhenSelect = true
        self.txtSelectCategory?.checkMarkEnabled = false
        self.txtSelectCategory?.selectedRowColor = (MySingleton.sharedManager().themeGlobalLightGreenColor?.withAlphaComponent(0.5))!
        
        self.txtSelectCategory?.didSelect{(selectedText , index ,id) in
            
            self.intSelectedCategoryID = id
            self.strSelectedCategoryName = selectedText
            
            //API CALL
            dataManager.user_GetAllSubCategoriesForAddStore(strCategoryID: "\(id)")
        }
        
        txtSelectSubCategoryContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtSelectSubCategoryContainerView?.layer.cornerRadius = 5.0
        
        //txtSelectSubCategory?.isUserInteractionEnabled = false
        txtSelectSubCategory?.placeholder = NSLocalizedString("pick_sub_category", value: "Escolha a subcategoria", comment: "")
        
        btnSelectSubCategory?.tintColor = .clear
        btnSelectSubCategory?.addTarget(self, action: #selector(self.btnSelectSubCategoryClicked(_:)), for: .touchUpInside)
        
        //SUB CATEGORY POPUP
        subCategoryContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBlackColor?.withAlphaComponent(0.5)
        
        subCategoryInnerContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        subCategoryTableView?.delegate = self
        subCategoryTableView?.dataSource = self
        subCategoryTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        subCategoryTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalWhiteColor
        
        btnSubCategoryOk?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSubCategoryOk?.backgroundColor = UIColor.clear
        btnSubCategoryOk?.setTitle(NSLocalizedString("ok", value: "OK", comment: ""), for: .normal)
        btnSubCategoryOk?.setTitleColor(MySingleton.sharedManager().themeGlobalLightGreenColor, for: .normal)
        btnSubCategoryOk?.addTarget(self, action: #selector(self.btnSubCategoryOkClicked(_:)), for: .touchUpInside)
        
        //TAGS
        lblSelectTags?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblSelectTags?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblSelectTags?.text = NSLocalizedString("add_tags", value: "Adicione palavras-chave que identificam o seu negócio:", comment: "")
        
        btnTagsInfo?.addTarget(self, action: #selector(self.btnInfoClicked(_:)), for: .touchUpInside)
        
        txtEnterTags?.delegate = self
        txtEnterTags?.placeholder = NSLocalizedString("enter_tags", value:"Escreva uma palavra e use enter para adiciona-la", comment: "")
        txtEnterTags?.title = ""
        txtEnterTags?.lineColor = UIColor.clear
        txtEnterTags?.selectedLineColor = UIColor.clear
        
        selectedTagListView?.delegate = self
        selectedTagListView?.textFont = MySingleton.sharedManager().themeFontFourteenSizeRegular!
        selectedTagListView?.textColor = MySingleton.sharedManager().themeGlobalBlackColor!
        selectedTagListView?.cornerRadius = 12
        selectedTagListView?.alignment = .left
        selectedTagListView?.tagBackgroundColor = MySingleton.sharedManager().themeGlobalLightGreyColor!
        selectedTagListView?.clipsToBounds = true
        selectedTagListView?.enableRemoveButton = true
        selectedTagListView?.removeButtonIconSize = 10
        selectedTagListView?.removeIconLineColor = MySingleton.sharedManager().themeGlobalDarkGreyColor!
        
        //DESCRIPTION
        lblEnterDescription?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblEnterDescription?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblEnterDescription?.text = NSLocalizedString("activity_edit_store_description_title", value: "Escreva uma breve descrição do seu negócio:", comment: "")
        
        btnEnterDescription?.addTarget(self, action: #selector(self.btnInfoClicked(_:)), for: .touchUpInside)
        
        txtViewEnterDescriptionContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtViewEnterDescriptionContainerView?.layer.cornerRadius = 5.0
        
        txtViewEnterDescription?.delegate = self
        txtViewEnterDescription?.font = txtEnterTags?.font
        txtViewEnterDescription?.textColor = txtEnterTags?.textColor
        txtViewEnterDescription?.placeholderColor = txtEnterTags?.placeholderColor
        txtViewEnterDescription?.placeholder = NSLocalizedString("activity_edit_store_description_hint", value: "Escreva um descrição sobre o seu negócio, essa descrição poderá ajudar um cliente a escolher o seu negócio.", comment: "")
        
        //FACEBOOK
        lblFacebookTitle?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblFacebookTitle?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblFacebookTitle?.text = NSLocalizedString("facebook_title_edit", value: "Link do seu Facebook\n(ex.: https://www.facebook.com/seu.nome)", comment: "")
        
        lblFacebook?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblFacebook?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        txtFacebookContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtFacebookContainerView?.layer.cornerRadius = 5.0
        
        txtFacebook?.delegate = self
        txtFacebook?.font = txtEnterTags?.font
        txtFacebook?.textColor = txtEnterTags?.textColor
        txtFacebook?.placeholder = NSLocalizedString("facebook_placeholder_edit", value: "nome", comment: "")
        
        //INSTAGRAM
        lblInstagramTitle?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblInstagramTitle?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblInstagramTitle?.text = NSLocalizedString("instagram_title_edit", value: "Usuário Instagram (ex.: @seunome)", comment: "")
        
        txtInstagram?.delegate = self
        txtInstagram?.font = txtEnterTags?.font
        txtInstagram?.textColor = txtEnterTags?.textColor
        txtInstagram?.placeholder = ""
        
        //TIMINGS
        lblEnterTimings?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblEnterTimings?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblEnterTimings?.text = NSLocalizedString("funcionamento_do", value: "Horários de funcionamento do seu negócio:", comment: "")
        
        btnEnterTimings?.addTarget(self, action: #selector(self.btnInfoClicked(_:)), for: .touchUpInside)
        
        timingsTagListView?.delegate = self
        timingsTagListView?.backgroundColor = UIColor.clear
        timingsTagListView?.textFont = MySingleton.sharedManager().themeFontFourteenSizeRegular!
        timingsTagListView?.textColor = MySingleton.sharedManager().themeGlobalBlackColor!
        timingsTagListView?.cornerRadius = 12
        timingsTagListView?.alignment = .left
        timingsTagListView?.tagBackgroundColor = MySingleton.sharedManager().themeGlobalLightGreyColor!
        timingsTagListView?.clipsToBounds = true
        timingsTagListView?.removeIconLineColor = MySingleton.sharedManager().themeGlobalDarkGreyColor!
        timingsTagListView?.tagSelectedBackgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        timingsTagListView?.addTags(self.arrayTimingDats)
        
        //        for tagView in timingsTagListView!.tagViews
        //        {
        //            tagView.isSelected = true
        //        }
        
        timingsTagListView!.tagViews[0].isSelected = true
        timingsTagListView!.tagViews[1].isSelected = true
        timingsTagListView!.tagViews[2].isSelected = true
        timingsTagListView!.tagViews[3].isSelected = true
        timingsTagListView!.tagViews[4].isSelected = true
        
        txtTimingsContainerView?.backgroundColor = UIColor.clear
        
        lblFrom?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblFrom?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblFrom?.text = "Início"
        
        txtFrom?.delegate = self
        txtFrom?.placeholder = "00:00"
        txtFrom?.title = ""
        datePickerFromTime.datePickerMode = .time
        datePickerFromTime.addTarget(self, action: #selector(self.datePickerValueChange(_:)), for: .valueChanged)
        txtFrom?.inputView = datePickerFromTime
        
        lblTo?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblTo?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblTo?.text = "Fim"
        
        txtTo?.delegate = self
        txtTo?.placeholder = "00:00"
        txtTo?.title = ""
        datePickerToTime.datePickerMode = .time
        datePickerToTime.addTarget(self, action: #selector(self.datePickerValueChange(_:)), for: .valueChanged)
        txtTo?.inputView = datePickerToTime
        
        selectedTimingsTagListView?.delegate = self
        selectedTimingsTagListView?.backgroundColor = UIColor.clear
        selectedTimingsTagListView?.textFont = MySingleton.sharedManager().themeFontFourteenSizeRegular!
        selectedTimingsTagListView?.textColor = MySingleton.sharedManager().themeGlobalBlackColor!
        selectedTimingsTagListView?.cornerRadius = 12
        selectedTimingsTagListView?.alignment = .left
        selectedTimingsTagListView?.tagBackgroundColor = MySingleton.sharedManager().themeGlobalLightGreyColor!
        selectedTimingsTagListView?.clipsToBounds = true
        selectedTimingsTagListView?.enableRemoveButton = true
        selectedTimingsTagListView?.removeButtonIconSize = 10
        selectedTimingsTagListView?.removeIconLineColor = MySingleton.sharedManager().themeGlobalDarkGreyColor!
        
        btnSave?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        if (self.boolIsOpenForEdit)
        {
               btnSave?.setTitle(NSLocalizedString("Edit_store_Save_button", value:"Salvar alterações", comment: ""), for: .normal)
        }else{
               btnSave?.setTitle(NSLocalizedString("signup_button", value:"Finalizar Cadastro", comment: ""), for: .normal)
        }
     
        btnSave?.setTitleColor( MySingleton.sharedManager() .themeGlobalWhiteColor, for: .normal)
        btnSave?.clipsToBounds = true
        btnSave?.layer.cornerRadius = 5
        btnSave?.addTarget(self, action: #selector(self.btnSaveClicked(_:)), for: .touchUpInside)
    }
    
    @objc func checkActionNew(sender : UITapGestureRecognizer) {
        // Do what you want
        
        self.appDelegate?.showAlertViewWithTitle(title: "", detail: "Para mudar o nome ou telefone contate os administradores.")
    }
    
    @IBAction func datePickerValueChange(_ sender: UIDatePicker)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        if (sender == datePickerFromTime)
        {
            datePickerToTime.minimumDate = datePickerFromTime.date
            txtFrom?.text = formatter.string(from: datePickerFromTime.date)
            
        }
        else
        {
            datePickerFromTime.maximumDate = datePickerToTime.date
            txtTo?.text = formatter.string(from: datePickerToTime.date)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        self.validationCheck()
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (self.boolIsOpenForEdit)
        {
            if ((self.txtStoreName?.text?.count)! <= 0 ||
                (self.txtWhatsappNumber?.text?.count)! <= 0 ||
                (self.txtEmail?.text?.count)! <= 0 ||
                (self.txtRua?.text?.count)! <= 0 ||
                (self.txtNumber?.text?.count)! <= 0 ||
                (self.txtBairro?.text?.count)! <= 0 ||
                self.strSelectedCityName == nil ||
                (self.strSelectedCityName?.count)! <= 0)
            {
                if ((self.strSelectedCityName?.count)! <= 0)
                {
                    appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("please_selete_city", value:"Selecione a Cidade!", comment: ""))
                }
            }
            else
            {
                //let intMobileNumber: Int = Int(txtWhatsappNumber!.text ?? "0")!
                let intMobileNumber = Int(txtWhatsappNumber!.text!) ?? 0
                if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
                {
                    if (objCommonUtility.isValidEmailAddress(strEmailString: (txtEmail?.text)!) == false)
                     {
                         
                     }
                     else
                     {
                         var strIsHideAddress: String = "0"
                         if (self.boolIsCheckboxSelected)
                         {
                             strIsHideAddress = "1"
                         }
                         
                         let arraySelectedSubCat = [String]()
                         //for ObjSubCategory in self.arraySelectedSubCategoryIDs
                         //{
                         //    arraySelectedSubCat.append(ObjSubCategory.strSubCategoryID)
                         //}
                         
                        if (txtFacebook?.text?.contains(find: "https://www.facebook.com/") == true)
                        {
                        }
                        
                         dataManager.user_EditStore(
                            strStoreID: objMyStore.strID,
                            arrayStoreImages: self.arraySelectedNewAttachments,
                            strStoreName: (txtStoreName?.text)!,
                            strStorePhoneNumber: (txtWhatsappNumber?.text)!,
                            strEmail: (txtEmail?.text)!,
                            strStoreAddress: "\((txtRua?.text)!)@\((txtNumber?.text)!)@\((txtBairro?.text)!)",
                            strIsHideAddress: strIsHideAddress,
                            strStoreCityID: "\(intSelectedCityID ?? 0)",
                            strStoreStateID: strSelectedStateID ?? "",
                            strStoreSubcategoryIDs: arraySelectedSubCat,
                            arrayTags: self.arraySelectedTags,
                            strStoreDescription: (txtViewEnterDescription?.text)!,
                            strFacebookLink: txtFacebook?.text != "" ? "\((lblFacebook?.text)!)\((txtFacebook?.text)!)".replacingOccurrences(of: "https://www.facebook.com/", with: "") : "",
                            strInstagramLink: (txtInstagram?.text)!.replacingOccurrences(of: "@", with: ""),
                            arrayStoreTimings: self.arraySelectedTimings,
                            arrayDeletedImages: self.arrayDeletedImages)
                     }
//                    let first2 = String("\(intMobileNumber)".prefix(2))
//
//                    if (first2 == "55")
//                    {
//                        appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: ""))
//                    }
//                    else
//                    {
//                        if (objCommonUtility.isValidEmailAddress(strEmailString: (txtEmail?.text)!) == false)
//                        {
//
//                        }
//                        else
//                        {
//                            var strIsHideAddress: String = "0"
//                            if (self.boolIsCheckboxSelected)
//                            {
//                                strIsHideAddress = "1"
//                            }
//
//                            let arraySelectedSubCat = [String]()
//                            //for ObjSubCategory in self.arraySelectedSubCategoryIDs
//                            //{
//                            //    arraySelectedSubCat.append(ObjSubCategory.strSubCategoryID)
//                            //}
//
//                            dataManager.user_EditStore(strStoreID: objMyStore.strID, arrayStoreImages: self.arraySelectedNewAttachments, strStoreName: (txtStoreName?.text)!, strStorePhoneNumber: (txtWhatsappNumber?.text)!, strEmail: (txtEmail?.text)!, strStoreAddress: "\((txtRua?.text)!)@\((txtNumber?.text)!)@\((txtBairro?.text)!)", strIsHideAddress: strIsHideAddress, strStoreCityID: "\(intSelectedCityID ?? 0)", strStoreStateID: strSelectedStateID ?? "", strStoreSubcategoryIDs: arraySelectedSubCat, arrayTags: self.arraySelectedTags, strStoreDescription: (txtViewEnterDescription?.text)!, arrayStoreTimings: self.arraySelectedTimings, arrayDeletedImages: self.arrayDeletedImages)
//                        }
//                    }
                }
            }
        }
        else
        {
            if ((self.txtStoreName?.text?.count)! <= 0 ||
                (self.txtWhatsappNumber?.text?.count)! <= 0 ||
                (self.txtEmail?.text?.count)! <= 0 ||
                (self.txtRua?.text?.count)! <= 0 ||
                (self.txtNumber?.text?.count)! <= 0 ||
                (self.txtBairro?.text?.count)! <= 0 ||
                self.strSelectedCityName == nil ||
                (self.strSelectedCityName?.count)! <= 0 ||
                self.strSelectedCategoryName == nil ||
                (self.strSelectedCategoryName?.count)! <= 0 ||
                self.arraySelectedSubCategoryIDs.count <= 0)
            {
                if ((self.strSelectedCityName?.count)! <= 0)
                {
                    appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("please_selete_city", value:"Selecione a Cidade!", comment: ""))
                }
                else if (self.strSelectedCategoryName == nil || (self.strSelectedCategoryName?.count)! <= 0)
                {
                    appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("please_selete_category", value:"Selecione a categoria antes!", comment: ""))
                }
                else if (self.arraySelectedSubCategoryIDs.count <= 0)
                {
                    appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("please_selete_subcategory", value:"Selecione a subcategoria antes!", comment: ""))
                }
            }
            else
            {
                // let intMobileNumber: Int = Int(txtWhatsappNumber!.text ?? "0")!
                let intMobileNumber = Int(txtWhatsappNumber!.text!) ?? 0
                if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
                {
                    if (objCommonUtility.isValidEmailAddress(strEmailString: (txtEmail?.text)!) == false)
                   {
                       
                   }
                   else
                   {
                       var strIsHideAddress: String = "0"
                       if (self.boolIsCheckboxSelected)
                       {
                           strIsHideAddress = "1"
                       }
                       
                       var arraySelectedSubCat = [String]()
                       for ObjSubCategory in self.arraySelectedSubCategoryIDs
                       {
                           arraySelectedSubCat.append(ObjSubCategory.strSubCategoryID)
                       }
                       
                       dataManager.user_AddStore(
                        arrayStoreImages: self.arraySelectedAttachments,
                        strStoreName: (txtStoreName?.text)!,
                        strStorePhoneNumber: (txtWhatsappNumber?.text)!,
                        strEmail: (txtEmail?.text)!,
                        strStoreAddress: "\((txtRua?.text)!)@\((txtNumber?.text)!)@\((txtBairro?.text)!)",
                        strIsHideAddress: strIsHideAddress,
                        strStoreCityID: "\(intSelectedCityID ?? 0)",
                        strStoreStateID: strSelectedStateID ?? "",
                        strStoreSubcategoryIDs: arraySelectedSubCat,
                        arrayTags: self.arraySelectedTags,
                        strStoreDescription: (txtViewEnterDescription?.text)!,
                        strFacebookLink: txtFacebook?.text != "" ? "\((lblFacebook?.text)!)\((txtFacebook?.text)!)".replacingOccurrences(of: "https://www.facebook.com/", with: "") : "",
                        strInstagramLink: (txtInstagram?.text)!.replacingOccurrences(of: "@", with: ""),
                        arrayStoreTimings: self.arraySelectedTimings)
                   }
//                    let first2 = String("\(intMobileNumber)".prefix(2))
//
//                    if (first2 == "55")
//                    {
//                        appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: ""))
//                    }
//                    else
//                    {
//                        if (objCommonUtility.isValidEmailAddress(strEmailString: (txtEmail?.text)!) == false)
//                        {
//
//                        }
//                        else
//                        {
//                            var strIsHideAddress: String = "0"
//                            if (self.boolIsCheckboxSelected)
//                            {
//                                strIsHideAddress = "1"
//                            }
//
//                            var arraySelectedSubCat = [String]()
//                            for ObjSubCategory in self.arraySelectedSubCategoryIDs
//                            {
//                                arraySelectedSubCat.append(ObjSubCategory.strSubCategoryID)
//                            }
//
//                            dataManager.user_AddStore(arrayStoreImages: self.arraySelectedAttachments, strStoreName: (txtStoreName?.text)!, strStorePhoneNumber: (txtWhatsappNumber?.text)!, strEmail: (txtEmail?.text)!, strStoreAddress: "\((txtRua?.text)!)@\((txtNumber?.text)!)@\((txtBairro?.text)!)", strIsHideAddress: strIsHideAddress, strStoreCityID: "\(intSelectedCityID ?? 0)", strStoreStateID: strSelectedStateID ?? "", strStoreSubcategoryIDs: arraySelectedSubCat, arrayTags: self.arraySelectedTags, strStoreDescription: (txtViewEnterDescription?.text)!, arrayStoreTimings: self.arraySelectedTimings)
//                        }
//                    }
                }
            }
        }
    }
    
    // MARK: - TagListView Delegate Methods
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        
        if (sender == timingsTagListView)
        {
            if let indexValue = self.arrayTimingDats.firstIndex(of: title)
            {
                if (tagView.isSelected)
                {
                    tagView.isSelected = false
                    self.arraySelectedTimingDats[indexValue] = "0"
                }
                else
                {
                    tagView.isSelected = true
                    self.arraySelectedTimingDats[indexValue] = "1"
                }
            }
        }
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView)
    {
        print("Tag pressed: \(title), \(sender)")
        
        if (sender == selectedTagListView)
        {
            if let indexValue = self.arraySelectedTags.firstIndex(of: title)
            {
                self.arraySelectedTags.remove(at: indexValue)
            }
            
            self.selectedTagListView?.removeAllTags()
            self.selectedTagListView?.addTags(self.arraySelectedTags)
            
            if (self.arraySelectedTags.count > 0)
            {
                let subcategoriesLastRow: UIView = (self.selectedTagListView?.subviews[(self.selectedTagListView?.subviews.count)! - 1])!
                
                selectedTagListView?.heightConstaint?.constant = subcategoriesLastRow.frame.origin.y + subcategoriesLastRow.frame.size.height
            }
            else
            {
                selectedTagListView?.heightConstaint?.constant = 0
            }
        }
        else
        {
            if let indexValue = self.arraySelectedTimingsFormated.firstIndex(of: title)
            {
                self.arraySelectedTimings.remove(at: indexValue)
                self.arraySelectedTimingsFormated.remove(at: indexValue)
            }
            
            self.selectedTimingsTagListView?.removeAllTags()
            self.selectedTimingsTagListView?.addTags(self.arraySelectedTimingsFormated)
            
            if (self.arraySelectedTimingsFormated.count > 0)
            {
                let selectedTimingsLastRow: UIView = (self.selectedTimingsTagListView?.subviews[(self.selectedTimingsTagListView?.subviews.count)! - 1])!
                
                selectedTimingsTagListView?.heightConstaint?.constant = selectedTimingsLastRow.frame.origin.y + selectedTimingsLastRow.frame.size.height
            }
            else
            {
                selectedTimingsTagListView?.heightConstaint?.constant = 0
            }
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
    
    @IBAction func btnCancelClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        print("\(sender.tag)")
        
        self.arraySelectedAttachments.remove(at: sender.tag)
        
        if (self.boolIsOpenForEdit)
        {
//            if (sender.tag < self.objMyStore.arrayStoreImages.count)
            if (sender.tag < self.arrayTempAlteredStoreImages.count)
            {
//                self.arrayDeletedImages.append(self.objMyStore.arrayStoreImages[sender.tag])
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
    }
    
    @IBAction func btnSelectSubCategoryClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (intSelectedCategoryID != nil)
        {
            self.view.addSubview(subCategoryContainerView!)
        }
    }
    
    @IBAction func btnSubCategoryOkClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        subCategoryContainerView?.removeFromSuperview()
    }
    
    @IBAction func btnInfoClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (sender == btnSubCategoryInfo)
        {
            let manager: JDFSequentialTooltipManager = JDFSequentialTooltipManager(hostView: scrollContaineView)
            
            let tooltip: JDFTooltipView = JDFTooltipView(targetView: btnSubCategoryInfo!,
                                                         hostView: scrollContaineView,
                                                         tooltipText: NSLocalizedString("activity_edit_store_subcategories_title_tooltip", value:"Adicione as subcategorias que melhor identifiquem seu negócio.", comment: ""),
                                                         arrowDirection: .down,
                                                         width: (scrollContaineView?.frame.size.width)! - 100)
            tooltip.tooltipBackgroundColour = MySingleton.sharedManager().themeGlobalLightGreenColor
            tooltip.textColour = MySingleton.sharedManager().themeGlobalWhiteColor
            tooltip.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
            tooltip.show()
        }
        else if (sender == btnTagsInfo)
        {
            let tooltip: JDFTooltipView = JDFTooltipView(targetView: btnTagsInfo!,
                                                         hostView: scrollContaineView,
                                                         tooltipText: NSLocalizedString("activity_edit_store_tags_description_title_tooltip", value:"Adicionando algumas palavras-chaves relacionadas ao seu negócio, como seus principais produtos e serviços, você ajudará nosso sistema de busca a indicá-lo ao maior número de usuários possível. Separe cada palavra-chave por enter.", comment: ""),
                                                         arrowDirection: .down,
                                                         width: (scrollContaineView?.frame.size.width)! - 100)
            tooltip.tooltipBackgroundColour = MySingleton.sharedManager().themeGlobalLightGreenColor
            tooltip.textColour = MySingleton.sharedManager().themeGlobalWhiteColor
            tooltip.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
            tooltip.show()
        }
        else if (sender == btnEnterDescription)
        {
            let tooltip: JDFTooltipView = JDFTooltipView(targetView: btnEnterDescription!,
                                                         hostView: scrollContaineView,
                                                         tooltipText: NSLocalizedString("activity_edit_store_description_title_tooltip", value:"Além de aumentar muito as chances de contatos, uma boa descrição ajuda nosso sistema de busca a classificar melhor seu perfil, indicando seu negócio para um número maior de possíveis clientes.", comment: ""),
                                                         arrowDirection: .down,
                                                         width: (scrollContaineView?.frame.size.width)! - 100)
            tooltip.tooltipBackgroundColour = MySingleton.sharedManager().themeGlobalLightGreenColor
            tooltip.textColour = MySingleton.sharedManager().themeGlobalWhiteColor
            tooltip.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
            tooltip.show()
        }
        else if (sender == btnEnterTimings)
        {
            let tooltip: JDFTooltipView = JDFTooltipView(targetView: btnEnterTimings!,
                                                         hostView: scrollContaineView,
                                                         tooltipText: NSLocalizedString("activity_edit_store_open_hours_title_tooltip", value:"Indique nesse campo o horário de atendimento via WhatsApp que seu negócio oferece aos clientes.", comment: ""),
                                                         arrowDirection: .down,
                                                         width: (scrollContaineView?.frame.size.width)! - 100)
            tooltip.tooltipBackgroundColour = MySingleton.sharedManager().themeGlobalLightGreenColor
            tooltip.textColour = MySingleton.sharedManager().themeGlobalWhiteColor
            tooltip.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
            tooltip.show()
        }
    }
    
//    // MARK: - TLPhotosPicker Delegate Methods
//    //TLPhotosPickerViewControllerDelegate
//
//    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
//        // use selected order, fullresolution image
//        print("shouldDismissPhotoPicker withTLPHAssets called")
////        self.selectedAssets = withTLPHAssets
//    return true
//    }
//
//    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
//        // if you want to use phasset.
//        print("dismissPhotoPicker withPHAssets called")
//    }
//
//    func photoPickerDidCancel() {
//        // cancel
//        print("photoPickerDidCancel called")
//    }
//
//    func dismissComplete() {
//        // picker viewcontroller dismiss completion
//        print("dismissComplete called")
//    }
//
//    func canSelectAsset(phAsset: PHAsset) -> Bool {
//        //Custom Rules & Display
//        print("canSelectAsset called")
//        //You can decide in which case the selection of the cell could be forbidden.
//        return true
//    }
//
//    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
//        // exceed max selection
//        print("didExceedMaximumNumberOfSelection called")
//    }
//
//    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
//        // handle denied albums permissions case
//        print("handleNoAlbumPermissions called")
//
//        DispatchQueue.main.async {
//            self.dismiss(animated: false, completion: nil)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                let alertController = UIAlertController(title: "Allow photo album access?", message: "Need your permission to access photo albums", preferredStyle: .alert)
//                let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
//                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//                }
//                alertController.addAction(dismissAction)
//                alertController.addAction(settingsAction)
//
//                self.present(alertController, animated: true, completion: nil)
//            })
//        }
//    }
//
//    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
//        // handle denied camera permissions case
//        print("handleNoCameraPermissions called")
//
//        DispatchQueue.main.async {
//            self.dismiss(animated: false, completion: nil)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//                let alertController = UIAlertController(title: "Allow camera album access?", message: "Need your permission to take a photo", preferredStyle: .alert)
//                let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
//                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//                }
//                alertController.addAction(dismissAction)
//                alertController.addAction(settingsAction)
//
//                // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
//                picker.present(alertController, animated: true, completion: nil)
//            })
//        }
//    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.dataRowsSubCategory.count > 0)
        {
            return self.dataRowsSubCategory.count
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (self.dataRowsSubCategory.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:CheckboxTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? CheckboxTableViewCell
            
            if(cell == nil)
            {
                cell = CheckboxTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblText.frame.size.width = cell.mainContainer.frame.size.width - 50
            
            cell.lblText.text = self.dataRowsSubCategory[indexPath.row].strSubCategoryName
            
            cell.lblText.sizeToFit()
            
            return cell.lblText.frame.size.height + 20
        }
        else
        {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (self.dataRowsSubCategory.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:CheckboxTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? CheckboxTableViewCell
            
            if(cell == nil)
            {
                cell = CheckboxTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblText.frame.size.width = cell.mainContainer.frame.size.width - 50
            
            cell.lblText.text = self.dataRowsSubCategory[indexPath.row].strSubCategoryName
            cell.lblText.sizeToFit()
            
            cell.mainContainer.frame.size.height = cell.lblText.frame.size.height + 20
            
            cell.imageViewCheckbox.frame.origin.y = (cell.mainContainer.frame.size.height - cell.imageViewCheckbox.frame.size.height) / 2
            
            if self.arraySelectedSubCategoryIDs.firstIndex(of: self.dataRowsSubCategory[indexPath.row]) != nil
            {
                cell.imageViewCheckbox.image = UIImage(named: "ic_green_tick.png")
            }
            else
            {
                cell.imageViewCheckbox.image = UIImage(named: "ic_grey_tick.png")
            }
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
        else
        {
            var lblNoDataFont: UIFont?
            
            if MySingleton.sharedManager().screenWidth == 320
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            }
            else if MySingleton.sharedManager().screenWidth == 375
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            }
            else
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            }
            
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
            
            let lblNoData = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: cell.frame.size.height))
            lblNoData.textAlignment = NSTextAlignment.center
            lblNoData.font = lblNoDataFont
            lblNoData.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
            lblNoData.text = "No data found!"
            
            cell.contentView.addSubview(lblNoData)
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (self.dataRowsSubCategory.count > 0)
        {
            if let indexValue = self.arraySelectedSubCategoryIDs.firstIndex(of: self.dataRowsSubCategory[indexPath.row])
            {
                self.arraySelectedSubCategoryIDs.remove(at: indexValue)
            }
            else
            {
                self.arraySelectedSubCategoryIDs.append(self.dataRowsSubCategory[indexPath.row])
            }
            
            subCategoryTableView?.reloadData()
            var strSelectedSubCategories: String = ""
            for objSubCategory in self.arraySelectedSubCategoryIDs
            {
                if (strSelectedSubCategories != "")
                {
                    strSelectedSubCategories = "\(strSelectedSubCategories), "
                }
                strSelectedSubCategories = "\(strSelectedSubCategories)\(objSubCategory.strSubCategoryName)"
            }
            
            txtSelectSubCategory?.text = strSelectedSubCategories
        }
        
        self.validationCheck()
    }
    
    // MARK: - GESTURE
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        

          let vc=ImagePreviewViewController()
          vc.imgArray = self.photosData
            let indexPath = IndexPath(item: selectedImageIndex, section: 0)
           vc.passedContentOffset = indexPath
          self.present(vc, animated: true, completion: nil)
//        self.browser.setCurrentPhotoIndex(UInt(sender.view?.tag ?? 0))
//
//        let nc : UINavigationController = UINavigationController(rootViewController: self.browser)
//        nc.modalTransitionStyle = .crossDissolve
//        self.present(nc, animated: true, completion: nil)
//
        //        let NewIcon: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.sayHello(sender:)))
        //
        //        self.browser?.navigationItem.rightBarButtonItem = NewIcon
        
    }    
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if (self.boolIsOpenForEdit)
        {
            if(textField == txtStoreName)// || textField == txtWhatsappNumber)
            {
                if (Int(objMyStore.strStatus) ?? 0 == 0)
                {
                    return true
                }
                else
                {
                    self.appDelegate?.showAlertViewWithTitle(title: "", detail: "Para mudar o nome ou telefone contate os administradores.")
                    return false
                }
            }
            else
            {
                return true
            }
        }
        else
        {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (textField == txtEnterTags)
        {
            if (textField.text != "")
            {
                self.arraySelectedTags.append(textField.text!)
                textField.text = ""
            }
            
            self.selectedTagListView?.removeAllTags()
            self.selectedTagListView?.addTags(self.arraySelectedTags)
            
            if (self.arraySelectedTags.count > 0)
            {
                let subcategoriesLastRow: UIView = (self.selectedTagListView?.subviews[(self.selectedTagListView?.subviews.count)! - 1])!
                
                selectedTagListView?.heightConstaint?.constant = subcategoriesLastRow.frame.origin.y + subcategoriesLastRow.frame.size.height
            }
            else
            {
                selectedTagListView?.heightConstaint?.constant = 0
            }
            self.view.layoutIfNeeded()
        }
        else if (textField == txtFrom || textField == txtTo)
        {
            if ((txtFrom?.text?.count)! > 0 && (txtTo?.text?.count)! > 0)
            {
                var index : Int = 0
                for strFlag in self.arraySelectedTimingDats
                {
                    if (strFlag == "1")
                    {
                        let strSelectedTime: String = "\(index)#\((txtFrom?.text)!)#\((txtTo?.text)!)"
                        
                        let strFinalTime: String = "\(objCommonUtility.arrayWeakDays[index]) das \((txtFrom?.text)!) até \((txtTo?.text)!)"
                        
                        self.arraySelectedTimings.append(strSelectedTime)
                        self.arraySelectedTimingsFormated.append(strFinalTime)
                    }
                    
                    index = index + 1
                }
                
                
                self.selectedTimingsTagListView?.removeAllTags()
                self.selectedTimingsTagListView?.addTags(self.arraySelectedTimingsFormated)
                
                if (self.arraySelectedTimingsFormated.count > 0)
                {
                    let selectedTimingsLastRow: UIView = (self.selectedTimingsTagListView?.subviews[(self.selectedTimingsTagListView?.subviews.count)! - 1])!
                    
                    selectedTimingsTagListView?.heightConstaint?.constant = selectedTimingsLastRow.frame.origin.y + selectedTimingsLastRow.frame.size.height
                }
                else
                {
                    selectedTimingsTagListView?.heightConstaint?.constant = 0
                }
                
                txtFrom?.text = ""
                txtTo?.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == txtEnterTags)
        {
            if (string == " " || string == ",")
            {
                if (textField.text != "")
                {
                    self.arraySelectedTags.append(textField.text!)
                    self.selectedTagListView?.removeAllTags()
                    self.selectedTagListView?.addTags(self.arraySelectedTags)
                    
                    if (self.arraySelectedTags.count > 0)
                    {
                        let subcategoriesLastRow: UIView = (self.selectedTagListView?.subviews[(self.selectedTagListView?.subviews.count)! - 1])!
                        
                        selectedTagListView?.heightConstaint?.constant = subcategoriesLastRow.frame.origin.y + subcategoriesLastRow.frame.size.height
                    }
                    else
                    {
                        selectedTagListView?.heightConstaint?.constant = 0
                    }
                    
                    textField.text = ""
                }
                return false
            }
            else
            {
                return true
            }
        }
        else if (textField == txtWhatsappNumber)
        {
            let maxLength = 11
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if (textField == txtStoreName)
        {
            let maxLength = 32
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if (textField == txtFacebook || textField == txtInstagram)
        {
            if string == " "
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Nome do usuário não pode conter espaços")
                return false
            }
            else
            {
                return true
            }
        }
        else
        {
            return true
        }
        
    }
    
    func validationCheck()
    {
        if (self.boolIsOpenForEdit)
        {
            if ((self.txtStoreName?.text?.count)! <= 0 ||
                (self.txtWhatsappNumber?.text?.count)! <= 0 ||
                (self.txtEmail?.text?.count)! <= 0 ||
                (self.txtRua?.text?.count)! <= 0 ||
                (self.txtNumber?.text?.count)! <= 0 ||
                (self.txtBairro?.text?.count)! <= 0 ||
                self.strSelectedCityName == nil ||
                (self.strSelectedCityName?.count)! <= 0)
            {
                btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                if ((self.txtStoreName?.text?.count)! <= 0)
                {
                    lblStoreNameValidation?.text = NSLocalizedString("activity_edit_store_store_name_hint_1", value:"Nome do negócio (max 32 caracteres)", comment: "")
                }
                else
                {
                    lblStoreNameValidation?.text = ""
                }
                
                if ((self.txtWhatsappNumber?.text?.count)! <= 0)
                {
                    lblWhatsappNumberValidation?.text = NSLocalizedString("activity_edit_store_store_phone_number_hint", value:"Número do WhatsApp (com DDD)", comment: "")
                }
                else
                {
                    lblWhatsappNumberValidation?.text = ""
                    //  let intMobileNumber: Int = Int(txtWhatsappNumber!.text ?? "0")!
                    let intMobileNumber = Int(txtWhatsappNumber!.text!) ?? 0
                    if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
                    {
//                        let first2 = String("\(intMobileNumber)".prefix(2))
//
//                        if (first2 == "55")
//                        {
//                            btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
//                            lblWhatsappNumberValidation?.text = NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: "")
//                        }
                    }
                    else
                    {
                        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                        lblWhatsappNumberValidation?.text = NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: "")
                    }
                    
                }
                
                if ((self.txtEmail?.text?.count)! <= 0)
                {
                    lblEmailValidation?.text = NSLocalizedString("activity_edit_store_email_error", value:"E-mail inválido", comment: "")
                }
                else
                {
                    lblEmailValidation?.text = ""
                    if (objCommonUtility.isValidEmailAddress(strEmailString: self.txtEmail!.text!) == false)
                    {
                        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                        lblEmailValidation?.text = NSLocalizedString("activity_edit_store_email_error", value:"E-mail inválido", comment: "")
                    }
                }
                
                if ((self.txtRua?.text?.count)! <= 0)
                {
                    lblRuaValidation?.text = NSLocalizedString("activity_edit_store_street_name_error", value:"Incluir rua", comment: "")
                }
                else
                {
                    lblRuaValidation?.text = ""
                }
                
                if ((self.txtNumber?.text?.count)! <= 0)
                {
                    lblNumberValidation?.text = NSLocalizedString("activity_edit_store_street_number_error", value:"Incluir número", comment: "")
                }
                else
                {
                    lblNumberValidation?.text = ""
                }
                
                if ((self.txtBairro?.text?.count)! <= 0)
                {
                    lblBairroValidation?.text = NSLocalizedString("activity_edit_store_street_neighbourhood_error", value:"Incluir bairro", comment: "")
                }
                else
                {
                    lblBairroValidation?.text = ""
                }
            }
            else
            {
                lblStoreNameValidation?.text = ""
                lblWhatsappNumberValidation?.text = ""
                lblEmailValidation?.text = ""
                lblRuaValidation?.text = ""
                lblNumberValidation?.text = ""
                lblBairroValidation?.text = ""
                
                var boolIsMobileValid: Bool = false
                var boolIsEmailValid: Bool = false
                
                //let intMobileNumber: Int = Int(txtWhatsappNumber!.text ?? "0")!
                let intMobileNumber = Int(txtWhatsappNumber!.text!) ?? 0
                if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
                {
                    lblWhatsappNumberValidation?.text = ""
                    boolIsMobileValid = true
                   // let first2 = String("\(intMobileNumber)".prefix(2))
                    
//                    if (first2 == "55")
//                    {
//                        boolIsMobileValid = false
//                        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
//                        lblWhatsappNumberValidation?.text = NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: "")
//                    }
//                    else
//                    {
//                        lblWhatsappNumberValidation?.text = ""
//                        boolIsMobileValid = true
//                    }
                }
                else
                {
                    boolIsMobileValid = false
                    btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                    lblWhatsappNumberValidation?.text = NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: "")
                }
                
                //EMAILK
                if (objCommonUtility.isValidEmailAddress(strEmailString: self.txtEmail!.text!) == false)
                {
                    boolIsEmailValid = false
                    btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                    lblEmailValidation?.text = NSLocalizedString("activity_edit_store_email_error", value:"E-mail inválido", comment: "")
                }
                else
                {
                    boolIsEmailValid = true
                    //btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
                    lblEmailValidation?.text = ""
                }
                
                if (boolIsMobileValid && boolIsEmailValid)
                {
                    btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
                    lblWhatsappNumberValidation?.text = ""
                    lblEmailValidation?.text = ""
                }
                else
                {
                    btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                }
            }
        }
        else
        {
            if ((self.txtStoreName?.text?.count)! <= 0 ||
                (self.txtWhatsappNumber?.text?.count)! <= 0 ||
                (self.txtEmail?.text?.count)! <= 0 ||
                (self.txtRua?.text?.count)! <= 0 ||
                (self.txtNumber?.text?.count)! <= 0 ||
                (self.txtBairro?.text?.count)! <= 0 ||
                self.strSelectedCityName == nil ||
                (self.strSelectedCityName?.count)! <= 0 ||
                self.strSelectedCategoryName == nil ||
                (self.strSelectedCategoryName?.count)! <= 0 ||
                self.arraySelectedSubCategoryIDs.count <= 0)
            {
                btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                if ((self.txtStoreName?.text?.count)! <= 0)
                {
                    lblStoreNameValidation?.text = NSLocalizedString("activity_edit_store_store_name_hint_1", value:"Nome do negócio (max 32 caracteres)", comment: "")
                }
                else
                {
                    lblStoreNameValidation?.text = ""
                }
                
                if ((self.txtWhatsappNumber?.text?.count)! <= 0)
                {
                    lblWhatsappNumberValidation?.text = NSLocalizedString("activity_edit_store_store_phone_number_hint", value:"Número do WhatsApp (com DDD)", comment: "")
                }
                else
                {
                    lblWhatsappNumberValidation?.text = ""
                    
                    //  let intMobileNumber: Int = Int(txtWhatsappNumber!.text ?? "0")!
                    let intMobileNumber = Int(txtWhatsappNumber!.text!) ?? 0
                    if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
                    {
//                        let first2 = String("\(intMobileNumber)".prefix(2))
//
//                        if (first2 == "55")
//                        {
//                            btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
//                            lblWhatsappNumberValidation?.text = NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: "")
//                        }
                    }
                    else
                    {
                        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                        lblWhatsappNumberValidation?.text = NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: "")
                    }
                }
                
                if ((self.txtEmail?.text?.count)! <= 0)
                {
                    lblEmailValidation?.text = NSLocalizedString("activity_edit_store_email_error", value:"E-mail inválido", comment: "")
                }
                else
                {
                    lblEmailValidation?.text = ""
                    if (objCommonUtility.isValidEmailAddress(strEmailString: self.txtEmail!.text!) == false)
                    {
                        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                        lblEmailValidation?.text = NSLocalizedString("activity_edit_store_email_error", value:"E-mail inválido", comment: "")
                    }
                }
                
                if ((self.txtRua?.text?.count)! <= 0)
                {
                    lblRuaValidation?.text = NSLocalizedString("activity_edit_store_street_name_error", value:"Incluir rua", comment: "")
                }
                else
                {
                    lblRuaValidation?.text = ""
                }
                
                if ((self.txtNumber?.text?.count)! <= 0)
                {
                    lblNumberValidation?.text = NSLocalizedString("activity_edit_store_street_number_error", value:"Incluir número", comment: "")
                }
                else
                {
                    lblNumberValidation?.text = ""
                }
                
                if ((self.txtBairro?.text?.count)! <= 0)
                {
                    lblBairroValidation?.text = NSLocalizedString("activity_edit_store_street_neighbourhood_error", value:"Incluir bairro", comment: "")
                }
                else
                {
                    lblBairroValidation?.text = ""
                }
            }
            else
            {
                lblStoreNameValidation?.text = ""
                lblWhatsappNumberValidation?.text = ""
                lblEmailValidation?.text = ""
                lblRuaValidation?.text = ""
                lblNumberValidation?.text = ""
                lblBairroValidation?.text = ""
                
                var boolIsMobileValid: Bool = false
                var boolIsEmailValid: Bool = false
                
                //  let intMobileNumber: Int = Int(txtWhatsappNumber!.text ?? "0")!
                let intMobileNumber = Int(txtWhatsappNumber!.text!) ?? 0
                if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
                {
                    lblWhatsappNumberValidation?.text = ""
                    boolIsMobileValid = true
//                    let first2 = String("\(intMobileNumber)".prefix(2))
//
//                    if (first2 == "55")
//                    {
//                        boolIsMobileValid = false
//                        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
//                        lblWhatsappNumberValidation?.text = NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: "")
//                    }
//                    else
//                    {
//                        lblWhatsappNumberValidation?.text = ""
//                        boolIsMobileValid = true
//                    }
                }
                else
                {
                    boolIsMobileValid = false
                    btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                    lblWhatsappNumberValidation?.text = NSLocalizedString("invalid_phone_code", value:"Número inválido. Não inclua o código do país.", comment: "")
                }
                
                //EMAILK
                if (objCommonUtility.isValidEmailAddress(strEmailString: self.txtEmail!.text!) == false)
                {
                    boolIsEmailValid = false
                    btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                    lblEmailValidation?.text = NSLocalizedString("activity_edit_store_email_error", value:"E-mail inválido", comment: "")
                }
                else
                {
                    boolIsEmailValid = true
                    //btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
                    lblEmailValidation?.text = ""
                }
                
                if (boolIsMobileValid && boolIsEmailValid)
                {
                    btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
                    lblWhatsappNumberValidation?.text = ""
                    lblEmailValidation?.text = ""
                }
                else
                {
                    btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                }
                
            }
        }
        
    }
    
    // MARK: - UIScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print("scrollViewDidScroll called")
        
        if (scrollView == imageScrollView)
        {
            let pageWidth : CGFloat = imageScrollView!.frame.size.width
            let page : Int = Int((imageScrollView?.contentOffset.x)!/pageWidth)
            imagePageControl?.currentPage = page
            selectedImageIndex = page
        }
    }
    
    // MARK: - MWPhotoBrowser Delegate Methods
    
//    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
//        print(photos.count)
//        return UInt(photos.count)
//    }
//
//    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol!
//    {
//        if index < photos.count
//        {
//            return photos[Int(index)]
//        }
//        return nil
//    }
//
//    func photoBrowserDidFinishModalPresentation(_ photoBrowser: MWPhotoBrowser!) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    @objc func sayHello(sender: UIBarButtonItem) {
//
//        print("HELLO")
//
//    }
//
//    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, actionButtonPressedForPhotoAt index: UInt)
//    {
//        print("ROTATE")
//
//        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self as UIActionSheetDelegate, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Rotate Left", "Rotate Right")
//        actionSheet.tag = Int(index)
//
//        actionSheet.show(in: photoBrowser.view)
//    }
//
//    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
//    {
//        switch (buttonIndex){
//
//        case 0:
//            print("Cancel")
//        case 1:
//            do {
//                print("Rotate Left")
//                var index: Int = 0
//                for imageInArray in self.photosData
//                {
//                    //let image: UIImage = imageInArray.image
//                    photos[index] = MWPhoto(image: imageInArray.rotate(radians: -(.pi / 2)))
//                    self.photosData[index] = imageInArray.rotate(radians: -(.pi / 2))
//                    index = index + 1
//                }
//                self.browser.reloadData()
//            }
//        case 2:
//            do {
//                print("Rotate Right")
//                var index: Int = 0
//                for imageInArray in self.photosData
//                {
//                    //let image: UIImage = imageInArray.underlyingImage
//                    photos[index] = MWPhoto(image: imageInArray.rotate(radians: .pi / 2))
//                    self.photosData[index] = imageInArray.rotate(radians: .pi / 2)
//                    index = index + 1
//                }
//                self.browser.reloadData()
//            }
//        default:
//            print("Default")
//            //Some code here..
//
//        }
//    }
    
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
