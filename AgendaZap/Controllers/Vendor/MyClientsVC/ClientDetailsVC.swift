//
//  ClientDetailsVC.swift
//  AgendaZap
//
//  Created by Dipen on 08/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift


class ClientDetailsVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblPhoneNumber: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEndereco: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblCPF: UILabel!
    @IBOutlet var lblObservation: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var viewStatus: UIViewX!
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var objSelectedClient: ObjMyClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //SET VALUES
        lblPhoneNumber.text = objSelectedClient.strPhoneNumber != "<null>" ? objSelectedClient.strPhoneNumber : "-"
        lblName.text = objSelectedClient.strName != "<null>" ? objSelectedClient.strName : "-"
        lblEndereco.text = objSelectedClient.strAddress != "<null>" ? objSelectedClient.strAddress : "-"
        lblEmail.text = objSelectedClient.strEmail != "<null>" ? objSelectedClient.strEmail : "-"
        lblCPF.text = objSelectedClient.strTaxID != "<null>" ? objSelectedClient.strTaxID : "-"
        lblObservation.text = objSelectedClient.strObservations != "<null>" ? objSelectedClient.strObservations : "-"
        
        if (objSelectedClient.strStatus == "1")
        {
            viewStatus.backgroundColor = UIColor.gray
            lblStatus.text = "Status do cliente não definido"
        }
        else if (objSelectedClient.strStatus == "2")
        {
            viewStatus.backgroundColor = UIColor.red
            lblStatus.text = "Cliente aguardando meu retorno"
        }
        else if (objSelectedClient.strStatus == "3")
        {
            viewStatus.backgroundColor = UIColor.yellow
            lblStatus.text = "Aguardando retorno do cliente"
        }
        else
        {
            viewStatus.backgroundColor = UIColor.green
            lblStatus.text = "Concluído com sucesso"
        }
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
            
//            NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(self.user_changeCartProductQuantityEvent),
//                name: Notification.Name("user_changeCartProductQuantityEvent"),
//                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_changeCartProductQuantityEvent()
    {
        DispatchQueue.main.async(execute: {
            
//            self.datarows = dataManager.arrayAllStoreCartProducts
//            self.lblTotal.text = "Total = R$ \(dataManager.strTotalMoney) ou \(dataManager.strTotalPoints) pontos"
//            self.tblCartItems.reloadData()
            
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnEditTapped(_ sender: Any) {
        
        let viewController: CreateClientVC = CreateClientVC()
        viewController.clientId = self.objSelectedClient.strID
        viewController.objClient = self.objSelectedClient
        viewController.isEditClient = true
        viewController.isOpenedFromDetails = true
        viewController.strStatus = self.objSelectedClient.strStatus
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnOption1Tapped(_ sender: Any) {
                
        if (objSelectedClient.strPhoneNumber != "")
        {
            print("self.objSelectedClient.strPhoneNumber :\(objSelectedClient.strPhoneNumber)")
            
            let realm = try! Realm()
            let selectedMyStore:MyStore = realm.objects(MyStore.self)[0]
            
//            let selectedMyStore = MyStore()
//            selectedMyStore.strFacebook_link = "Sanjay"
//            selectedMyStore.strInstagram_link = "Sanjay"
//            selectedMyStore.strName = "test Store"
//            selectedMyStore.strPhoneNumber = "1234567890"
//            selectedMyStore.strEmail = "test@test.com"
//            selectedMyStore.strSlug = "storeTest"
            
            var message: String = ""
            
            if (selectedMyStore.strFacebook_link != "" && selectedMyStore.strInstagram_link != "") {
                let instaLink = "https://www.instagram.com/" + selectedMyStore.strInstagram_link
                let fbLink = "https://www.facebook.com/" + selectedMyStore.strFacebook_link
                message = "*" + selectedMyStore.strName + "*" + "\n" +
                    "*WhatsApp:* " + selectedMyStore.strPhoneNumber + "\n" +
                    "*Email:* " + selectedMyStore.strEmail + "\n" +
                    "*Website:* " + ServerIPForWebsite + selectedMyStore.strSlug + "\n" +
                    "*Facebook:* " + fbLink + "\n" +
                    "*Instagram:* " + instaLink + "\n" +
                    "\nDados do meu negócio ☝️"
            } else {
                message = "*" + selectedMyStore.strName + "*" + "\n" +
                    "*WhatsApp:* " + selectedMyStore.strPhoneNumber + "\n" +
                    "*Email:* " + selectedMyStore.strEmail + "\n" +

                    "*Website:* " + ServerIPForWebsite + selectedMyStore.strSlug + "\n" +
                    "\nDados do meu negócio ☝️"
            }
            
            let originalString = "https://wa.me/55\(objSelectedClient.strPhoneNumber)/?text=\(message)"
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            guard let url = URL(string: escapedString!) else {
              return //be safe
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    @IBAction func btnOption2Tapped(_ sender: Any) {
        let viewController: SendQuotationVC = SendQuotationVC()
        viewController.isFromClientEdit = true
        viewController.strCustomerName = objSelectedClient.strName != "<null>" ? objSelectedClient.strName : ""
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnOption3Tapped(_ sender: Any) {
        
        let objNew: ObjRewardUser = ObjRewardUser()
        objNew.strID = ""
        objNew.strFullName = self.objSelectedClient.strName
        objNew.strPhoneNumner = self.objSelectedClient.strPhoneNumber
        objNew.strPurchases = "0"
        objNew.strCreatedDate = self.objSelectedClient.strUpdateDate
        
        let viewController: LoyaltyProgramVC = LoyaltyProgramVC()
        dataManager.objSelectedRewardUser = objNew
        self.navigationController?.pushViewController(viewController, animated: true)
        
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
