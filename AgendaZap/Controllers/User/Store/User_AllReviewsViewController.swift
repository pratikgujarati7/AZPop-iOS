//
//  User_AllReviewsViewController.swift
//  AgendaZap
//
//  Created by Dipen on 22/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class User_AllReviewsViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
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
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var boolIsOpenedForProduct: Bool!
    var strID: String!
    var dataRows = [ObjReview]()
    
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
            selector: #selector(self.user_GetAllProductReviewsEvent),
            name: Notification.Name("user_GetAllProductReviewsEvent"),
            object: nil)
            
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.user_GetAllStoreReviewsEvent),
            name: Notification.Name("user_GetAllStoreReviewsEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllProductReviewsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.dataRows = dataManager.arrayAllReviews
            
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
            
        })
    }
    
    @objc func user_GetAllStoreReviewsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.dataRows = dataManager.arrayAllReviews
            
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
            
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
        navigationTitle?.text = NSLocalizedString("activity_reviews_title", value:"Todos as resenhas", comment: "")
        
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
        
        
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalBackgroundGreyColor
        mainTableView?.isHidden = true
        
        //API CALL
        if boolIsOpenedForProduct
        {
            dataManager.user_GetAllProductReviews(strProductID: self.strID)
        }
        else
        {
            dataManager.user_GetAllStoreReviews(strStoreID: self.strID)
        }
    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataRows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:ReviewTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? ReviewTableViewCell
        
        if(cell == nil)
        {
            cell = ReviewTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
        }
        
        cell.ratingViewUserRating.rating = Double(self.dataRows[indexPath.row].strRate) ?? 0
        
        cell.lblDate.text = self.dataRows[indexPath.row].strReviewDate
        cell.lblReviewText.text = self.dataRows[indexPath.row].strReviewText
        
        cell.lblReviewText.sizeToFit()
        
        cell.innerContainer.frame.size.height = cell.lblReviewText.frame.origin.y + cell.lblReviewText.frame.size.height + 10
        cell.mainContainer.frame.size.height = cell.innerContainer.frame.origin.y + cell.innerContainer.frame.size.height + 5
        
        return cell.mainContainer.frame.size.height
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
        
        cell.ratingViewUserRating.rating = Double(self.dataRows[indexPath.row].strRate) ?? 0
        
        cell.lblDate.text = self.dataRows[indexPath.row].strReviewDate
        cell.lblReviewText.text = self.dataRows[indexPath.row].strReviewText
        
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

}
