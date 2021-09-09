//
//  ViewRewardHistoryVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 11/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import ZMJGanttChart

class ViewRewardHistoryVC: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var spreadsheetView: SpreadsheetView?
    @IBOutlet var lblBalance: UILabel!
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
        
    let header: Array = ["Data","Compras"]
    var datarows = [ObjRewardHistory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        spreadsheetView?.flashScrollIndicators()
        
        self.setupNotificationEvent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //API CALL
        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        dataManager.user_GetUserRewardHistory(strStoreID: strSelectedStoreID, strSelectedUserID: dataManager.objSelectedRewardUser?.strID ?? "0")
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
                selector: #selector(self.user_GetUserRewardHistoryEvent),
                name: Notification.Name("user_GetUserRewardHistoryEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetUserRewardHistoryEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarows = dataManager.arrayRewardHistory
            self.spreadsheetView?.reloadData()
            self.lblBalance.text = "Compras as Acumuladas : \((dataManager.objSelectedRewardUser?.strPurchases != "<null>" ? dataManager.objSelectedRewardUser?.strPurchases : "0") ?? "0")"
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
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        viewNavigation?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        //navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        //navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        lblNavigationTitle?.text = dataManager.objSelectedRewardUser?.strFullName
        
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        spreadsheetView?.delegate = self
        spreadsheetView?.dataSource = self
        spreadsheetView?.bounces = false
        spreadsheetView?.scrollView.isScrollEnabled = false
        spreadsheetView?.alwaysBounceVertical = false
        spreadsheetView?.alwaysBounceHorizontal = false
        spreadsheetView?.gridStyle = GridStyle(style: .solid, width: 1, color: .black)
        //spreadsheetView?.allowsSelection = false
        spreadsheetView?.tintColor = .clear
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

//MARK:- SpreadsheetView Delagate Methods
extension ViewRewardHistoryVC : SpreadsheetViewDelegate, SpreadsheetViewDataSource {
    
    func number(ofColumns spreadsheetView: SpreadsheetView!) -> Int {
        
        return header.count
    
    }
    
    func number(ofRows spreadsheetView: SpreadsheetView!) -> Int {
        
        return self.datarows.count + 1
        
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView!, heightForRow row: Int) -> CGFloat {
        
        if case 0 = row
        {
            return 40
        }
        else
        {
            return 30
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView!, widthForColumn column: Int) -> CGFloat {
        
        let section = (MySingleton.sharedManager().screenWidth - 23) / 2
        
        return section
    }
    
    func frozenRows(_ spreadsheetView: SpreadsheetView!) -> Int
    {
        return 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView!, cellForItemAt indexPath: IndexPath!) -> ZMJCell! {
        
        if case 0 = indexPath.row {
            
            spreadsheetView?.register(HeaderCell.self, forCellWithReuseIdentifier: "header:1:\(indexPath.section):\(indexPath.row)")
            
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "header:1:\(indexPath.section):\(indexPath.row)", for: indexPath) as! HeaderCell
            
            cell.label.text = header[indexPath.section]
            cell.label.textColor = MySingleton.sharedManager().themeGlobalBlackColor
            
            cell.setNeedsLayout()
            
            cell.bottomLine.frame.origin.y = 49

            return cell
        }
        else
        {
            spreadsheetView?.register(TextCell.self, forCellWithReuseIdentifier: "cell:1:\(indexPath.section):\(indexPath.row)")
            
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: "cell:1:\(indexPath.section):\(indexPath.row)", for: indexPath) as! TextCell
            
            cell.label.textAlignment = .center
            cell.label.numberOfLines = 2
            cell.label.text = ""
            cell.label.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
            
            if (indexPath.section == 0)
            {
                cell.label.text = self.datarows[indexPath.row - 1].strDate
            }
            else
            {
                cell.label.text = self.datarows[indexPath.row - 1].strPurchases
                let float: Float = Float(self.datarows[indexPath.row - 1].strPurchases) ?? 0
                if (float < 0)
                {
                    cell.label.textColor = MySingleton.sharedManager().themeGlobalRedColor
                }
            }
            
            return cell
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView!, didSelectItemAt indexPath: IndexPath!)
    {
        if case 0 = indexPath.row {
            
            
        }
        else
        {
            if (indexPath.section == 1)
            {
                
            }
        }
    }
}
