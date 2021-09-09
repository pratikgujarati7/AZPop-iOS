//
//  VendorHomeVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 13/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class VendorHomeVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblStoreName: UILabel!
    @IBOutlet var lblStoreURL: UILabel!
    //1
    @IBOutlet var imageViewOption1: UIImageView!
    @IBOutlet var lblOption1: UILabel!
    @IBOutlet var checkboxOption1: UIImageView!
    @IBOutlet var btnOption1: UIButton!
    //2
    @IBOutlet var imageViewOption2: UIImageView!
    @IBOutlet var lblOption2: UILabel!
    @IBOutlet var checkboxOption2: UIImageView!
    @IBOutlet var btnOption2: UIButton!
    //3
    @IBOutlet var imageViewOption3: UIImageView!
    @IBOutlet var lblOption3: UILabel!
    @IBOutlet var checkboxOption3: UIImageView!
    @IBOutlet var btnOption3: UIButton!
    //4
    @IBOutlet var imageViewOption4: UIImageView!
    @IBOutlet var lblOption4: UILabel!
    @IBOutlet var checkboxOption4: UIImageView!
    @IBOutlet var btnOption4: UIButton!
    //5
    @IBOutlet var imageViewOption5: UIImageView!
    @IBOutlet var lblOption5: UILabel!
    @IBOutlet var checkboxOption5: UIImageView!
    @IBOutlet var btnOption5: UIButton!
    //6
    @IBOutlet var imageViewOption6: UIImageView!
    @IBOutlet var lblOption6: UILabel!
    @IBOutlet var checkboxOption6: UIImageView!
    @IBOutlet var btnOption6: UIButton!
    //7
    @IBOutlet var imageViewOption7: UIImageView!
    @IBOutlet var lblOption7: UILabel!
    @IBOutlet var checkboxOption7: UIImageView!
    @IBOutlet var btnOption7: UIButton!
    //8
    @IBOutlet var imageViewOption8: UIImageView!
    @IBOutlet var lblOption8: UILabel!
    @IBOutlet var checkboxOption8: UIImageView!
    @IBOutlet var btnOption8: UIButton!
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupInitialView()
        
        self.setupNotificationEvent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //API CALL
        dataManager.user_GetStoreCheckList()
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
                selector: #selector(self.user_GetStoreCheckListEvent),
                name: Notification.Name("user_GetStoreCheckListEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetStoreCheckListEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.lblStoreName.text = dataManager.strStoreName

            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let underlineAttributedString = NSAttributedString(string: "\(ServerIPForWebsite)\(dataManager.strStoreSlug)", attributes: underlineAttribute)
            self.lblStoreURL.attributedText = underlineAttributedString
            
            for index in 0...7
            {
                if index == 0
                {
                    if dataManager.arrayStoreCheckList[index] == "1"
                    {
                        self.checkboxOption1.isHidden = false
                        self.btnOption1.isHidden = true
                    }
                    else
                    {
                        self.checkboxOption1.isHidden = true
                        self.btnOption1.isHidden = false
                    }
                }
                else if index == 1
                {
                    if dataManager.arrayStoreCheckList[index] == "1"
                    {
                        self.checkboxOption2.isHidden = false
                        self.btnOption2.isHidden = true
                    }
                    else
                    {
                        self.checkboxOption2.isHidden = true
                        self.btnOption2.isHidden = false
                    }
                }
                else if index == 2
                {
                    if dataManager.arrayStoreCheckList[index] == "1"
                    {
                        self.checkboxOption3.isHidden = false
                        self.btnOption3.isHidden = true
                    }
                    else
                    {
                        self.checkboxOption3.isHidden = true
                        self.btnOption3.isHidden = false
                    }
                }
                else if index == 3
                {
                    if dataManager.arrayStoreCheckList[index] == "1"
                    {
                        self.checkboxOption4.isHidden = false
                        self.btnOption4.isHidden = true
                    }
                    else
                    {
                        self.checkboxOption4.isHidden = true
                        self.btnOption4.isHidden = false
                    }
                }
                else if index == 4
                {
                    if dataManager.arrayStoreCheckList[index] == "1"
                    {
                        self.checkboxOption5.isHidden = false
                        self.btnOption5.isHidden = true
                    }
                    else
                    {
                        self.checkboxOption5.isHidden = true
                        self.btnOption5.isHidden = false
                    }
                }
                else if index == 5
                {
                    if dataManager.arrayStoreCheckList[index] == "1"
                    {
                        self.checkboxOption6.isHidden = false
                        self.btnOption6.isHidden = true
                    }
                    else
                    {
                        self.checkboxOption6.isHidden = true
                        self.btnOption6.isHidden = false
                    }
                }
                else if index == 6
                {
                    if dataManager.arrayStoreCheckList[index] == "1"
                    {
                        self.checkboxOption7.isHidden = false
                        self.btnOption7.isHidden = true
                    }
                    else
                    {
                        self.checkboxOption7.isHidden = true
                        self.btnOption7.isHidden = false
                    }
                }
                else if index == 7
                {
                    if dataManager.arrayStoreCheckList[index] == "1"
                    {
                        self.checkboxOption8.isHidden = false
                        self.btnOption8.isHidden = true
                    }
                    else
                    {
                        self.checkboxOption8.isHidden = true
                        self.btnOption8.isHidden = false
                    }
                }
            }
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnModeTapped(_ sender: Any) {

        UserDefaults.standard.setValue("0", forKey: "is_show_vendor_mode")
        UserDefaults.standard.synchronize()
        self.appDelegate?.setTabBarVC()
        
    }
    
    @IBAction func btnCopyTapped(_ sender: UIButton)
    {
        UIPasteboard.general.string = self.lblStoreURL.text
        AppDelegate.showToast(message : NSLocalizedString("Copy_to_ClipBoard", value:"Link copiado", comment: ""), font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
    }
    
    @IBAction func btnShareTapped(_ sender: UIButton)
    {
        let originalString = "https://wa.me/?text=\(self.lblStoreURL.text ?? "")"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: escapedString!) else {
          return //be safe
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnFazerTapped(_ sender: UIButton)
    {
        if sender == btnOption1
        {
            
        }
        else if sender == btnOption2
        {
            let viewController: BusinessCardVC = BusinessCardVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if sender == btnOption3
        {
            let viewController: MyStoreProductListVC = MyStoreProductListVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if sender == btnOption4
        {
            let viewController: MyStoreProductListVC = MyStoreProductListVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if sender == btnOption5
        {
            let viewController: SendQuotationVC = SendQuotationVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if sender == btnOption6
        {
            //WEBSITE
            let strWebsiteURL = self.lblStoreURL.text ?? ""
            guard let url = URL(string: strWebsiteURL) else { return }
            UIApplication.shared.open(url)
        }
        else if sender == btnOption7
        {
            let viewController: DiscountsLinksVC = DiscountsLinksVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            let viewController: BookingScheduleVC = BookingScheduleVC()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
        
        btnOption1.clipsToBounds = true
        btnOption1.layer.cornerRadius = 5
        
        btnOption2.clipsToBounds = true
        btnOption2.layer.cornerRadius = 5
        
        btnOption3.clipsToBounds = true
        btnOption3.layer.cornerRadius = 5
        
        btnOption4.clipsToBounds = true
        btnOption4.layer.cornerRadius = 5
        
        btnOption5.clipsToBounds = true
        btnOption5.layer.cornerRadius = 5
        
        btnOption6.clipsToBounds = true
        btnOption6.layer.cornerRadius = 5
        
        btnOption7.clipsToBounds = true
        btnOption7.layer.cornerRadius = 5
        
        btnOption8.clipsToBounds = true
        btnOption8.layer.cornerRadius = 5
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
