//
//  NotificationSettingsVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 02/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController

class NotificationSettingsVC: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblActivateNotification: UILabel!
    @IBOutlet var switchOnOff: UISwitch!
    @IBOutlet var btnSave: UIButton?
    @IBOutlet var lblConfigurationSaved: UILabel!
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let strIsNotificationActive : String = "\(UserDefaults.standard.value(forKey: "is_notification_activate") ?? "0")"
        if (strIsNotificationActive == "1")
        {
            switchOnOff.isOn = true
            lblActivateNotification.text = "Notificações ativadas"
        }
        else
        {
            switchOnOff.isOn = false
            lblActivateNotification.text = "Notificações desativadas"
        }
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
                selector: #selector(self.user_updateNotificationStatusEvent),
                name: Notification.Name("user_updateNotificationStatusEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_updateNotificationStatusEvent()
    {
        DispatchQueue.main.async(execute: {
          
            let switchValue: String = self.switchOnOff.isOn ? "1" : "0"
            UserDefaults.standard.setValue(switchValue, forKey: "is_notification_activate")
            UserDefaults.standard.synchronize()
            
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = ""
            alertViewController.message = "Configuração salva."
            
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
            let okAction = NYAlertAction(
                title: "Ok",
                style: .default,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.navigationController!.dismiss(animated: true, completion: {
                        
                        self.navigationController?.popViewController(animated: false)
                        
                    })
            })
            
            alertViewController.addAction(okAction)
                                
            self.navigationController!.present(alertViewController, animated: true, completion: nil)
            
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchOnOffValueChange(_ sender: UISwitch) {
        
        let strIsNotificationActive : String = "\(UserDefaults.standard.value(forKey: "is_notification_activate") ?? "0")"
        let switchValue: String = switchOnOff.isOn ? "1" : "0"
        
        if strIsNotificationActive == switchValue
        {
            lblConfigurationSaved.isHidden = true
            lblActivateNotification.text = "Notificações ativadas"
        }
        else
        {
            lblConfigurationSaved.isHidden = false
            lblActivateNotification.text = "Notificações desativadas"
         }
        
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        
        let switchValue: String = switchOnOff.isOn ? "1" : "0"
        //API CALL
        dataManager.user_updateNotificationStatus(strStatus: switchValue)
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
        
        btnSave?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSave?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSave?.clipsToBounds = true
        btnSave?.layer.cornerRadius = 5
    }
}
