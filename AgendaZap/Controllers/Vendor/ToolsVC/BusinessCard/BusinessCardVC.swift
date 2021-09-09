//
//  BusinessCardVC.swift
//  AgendaZap
//
//  Created by Dipen on 11/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class BusinessCardVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    //POPUP
    @IBOutlet var viewPopupContainer: UIView!
    @IBOutlet var viewPopupInnerContainer: UIView!
    @IBOutlet var txtMobileNumber: UITextField!
    @IBOutlet var btnSend: UIButton?
    
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false

    var documentInteractionController:UIDocumentInteractionController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        dataManager.user_GetStoreDetails(strStoreID: strSelectedStoreID)
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
        
        viewPopupContainer.frame.size = self.view.frame.size
        
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
                selector: #selector(self.user_GetStoreDetailsEvent),
                name: Notification.Name("user_GetStoreDetailsEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetStoreDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
          
            
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnWhatsapp1Tapped(_ sender: Any) {
        
        let originalString = "https://wa.me/?text=*\(dataManager.objSelectedStoreDetails.strName)*\n*WhatsApp:* \(dataManager.objSelectedStoreDetails.strPhoneNumber)\(dataManager.objSelectedStoreDetails.strEmail != "" ? "\n*Email:* \(dataManager.objSelectedStoreDetails.strEmail)" : "")\n*Website:* \(ServerIPForWebsite)\(dataManager.objSelectedStoreDetails.strSlug)\(dataManager.objSelectedStoreDetails.strFacebookLink != "" ? "\n*Facebook:* https://www.facebook.com/\(dataManager.objSelectedStoreDetails.strFacebookLink)" : "")\(dataManager.objSelectedStoreDetails.strInstagramLink != "" ? "\n*Instagram:* \(dataManager.objSelectedStoreDetails.strInstagramLink)" : "")\n\nDados do meu negócio ☝️"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: escapedString!) else {
          return //be safe
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
//        let urlWhats = "whatsapp://app?text=\(originalString)"
//        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
//            if let whatsappURL = NSURL(string: urlString) {
//
//                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
//
////                    let imgURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//                    let fileName = "whatsapp_round_white.jpg"
////                    let fileURL = imgURL.appendingPathComponent(fileName)
////                    if let image = UIImage(contentsOfFile: fileURL.path) {
//                    if let image = UIImage(named: fileName) {
//                        if let imageData = image.jpegData(compressionQuality: 0.75) {
//                            let tempFile = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Documents/whatsapp_round_white.jpg")
//                            do {
//                                try imageData.write(to: tempFile!, options: .atomicWrite)
//                                self.documentInteractionController = UIDocumentInteractionController(url: tempFile!)
//                                self.documentInteractionController.uti = "net.whatsapp.image"
//                                self.documentInteractionController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
//                            } catch {
//                                print(error)
//                            }
//                        }
//                    }
//                } else {
//                    let ac = UIAlertController(title: "Failed", message: "Whatsapp not installed", preferredStyle: .alert)
//                                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
//                                        present(ac, animated: true)
//                }
//            }
//        }
    }
    
    @IBAction func btnWhatsapp2Tapped(_ sender: Any) {
        
        self.view.addSubview(viewPopupContainer)
        
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        txtMobileNumber.text = ""
        viewPopupContainer.removeFromSuperview()
    }
    
    @IBAction func btnSendTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        if(txtMobileNumber?.text?.count == 0 || ((txtMobileNumber?.text?.isEmpty) == nil)){
            
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
            
        }else{
            
            let intMobileNumber = Int(txtMobileNumber!.text!) ?? 0
            if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
            {
                let originalString = "https://wa.me/55\(intMobileNumber)?text=*\(dataManager.objSelectedStoreDetails.strName)*\n*WhatsApp:* \(dataManager.objSelectedStoreDetails.strPhoneNumber)\n*Email:* \(dataManager.objSelectedStoreDetails.strEmail)\n*Website:* \(ServerIPForWebsite)\(dataManager.objSelectedStoreDetails.strSlug)\(dataManager.objSelectedStoreDetails.strFacebookLink != "" ? "\n*Facebook:* https://www.facebook.com/\(dataManager.objSelectedStoreDetails.strFacebookLink)" : "")\(dataManager.objSelectedStoreDetails.strInstagramLink != "" ? "\n*Instagram:* \(dataManager.objSelectedStoreDetails.strInstagramLink)" : "")\n\nDados do meu negócio ☝️"
                let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                
                guard let url = URL(string: escapedString!) else {
                  return //be safe
                }
                
                UIApplication.shared.open(url, options: [:], completionHandler: {_ in
                
                    self.txtMobileNumber.text = ""
                    self.viewPopupContainer.removeFromSuperview()
                    
                })
            }
            else
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
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
        
        viewPopupContainer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        btnSend?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSend?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSend?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSend?.clipsToBounds = true
        btnSend?.layer.cornerRadius = 5
    }

}
