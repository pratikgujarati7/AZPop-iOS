//
//  RequestListVC.swift
//  AgendaZap
//
//  Created by Dipen on 01/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RequestListVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var bulkMessageContainerView: UIView!
    @IBOutlet var lblBulkMessageTitle: UILabel!
    @IBOutlet var bulkMessageTableView: UITableView! {
        didSet {
            self.bulkMessageTableView.register(UINib(nibName: "MyClientMessageTVCell", bundle: nil), forCellReuseIdentifier: "MyClientMessageTVCell")
        }
    }
    
    @IBOutlet var ordersContainerView: UIView!
    @IBOutlet var lblOrdersTitle: UILabel!
    @IBOutlet var mainTableView: UITableView! {
        didSet {
            self.mainTableView.register(UINib(nibName: "MyClientOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MyClientOrderTableViewCell")
        }
    }
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var datarowsBulkMessages = [ObjBulkMessageCluster]()
    var datarows = [ObjMyStoreOrderCluster]()
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (dataManager.boolIsAppOpenedFromNotification == true)
        {
            dataManager.boolIsAppOpenedFromNotification = false
            
            if dataManager.strNotificationCode == "100"
            {
                //orders
                segmentedControl.selectedSegmentIndex = 1
            }
            else
            {
                //Bulk mesage
                segmentedControl.selectedSegmentIndex = 0
            }
        }
        
        self.setupInitialView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //API CALL
        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        dataManager.user_getBulkMessageList(strStoreID: strSelectedStoreID)
        dataManager.user_GetMyStoreOrders()
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
                selector: #selector(self.user_getBulkMessageListEvent),
                name: Notification.Name("user_getBulkMessageListEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetMyStoreOrdersEvent),
                name: Notification.Name("user_GetMyStoreOrdersEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_getBulkMessageListEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarowsBulkMessages = dataManager.arrayBulkMessageClusterList.reversed()
            self.bulkMessageTableView?.reloadData()
        })
    }
    
    @objc func user_GetMyStoreOrdersEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarows = dataManager.arrayMyStoreOrdersCluster.reversed()
            self.mainTableView?.reloadData()
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnModeTapped(_ sender: Any) {

        UserDefaults.standard.setValue("0", forKey: "is_show_vendor_mode")
        UserDefaults.standard.synchronize()
        self.appDelegate?.setTabBarVC()
        
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.bulkMessageContainerView.isHidden = false
            self.ordersContainerView.isHidden = true
            //API CALL
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            dataManager.user_getBulkMessageList(strStoreID: strSelectedStoreID)
        
        case 1:
            self.bulkMessageContainerView.isHidden = true
            self.ordersContainerView.isHidden = false
            //API CALL
            dataManager.user_GetMyStoreOrders()
        
        default:
            break
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

//MARK:- TableView Methods
extension RequestListVC : UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int
    {
        if tableView == bulkMessageTableView
        {
            return self.datarowsBulkMessages.count
        }
        else
        {
            return self.datarows.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let lblHeader: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: 30))
        lblHeader.backgroundColor = MySingleton.sharedManager().themeGlobalGreenColor
        lblHeader.font = MySingleton.sharedManager().themeFontSixteenSizeMedium
        lblHeader.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblHeader.textAlignment = .center
        
        if tableView == bulkMessageTableView
        {
            lblHeader.text = self.datarowsBulkMessages[section].strDate
        }
        else
        {
            lblHeader.text = self.datarows[section].strDate
        }
        
        return lblHeader
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == bulkMessageTableView
        {
            return self.datarowsBulkMessages[section].arrayMessages.count
        }
        else
        {
            return self.datarows[section].arrayOrders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == bulkMessageTableView
        {
            tableView.register(UINib(nibName: "MyClientMessageTVCell", bundle: nil), forCellReuseIdentifier: "MyClientMessageTVCell-\(indexPath.section)-\(indexPath.row)")
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:MyClientMessageTVCell! = tableView.dequeueReusableCell(withIdentifier: "MyClientMessageTVCell-\(indexPath.section)-\(indexPath.row)") as? MyClientMessageTVCell
            
            if(cell == nil)
            {
                cell = MyClientMessageTVCell(style: .default, reuseIdentifier: "MyClientMessageTVCell-\(indexPath.section)-\(indexPath.row)")
            }
            
            let objMessage: ObjBulkMessage = self.datarowsBulkMessages[indexPath.section].arrayMessages[indexPath.row]
            
            cell.lblMessage.text = objMessage.strMessage
            cell.lblNumber.text = objMessage.strPhoneNumner
            
            cell.btnToggleClick = {(_ aCell: MyClientMessageTVCell) -> Void in
                
                if objMessage.boolIsExpanded == true
                {
                    objMessage.boolIsExpanded = false
                    cell.lblMessage.numberOfLines = 1
                    cell.btnToggle.setImage(UIImage(named: "down_arrow_gray"), for: .normal)
                }
                else
                {
                    objMessage.boolIsExpanded = true
                    cell.lblMessage.numberOfLines = 0
                    cell.btnToggle.setImage(UIImage(named: "up_arrow_gray"), for: .normal)
                }
                tableView.reloadData()
                
            }
            
            cell.btnWhatsappClick = {(_ aCell: MyClientMessageTVCell) -> Void in
                
                if (objMessage.strPhoneNumner != "")
                {
                    print("self.objStoreDetails.strPhoneNumber :\(objMessage.strPhoneNumner)")

                    let originalString = "https://wa.me/55\(objMessage.strPhoneNumner)?text="
                    let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

                    guard let url = URL(string: escapedString!) else {
                      return //be safe
                    }

                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        else
        {
            tableView.register(UINib(nibName: "MyClientOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "MyClientOrderTableViewCell-\(indexPath.section)-\(indexPath.row)")
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:MyClientOrderTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "MyClientOrderTableViewCell-\(indexPath.section)-\(indexPath.row)") as? MyClientOrderTableViewCell
            
            if(cell == nil)
            {
                cell = MyClientOrderTableViewCell(style: .default, reuseIdentifier: "MyClientOrderTableViewCell-\(indexPath.section)-\(indexPath.row)")
            }
            
            let objOrder: ObjMyStoreOrder = self.datarows[indexPath.section].arrayOrders[indexPath.row]
            
            cell.lblMessage.text = objOrder.strName
            
            if (objOrder.strPaymentMethod == "1")
            {
                cell.lblTotal.text = "\(objOrder.strPointSpent) Pontos"
            }
            else
            {
                let strMoney: String = String(format: "%.02f", Float(objOrder.strMoneySpent.replacingOccurrences(of: ",", with: ".")) ?? 0)
                cell.lblTotal.text = "R$ \(strMoney)"
            }
            
            cell.lblNumber.text = objOrder.strPhoneNumber
            
            cell.btnDetailsClick = {(_ aCell: MyClientOrderTableViewCell) -> Void in
                
                let viewController: RequestDetailsVC = RequestDetailsVC()
                viewController.strSelectedOrderID = objOrder.strID
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            
            cell.btnWhatsappClick = {(_ aCell: MyClientOrderTableViewCell) -> Void in
                
                if (objOrder.strPhoneNumber != "")
                {
                    print("self.objStoreDetails.strPhoneNumber :\(objOrder.strPhoneNumber)")

                    let originalString = "https://wa.me/55\(objOrder.strPhoneNumber)?text="
                    let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

                    guard let url = URL(string: escapedString!) else {
                      return //be safe
                    }

                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                
            }
            
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    
}
