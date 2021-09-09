//
//  User_StoreDetailsViewController.swift
//  AgendaZap
//
//  Created by Dipen on 19/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import TagListView
import SDWebImage
import MWPhotoBrowser
import MBProgressHUD
import DTPhotoViewerController

class User_StoreDetailsViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, TagListViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate, DTPhotoViewerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate
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
    //EDIT
    @IBOutlet var editContainerView: UIView?
    @IBOutlet var imageViewEdit: UIImageView?
    @IBOutlet var btnEdit: UIButton?
    
    @IBOutlet var mainTableView: UITableView?
    @IBOutlet var btnSend: UIButton?
    
    //BASIC DETAILS
    @IBOutlet var basicDetailsContainerView: UIView?
    //@IBOutlet var imageSliderScrollView: UIScrollView?
    //@IBOutlet var imageSliderPageControl: UIPageControl?
    @IBOutlet var imageViewStoreImage: UIImageView?
    @IBOutlet var lblName: UILabel?
    @IBOutlet var imageViewVerified: UIImageView?
    @IBOutlet var btnFavourite: UIButton?
    @IBOutlet var btnFacebook: UIButton?
    @IBOutlet var btnInstagram: UIButton?
    @IBOutlet var lblAddress: UILabel?
    @IBOutlet var lblPromotionContainerView: UIView?
    @IBOutlet var imageViewPromotion: UIImageView?
    @IBOutlet var lblPromotion: UILabel?
    @IBOutlet var lblPromotionValue: UILabel?
    @IBOutlet var ratingViewInDetails: CosmosView?
    @IBOutlet var btnRatingInDetails: UIButton?
    @IBOutlet var lblRatingInDetails: UILabel?
    
    //BULK MESSAGE
    @IBOutlet var bulkMessageContainerView: UIView?
    @IBOutlet var btnBulkMessage: UIButton?
    
    //PRODCTS
    @IBOutlet var productsContainerView: UIView?
    @IBOutlet var productsCollectionView: UICollectionView! {
        didSet {
            self.productsCollectionView.register(UINib(nibName: "ProductCVCell", bundle: nil), forCellWithReuseIdentifier: "ProductCVCell")
        }
    }
    
    //FOTOS
    @IBOutlet var fotosContainerView: UIView?
    @IBOutlet var fotosCollectionView: UICollectionView! {
        didSet {
            self.fotosCollectionView.register(UINib(nibName: "StoreImageCVCell", bundle: nil), forCellWithReuseIdentifier: "StoreImageCVCell")
        }
    }
    
    //DESCRIPTION
    @IBOutlet var descriptionContainerView: UIView?
    @IBOutlet var lblDescription: UILabel?
    
    //MY RATINGS
    @IBOutlet var myRatingsContainerView: UIView?
    @IBOutlet var lblMyRating: UILabel?
    @IBOutlet var ratingViewMyRating: CosmosView?
    @IBOutlet var lblAddMyRating: UILabel?
    @IBOutlet var btnAddMyRating: UIButton?
    
    @IBOutlet var ratingCartContainerView: UIView?
    @IBOutlet var lblAverageRating: UILabel?
    @IBOutlet var ratingViewAverageRating: CosmosView?
    @IBOutlet var lblRatingCount: UILabel?
    
    @IBOutlet var barChartView: UIView?
    //5
    @IBOutlet var lblFive: UILabel?
    @IBOutlet var fiveValueContainerView: UIView?
    @IBOutlet var fiveValueView: UIView?
    //4
    @IBOutlet var lblFore: UILabel?
    @IBOutlet var foreValueContainerView: UIView?
    @IBOutlet var foreValueView: UIView?
    //3
    @IBOutlet var lblThree: UILabel?
    @IBOutlet var threeValueContainerView: UIView?
    @IBOutlet var threeValueView: UIView?
    //2
    @IBOutlet var lblTwo: UILabel?
    @IBOutlet var twoValueContainerView: UIView?
    @IBOutlet var twoValueView: UIView?
    //1
    @IBOutlet var lblOne: UILabel?
    @IBOutlet var oneValueContainerView: UIView?
    @IBOutlet var oneValueView: UIView?
    
    
    //ALL RATINGS
    @IBOutlet var allRatingsContainerView: UIView?
    @IBOutlet var btnViewAllRating: UIButton?
    
    //SUBCATEGORIES
    @IBOutlet var subcategoriesContainerView: UIView?
    @IBOutlet var lblSubcategories: UILabel?
    @IBOutlet var subcategoriesTagListView: TagListView?
    
    //SERVICES
    @IBOutlet var servicesContainerView: UIView?
    @IBOutlet var lblServices: UILabel?
    @IBOutlet var servicesTagListView: TagListView?
    
    //TIMINGS
    @IBOutlet var timingsContainerView: UIView?
    @IBOutlet var lblTimings: UILabel?
    @IBOutlet var timingsTagListView: TagListView?
    
    //REPORTER PROBLEM
    @IBOutlet var reporterProbContainerView: UIView?
    @IBOutlet var lblReporterView: UIView?
    @IBOutlet var lblReporterProb: UILabel?
    @IBOutlet var imgReporterProb: UIImageView?
    @IBOutlet var btnReporterProb: UIButton?
    
    //BLANK MARGIN VIEW AT THE BOTTOM
    @IBOutlet var blankMarginContainerView: UIView?
    
    //SEND BULK MESSAGE
    @IBOutlet var bulkMessagePopupContainerView: UIView?
    @IBOutlet var bulkMessageInnerContainerView: UIView?
    @IBOutlet var btnCloseBulkMessage: UIButton?
    @IBOutlet var lblBulkMessage: UILabel?
    @IBOutlet var lblBulkMessageTitle: UILabel?
    @IBOutlet var txtViewBulkMessageContainerView: UIView?
    @IBOutlet var txtViewBulkMessage: UITextView?
    @IBOutlet var btnSendBulkMessage: UIButton?
    
    fileprivate var selectedImageIndex: Int = 0
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    let strScreenID: String = "6"
    
    var strSelectedStoreID: String!
    var objStoreDetails: ObjStoreDetails = ObjStoreDetails()
    
    var browser : MWPhotoBrowser!
    var photos = [MWPhoto]()
    var photosData = [UIImage]()
    
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

        //API CALL
        dataManager.user_GetStoreDetails(strStoreID: self.strSelectedStoreID)
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
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
        self.removeNotificationEventObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(true)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
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
            selector: #selector(self.user_GetStoreDetailsEvent),
            name: Notification.Name("user_GetStoreDetailsEvent"),
            object: nil)
            
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.user_UpdateStoreFavouriteEvent),
            name: Notification.Name("user_UpdateStoreFavouriteEvent"),
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
    
    @objc func user_GetStoreDetailsEvent()
    {
        DispatchQueue.main.async(execute: {

            self.objStoreDetails = dataManager.objSelectedStoreDetails
            
//            if (self.objStoreDetails.strIsOwned == "1")
//            {
//                self.editContainerView?.isHidden = false
//            }
//            else
//            {
//                self.editContainerView?.isHidden = true
//            }
            
            if (self.objStoreDetails.arrayStoreImages.count > 0)
            {
                self.photos = [MWPhoto]()
                self.photosData = [UIImage]()
                var i: Int = 0
                for strImageURL in self.objStoreDetails.arrayStoreImages
                {
                    let url:NSURL = NSURL(string: strImageURL)!
                    let data = try? Data(contentsOf: url as URL)
                    
                    if (data != nil)
                    {
                        if i == 0
                        {
                            self.imageViewStoreImage?.image = UIImage(data: data!)
                        }
                        self.photos.append(MWPhoto(image: UIImage(data: data!)))
                        self.photosData.append(UIImage(data: data!)!)
                    }
                    else
                    {
                        if i == 0
                        {
                            self.imageViewStoreImage?.image = UIImage(named: "no_image_to_show.png")
                        }
                        self.photos.append(MWPhoto(image: UIImage(named: "no_image_to_show.png")))
                        self.photosData.append(UIImage(named: "no_image_to_show.png")!)
                    }
                    
                    i = i + 1
                }
            }
            else
            {
                self.imageViewStoreImage?.image = UIImage(named: "no_image_to_show.png")
            }
            
            //BASIC DETAILS
            self.lblName?.text = self.objStoreDetails.strName
            
            if (self.objStoreDetails.strIsFavourite == "1")
            {
                self.btnFavourite?.setBackgroundImage(UIImage(named: "ic_yellow_star.png"), for: .normal)
            }
            else
            {
                self.btnFavourite?.setBackgroundImage(UIImage(named: "ic_grey_star.png"), for: .normal)
            }

            if ((Float(self.objStoreDetails.strLatitude) ?? 0) != 0 && (Float(self.objStoreDetails.strLongitude) ?? 0) != 0 && dataManager.currentLocation.coordinate.latitude != 0 && dataManager.currentLocation.coordinate.latitude != 0)
            {
                let storeLocation: CLLocation = CLLocation(latitude: (CLLocationDegrees(Float(self.objStoreDetails.strLatitude) ?? 0)), longitude: (CLLocationDegrees(Float(self.objStoreDetails.strLongitude) ?? 0)))
                
                let strDistance: String = objCommonUtility.calculateDistanceInKiloMeters(coordinateOne: dataManager.currentLocation, coordinateTwo: storeLocation)
                
                self.lblAddress?.text = "\(self.objStoreDetails.strFormatedAddress) (\(strDistance) km)"
                
            }
            else
            {
                self.lblAddress?.text = self.objStoreDetails.strFormatedAddress
            }
            
            self.lblDescription?.text = self.objStoreDetails.strDescription
                        
                //ADJUST FRAMES
            self.lblName?.sizeToFit()
            if self.objStoreDetails.strTaxIdStatus == "1"
            {
                self.imageViewVerified?.isHidden = false
                self.imageViewVerified?.frame.origin.x = (self.lblName?.frame.origin.x)! + (self.lblName?.frame.size.width)! + 10
                self.imageViewVerified?.frame.origin.y = (self.lblName?.frame.origin.y)!
                
                self.btnFavourite?.frame.origin.x = (self.imageViewVerified?.frame.origin.x)! + (self.imageViewVerified?.frame.size.width)! + 10
                self.btnFavourite?.frame.origin.y = (self.lblName?.frame.origin.y)!
            }
            else
            {
                self.imageViewVerified?.isHidden = true
                self.btnFavourite?.frame.origin.x = (self.lblName?.frame.origin.x)! + (self.lblName?.frame.size.width)! + 10
                self.btnFavourite?.frame.origin.y = (self.lblName?.frame.origin.y)!
            }
            
            self.btnFavourite?.frame.origin.x = (self.imageViewVerified?.frame.origin.x)! + (self.imageViewVerified?.frame.size.width)! + 10
            self.btnFavourite?.frame.origin.y = (self.lblName?.frame.origin.y)!
            
            
            self.lblAddress?.sizeToFit()
            self.lblAddress?.frame.origin.y = (self.lblName?.frame.origin.y)! + (self.lblName?.frame.size.height)! + 10
            
            if (self.objStoreDetails.strPrmotion != "")
            {
                self.lblPromotionContainerView?.isHidden = false
                
                self.lblPromotionContainerView?.frame.origin.y = (self.lblAddress?.frame.origin.y)! + (self.lblAddress?.frame.size.height)! + 10
                
                let strOneAttribute = [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().themeGlobalBlackColor]
                let strOne = NSMutableAttributedString(string: self.objStoreDetails.strPrmotion, attributes: strOneAttribute as [NSAttributedString.Key : Any])
                
                let strTwoAttribute = [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().themeGlobalOrangeColor]
                let strTwo = NSMutableAttributedString(string: "  \(NSLocalizedString("btnDetal", value:"+detalhes", comment: ""))", attributes: strTwoAttribute as [NSAttributedString.Key : Any])
                
                let finalString: NSMutableAttributedString = NSMutableAttributedString()
                finalString.append(strOne)
                finalString.append(strTwo)
                
                self.lblPromotionValue?.attributedText = finalString
                self.lblPromotionValue?.sizeToFit()
                self.lblPromotionValue?.frame.size.width = (self.basicDetailsContainerView?.frame.size.width)! - (self.lblPromotionValue?.frame.origin.x)! - 20
                
                self.lblPromotionContainerView?.frame.size.height = (self.lblPromotionValue?.frame.origin.y)! + (self.lblPromotionValue?.frame.size.height)!
                
                self.imageViewPromotion?.frame.origin.y = 30 + (((self.lblPromotionValue?.frame.size.height)! - (self.imageViewPromotion?.frame.size.height)!) / 2)
                
                self.basicDetailsContainerView?.frame.size.height = (self.lblPromotionContainerView?.frame.origin.y)! + (self.lblPromotionContainerView?.frame.size.height)! + 10
            }
            else
            {
                self.lblPromotionContainerView?.isHidden = true
                
                self.basicDetailsContainerView?.frame.size.height = (self.lblAddress?.frame.origin.y)! + (self.lblAddress?.frame.size.height)! + 10
            }
            
            self.ratingViewInDetails?.frame.origin.y = (self.basicDetailsContainerView?.frame.size.height)! - 10
            self.lblRatingInDetails?.frame.origin.y = (self.basicDetailsContainerView?.frame.size.height)! - 10
            self.btnRatingInDetails?.frame.origin.y = (self.basicDetailsContainerView?.frame.size.height)! - 10
            
            if (self.objStoreDetails.strFacebookLink != "")
            {
                self.btnFacebook?.frame.origin.x = (self.lblRatingInDetails?.frame.origin.x)! + (self.lblRatingInDetails?.frame.size.width)! + 10
                self.btnFacebook?.frame.origin.y = (self.lblRatingInDetails?.frame.origin.y)!
                self.btnFacebook?.isHidden = false
                
                self.btnInstagram?.frame.origin.x = (self.btnFacebook?.frame.origin.x)! + (self.btnFacebook?.frame.size.width)! + 10
                self.btnInstagram?.frame.origin.y = (self.lblRatingInDetails?.frame.origin.y)!
            }
            else
            {
                self.btnInstagram?.frame.origin.x = (self.lblRatingInDetails?.frame.origin.x)! + (self.lblRatingInDetails?.frame.size.width)! + 10
                self.btnInstagram?.frame.origin.y = (self.lblRatingInDetails?.frame.origin.y)!
                self.btnFacebook?.isHidden = true
                
            }
            
            if (self.objStoreDetails.strInstagramLink != "")
            {
                self.btnInstagram?.isHidden = false
            }
            else
            {
                self.btnInstagram?.isHidden = true
            }
            
            self.basicDetailsContainerView?.frame.size.height =  (self.ratingViewInDetails?.frame.origin.y)! + (self.ratingViewInDetails?.frame.size.height)! + 10
            
            if ((self.basicDetailsContainerView?.frame.size.height)! < 120)
            {
                self.basicDetailsContainerView?.frame.size.height = 120
            }
            
            self.lblDescription?.sizeToFit()
            self.descriptionContainerView?.frame.size.height = (self.lblDescription?.frame.origin.y)! + (self.lblDescription?.frame.size.height)! + 10
            
            self.ratingViewMyRating?.rating = 0//Double(self.objStoreDetails.strTotalRating) ?? 0
            
            let strAvgRtng: String = String(format: "%.01f", Float(self.objStoreDetails.strAverageRating) ?? 0)
            self.lblRatingInDetails?.text = strAvgRtng
            self.ratingViewInDetails?.rating = Double(self.objStoreDetails.strAverageRating) ?? 0
            self.lblAverageRating?.text = strAvgRtng
            self.ratingViewAverageRating?.rating = Double(self.objStoreDetails.strAverageRating) ?? 0
            self.lblRatingCount?.text = self.objStoreDetails.strTotalRating
            
            if ((Double(self.objStoreDetails.strAverageRating5) ?? 0) > 0)
            {
                self.fiveValueView?.frame.size.width = ((self.fiveValueContainerView?.frame.size.width)! / 100) * CGFloat((Double(self.objStoreDetails.strAverageRating5) ?? 0))
            }
            else
            {
                self.fiveValueView?.frame.size.width = 0
            }
            
            if ((Double(self.objStoreDetails.strAverageRating4) ?? 0) > 0)
            {
                self.foreValueView?.frame.size.width = ((self.foreValueContainerView?.frame.size.width)! / 100) * CGFloat((Double(self.objStoreDetails.strAverageRating4) ?? 0))
            }
            else
            {
                self.foreValueView?.frame.size.width = 0
            }
            
            if ((Double(self.objStoreDetails.strAverageRating3) ?? 0) > 0)
            {
                self.threeValueView?.frame.size.width = ((self.threeValueContainerView?.frame.size.width)! / 100) * CGFloat((Double(self.objStoreDetails.strAverageRating3) ?? 0))
            }
            else
            {
                self.threeValueView?.frame.size.width = 0
            }
            
            if ((Double(self.objStoreDetails.strAverageRating2) ?? 0) > 0)
            {
                self.twoValueView?.frame.size.width = ((self.twoValueContainerView?.frame.size.width)! / 100) * CGFloat((Double(self.objStoreDetails.strAverageRating2) ?? 0))
            }
            else
            {
                self.twoValueView?.frame.size.width = 0
            }
            
            if ((Double(self.objStoreDetails.strAverageRating1) ?? 0) > 0)
            {
                self.oneValueView?.frame.size.width = ((self.oneValueContainerView?.frame.size.width)! / 100) * CGFloat((Double(self.objStoreDetails.strAverageRating1) ?? 0))
            }
            else
            {
                self.oneValueView?.frame.size.width = 0
            }
            
            if (self.objStoreDetails.arrayReview.count > 0)
            {
                self.btnViewAllRating?.setTitle(NSLocalizedString("activity_store_details_see_more_reviews", value:"Ver todos as resenhas", comment: ""), for: .normal)
            }
            else
            {
                self.btnViewAllRating?.setTitle("Este negócio ainda não foi avaliado", for: .normal)
            }
            
            //SUB CATEGORY
            self.subcategoriesTagListView?.removeAllTags()
            self.subcategoriesTagListView?.addTags(self.objStoreDetails.arrayTags)
            
            if (self.objStoreDetails.arrayTags.count > 0)
            {
                let subcategoriesLastRow: UIView = (self.subcategoriesTagListView?.subviews[(self.subcategoriesTagListView?.subviews.count)! - 1])!
                
                self.subcategoriesTagListView?.frame.size.height = subcategoriesLastRow.frame.origin.y + subcategoriesLastRow.frame.size.height
                
                self.subcategoriesContainerView?.frame.size.height = (self.subcategoriesTagListView?.frame.origin.y)! + (self.subcategoriesTagListView?.frame.size.height)! + 20
            }
            
            
            //SERVICE
            self.servicesTagListView?.removeAllTags()
            self.servicesTagListView?.addTags(self.objStoreDetails.arrayStoreTags)
            
            if (self.objStoreDetails.arrayStoreTags.count > 0)
            {
                let servicesLastRow: UIView = (self.servicesTagListView?.subviews[(self.servicesTagListView?.subviews.count)! - 1])!
                
                self.servicesTagListView?.frame.size.height = servicesLastRow.frame.origin.y + servicesLastRow.frame.size.height
                
                self.servicesContainerView?.frame.size.height = (self.servicesTagListView?.frame.origin.y)! + (self.servicesTagListView?.frame.size.height)! + 20
            }
            
            
            //TIMINGS
            self.timingsTagListView?.removeAllTags()
            self.timingsTagListView?.addTags(self.objStoreDetails.arrayStoreTimings)
            
            if (self.objStoreDetails.arrayStoreTimings.count > 0)
            {
                let timingsLastRow: UIView = (self.timingsTagListView?.subviews[(self.timingsTagListView?.subviews.count)! - 1])!
                
                self.timingsTagListView?.frame.size.height = timingsLastRow.frame.origin.y + timingsLastRow.frame.size.height
                
                self.timingsContainerView?.frame.size.height = (self.timingsTagListView?.frame.origin.y)! + (self.timingsTagListView?.frame.size.height)! + 20
            }
            
          
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
            self.productsCollectionView.reloadData()
        })
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        
        let vc=ImagePreviewViewController()
        vc.imgArray = self.photosData
          let indexPath = IndexPath(item: selectedImageIndex, section: 0)
         vc.passedContentOffset = indexPath
        self.present(vc, animated: true, completion: nil)
 
    }
    
    @objc func user_UpdateStoreFavouriteEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.objStoreDetails = dataManager.objSelectedStoreDetails
            

            
            let hud : MBProgressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.text
            
            if (self.objStoreDetails.strIsFavourite == "1")
            {
                self.btnFavourite?.setBackgroundImage(UIImage(named: "ic_yellow_star.png"), for: .normal)

                hud.detailsLabel.text = NSLocalizedString("activity_add_favourite_dialog_title", value:"Adicionado aos favoritos", comment: "")
            }
            else
            {
                self.btnFavourite?.setBackgroundImage(UIImage(named: "ic_grey_star.png"), for: .normal)
                
                hud.detailsLabel.text = NSLocalizedString("activity_remove_favourite_dialog_title", value:"Removido dos favoritos", comment: "")
            }
            
            
            hud.detailsLabel.font = MySingleton .sharedManager().themeFontFourteenSizeRegular
            hud.removeFromSuperViewOnHide = true
            hud.margin = 10
            hud.hide(animated: true, afterDelay: 2)
            
        })
    }
    
    @objc func user_sendBulkMessageEvent()
    {
        DispatchQueue.main.async(execute: {
            
            UserDefaults.standard.setValue((self.txtViewBulkMessage?.text)!, forKey: "bulk_message")
            UserDefaults.standard.synchronize()
            
            self.bulkMessagePopupContainerView?.removeFromSuperview()
                        
            var originalString = ""
            
            if (self.txtViewBulkMessage?.text == "")
            {
                originalString = "https://wa.me/55\(self.objStoreDetails.strPhoneNumber)?text=(via AZpop) \("Gostaria de mais informações.")"
            }
            else
            {
                originalString = "https://wa.me/55\(self.objStoreDetails.strPhoneNumber)?text=(via AZpop) \((self.txtViewBulkMessage?.text)!)"
            }
            
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

            guard let url = URL(string: escapedString!) else {
              return //be safe
            }

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            //self.appDelegate?.showAlertViewWithTitle(title: "", detail: "Sucesso! Enviamos sua mensagem para nossos parceiros. Aguarde o contato por WhatsApp.!")
            
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        subcategoriesContainerView?.frame.size.width = (mainTableView?.frame.size.width)!
        
        
        mainTableView?.reloadData()
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("store_details", value:"Detalhes do negócio", comment: "")
        
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
        
        btnEdit?.addTarget(self, action: #selector(self.btnEditClicked(_:)), for: .touchUpInside)
        editContainerView?.isHidden = false
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnEditClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        //SHARE
        let originalString = "https://wa.me/?text=*---Dados do meu negócio---*\n*\(objStoreDetails.strName)*\n*\(objStoreDetails.strPhoneNumber)*\n*\(objStoreDetails.strEmail)*\n*\(ServerIPForWebsite)\(objStoreDetails.strSlug)*"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: escapedString!) else {
          return //be safe
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
//        if (Int(self.objStoreDetails.strIsEditUnderApproval) ?? 0 > 0)
//         {
//             appDelegate?.showAlertViewWithTitle(title: NSLocalizedString("activity_manage_store_already_approval_title", value:"Aguardando aprovação da solicitação anterior", comment: ""), detail: NSLocalizedString("activity_manage_store_already_approval_description", value:"Você poderá fazer novas modificações assim que a sua alteração anterior for aprovada", comment: ""))
//         }
//        else
//        {
//            //EDIT STORE
//
//            let objMyStore: MyStore = MyStore()
//            objMyStore.strID = self.objStoreDetails.strID
//            objMyStore.strUserID = ""
//            objMyStore.strName = self.objStoreDetails.strName
//            objMyStore.strCountryCode = self.objStoreDetails.strCountryCode
//            objMyStore.strPhoneNumber = self.objStoreDetails.strPhoneNumber
//            objMyStore.strAddress = self.objStoreDetails.strAddress
//            objMyStore.strStateID = self.objStoreDetails.strAddress
//            objMyStore.strStateName = self.objStoreDetails.strStateName
//            objMyStore.strCityID = self.objStoreDetails.strCityID
//            objMyStore.strCityName = self.objStoreDetails.strCityName
//            objMyStore.strZipCode = ""
//            objMyStore.strEmail = self.objStoreDetails.strEmail
//            objMyStore.strStatus = "1"
//            objMyStore.strType = self.objStoreDetails.strType
//            objMyStore.strDescription = self.objStoreDetails.strDescription
//            objMyStore.strProfileScore = "0"
//            objMyStore.strIsHideAddress = self.objStoreDetails.strHideAddress
//            objMyStore.strFormatedAddress = self.objStoreDetails.strFormatedAddress
//
//            objMyStore.strTags = self.objStoreDetails.strTags
//            objMyStore.strIsEditUnderApproval = self.objStoreDetails.strIsEditUnderApproval
//            objMyStore.strIsPromotionUnderApproval = self.objStoreDetails.strIsPromotionUnderApproval
//            objMyStore.strStoreTags = self.objStoreDetails.strStoreTags
//            objMyStore.strStoreTime = self.objStoreDetails.strStoreTime
//            objMyStore.strStoreTimeFormated = ""
//            objMyStore.strImages = self.objStoreDetails.strStoreImages
//
//            if (objMyStore.strImages != "")
//            {
//                objMyStore.arrayStoreImages = objMyStore.strImages.components(separatedBy: ",")
//            }
//
//
//            //TIMINGS
//            if (objMyStore.strStoreTime != "")
//            {
//                let arrayStoreTimingsTemp = objMyStore.strStoreTime.components(separatedBy: ",")
//                objMyStore.arrayStoreTimings = [String]()
//                objMyStore.arrayStoreTimingsFormated = [String]()
//                for strTiming in arrayStoreTimingsTemp
//                {
//                    objMyStore.arrayStoreTimings.append(strTiming)
//                    let arrayTimingTemp = strTiming.components(separatedBy: "#")
//
//                    if (arrayTimingTemp.count == 3)
//                    {
//                        let strFinalTime: String = "\(objCommonUtility.arrayWeakDays[Int(arrayTimingTemp[0]) ?? 0]) das \(arrayTimingTemp[1]) até \(arrayTimingTemp[2])"
//
//                        objMyStore.arrayStoreTimingsFormated.append(strFinalTime)
//                    }
//                    else
//                    {
//                        objMyStore.arrayStoreTimingsFormated.append(strTiming)
//                    }
//                }
//            }
//
//            let viewController: User_AddStoreViewController = User_AddStoreViewController()
//            viewController.objMyStore = objMyStore
//            viewController.boolIsOpenForEdit = true
//            self.navigationController?.pushViewController(viewController, animated: false)
//        }
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        mainTableView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //BASIC DETAILS
        basicDetailsContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        lblName?.font = MySingleton.sharedManager().themeFontTwentySizeBold
        lblName?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblName?.text = ""
        
        btnFavourite?.addTarget(self, action: #selector(self.btnFavouriteClicked(_:)), for: .touchUpInside)
        btnFacebook?.addTarget(self, action: #selector(self.btnFacebookClicked(_:)), for: .touchUpInside)
        btnInstagram?.addTarget(self, action: #selector(self.btnInstagramClicked(_:)), for: .touchUpInside)
        
        lblAddress?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblAddress?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblAddress?.text = ""
        
        lblDescription?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblDescription?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblDescription?.text = ""
                
        lblPromotionContainerView?.backgroundColor = .clear
        
        lblPromotion?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblPromotion?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblPromotion?.text = NSLocalizedString("promotion", value:"Promoção", comment: "")
                
        lblPromotionValue?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblPromotionValue?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        lblPromotionValue?.isUserInteractionEnabled = true
        lblPromotionValue!.addGestureRecognizer(labelTap)
        
        lblRatingInDetails?.font = MySingleton.sharedManager().themeFontTwentySizeBold
        lblRatingInDetails?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        ratingViewInDetails?.backgroundColor = .clear
        ratingViewInDetails?.settings.fillMode = .full
        ratingViewInDetails?.settings.starMargin = 5
        ratingViewInDetails?.settings.starSize = 15
        ratingViewInDetails?.settings.filledColor = MySingleton.sharedManager().themeGlobalLightGreenColor!
        ratingViewInDetails?.settings.emptyBorderColor = MySingleton.sharedManager().themeGlobalDarkGreyColor!
        
        btnRatingInDetails?.addTarget(self, action: #selector(self.btnViewAllRatingClicked(_:)), for: .touchUpInside)
        
        //BULK MESSSAGE
        bulkMessageContainerView?.backgroundColor = UIColor.clear
        
        btnBulkMessage?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnBulkMessage?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnBulkMessage?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnBulkMessage?.clipsToBounds = true
        btnBulkMessage?.layer.cornerRadius = 5
        btnBulkMessage?.addTarget(self, action: #selector(self.btnBulkMessageClicked(_:)), for: .touchUpInside)
        
        //PRODUCTS
        productsContainerView?.backgroundColor = UIColor.clear
        
        //MY RATINGS
        myRatingsContainerView?.backgroundColor = .clear
        
        lblMyRating?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblMyRating?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblMyRating?.text = NSLocalizedString("activity_reviews_title", value:"Todos as resenhas", comment: "")
        
        ratingViewMyRating?.backgroundColor = .clear
        ratingViewMyRating?.settings.fillMode = .full
        //ratingViewMyRating?.settings.starMargin = 10
        ratingViewMyRating?.settings.filledColor = MySingleton.sharedManager().themeGlobalLightGreenColor!
        ratingViewMyRating?.settings.emptyBorderColor = MySingleton.sharedManager().themeGlobalDarkGreyColor!
        
        lblAddMyRating?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        lblAddMyRating?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblAddMyRating?.text = NSLocalizedString("activity_store_details_give_rating_text", value:"escreva uma resenha", comment: "").uppercased()
        
        btnAddMyRating?.addTarget(self, action: #selector(self.btnAddMyRatingClicked(_:)), for: .touchUpInside)
        
        lblAverageRating?.font = MySingleton.sharedManager().themeFontTwentySizeBold
        lblAverageRating?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        ratingViewAverageRating?.backgroundColor = .clear
        ratingViewAverageRating?.settings.fillMode = .full
        ratingViewAverageRating?.settings.starMargin = 5
        ratingViewAverageRating?.settings.starSize = 20
        ratingViewAverageRating?.settings.filledColor = MySingleton.sharedManager().themeGlobalLightGreenColor!
        ratingViewAverageRating?.settings.emptyBorderColor = MySingleton.sharedManager().themeGlobalDarkGreyColor!
        
        lblRatingCount?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblRatingCount?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        fiveValueView?.backgroundColor = MySingleton.sharedManager().themeGlobalGreenColor
        fiveValueView?.clipsToBounds = true
        fiveValueView?.layer.cornerRadius = 5
        
        foreValueView?.backgroundColor = MySingleton.sharedManager().themeGlobalGreenColor
        foreValueView?.clipsToBounds = true
        foreValueView?.layer.cornerRadius = 5
        
        threeValueView?.backgroundColor = MySingleton.sharedManager().themeGlobalGreenColor
        threeValueView?.clipsToBounds = true
        threeValueView?.layer.cornerRadius = 5
        
        twoValueView?.backgroundColor = MySingleton.sharedManager().themeGlobalGreenColor
        twoValueView?.clipsToBounds = true
        twoValueView?.layer.cornerRadius = 5
        
        oneValueView?.backgroundColor = MySingleton.sharedManager().themeGlobalGreenColor
        oneValueView?.clipsToBounds = true
        oneValueView?.layer.cornerRadius = 5
        
        
        //ALL RATINGS
        allRatingsContainerView?.backgroundColor = .clear
        
        btnViewAllRating?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnViewAllRating?.setTitle(NSLocalizedString("activity_store_details_see_more_reviews", value:"Ver todos as resenhas", comment: ""), for: .normal)
        btnViewAllRating?.setTitleColor(MySingleton.sharedManager().themeGlobalDarkGreyColor, for: .normal)
        btnViewAllRating?.addTarget(self, action: #selector(self.btnViewAllRatingClicked(_:)), for: .touchUpInside)
        
        //SUBCATEGORIES
        subcategoriesContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        lblSubcategories?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblSubcategories?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblSubcategories?.text = NSLocalizedString("subcategoria_do", value:"Subcategoria do negócio", comment: "")
        
        subcategoriesTagListView?.textFont = MySingleton.sharedManager().themeFontFourteenSizeRegular!
        subcategoriesTagListView?.textColor = MySingleton.sharedManager().themeGlobalBlackColor!
        subcategoriesTagListView?.cornerRadius = 12
        subcategoriesTagListView?.alignment = .left
        subcategoriesTagListView?.tagBackgroundColor = MySingleton.sharedManager().themeGlobalLightGreyColor!
        
        
        //SERVICES
        servicesContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        lblServices?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblServices?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblServices?.text = NSLocalizedString("palavras_chave", value:"Palavras-chave", comment: "")
        
        servicesTagListView?.textFont = MySingleton.sharedManager().themeFontFourteenSizeRegular!
        servicesTagListView?.textColor = MySingleton.sharedManager().themeGlobalBlackColor!
        servicesTagListView?.cornerRadius = 10
        servicesTagListView?.alignment = .left
        servicesTagListView?.tagBackgroundColor = MySingleton.sharedManager().themeGlobalLightGreyColor!
        
        //TIMINGS
        timingsContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        lblTimings?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblTimings?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblTimings?.text = NSLocalizedString("funcionamento_do", value:"Horários de funcionamento do seu negócio", comment: "")
        
        timingsTagListView?.textFont = MySingleton.sharedManager().themeFontFourteenSizeRegular!
        timingsTagListView?.textColor = MySingleton.sharedManager().themeGlobalBlackColor!
        timingsTagListView?.cornerRadius = 10
        timingsTagListView?.alignment = .left
        timingsTagListView?.tagBackgroundColor = MySingleton.sharedManager().themeGlobalLightGreyColor!
        
                
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalBackgroundGreyColor
        mainTableView?.isHidden = true
        
        btnSend?.backgroundColor = MySingleton.sharedManager().themeGlobalWhatsappColor
        btnSend?.clipsToBounds = true
        btnSend?.layer.cornerRadius = (btnSend?.frame.size.width)! / 2
        btnSend?.addTarget(self, action: #selector(self.btnSendClicked(_:)), for: .touchUpInside)
        
        lblReporterProb?.text = NSLocalizedString("reportar_problema", value:"O WhatsApp desse negócio não existe/está errado? Avise aqui!", comment: "")
        lblReporterProb?.numberOfLines = 3
        lblReporterProb?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblReporterProb?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        lblReporterView?.clipsToBounds = true
        lblReporterView?.layer.cornerRadius = 5
        lblReporterView?.backgroundColor = MySingleton.sharedManager().themeGlobalReportAProblemButtonGrayColor
        
        btnReporterProb?.addTarget(self, action: #selector(self.btnReporterClicked(_:)), for: .touchUpInside)
               
        
      //  self.browser = MWPhotoBrowser(delegate: self)
        
        // Set options
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
        
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        print("labelTapped")
        
        let viewController: User_PromotionDetailsViewController = User_PromotionDetailsViewController()
        viewController.strSelectedStoreID = self.strSelectedStoreID
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        self.view.addSubview(bulkMessagePopupContainerView!)
        
//        //API CALL
//        dataManager.user_UpdateStoreClicks(strStoreID: self.objStoreDetails.strID, strScreenID: self.strScreenID)
//
//        if (self.objStoreDetails.strPhoneNumber != "")
//        {
//            print("self.objStoreDetails.strPhoneNumber :\(self.objStoreDetails.strPhoneNumber)")
//
//            let originalString = "https://wa.me/55\(self.objStoreDetails.strPhoneNumber)?text=Olá. Achei seu contato no AZpop (Cliente n. \(UserDefaults.standard.value(forKey: "hashed_user_id") ?? "-"))&source=&data="
//            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//
//            guard let url = URL(string: escapedString!) else {
//              return //be safe
//            }
//
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
    }
    
    @IBAction func btnFavouriteClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (self.objStoreDetails.strIsFavourite == "1")
        {
            //API CALL
            dataManager.user_UpdateStoreFavourite(strStoreID: self.strSelectedStoreID, strIsFavourite: "0")
        }
        else
        {
            //API CALL
            dataManager.user_UpdateStoreFavourite(strStoreID: self.strSelectedStoreID, strIsFavourite: "1")
        }
    }
    
    @IBAction func btnFacebookClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let originalString: String = "https://www.facebook.com/\(objStoreDetails.strFacebookLink)"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: escapedString!) else {
          return //be safe
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnInstagramClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let originalString: String = "\(objStoreDetails.strInstagramLink)"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: escapedString!) else {
          return //be safe
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnAddMyRatingClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (self.objStoreDetails.strIsReviewes == "1")
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Você já avaliou esse profissional e/ou lojista")
        }
        else
        {
            let viewController: User_AddReviewViewController = User_AddReviewViewController()
            viewController.boolIsOpenedForProduct = false
            viewController.strID = self.strSelectedStoreID
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @IBAction func btnViewAllRatingClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if self.objStoreDetails.arrayReview.count > 0
        {
            let viewController: User_AllReviewsViewController = User_AllReviewsViewController()
            viewController.boolIsOpenedForProduct = false
            viewController.strID = self.strSelectedStoreID
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @IBAction func btnReporterClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController: ReporterProblemViewController = ReporterProblemViewController()
        viewController.strStoreID = strSelectedStoreID
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    @IBAction func btnBulkMessageClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        self.view.addSubview(bulkMessagePopupContainerView!)
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
            dataManager.user_sendBulkMessage(strType: "2", strStoreID: self.objStoreDetails.strID, strMessage: "\((txtViewBulkMessage?.text)!)")
        }
        
    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 11
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if (section == 0)
        {
            return (basicDetailsContainerView?.frame.size.height)!
        }
        else if (section == 1)
        {
            return (bulkMessageContainerView?.frame.size.height)!
        }
        else if (section == 2)
        {
            return dataManager.arrayStoreProducts.count > 0 ? (productsContainerView?.frame.size.height)! : 0
        }
        else if (section == 3)
        {
            return self.objStoreDetails.arrayStoreImages.count > 0 ? (fotosContainerView?.frame.size.height)! : 0
        }
        else if (section == 4)
        {
            return self.objStoreDetails.strDescription != "" ? (descriptionContainerView?.frame.size.height)! : 0
        }
        else if (section == 5)
        {
            if (self.objStoreDetails.arrayTags.count > 0)
            {
                return (subcategoriesContainerView?.frame.size.height)!
            }
            else
            {
                return 0
            }
        }
        else if (section == 6)
        {
            if (self.objStoreDetails.arrayStoreTags.count > 0)
            {
                return (servicesContainerView?.frame.size.height)!
            }
            else
            {
                return 0
            }
        }
        else if (section == 7)
        {
            return (myRatingsContainerView?.frame.size.height)!
        }
        else if (section == 8)
        {
            return (allRatingsContainerView?.frame.size.height)!
        }
        else if (section == 9)
        {
           if (self.objStoreDetails.arrayStoreTimings.count > 0)
          {
              return (timingsContainerView?.frame.size.height)!
          }
          else
          {
              return 0
          }
        }
        else if (section == 10)
        {
            return (reporterProbContainerView?.frame.size.height)!
           
        }
        else
        {
//            return (blankMarginContainerView?.frame.size.height)!
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if (section == 0)
        {
            return basicDetailsContainerView
        }
        else if (section == 1)
        {
            return bulkMessageContainerView
        }
        else if (section == 2)
        {
            return dataManager.arrayStoreProducts.count > 0 ? productsContainerView : nil
        }
        else if (section == 3)
        {
            return self.objStoreDetails.arrayStoreImages.count > 0 ? fotosContainerView : nil
        }
        else if (section == 4)
        {
            return self.objStoreDetails.strDescription != "" ? descriptionContainerView : nil
        }
        else if (section == 5)
        {
            if (self.objStoreDetails.arrayTags.count > 0)
            {
                return subcategoriesContainerView
            }
            else
            {
                return nil
            }
        }
        else if (section == 6)
        {
            if (self.objStoreDetails.arrayStoreTags.count > 0)
            {
                return servicesContainerView
            }
            else
            {
                return nil
            }
        }
        else if (section == 7)
        {
            return myRatingsContainerView
        }
        else if (section == 8)
        {
            return allRatingsContainerView
        }
        else if (section == 9)
        {
            if (self.objStoreDetails.arrayStoreTimings.count > 0)
            {
              return timingsContainerView
            }
            else
            {
                return nil
            }
        }
        else if (section == 10)
        {
            return reporterProbContainerView
        }
        else
        {
//            return blankMarginContainerView
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == 7)
        {
            return self.objStoreDetails.arrayReview.count
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.section == 7)
        {
            let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:ReviewTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? ReviewTableViewCell
            
            if(cell == nil)
            {
                cell = ReviewTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.ratingViewUserRating.rating = Double(self.objStoreDetails.arrayReview[indexPath.row].strRate) ?? 0
            
            cell.lblDate.text = self.objStoreDetails.arrayReview[indexPath.row].strReviewDate
            cell.lblReviewText.text = self.objStoreDetails.arrayReview[indexPath.row].strReviewText
            
            cell.lblReviewText.sizeToFit()
            
            cell.innerContainer.frame.size.height = cell.lblReviewText.frame.origin.y + cell.lblReviewText.frame.size.height + 10
            cell.mainContainer.frame.size.height = cell.innerContainer.frame.origin.y + cell.innerContainer.frame.size.height + 5
            
            return cell.mainContainer.frame.size.height
        }
        else
        {
            return 44.0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:ReviewTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? ReviewTableViewCell
        
        if(cell == nil)
        {
            cell = ReviewTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
        }
        
        cell.ratingViewUserRating.rating = Double(self.objStoreDetails.arrayReview[indexPath.row].strRate) ?? 0
        
        cell.lblDate.text = self.objStoreDetails.arrayReview[indexPath.row].strReviewDate
        cell.lblReviewText.text = self.objStoreDetails.arrayReview[indexPath.row].strReviewText
        
        cell.lblReviewText.sizeToFit()
        
        cell.innerContainer.frame.size.height = cell.lblReviewText.frame.origin.y + cell.lblReviewText.frame.size.height + 10
        cell.mainContainer.frame.size.height = cell.innerContainer.frame.origin.y + cell.innerContainer.frame.size.height + 5
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    // MARK: - UICollectionView Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productsCollectionView
        {
            return dataManager.arrayStoreProducts.count > 0 ? (dataManager.arrayStoreProducts.count + 1) : 0
        }
        else
        {
            return self.objStoreDetails.arrayStoreImages.count > 0 ? (self.objStoreDetails.arrayStoreImages.count) : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == productsCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVCell", for: indexPath) as! ProductCVCell
            
            if (indexPath.item < (dataManager.arrayStoreProducts.count))
            {
                let objProduct = dataManager.arrayStoreProducts[indexPath.item]
                if (objProduct.arrayProductImages.count > 0)
                {
                    cell.imgViewProduct.sd_setImage(with: URL(string: objProduct.arrayProductImages[0]), placeholderImage: objProduct.strProductType == "1" ? UIImage(named: "product_placeholder") : UIImage(named: "service_placeholder"))
                }
                else
                {
                    cell.imgViewProduct.image = objProduct.strProductType == "1" ? UIImage(named: "product_placeholder") : UIImage(named: "service_placeholder")
                }
                
                cell.lblProductName.text = objProduct.strTitle
                
                
                
                //cell.lblProductPricePoints.text = "R$\(objProduct.strMoneyPrice) ou\(objProduct.strPointPrice) Pontos"
                
                let floatValue: Float = Float(objProduct.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
                if (floatValue > 0)
                {
                    let floatDiscountValue: Float = Float(objProduct.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
                    if (floatDiscountValue > 0)
                    {
                        let strDiscountValue: String = String(format: "%.02f", Float(objProduct.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                        let strValue: String = String(format: "%.02f", Float(objProduct.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                        
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "R$ \(strValue)".replacingOccurrences(of: ".", with: ","))
                        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        let attributeString2: NSMutableAttributedString = NSMutableAttributedString(string: " R$ \(strDiscountValue)".replacingOccurrences(of: ".", with: ","))
                        attributeString2.addAttribute(NSAttributedString.Key.foregroundColor, value: MySingleton.sharedManager().themeGlobalBlackColor!, range: NSMakeRange(0, attributeString2.length))
                        attributeString.append(attributeString2)
                        cell.lblProductPricePoints.attributedText = attributeString
                    }
                    else
                    {
                        let strValue: String = String(format: "%.02f", Float(objProduct.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                                    
                        cell.lblProductPricePoints.text = "R$ \(strValue)".replacingOccurrences(of: ".", with: ",")
                    }
                }
                else
                {
                    cell.lblProductPricePoints.text = ""
                }
                
                cell.viewAllContainerView.isHidden = true
            }
            else
            {
                cell.viewAllContainerView.isHidden = false
            }
            
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreImageCVCell", for: indexPath) as! StoreImageCVCell
                        
            cell.imgViewStore.sd_setImage(with: URL(string: self.objStoreDetails.arrayStoreImages[indexPath.row]), placeholderImage: UIImage(named: "no_image_to_show.png"))
            
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        if collectionView == productsCollectionView
        {
            
            if (indexPath.item < dataManager.arrayStoreProducts.count)
            {
                let objProduct = dataManager.arrayStoreProducts[indexPath.item]
                
                let viewController = ProductDetailsVC()
                viewController.strSelectedStoreProductID = objProduct.strID
                self.navigationController?.pushViewController(viewController, animated: false)
            }
            else
            {
                let viewController: ProductListByStoreVC = ProductListByStoreVC()
                viewController.strStoreID = self.strSelectedStoreID
                self.navigationController?.pushViewController(viewController, animated: false)
                
            }
        }
        else
        {
            let vc=ImagePreviewViewController()
            vc.imgArray = self.photosData
            let indexPath = IndexPath(item: indexPath.row, section: 0)
             vc.passedContentOffset = indexPath
            self.present(vc, animated: true, completion: nil)
        }
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
    
    // MARK: - UIScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll called")
        
        
    }

    
    
    
//    // MARK: - MWPhotoBrowser Delegate Methods
//
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
//            print("Rotate Left")
//                var index: Int = 0
//
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
    
}




