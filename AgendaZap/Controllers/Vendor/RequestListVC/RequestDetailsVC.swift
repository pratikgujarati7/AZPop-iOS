//
//  RequestDetailsVC.swift
//  AgendaZap
//
//  Created by Dipen on 09/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RequestDetailsVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!

    @IBOutlet var lblOrderDetails: UILabel!
    @IBOutlet var lblClientDetails: UILabel!
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var strSelectedOrderID: String!
    var objMyStoreOrder: ObjMyStoreOrder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        //API CALL
        dataManager.user_GetMyStoreOrderDetails(strOrderID: strSelectedOrderID)
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
                selector: #selector(self.user_GetMyStoreOrderDetailsEvent),
                name: Notification.Name("user_GetMyStoreOrderDetailsEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetMyStoreOrderDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
          
            self.objMyStoreOrder = dataManager.objSelectedStoreOrder
            
            let titleAttribute = [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().themeGlobalBlackColor!, NSAttributedString.Key.font: MySingleton.sharedManager().themeFontSixteenSizeBold!] as [NSAttributedString.Key : Any]
            let valueAttribute = [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().themeGlobalDarkGreyColor!, NSAttributedString.Key.font: MySingleton.sharedManager().themeFontSixteenSizeRegular!] as [NSAttributedString.Key : Any]
            
            let mainString = NSMutableAttributedString(string: "", attributes: titleAttribute)
            
            for objProduct in self.objMyStoreOrder.arrayOrderItems
            {
                let strProductTitle = NSAttributedString(string: "\nProduto : ", attributes: titleAttribute)
                mainString.append(strProductTitle)
                let strProductValue = NSAttributedString(string: "\(objProduct.strTitle)", attributes: valueAttribute)
                mainString.append(strProductValue)
                
                let strPrecoTitle = NSAttributedString(string: "\nPreço : ", attributes: titleAttribute)
                mainString.append(strPrecoTitle)
                let strPrecoValue = NSAttributedString(string: "\(objProduct.strMoneyPrice)", attributes: valueAttribute)
                mainString.append(strPrecoValue)
                
                let strQuantityTitle = NSAttributedString(string: "\nQuantity : ", attributes: titleAttribute)
                mainString.append(strQuantityTitle)
                let strQuantityValue = NSAttributedString(string: "\(objProduct.strQuantity)", attributes: valueAttribute)
                mainString.append(strQuantityValue)
            }
            
            if (self.objMyStoreOrder.strDiscount == "" || self.objMyStoreOrder.strDiscount == "<null>" || self.objMyStoreOrder.strDiscount == "0")
            {
                let strPaymentMethodTitle = NSAttributedString(string: "\n\nMétodo de Pgto : ", attributes: titleAttribute)
                mainString.append(strPaymentMethodTitle)
                let strPaymentMethodValue = NSAttributedString(string: "\(self.objMyStoreOrder.strPaymentMethod)", attributes: valueAttribute)
                mainString.append(strPaymentMethodValue)
                
                let strDateTitle = NSAttributedString(string: "\nData : ", attributes: titleAttribute)
                mainString.append(strDateTitle)
                let strDateValue = NSAttributedString(string: "\(self.objMyStoreOrder.strCreatedDate)", attributes: valueAttribute)
                mainString.append(strDateValue)
            }
            else
            {
                let strDiscount: String = String(format: "%.02f", Float(self.objMyStoreOrder.strDiscount.replacingOccurrences(of: ",", with: ".")) ?? 0)
                                
                let strDiscountTitle = NSAttributedString(string: "\n\nDesconto p/pgto ā vista : ", attributes: titleAttribute)
                mainString.append(strDiscountTitle)
                let strDiscountValue = NSAttributedString(string: "R$ \(strDiscount.replacingOccurrences(of: ".", with: ","))", attributes: valueAttribute)
                mainString.append(strDiscountValue)
                
                let strTotal: String = String(format: "%.02f", Float(self.objMyStoreOrder.strMoneySpent .replacingOccurrences(of: ",", with: ".")) ?? 0)
                                
                let strTotalTitle = NSAttributedString(string: "\nTotal ā vista : ", attributes: titleAttribute)
                mainString.append(strTotalTitle)
                let strTotalValue = NSAttributedString(string: "R$ \(strTotal.replacingOccurrences(of: ".", with: ","))", attributes: valueAttribute)
                mainString.append(strTotalValue)
                
                let strPaymentMethodTitle = NSAttributedString(string: "\nMétodo de Pgto : ", attributes: titleAttribute)
                mainString.append(strPaymentMethodTitle)
                let strPaymentMethodValue = NSAttributedString(string: "\(self.objMyStoreOrder.strPaymentMethod)", attributes: valueAttribute)
                mainString.append(strPaymentMethodValue)
                
                let strDateTitle = NSAttributedString(string: "\nData : ", attributes: titleAttribute)
                mainString.append(strDateTitle)
                let strDateValue = NSAttributedString(string: "\(self.objMyStoreOrder.strCreatedDate)", attributes: valueAttribute)
                mainString.append(strDateValue)
            }
            
            
            
            self.lblOrderDetails.attributedText = mainString
            
            //CLIENT DETAILS
            let clientString = NSMutableAttributedString(string: "", attributes: titleAttribute)
            
            let strClientTitle = NSAttributedString(string: "Cliente : ", attributes: titleAttribute)
            clientString.append(strClientTitle)
            let strClientValue = NSAttributedString(string: "\(self.objMyStoreOrder.strName)", attributes: valueAttribute)
            clientString.append(strClientValue)
            
            let strWhatsAppTitle = NSAttributedString(string: "\nWhatsApp : ", attributes: titleAttribute)
            clientString.append(strWhatsAppTitle)
            let strWhatsAppValue = NSAttributedString(string: "\(self.objMyStoreOrder.strPhoneNumber)", attributes: valueAttribute)
            clientString.append(strWhatsAppValue)
            
            let strObservationsTitle = NSAttributedString(string: "\nObservações : ", attributes: titleAttribute)
            clientString.append(strObservationsTitle)
            let strObservationsValue = NSAttributedString(string: "\(self.objMyStoreOrder.strObservations)", attributes: valueAttribute)
            clientString.append(strObservationsValue)
            
            var boolNeedAddress: Bool = false
            
            for obj in self.objMyStoreOrder.arrayOrderItems
            {
                if obj.strNeedAddress == "1"
                {
                    boolNeedAddress = true
                }
            }
            
            if boolNeedAddress
            {
                let strCityTitle = NSAttributedString(string: "\nCidade : ", attributes: titleAttribute)
                clientString.append(strCityTitle)
                let strCityValue = NSAttributedString(string: "\(self.objMyStoreOrder.strUserCity)", attributes: valueAttribute)
                clientString.append(strCityValue)
                
                let strAddressTitle = NSAttributedString(string: "\nEndereço : ", attributes: titleAttribute)
                clientString.append(strAddressTitle)
                let strAddressValue = NSAttributedString(string: "\(self.objMyStoreOrder.strStreet), \(self.objMyStoreOrder.strNumber)", attributes: valueAttribute)
                clientString.append(strAddressValue)
                
                let strZipcodeTitle = NSAttributedString(string: "\nCEP : ", attributes: titleAttribute)
                clientString.append(strZipcodeTitle)
                let strZipcodeValue = NSAttributedString(string: "\(self.objMyStoreOrder.strZipcode)", attributes: valueAttribute)
                clientString.append(strZipcodeValue)
            }
            
            self.lblClientDetails.attributedText = clientString
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnWhatsappTapped(_ sender: Any) {
        
        if (self.objMyStoreOrder.strPhoneNumber != "")
        {
            print("self.objStoreDetails.strPhoneNumber :\(self.objMyStoreOrder.strPhoneNumber)")
            
            let originalString = "https://wa.me/55\(self.objMyStoreOrder.strPhoneNumber)"
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            guard let url = URL(string: escapedString!) else {
              return //be safe
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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

}
