//
//  User_AddPromotionViewController.swift
//  AgendaZap
//
//  Created by Dipen on 11/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import SDWebImage
import MWPhotoBrowser
import MBProgressHUD
import Photos
import TLPhotoPicker

class User_AddPromotionViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, TLPhotosPickerViewControllerDelegate
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
    
    @IBOutlet var lblStoreName: UILabel?
    @IBOutlet var lblAddress: UILabel?
    @IBOutlet var lblPromotion: UILabel?
    @IBOutlet var lblCharacterCount: UILabel?
    @IBOutlet var txtStorePromotion: SATextField?
    
    @IBOutlet var lblDescription: UILabel?
    @IBOutlet var txtViewDescriptionContainerView: UIView?
    @IBOutlet var txtViewDescription: UITextView?
    
    @IBOutlet var btnSave: UIButton?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var arraySelectedAttachments = [Data]()
    var arraySelectedNewAttachments = [Data]()
    var arrayDeletedImages = [String]()
    
    var browser : MWPhotoBrowser!
    var photos = [MWPhoto]()
    var photosData = [UIImage]()
    
    //FOR EDIT
    var objMyStore: MyStore!
    var boolIsOpenForEdit: Bool!
    var arrayTempAlteredPromotionImages = [String]()
    var isSliderImageLoaded : Bool!
    
    var objPromotionDetails: ObjPromotionDetails = ObjPromotionDetails()
     fileprivate var selectedImageIndex: Int = 0
    // MARK: - UIViewController Delegate Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isSliderImageLoaded = false
        
        self.setupNotificationEvent()
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        lblStoreName?.text = self.objMyStore.strName
        lblAddress?.text = self.objMyStore.strFormatedAddress
        
        //API CALL
        dataManager.user_GetPromotionDetails(strStoreID: objMyStore.strID)
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
                selector: #selector(self.user_GetPromotionDetailsEvent),
                name: Notification.Name("user_GetPromotionDetailsEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_AddEditStorePromotionEvent),
                name: Notification.Name("user_AddEditStorePromotionEvent"),
                object: nil)
            
            
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetPromotionDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.objPromotionDetails = dataManager.objSelectedPromotionDetails
            
            self.arraySelectedAttachments = [Data]()
            self.appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading promotion images.")
            
            DispatchQueue.global(qos: .background).async {
                print("This is run on the background queue")
                
                for strImageURL in self.objPromotionDetails.arrayImages
                {
                    let url:NSURL = NSURL(string: strImageURL)!
                    let data = try? Data(contentsOf: url as URL)
                    
                    if (data != nil)
                    {
                        self.arraySelectedAttachments.append(data ?? Data())
                    }
                }
                
                if(self.objPromotionDetails.arrayImages.count>0)
                {
                    for index in 0...(self.objPromotionDetails.arrayImages.count - 1)
                    {
                        self.arrayTempAlteredPromotionImages.append(self.objPromotionDetails.arrayImages[index])
                    }
                }
                
                DispatchQueue.main.async {
                    print("This is run on the main queue, after the previous code in outer block")
                    
                    self.appDelegate?.dismissGlobalHUD()
                    
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
                }
            }
            
            self.txtStorePromotion?.text = self.objPromotionDetails.strTitle
            self.lblCharacterCount?.text = "\(self.txtStorePromotion?.text?.count ?? 0)/110"
            self.txtViewDescription?.text = self.objPromotionDetails.strDescription
        })
    }
    
    @objc func user_AddEditStorePromotionEvent()
    {
        DispatchQueue.main.async(execute: {
            
            print("SUCCESS")
            
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = NSLocalizedString("dialog_update_promotion_title", value:"Promoção atualizada", comment: "")
            alertViewController.message = NSLocalizedString("dialog_update_promotion_description", value:"Sua promoção foi atualizada e já está visível no aplicativo", comment: "")
            
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
        
        if(self.imagePageControl?.numberOfPages == self.objPromotionDetails.arrayImages.count)
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
//        self.browser.displayActionButton = true
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
        
        //STORE NAME
        lblStoreName?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        lblStoreName?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        //ADDRESS
        lblAddress?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblAddress?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        
        //PROMOTION
        lblPromotion?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblPromotion?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblPromotion?.text = NSLocalizedString("activity_edit_store_store_pramotion_title_Optional_hint", value: "Resumo da promoção (obrigatório)", comment: "")
        
        //COUNT
        lblCharacterCount?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblCharacterCount?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblCharacterCount?.text = "0/110"
        
        
        txtStorePromotion?.delegate = self
        txtStorePromotion?.placeholder = ""
        txtStorePromotion?.title = ""
        txtStorePromotion?.addTarget(self, action: #selector(self.txtStorePromotionTextChange(_:)), for: .editingChanged)
        
        //PROMOTION DESCRIPTION
        lblDescription?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblDescription?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblDescription?.text = NSLocalizedString("activity_edit_store_store_pramotion_details_hint", value: "Detalhes da promoção (opcional)", comment: "")
        
        txtViewDescriptionContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtViewDescriptionContainerView?.layer.cornerRadius = 5.0
        
        txtViewDescription?.font = txtStorePromotion?.font
        txtViewDescription?.textColor = txtStorePromotion?.textColor
        txtViewDescription?.placeholderColor = txtStorePromotion?.placeholderColor
        txtViewDescription?.placeholder = NSLocalizedString("activity_edit_store_store_pramotion_details_hint", value: "Detalhes da promoção (opcional)", comment: "")
        
        btnSave?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        
        btnSave?.setTitle(NSLocalizedString("activity_btn_confirmation", value:"Salvar Promoção", comment: ""), for: .normal)
        btnSave?.setTitleColor( MySingleton.sharedManager() .themeGlobalWhiteColor, for: .normal)
        btnSave?.clipsToBounds = true
        btnSave?.layer.cornerRadius = 5
        btnSave?.addTarget(self, action: #selector(self.btnSaveClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func txtStorePromotionTextChange(_ sender: SATextField)
    {
        lblCharacterCount?.text = "\(txtStorePromotion?.text?.count ?? 0)/110"
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if ((self.txtStorePromotion?.text?.count)! <= 0)
        {
            DispatchQueue.main.async {
                //  self.appDelegate?.showAlertViewWithTitle(title: "", detail: "Resumo da promoção")
            }
            
        }
        else
        {
            dataManager.user_AddEditStorePromotion(strStoreID: objMyStore.strID, strPromotionID: self.objPromotionDetails.strPromotionID, arrayPromotionImagesImages: self.arraySelectedNewAttachments, strTitle: (txtStorePromotion?.text)!, strPromotionDescription: (txtViewDescription?.text)!, arrayDeletedImages: self.arrayDeletedImages)
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
                            
                            print("image width after resizing: \(image!.size.width)")
                            print("image height after resizing: \(image!.size.height)")
                            
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
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("please_wait_while_we_are_still_loading_uploaded_images_promotion", value:"Por favor aguarde enquanto enviamos as fotos da promoção.", comment: ""))
        }
    }
    
    @IBAction func btnCancelClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        self.arraySelectedAttachments.remove(at: sender.tag)
        
        if (self.boolIsOpenForEdit)
        {
//            if (sender.tag < self.objPromotionDetails.arrayImages.count)
            if (sender.tag < self.arrayTempAlteredPromotionImages.count)
            {
//                self.arrayDeletedImages.append(self.objPromotionDetails.arrayImages[sender.tag])
                self.arrayDeletedImages.append(self.arrayTempAlteredPromotionImages[sender.tag])
                self.arrayTempAlteredPromotionImages.remove(at: sender.tag)
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
    }
    
//    // MARK: - TLPhotosPicker Delegate Methods
//    //TLPhotosPickerViewControllerDelegate
//
//    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
//        // use selected order, fullresolution image
//        print("shouldDismissPhotoPicker withTLPHAssets called")
////        self.selectedAssets = withTLPHAssets
//        return true
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
//    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == txtStorePromotion)
        {
            let maxLength = 110
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else
        {
            return true
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
