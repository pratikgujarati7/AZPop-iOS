//
//  ToolsVC.swift
//  AgendaZap
//
//  Created by Dipen on 01/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ToolsVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
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
                selector: #selector(self.user_GetAllStoreProductsEvent),
                name: Notification.Name("user_GetAllStoreProductsEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllStoreProductsEvent()
    {
        DispatchQueue.main.async(execute: {
            
//            self.arrStoresProducts = dataManager.arrayAllStoreProducts
//
//            self.tblHighlightedProducts?.isHidden = false
//            self.tblHighlightedProducts?.reloadData()
        })
    }
    
    //MARK:- IBActions
    
    @IBAction func btnOption1Tapped(_ sender: Any) {

        let viewController: BusinessCardVC = BusinessCardVC()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnOption2Tapped(_ sender: Any) {

        let viewController: SendQuotationVC = SendQuotationVC()
        viewController.isFromClientEdit = false
        viewController.strCustomerName = ""
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnOption3Tapped(_ sender: Any) {

        let viewController: LoyaltyProgramVC = LoyaltyProgramVC()
        dataManager.objSelectedRewardUser = nil
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnOption4Tapped(_ sender: Any) {

        let viewController: DiscountsLinksVC = DiscountsLinksVC()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnOption5Tapped(_ sender: Any) {
        
        let viewController: BookingScheduleVC = BookingScheduleVC()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnOption6Tapped(_ sender: Any) {
        
        let viewController: User_ContactlessZapViewController = User_ContactlessZapViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnOption7Tapped(_ sender: Any) {
        
        let viewController: PointsToolVC = PointsToolVC()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnOption8Tapped(_ sender: Any) {

        let viewController: BoostViewController = BoostViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        viewNavigation.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        //navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        //navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        //navigationTitle?.text = ""
        
    }
    
    //MARK:- Setting Initial Views Methods
    func setupInitialView() {
        
        appDelegate  = UIApplication.shared.delegate as? AppDelegate
        
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
    
    // MARK: - Other Methods

}
