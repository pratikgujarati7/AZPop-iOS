//
//  User_PromotionDetailsViewController.swift
//  AgendaZap
//
//  Created by Dipen on 28/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage
import MWPhotoBrowser

class User_PromotionDetailsViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIActionSheetDelegate
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
    
    @IBOutlet var mainTableView: UITableView?
    @IBOutlet var btnSend: UIButton?
    
    //BASIC DETAILS
    @IBOutlet var basicDetailsContainerView: UIView?
    @IBOutlet var imageSliderScrollView: UIScrollView?
    @IBOutlet var imageSliderPageControl: UIPageControl?
    @IBOutlet var lblName: UILabel?
    @IBOutlet var lblAddress: UILabel?
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblDescription: UILabel?
    
    //BLANK MARGIN VIEW AT THE BOTTOM
    @IBOutlet var blankMarginContainerView: UIView?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    let strScreenID: String = "6"
    
    var strSelectedStoreID: String!
    var objPromotionDetails: ObjPromotionDetails = ObjPromotionDetails()
    
  //  var browser : MWPhotoBrowser!
    var photos = [MWPhoto]()
    var photosData = [UIImage]()
    fileprivate var selectedImageIndex: Int = 0
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
        dataManager.user_GetPromotionDetails(strStoreID: self.strSelectedStoreID)
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
            
            let subViews = self.imageSliderScrollView?.subviews
            for subview in subViews!{
                subview.removeFromSuperview()
            }
            
            if (self.objPromotionDetails.arrayImages.count > 0)
            {

                self.photos = [MWPhoto]()
                self.photosData = [UIImage]()
                var i: Int = 0
                for strImageURL in self.objPromotionDetails.arrayImages
                {
                    let width: CGFloat = (self.imageSliderScrollView?.frame.size.width)!
                    let height: CGFloat = (self.imageSliderScrollView?.frame.size.height)!
                    
                    let url:NSURL = NSURL(string: strImageURL)!
                    let data = try? Data(contentsOf: url as URL)
                    
                    let imageView: UIImageView = UIImageView(frame: CGRect(x: (CGFloat(i) * width), y: 0, width: width, height: height))
                    imageView.contentMode = .scaleAspectFit
                    imageView.clipsToBounds = true
                    if (data != nil)
                    {
                        imageView.image = UIImage(data: data!)
                    }
                    else
                    {
                        imageView.image = UIImage(named: "no_image_to_show.png")
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

                self.imageSliderScrollView?.contentSize = CGSize(width: (self.imageSliderScrollView?.frame.size.width)! * CGFloat(self.objPromotionDetails.arrayImages.count), height: (self.imageSliderScrollView?.frame.size.height)!)

                self.imageSliderPageControl?.numberOfPages = self.objPromotionDetails.arrayImages.count
            }
            else
            {
                self.imageSliderScrollView?.isHidden = true
                self.imageSliderPageControl?.isHidden = true
                self.lblName?.frame.origin.y = 10
            }
            
            //BASIC DETAILS
            let main_string = self.objPromotionDetails.strName + " " + NSLocalizedString("ver_perfil", value:"Ver perfil", comment: "")
            let string_to_color = NSLocalizedString("ver_perfil", value:"Ver perfil", comment: "")
            
            

            let range = (main_string as NSString).range(of: string_to_color)

            let attribute = NSMutableAttributedString.init(string: main_string)
//            attribute.setAttributes([NSAttributedString.Key.font : MySingleton.sharedManager().themeFontTwelveSizeRegular!
//                , NSAttributedString.Key.foregroundColor : UIColor(red: 232 / 255.0, green: 117 / 255.0, blue: 40 / 255.0, alpha: 1.0)], range: range) // What ever range you want to give
            attribute.setAttributes([NSAttributedString.Key.font : MySingleton.sharedManager().themeFontTwelveSizeRegular!
            , NSAttributedString.Key.foregroundColor : MySingleton.sharedManager().themeGlobalOrangeColor], range: range) // What ever range you want t
            
          
//            attribute.addAttribute(NSAttributedString.Key.foregroundColor,NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 18.0)!, value: UIColor.red , range: range)
            self.lblName!.attributedText = attribute
            let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.lblNametapGestureMethod(_:)))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            self.lblName?.isUserInteractionEnabled = true
            self.lblName?.addGestureRecognizer(tapGesture)

            if ((Float(self.objPromotionDetails.strLatitude) ?? 0) != 0 && (Float(self.objPromotionDetails.strLongitude) ?? 0) != 0 && dataManager.currentLocation.coordinate.latitude != 0 && dataManager.currentLocation.coordinate.latitude != 0)
            {
                let storeLocation: CLLocation = CLLocation(latitude: (CLLocationDegrees(Float(self.objPromotionDetails.strLatitude) ?? 0)), longitude: (CLLocationDegrees(Float(self.objPromotionDetails.strLongitude) ?? 0)))
                
                let strDistance: String = objCommonUtility.calculateDistanceInKiloMeters(coordinateOne: dataManager.currentLocation, coordinateTwo: storeLocation)
                
                self.lblAddress?.text = "\(self.objPromotionDetails.strFormatedAddress) (\(strDistance) km)"
                
            }
            else
            {
                self.lblAddress?.text = self.objPromotionDetails.strFormatedAddress
            }
            
            
            self.lblTitle?.text = self.objPromotionDetails.strTitle
            self.lblDescription?.text = self.objPromotionDetails.strDescription
                        
                //ADJUST FRAMES
            self.lblName?.sizeToFit()
            
            self.lblAddress?.sizeToFit()
            self.lblAddress?.frame.origin.y = (self.lblName?.frame.origin.y)! + (self.lblName?.frame.size.height)! + 10
            
            self.lblTitle?.sizeToFit()
            self.lblTitle?.frame.origin.y = (self.lblAddress?.frame.origin.y)! + (self.lblAddress?.frame.size.height)! + 10
            
            self.lblDescription?.sizeToFit()
            self.lblDescription?.frame.origin.y = (self.lblTitle?.frame.origin.y)! + (self.lblTitle?.frame.size.height)! + 10
            
            self.basicDetailsContainerView?.frame.size.height = (self.lblDescription?.frame.origin.y)! + (self.lblDescription?.frame.size.height)! + 10
            
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
            
        })
    }
    
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
    @objc func lblNametapGestureMethod(_ gesture: UITapGestureRecognizer) {
        
        let viewController: User_StoreDetailsViewController = User_StoreDetailsViewController()
               //        print(dataRows[indexPath.row].strID)
        viewController.strSelectedStoreID = objPromotionDetails.strID
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }

    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //subcategoriesContainerView?.frame.size.width = (mainTableView?.frame.size.width)!
        
        
        mainTableView?.reloadData()
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("activity_edit_store_store_pramotion_title_hint", value:"Resumo da Promoção", comment: "")
        
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
        mainTableView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //BASIC DETAILS
        basicDetailsContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        //IMAGE SLIDER
        imageSliderScrollView?.delegate = self
        imageSliderScrollView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        imageSliderScrollView?.clipsToBounds = true
        imageSliderScrollView?.isPagingEnabled = true
                
        //SETUP PAGE CONTROLL
        imageSliderPageControl?.isUserInteractionEnabled = false
        imageSliderPageControl?.currentPage = 0
        imageSliderPageControl?.pageIndicatorTintColor = MySingleton.sharedManager().themeGlobalWhiteColor
        imageSliderPageControl?.currentPageIndicatorTintColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        
        lblName?.font = MySingleton.sharedManager().themeFontTwentySizeBold
        lblName?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblName?.text = ""
        
        lblAddress?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblAddress?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblAddress?.text = ""
        
        lblTitle?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblTitle?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblTitle?.text = ""
        
        lblDescription?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblDescription?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblDescription?.text = ""
        
                
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalBackgroundGreyColor
        mainTableView?.isHidden = true
        
        btnSend?.backgroundColor = MySingleton.sharedManager().themeGlobalWhatsappColor
        btnSend?.clipsToBounds = true
        btnSend?.layer.cornerRadius = (btnSend?.frame.size.width)! / 2
        btnSend?.addTarget(self, action: #selector(self.btnSendClicked(_:)), for: .touchUpInside)
        
        
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
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        //API CALL
        dataManager.user_UpdateStoreClicks(strStoreID: self.objPromotionDetails.strID, strScreenID: self.strScreenID)
        
        if (self.objPromotionDetails.strPhoneNumber != "")
        {
            let originalString = "https://wa.me/55\(self.objPromotionDetails.strPhoneNumber)?text=Quero a promoção AgendaZap. Meu código: \(objCommonUtility.fourDigitNumber) &source=&data="
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            print(escapedString)
            
            guard let url = URL(string: escapedString!) else {
              return //be safe
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if (section == 0)
        {
            return (basicDetailsContainerView?.frame.size.height)!
        }
        else if (section == 1)
        {
            return (blankMarginContainerView?.frame.size.height)!
        }
        else
        {
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
            return blankMarginContainerView
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 0
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
//        print("scrollViewDidScroll called")
        
        if (scrollView == imageSliderScrollView)
        {
            let pageWidth : CGFloat = imageSliderScrollView!.frame.size.width
            let page : Int = Int((imageSliderScrollView?.contentOffset.x)!/pageWidth)
            imageSliderPageControl?.currentPage = page
            selectedImageIndex = page
        }
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
