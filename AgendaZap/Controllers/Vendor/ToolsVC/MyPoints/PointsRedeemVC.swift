//
//  PointsRedeemVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 24/05/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController

class PointsRedeemVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblVoice: UILabel!
    @IBOutlet var lblPontosValue: UILabel!
    @IBOutlet var lblPontos: UILabel!
    
    //REDEEM 50 POINTS
    @IBOutlet var lblRedeem50PointsTitle: UILabel!
    @IBOutlet var lblRedeem50PointsDescription: UILabel!
    @IBOutlet var btnRedeem50Points: UIButton!
    
    //REDEEM 100 POINTS
    @IBOutlet var lblRedeem100PointsTitle: UILabel!
    @IBOutlet var lblRedeem100PointsDescription: UILabel!
    @IBOutlet var btnRedeem100Points: UIButton!
    
    //REDEEM 200 POINTS
    @IBOutlet var lblRedeem200PointsTitle: UILabel!
    @IBOutlet var lblRedeem200PointsDescription: UILabel!
    @IBOutlet var btnRedeem200Points: UIButton!
    
    @IBOutlet var lblDescription: UILabel!
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var boolIsAPICalledOnce: Bool = false
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //API CALL
        dataManager.user_getUser()
        
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
                selector: #selector(self.user_getUserEvent),
                name: Notification.Name("user_getUserEvent"),
                object: nil)
        }
    }
        
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_getUserEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.lblPontosValue.text = dataManager.strPointsToolValues
            self.lblPontosValue.adjustsFontSizeToFitWidth = true
            
            if (dataManager.boolIsRequestUnderApproval == true)
            {
                self.btnRedeem50Points.alpha = 0.5
                self.btnRedeem100Points.alpha = 0.5
                self.btnRedeem200Points.alpha = 0.5
            }
            else
            {
                let intPoints: Int = Int(dataManager.strPointsToolValues) ?? 0
                if (intPoints < 50)
                {
                    self.btnRedeem50Points.alpha = 0.5
                    self.btnRedeem100Points.alpha = 0.5
                    self.btnRedeem200Points.alpha = 0.5
                }
                else if (intPoints < 100)
                {
                    self.btnRedeem50Points.alpha = 1.0
                    self.btnRedeem100Points.alpha = 0.5
                    self.btnRedeem200Points.alpha = 0.5
                }
                else if (intPoints < 200)
                {
                    self.btnRedeem50Points.alpha = 1.0
                    self.btnRedeem100Points.alpha = 1.5
                    self.btnRedeem200Points.alpha = 0.5
                }
                else
                {
                    self.btnRedeem50Points.alpha = 1.0
                    self.btnRedeem100Points.alpha = 1.0
                    self.btnRedeem200Points.alpha = 1.0
                }
            }
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRedeem50PointsTapped(_ sender: Any) {
        self.view.endEditing(true)
                
        let intPoints: Int = Int(dataManager.strPointsToolValues) ?? 0
        if (dataManager.boolIsRequestUnderApproval == false && intPoints >= 50)
        {
            let viewController: PointsRedeemFormVC = PointsRedeemFormVC()
            viewController.intType = 1
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func btnRedeem100PointsTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let intPoints: Int = Int(dataManager.strPointsToolValues) ?? 0
        if (dataManager.boolIsRequestUnderApproval == false && intPoints >= 100)
        {
            let viewController: PointsRedeemFormVC = PointsRedeemFormVC()
            viewController.intType = 2
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func btnRedeem200PointsTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let intPoints: Int = Int(dataManager.strPointsToolValues) ?? 0
        if (dataManager.boolIsRequestUnderApproval == false && intPoints >= 200)
        {
            let viewController: PointsRedeemFormVC = PointsRedeemFormVC()
            viewController.intType = 3
            self.navigationController?.pushViewController(viewController, animated: true)
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
        
        btnRedeem50Points.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnRedeem50Points.backgroundColor = MySingleton.sharedManager().themeGlobalGreen2Color
        btnRedeem50Points.setTitleColor( MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnRedeem50Points.clipsToBounds = true
        btnRedeem50Points.layer.cornerRadius = 5
        
        btnRedeem100Points.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnRedeem100Points.backgroundColor = MySingleton.sharedManager().themeGlobalGreen2Color
        btnRedeem100Points.setTitleColor( MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnRedeem100Points.clipsToBounds = true
        btnRedeem100Points.layer.cornerRadius = 5
        
        btnRedeem200Points.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnRedeem200Points.backgroundColor = MySingleton.sharedManager().themeGlobalGreen2Color
        btnRedeem200Points.setTitleColor( MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnRedeem200Points.clipsToBounds = true
        btnRedeem200Points.layer.cornerRadius = 5
    }
}
