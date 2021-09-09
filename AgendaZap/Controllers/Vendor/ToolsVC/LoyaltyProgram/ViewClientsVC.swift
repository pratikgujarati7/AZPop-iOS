//
//  ViewClientsVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 11/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import iOSDropDown
import ZMJGanttChart

class ViewClientsVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var spreadsheetView: SpreadsheetView?
        
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    let header: Array = ["Name","Number","Points",""]
    var datarows = [ObjRewardUser]()
    
    //MARK:- Methods
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
        dataManager.user_GetTopRewardList(strStoreID: strSelectedStoreID)
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
                selector: #selector(self.user_GetTopRewardListEvent),
                name: Notification.Name("user_GetTopRewardListEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetTopRewardListEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarows = dataManager.arrayTopRewardList
            self.spreadsheetView?.reloadData()
            
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
        //navigationTitle?.text = ""
        
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
extension ViewClientsVC : SpreadsheetViewDelegate, SpreadsheetViewDataSource {
    
    func number(ofColumns spreadsheetView: SpreadsheetView!) -> Int {
        
        return header.count
    
    }
    
    func number(ofRows spreadsheetView: SpreadsheetView!) -> Int {
        
        return self.datarows.count + 1
        
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView!, heightForRow row: Int) -> CGFloat {
        
        return 50
        
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView!, widthForColumn column: Int) -> CGFloat {
        
        let section = (MySingleton.sharedManager().screenWidth - 25) / 15
        
        if (column == 0)
        {
            return section * 3.5
        }
        else if (column == 1)
        {
            return section * 6
        }
        else if (column == 2)
        {
            return section * 3.5
        }
        else
        {
            return section * 2
        }
        
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
                if self.datarows[indexPath.row - 1].strFullName == "" || self.datarows[indexPath.row - 1].strFullName == "<null>"
                {
                    cell.label.text = "-"
                }
                else
                {
                    cell.label.text = self.datarows[indexPath.row - 1].strFullName
                }
            }
            else if (indexPath.section == 1)
            {
                cell.label.text = self.datarows[indexPath.row - 1].strPhoneNumner
            }
            else if (indexPath.section == 2)
            {
                cell.label.text = self.datarows[indexPath.row - 1].strPurchases
            }
            else
            {
                cell.label.addImage(imageName: "whatsapp_round.png")
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
            if (indexPath.section == 3)
            {
                if (self.datarows[indexPath.row - 1].strPhoneNumner != "")
                {
                    print("self.objStoreDetails.strPhoneNumber :\(self.datarows[indexPath.row - 1].strPhoneNumner)")

                    let originalString = "https://wa.me/55\(self.datarows[indexPath.row - 1].strPhoneNumner)?text="
                    let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

                    guard let url = URL(string: escapedString!) else {
                      return //be safe
                    }

                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            else
            {
                dataManager.objSelectedRewardUser = self.datarows[indexPath.row - 1]
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
}
