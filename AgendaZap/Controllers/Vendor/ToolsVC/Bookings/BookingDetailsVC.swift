//
//  BookingDetailsVC.swift
//  AgendaZap
//
//  Created by Shashank Bansal on 27/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController

class BookingDetailsVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblBookingDate: UILabel!
    @IBOutlet var lblBookingTime: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblMobileNumber: UILabel!
    @IBOutlet var lblObservationsTitle: UILabel!
    @IBOutlet var lblObservationsValue: UILabel!
    
    //WHATSAPP
    @IBOutlet var viewWhatsapp: UIView!
    @IBOutlet var imageViewWhatsapp: UIImageView!
    @IBOutlet var lblWhatsapp: UILabel!
    @IBOutlet var btnWhatsapp: UIButton!
    
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var strSelectedBookingID: String!
    var objBookingDetails: ObjBookingDetails!
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        //API CALL
        dataManager.user_GetBookingDetails(strBookingID: strSelectedBookingID)
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
                selector: #selector(self.user_GetBookingDetailsEvent),
                name: Notification.Name("user_GetBookingDetailsEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetBookingDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.objBookingDetails = dataManager.objBookingDetails
            self.lblBookingDate.text = self.objBookingDetails.strBookingDate
            self.lblBookingTime.text = self.objBookingDetails.strBookingTime
            self.lblName.text = self.objBookingDetails.strName
            self.lblMobileNumber.text = self.objBookingDetails.strPhoneNumber
            self.lblObservationsValue.text = self.objBookingDetails.strObservations
            
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
    
    @IBAction func btnWhatsappTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        if objBookingDetails != nil
        {
            let lblSharableText: String = "*Olá. Você tem o seguinte agendamento:*\n\n*👤 Cliente:* \(objBookingDetails.strName)\n*📆 Dia:* \(objBookingDetails.strBookingDate)\n*🕑 Horário:*: \(objBookingDetails.strBookingTime)\n*📝 Observações:* \(objBookingDetails.strObservations)"
            
            if (objBookingDetails.strPhoneNumber != "")
            {
                let originalString = "https://wa.me/55\(objBookingDetails.strPhoneNumber)?text=\(lblSharableText)"
                let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                
                guard let url = URL(string: escapedString!) else {
                  return //be safe
                }
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else
            {
                let originalString = "https://wa.me/?text=\(lblSharableText)"
                let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                
                guard let url = URL(string: escapedString!) else {
                  return //be safe
                }
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
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
