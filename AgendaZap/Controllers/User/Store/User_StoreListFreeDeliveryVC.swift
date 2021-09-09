//
//  User_StoreListFreeDeliveryVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 27/05/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController

class User_StoreListFreeDeliveryVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    //Result and Sortby view
    @IBOutlet var lblResults: UILabel!
    
    @IBOutlet var mainTableView: UITableView? {
        didSet {
            self.mainTableView?.register(UINib(nibName: "StoreTVCell", bundle: nil), forCellReuseIdentifier: "StoreTVCell")
        }
    }
    
    //SEND BULK MESSAGE
    @IBOutlet var bulkMessagePopupContainerView: UIView?
    @IBOutlet var bulkMessageInnerContainerView: UIView?
    @IBOutlet var btnCloseBulkMessage: UIButton?
    @IBOutlet var lblBulkMessage: UILabel?
    @IBOutlet var lblBulkMessageTitle: UILabel?
    @IBOutlet var txtViewBulkMessageContainerView: UIView?
    @IBOutlet var txtViewBulkMessage: UITextView?
    @IBOutlet var btnSendBulkMessage: UIButton?
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var boolIsAPICalledOnce: Bool = false
    
    var arrStores = [ObjStorePromotion]()
    var intPageNumber: Int = 1
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        //API CALL
        self.intPageNumber = 1
        dataManager.user_GetAllFreeDeliveryStores(strPageNumber: "\(self.intPageNumber)")
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
        
        bulkMessagePopupContainerView?.frame.size = self.view.frame.size
        let strBulkMessage: String = "\(UserDefaults.standard.value(forKey: "bulk_message") ?? "")"
        txtViewBulkMessage?.text = strBulkMessage
        
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
                selector: #selector(self.user_GetAllFreeDeliveryStoresEvent),
                name: Notification.Name("user_GetAllFreeDeliveryStoresEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.user_sendBulkMessageEvent),
            name: Notification.Name("user_sendBulkMessageEvent"),
            object: nil)
        }
    }
        
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllFreeDeliveryStoresEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.arrStores = dataManager.arrayAllFreeDeliveryStores
            self.lblResults.text = "\(dataManager.strTotalFreeDeliveryStores) resultados"
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
            
        })
    }
    
    @objc func user_sendBulkMessageEvent()
    {
        DispatchQueue.main.async(execute: {
            
            UserDefaults.standard.setValue((self.txtViewBulkMessage?.text)!, forKey: "bulk_message")
            UserDefaults.standard.synchronize()
            
            self.bulkMessagePopupContainerView?.removeFromSuperview()
            
            var originalString = ""
            
            if (self.txtViewBulkMessage?.text == "")
            {
                originalString = "https://wa.me/55\(self.arrStores[self.btnSendBulkMessage?.tag ?? 0].strPhoneNumber)?text=(via AZpop) \("Gostaria de mais informações.")"
            }
            else
            {
                originalString = "https://wa.me/55\(self.arrStores[self.btnSendBulkMessage?.tag ?? 0].strPhoneNumber)?text=(via AZpop) \((self.txtViewBulkMessage?.text)!)"
            }
            
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

            guard let url = URL(string: escapedString!) else {
              return //be safe
            }

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
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
    
    @IBAction func btnCancelBulkMessageClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        bulkMessagePopupContainerView?.removeFromSuperview()
    }
    
    @IBAction func btnSendBulkMessageClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
//        if (txtViewBulkMessage?.text == "")
//        {
//            AppDelegate.showToast(message : "Please enter message", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
//        }
//        else
        if ((txtViewBulkMessage?.text.count)! > 140)
        {
            AppDelegate.showToast(message : "Máximo 140 caracteres", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
        }
        else
        {
            //API CALL
            dataManager.user_sendBulkMessage(strType: "2", strStoreID: arrStores[sender.tag].strID, strMessage: "\((txtViewBulkMessage?.text)!)")
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
        
        mainTableView?.isHidden = false //true
        mainTableView?.separatorStyle = .none
        //mainTableView?.tableFooterView = UIView()
        mainTableView?.separatorColor = .clear
        
        //BULK MESSAGE POPUP
        bulkMessagePopupContainerView?.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        btnCloseBulkMessage?.addTarget(self, action: #selector(self.btnCancelBulkMessageClicked(_:)), for: .touchUpInside)
        
        txtViewBulkMessage?.delegate = self
        
        btnSendBulkMessage?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSendBulkMessage?.backgroundColor = MySingleton.sharedManager().themeGlobalGreen2Color
        btnSendBulkMessage?.setTitleColor( MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnSendBulkMessage?.clipsToBounds = true
        btnSendBulkMessage?.layer.cornerRadius = 5
        btnSendBulkMessage?.addTarget(self, action: #selector(self.btnSendBulkMessageClicked(_:)), for: .touchUpInside)
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

//MARK:- Tableview Methods
extension User_StoreListFreeDeliveryVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.arrStores.count == 0 {
            self.mainTableView!.showNoDataLabel(NSLocalizedString("no_store_found", value:"Nenhum negócio encontrado.", comment: ""), isScrollable: true)
            return 0
        }
        else {
            self.mainTableView!.removeNoDataLabel()
            return self.arrStores.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let objStore = self.arrStores[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTVCell") as! StoreTVCell
        
        cell.lblStoreName.text = objStore.strName
        cell.lblDistance.text = ""//"\(objStore.strDistance) km"
        cell.lblCategoryType.text = objStore.strTags
        
        cell.btnViewProfile.isUserInteractionEnabled = false
        
        if objStore.strType == "1" {
            cell.viewPriorityContainer.isHidden = false
            cell.lblPriority.text = "Em Alta"
        } else {
            cell.viewPriorityContainer.isHidden = true
            cell.lblPriority.text = ""
        }
        
        if objStore.strIsFreeDelivery == "1" {
            cell.viewFreeDeliveryContainer.isHidden = false
            cell.lblFreeDelivery.text = "Entrega grátis"
        } else {
            cell.viewFreeDeliveryContainer.isHidden = true
            cell.lblFreeDelivery.text = ""
        }
        
        if objStore.strTaxIdStatus == "1" {
            cell.imageViewIsVerified.isHidden = false
        }
        else
        {
            cell.imageViewIsVerified.isHidden = true
        }
        
        cell.btnWhatsappClick = {(_ aCell: StoreTVCell) -> Void in
            
            self.btnSendBulkMessage?.tag = indexPath.row
            self.view.addSubview(self.bulkMessagePopupContainerView!)
            
        }
        
        if (indexPath.row == self.arrStores.count - 1)
        {
            // This is the last cell in the table
            if (intPageNumber < dataManager.totalPageNumberForFreeDeliveryStores)
            {
                intPageNumber = intPageNumber + 1
                
                //API CALL
                dataManager.user_GetAllFreeDeliveryStores(strPageNumber: "intPageNumber")
            }
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (arrStores.count > 0)
        {
            if (arrStores[indexPath.row].strIsBlocked == "0")
            {
                let viewController: User_StoreDetailsViewController = User_StoreDetailsViewController()
                print(arrStores[indexPath.row].strID)
                viewController.strSelectedStoreID = arrStores[indexPath.row].strID
                self.navigationController?.pushViewController(viewController, animated: false)
            }
            else
            {
                appDelegate?.showAlertViewWithTitle(title: arrStores[indexPath.row].strBlockedTitle, detail: arrStores[indexPath.row].strBlockedMessage)
            }
        }
    }
}
