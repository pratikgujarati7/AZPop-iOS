//
//  ProductDetailsVC.swift
//  AgendaZap
//
//  Created by Dipen on 16/12/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import MWPhotoBrowser
import MBProgressHUD

class ProductDetailsVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Outlets
    
    @IBOutlet var mainTableView: UITableView?
    
    @IBOutlet var basicDetailsContainerView: UIView!
    
    @IBOutlet var imageSliderScrollView: UIScrollView?
    @IBOutlet var imageSliderPageControl: UIPageControl?
    
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var imageViewWhatsapp: UIImageView!
    @IBOutlet var btnBuyNow: UIButton!
    
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
    
    @IBOutlet var descriptionContainerView: UIView!
    @IBOutlet var lblProductDetails: UILabel!
    
    @IBOutlet var btnWhatsapp: UIButton!
    
    //SEND BULK MESSAGE
    @IBOutlet var bulkMessagePopupContainerView: UIView?
    @IBOutlet var bulkMessageInnerContainerView: UIView?
    @IBOutlet var btnCloseBulkMessage: UIButton?
    @IBOutlet var lblBulkMessage: UILabel?
    @IBOutlet var lblBulkMessageTitle: UILabel?
    @IBOutlet var txtViewBulkMessageContainerView: UIView?
    @IBOutlet var txtViewBulkMessage: UITextView?
    @IBOutlet var btnSendBulkMessage: UIButton?
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var boolIsScreenOpenedFromNotification: Bool = false
    
    var strSelectedStoreProductID: String!
    var objProductData: ObjStoreProduct!
    
    fileprivate var selectedImageIndex: Int = 0
    
    var browser : MWPhotoBrowser!
    var photos = [MWPhoto]()
    var photosData = [UIImage]()
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNotificationEvent()
        self.setupInitialView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //API CALL
        dataManager.user_GetStoreProductDetails(strProductID: self.strSelectedStoreProductID)
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
    
    //MARK:- Setup Notification Methods
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetStoreProductDetailsEvent),
                name: Notification.Name("user_GetStoreProductDetailsEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_getStoreCartProductsEvent),
                name: Notification.Name("user_getStoreCartProductsEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_sendBulkMessageEvent),
                name: Notification.Name("user_sendBulkMessageEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_makeProductOrderEvent),
                name: Notification.Name("user_makeProductOrderEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetStoreProductDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
                        
            self.objProductData = dataManager.objSelectedStoreProduct
            
            let subViews = self.imageSliderScrollView?.subviews
            for subview in subViews!{
                subview.removeFromSuperview()
            }
            
            if (self.objProductData.arrayProductImages.count > 0)
            {
                self.photos = [MWPhoto]()
                self.photosData = [UIImage]()
                var i: Int = 0
                for strImageURL in self.objProductData.arrayProductImages
                {
                    let width: CGFloat = (self.imageSliderScrollView?.frame.size.width)!
                    let height: CGFloat = (self.imageSliderScrollView?.frame.size.height)!

                    let url:NSURL = NSURL(string: strImageURL)!
                    let data = try? Data(contentsOf: url as URL)
                    
                    let imageView: UIImageView = UIImageView(frame: CGRect(x: (CGFloat(i) * width), y: 0, width: width, height: height))
                    imageView.contentMode = .scaleAspectFill
                    imageView.clipsToBounds = true
                    if (data != nil)
                    {
                        imageView.image = UIImage(data: data!)
                    }
                    else
                    {
                        imageView.image = self.objProductData.strProductType == "1" ? UIImage(named: "product_placeholder") : UIImage(named: "service_placeholder")
                    }
                    imageView.isUserInteractionEnabled = true
                    imageView.tag = i

                    self.photos.append(MWPhoto(image: imageView.image))
                    self.photosData.append(imageView.image!)

                    let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
                    imageView.addGestureRecognizer(gesture)
                    i = i + 1
                    self.imageSliderScrollView?.addSubview(imageView)
                }

                self.imageSliderScrollView?.contentSize = CGSize(width: (self.imageSliderScrollView?.frame.size.width)! * CGFloat(self.objProductData.arrayProductImages.count), height: (self.imageSliderScrollView?.frame.size.height)!)

                self.imageSliderPageControl?.numberOfPages = self.objProductData.arrayProductImages.count
            }
            else
            {
                let width: CGFloat = (self.imageSliderScrollView?.frame.size.width)!
                let height: CGFloat = (self.imageSliderScrollView?.frame.size.height)!
                
                let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
                imageView.image = self.objProductData.strProductType == "1" ? UIImage(named: "product_placeholder") : UIImage(named: "service_placeholder")
                self.imageSliderScrollView?.addSubview(imageView)

                self.imageSliderScrollView?.contentSize = CGSize(width: (self.imageSliderScrollView?.frame.size.width)!, height: (self.imageSliderScrollView?.frame.size.height)!)

                self.imageSliderPageControl?.numberOfPages = 0
            }
            
            //RATING
            self.ratingViewMyRating?.rating = 0//Double(self.objStoreDetails.strTotalRating) ?? 0
            
            let strAvgRtng: String = String(format: "%.01f", Float(self.objProductData.strAverageRating) ?? 0)
            self.lblAverageRating?.text = strAvgRtng
            self.ratingViewAverageRating?.rating = Double(self.objProductData.strAverageRating) ?? 0
            self.lblRatingCount?.text = self.objProductData.strTotalRating
            
            if ((Double(self.objProductData.strAverageRating5) ?? 0) > 0)
            {
                self.fiveValueView?.frame.size.width = ((self.fiveValueContainerView?.frame.size.width)! / 100) * CGFloat((Double(self.objProductData.strAverageRating5) ?? 0))
            }
            else
            {
                self.fiveValueView?.frame.size.width = 0
            }
            
            if ((Double(self.objProductData.strAverageRating4) ?? 0) > 0)
            {
                self.foreValueView?.frame.size.width = ((self.foreValueContainerView?.frame.size.width)! / 100) * CGFloat((Double(self.objProductData.strAverageRating4) ?? 0))
            }
            else
            {
                self.foreValueView?.frame.size.width = 0
            }
            
            if ((Double(self.objProductData.strAverageRating3) ?? 0) > 0)
            {
                self.threeValueView?.frame.size.width = ((self.threeValueContainerView?.frame.size.width)! / 100) * CGFloat((Double(self.objProductData.strAverageRating3) ?? 0))
            }
            else
            {
                self.threeValueView?.frame.size.width = 0
            }
            
            if ((Double(self.objProductData.strAverageRating2) ?? 0) > 0)
            {
                self.twoValueView?.frame.size.width = ((self.twoValueContainerView?.frame.size.width)! / 100) * CGFloat((Double(self.objProductData.strAverageRating2) ?? 0))
            }
            else
            {
                self.twoValueView?.frame.size.width = 0
            }
            
            if ((Double(self.objProductData.strAverageRating1) ?? 0) > 0)
            {
                self.oneValueView?.frame.size.width = ((self.oneValueContainerView?.frame.size.width)! / 100) * CGFloat((Double(self.objProductData.strAverageRating1) ?? 0))
            }
            else
            {
                self.oneValueView?.frame.size.width = 0
            }
            
            if (self.objProductData.arrayReview.count > 0)
            {
                self.btnViewAllRating?.setTitle(NSLocalizedString("activity_store_details_see_more_reviews", value:"Ver todos as resenhas", comment: ""), for: .normal)
            }
            else
            {
                self.btnViewAllRating?.setTitle("Este negócio ainda não foi avaliado", for: .normal)
            }
            
            //SET OTHER DATA
            self.lblProductName.text = self.objProductData.strTitle
            
            let boldAttribute = [NSAttributedString.Key.font: MySingleton.sharedManager().themeFontSixteenSizeMedium!] as [NSAttributedString.Key : Any]
            let normalAttribute = [NSAttributedString.Key.font: MySingleton.sharedManager().themeFontSixteenSizeRegular!] as [NSAttributedString.Key : Any]
            
            //PRICE
            //let strMoney: String = String(format: "%.02f", Float(self.objProductData.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
            //self.lblPrice.text = "R$\(strMoney.replacingOccurrences(of: ".", with: ","))"
            let floatValue: Float = Float(self.objProductData.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
            if (floatValue > 0)
            {
                let floatDiscountValue: Float = Float(self.objProductData.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
                if (floatDiscountValue > 0)
                {
                    let strDiscountValue: String = String(format: "%.02f", Float(self.objProductData.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                    let strValue: String = String(format: "%.02f", Float(self.objProductData.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                    
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "R$ \(strValue)".replacingOccurrences(of: ".", with: ","))
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    let attributeString2: NSMutableAttributedString = NSMutableAttributedString(string: " R$ \(strDiscountValue)".replacingOccurrences(of: ".", with: ","))
                    attributeString2.addAttribute(NSAttributedString.Key.foregroundColor, value: MySingleton.sharedManager().themeGlobalBlackColor!, range: NSMakeRange(0, attributeString2.length))
                    attributeString.append(attributeString2)
                    self.lblPrice.attributedText = attributeString
                }
                else
                {
                    let strValue: String = String(format: "%.02f", Float(self.objProductData.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                                
                    self.lblPrice.text = "R$ \(strValue)".replacingOccurrences(of: ".", with: ",")
                }
            }
            else
            {
                self.lblPrice.text = ""
            }
            
            //DESCRIPTION
            if (self.objProductData.strGift == "")
            {
                self.lblDescription.text = self.objProductData.strDescription
            }
            else
            {
                let desc1String = NSMutableAttributedString(string: "Brinde: ", attributes: boldAttribute)
                let desc2String = NSAttributedString(string: "\(self.objProductData.strGift)", attributes: normalAttribute)
                desc1String.append(desc2String)
                if (self.objProductData.strDescription != "")
                {
                    let desc3String = NSAttributedString(string: "\n\n\(self.objProductData.strDescription)", attributes: normalAttribute)
                    desc1String.append(desc3String)
                }
                self.lblDescription.attributedText = desc1String
            }
            
            self.lblDescription.sizeToFit()
            
            self.btnBuyNow.frame.origin.y = self.lblDescription.frame.origin.y + self.lblDescription.frame.size.height + 20
            self.imageViewWhatsapp.frame.origin.y = self.btnBuyNow.frame.origin.y + 15
            
            self.basicDetailsContainerView.frame.size.height = self.btnBuyNow.frame.origin.y + self.btnBuyNow.frame.size.height + 20
            
            //PRODUCT DETAILS
            let description1String = NSMutableAttributedString(string: "Vendedor: ", attributes: boldAttribute)
            let description2String = NSAttributedString(string: "\(self.objProductData.strStoreName)", attributes: normalAttribute)
            description1String.append(description2String)
            let description3String = NSAttributedString(string: "\nCidade: ", attributes: boldAttribute)
            description1String.append(description3String)
            let description4String = NSAttributedString(string: "\(self.objProductData.strCity != "<null>" ? self.objProductData.strCity : "-")", attributes: normalAttribute)
            description1String.append(description4String)
            self.lblProductDetails.attributedText = description1String
            
            self.descriptionContainerView.frame.size.width = MySingleton.sharedManager().screenWidth
            
            self.lblProductDetails.sizeToFit()
            self.descriptionContainerView.frame.size.height = self.lblProductDetails.frame.size.height + 60
            
            self.appDelegate?.dismissGlobalHUD()
            
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
        })
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        
        let vc = ImagePreviewViewController()
        vc.imgArray = self.photosData
          let indexPath = IndexPath(item: selectedImageIndex, section: 0)
         vc.passedContentOffset = indexPath
        self.present(vc, animated: true, completion: nil)
 
    }
    
    @objc func user_getStoreCartProductsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let viewController: CartVC = CartVC()
            viewController.datarows = dataManager.arrayAllStoreCartProducts
            viewController.strStoreID = self.objProductData.strStoreID
            self.navigationController?.pushViewController(viewController, animated: true)
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
                originalString = "https://wa.me/55\(self.objProductData.strPhoneNumber)?text=(via AZpop) \("Gostaria de mais informações.")"
            }
            else
            {
                originalString = "https://wa.me/55\(self.objProductData.strPhoneNumber)?text=(via AZpop) \((self.txtViewBulkMessage?.text)!)"
            }
            
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

            guard let url = URL(string: escapedString!) else {
              return //be safe
            }

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        })
    }
    
    @objc func user_makeProductOrderEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let strSendNumber: String = dataManager.objSelectedStoreProduct.strPhoneNumber
            
            var originalString = "https://wa.me/55\(strSendNumber)?text=*---Pedido AZpop---*"
            
            originalString = "\(originalString)\n*Produto:* \(dataManager.objSelectedStoreProduct.strTitle)\n*Preço:* \(dataManager.objSelectedStoreProduct.strMoneyPrice)"
            
            let strPaymentType: String = "buynow"
            
            let strFirstName = "\(UserDefaults.standard.value(forKey: "first_name") ?? "")"
            let strLastName = "\(UserDefaults.standard.value(forKey: "last_name") ?? "")"
            let strName = (strFirstName.lowercased() == "<null>" ? "" : strFirstName) + " " + (strLastName.lowercased() == "<null>" ? "" : strLastName)
            let strPhoneNumber = "\(UserDefaults.standard.value(forKey: "phone_number") ?? "")"
            let strCityName = "\(UserDefaults.standard.value(forKey: "city_name") ?? "")"
            
            originalString = "\(originalString)\n*Método de Pgto.:* \(strPaymentType)\n*-----------------------------------------*\n*TOTAL:* R$ \(self.objProductData.strMoneyPrice.replacingOccurrences(of: ".", with: ","))\n\n*Cliente:* \(strName)\n*WhatsApp:* \(strPhoneNumber)\n*Cidade:* \(strCityName)"
            
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

            guard let url = URL(string: escapedString!) else {
              return //be safe
            }

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mainTableView?.reloadData()
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        if (boolIsScreenOpenedFromNotification == true)
        {
            appDelegate?.setTabBarVC()
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnShareTapped(_ sender: Any) {
        
        var strPrice: String = ""
        let floatValue: Float = Float(self.objProductData.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
        if (floatValue > 0)
        {
            let floatDiscountValue: Float = Float(self.objProductData.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
            if (floatDiscountValue > 0)
            {
                let strDiscountValue: String = String(format: "%.02f", Float(self.objProductData.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                let strValue: String = String(format: "%.02f", Float(self.objProductData.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                
                strPrice = "\n💲Preço normal: R$\(strValue)\n*💲Preço com desconto: R$\(strDiscountValue)*".replacingOccurrences(of: ".", with: ",")
            }
            else
            {
                let strValue: String = String(format: "%.02f", Float(self.objProductData.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                
                strPrice = "\n💲Preço normal: R$\(strValue)".replacingOccurrences(of: ".", with: ",")
            }
        }
        
        if (self.objProductData.strGift != "" && self.objProductData.strGift != "<null>")
        {
            strPrice = "\(strPrice)\n*Brinde:* \(self.objProductData.strGift)"
        }
        
        let slugUrl = "\(ServerIPForWeb)/p/\(self.objProductData.strSlug)"
        let originalString = "https://wa.me/?text=Veja que bacana este item que achei! 👇\n✅\(self.objProductData.strTitle)\(strPrice)\n📱  Link para fazer pedido: \(slugUrl)"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        guard let url = URL(string: escapedString!) else {
          return //be safe
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    @IBAction func btnComboTapped(_ sender: Any) {
        
//        appDelegate?.openTabBarVCScreenPoints()
        
    }
    
    @IBAction func btnBuyNowTapped(_ sender: Any) {
        
        let strFirstName = "\(UserDefaults.standard.value(forKey: "first_name") ?? "")"
        let strLastName = "\(UserDefaults.standard.value(forKey: "last_name") ?? "")"
        let strName = (strFirstName.lowercased() == "<null>" ? "" : strFirstName) + " " + (strLastName.lowercased() == "<null>" ? "" : strLastName)
        let strPhoneNumber = "\(UserDefaults.standard.value(forKey: "phone_number") ?? "")"
        let strEmail = "\(UserDefaults.standard.value(forKey: "email") ?? "")"
        let strCityID = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
        
        //API Call
        dataManager.user_makeProductOrder(
            strStoreID: self.objProductData.strStoreID,
            strCheckoutType: "buynow",
            strID: self.objProductData.strID,
            strMoneySpent: self.objProductData.strMoneyPrice,
            strPointsSpent: self.objProductData.strPointPrice,
            strPhoneNumber: strPhoneNumber,
            strCityID: strCityID,
            strPaymentMethod: "buynow")
    }
    
    @IBAction func btnWhatsappTapped(_ sender: Any) {
        
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
            dataManager.user_sendBulkMessage(strType: "2", strStoreID: self.objProductData.strStoreID, strMessage: "\((txtViewBulkMessage?.text)!)")
        }
        
    }
    
    @IBAction func btnAddMyRatingClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (self.objProductData.strIsReviewes == "1")
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Você já avaliou esse profissional e/ou lojista")
        }
        else
        {
            let viewController: AddProductReviewVC = AddProductReviewVC()
            viewController.boolIsOpenedForProduct = true
            viewController.strID = self.strSelectedStoreProductID
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @IBAction func btnViewAllRatingClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if self.objProductData.arrayReview.count > 0
        {
            let viewController: User_AllReviewsViewController = User_AllReviewsViewController()
            viewController.boolIsOpenedForProduct = true
            viewController.strID = self.strSelectedStoreProductID
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        mainTableView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        //IMAGE SLIDER
        imageSliderScrollView?.delegate = self
        //imageSliderScrollView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        imageSliderScrollView?.clipsToBounds = true
        imageSliderScrollView?.isPagingEnabled = true
                
        //SETUP PAGE CONTROLL
        imageSliderPageControl?.isUserInteractionEnabled = false
        imageSliderPageControl?.currentPage = 0
        imageSliderPageControl?.pageIndicatorTintColor = MySingleton.sharedManager().themeGlobalWhiteColor
        imageSliderPageControl?.currentPageIndicatorTintColor = MySingleton.sharedManager().themeGlobalLightGreenColor
                
        lblPrice?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblPrice?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        btnBuyNow?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnBuyNow?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnBuyNow?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnBuyNow?.clipsToBounds = true
        btnBuyNow?.layer.cornerRadius = 5
        btnBuyNow?.addTarget(self, action: #selector(self.btnBuyNowTapped(_:)), for: .touchUpInside)
        
        //MY RATINGS
        myRatingsContainerView?.backgroundColor = .clear
        
        lblMyRating?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblMyRating?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblMyRating?.text = "Dê sua opinião"
        
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
        
        btnWhatsapp.clipsToBounds = true
        btnWhatsapp.layer.cornerRadius = btnWhatsapp.frame.size.width / 2
        
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
        
        
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalBackgroundGreyColor
        mainTableView?.isHidden = true
    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if (section == 0)
        {
            return (basicDetailsContainerView?.frame.size.height)!
        }
        else if (section == 1)
        {
            return (myRatingsContainerView?.frame.size.height)!
        }
        else if (section == 2)
        {
            return (allRatingsContainerView?.frame.size.height)!
        }
        else
        {
            return (descriptionContainerView?.frame.size.height)!
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
            return myRatingsContainerView
        }
        else if (section == 2)
        {
            return allRatingsContainerView
        }
        else
        {
            return descriptionContainerView
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == 1)
        {
            if self.objProductData != nil
            {
                return self.objProductData.arrayReview.count
            }
            else
            {
                return 0
            }
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath.section == 1)
        {
            let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:ReviewTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? ReviewTableViewCell
            
            if(cell == nil)
            {
                cell = ReviewTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.ratingViewUserRating.rating = Double(self.objProductData.arrayReview[indexPath.row].strRate) ?? 0
            
            cell.lblDate.text = self.objProductData.arrayReview[indexPath.row].strReviewDate
            cell.lblReviewText.text = self.objProductData.arrayReview[indexPath.row].strReviewText
            
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
        
        cell.ratingViewUserRating.rating = Double(self.objProductData.arrayReview[indexPath.row].strRate) ?? 0
        
        cell.lblDate.text = self.objProductData.arrayReview[indexPath.row].strReviewDate
        cell.lblReviewText.text = self.objProductData.arrayReview[indexPath.row].strReviewText
        
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
        
        if (scrollView == imageSliderScrollView)
        {
            let pageWidth : CGFloat = imageSliderScrollView!.frame.size.width
            let page : Int = Int((imageSliderScrollView?.contentOffset.x)!/pageWidth)
            imageSliderPageControl?.currentPage = page
            
            selectedImageIndex = page
        }
    }

}
