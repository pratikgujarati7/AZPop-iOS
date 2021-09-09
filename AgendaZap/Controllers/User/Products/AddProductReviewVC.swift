//
//  AddProductReviewVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 24/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UITextView_Placeholder

class AddProductReviewVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
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
    //SAVE
    @IBOutlet var btnSave: UIButton?
    
    @IBOutlet var ratingViewMyRating: CosmosView?
    @IBOutlet var lblRating: UILabel?
    @IBOutlet var txtViewMyReviewContainerView: UIView?
    @IBOutlet var txtViewMyReview: UITextView?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var boolIsOpenedForProduct: Bool!
    var strID: String!
    
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
            selector: #selector(self.user_AddProductReviewEvent),
            name: Notification.Name("user_AddProductReviewEvent"),
            object: nil)
            
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.user_AddReviewEvent),
            name: Notification.Name("user_AddReviewEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_AddProductReviewEvent()
    {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: false)
        })
    }
    
    @objc func user_AddReviewEvent()
    {
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: false)
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("activity_write_review_title", value:"Avalie este negócio", comment: "")
        
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
        
//        btnSave?.titleLabel?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        btnSave?.setTitle(NSLocalizedString("enviar", value:"Enviar", comment: "").uppercased(), for: .normal)
//        btnSave?.setTitleColor(MySingleton.sharedManager().themeGlobalDarkGreyColor, for: .normal)
        
        btnSave?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSave?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSave?.clipsToBounds = true
        btnSave?.layer.cornerRadius = 5
        btnSave?.addTarget(self, action: #selector(self.btnSaveClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if ((ratingViewMyRating?.rating)! > 0.0)
        {
            //API CALL
            if boolIsOpenedForProduct
            {
                dataManager.user_AddProductReview(strProductID: self.strID, strRating: "\(ratingViewMyRating?.rating ?? 0)", strReviewText: (txtViewMyReview?.text)!)
            }
            else
            {
                dataManager.user_AddReview(strStoreID: self.strID, strRating: "\(ratingViewMyRating?.rating ?? 0)", strReviewText: (txtViewMyReview?.text)!)
            }
            
        }
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        masterContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        ratingViewMyRating?.backgroundColor = .clear
        ratingViewMyRating?.settings.fillMode = .full
        ratingViewMyRating?.settings.starSize = 40
        ratingViewMyRating?.settings.starMargin = 10
        ratingViewMyRating?.settings.filledColor = MySingleton.sharedManager().themeGlobalLightGreenColor!
        ratingViewMyRating?.settings.emptyBorderColor = MySingleton.sharedManager().themeGlobalDarkGreyColor!
        ratingViewMyRating?.didTouchCosmos = didTouchCosmos
        
        lblRating?.font = MySingleton.sharedManager().themeFontTwentyTwoSizeMedium
        lblRating?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        txtViewMyReviewContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        txtViewMyReviewContainerView?.clipsToBounds = true
        txtViewMyReviewContainerView?.layer.cornerRadius = 10
        txtViewMyReviewContainerView?.layer.borderWidth = 1
        txtViewMyReviewContainerView?.layer.borderColor = MySingleton.sharedManager().themeGlobalDarkGreyColor?.cgColor
        
        txtViewMyReview?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtViewMyReview?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        //txtViewMyReview?.placeholder = NSLocalizedString("enter_review", value:"Descreva sua experiencia", comment: "")
        txtViewMyReview?.placeholderColor = MySingleton.sharedManager().textfieldPlaceholderColor
    }

    private func didTouchCosmos(_ rating: Double) {
        lblRating!.text = "\(ratingViewMyRating?.rating ?? 0)"
        
        if ((ratingViewMyRating?.rating)! > 0.0)
        {
            //btnSave?.setTitleColor(MySingleton.sharedManager().themeGlobalLightGreenColor, for: .normal)
        }
        else
        {
            //btnSave?.setTitleColor(MySingleton.sharedManager().themeGlobalDarkGreyColor, for: .normal)
        }

    }

}
