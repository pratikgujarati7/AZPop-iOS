//
//  User_RecentViewController.swift
//  AgendaZap
//
//  Created by Dipen on 24/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift

class User_RecentViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
{
    // MARK: - IBOutlet
    @IBOutlet var statusBarContainerView: UIView?
    @IBOutlet var homeBarContainerView: UIView?
    @IBOutlet var masterContainerView: UIView?
    
    //NAVIGATION BAR
    @IBOutlet var navigationBarView: UIView?
    @IBOutlet var navigationTitle: UILabel?
    //BACK
    @IBOutlet var backContainerView: UIView?
    @IBOutlet var imageViewBack: UIImageView?
    @IBOutlet var btnBack: UIButton?
    
    @IBOutlet var mainContainerView: UIView?
    @IBOutlet var mainTableView: UITableView?
    @IBOutlet  var segmentedController: UISegmentedControl!
    // @IBOutlet var segmentedControl: UISegmentedControl!
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    let strScreenID: String = "3"
    
    var dataRow = [RecentStore]()
    // var dataRowFavourite = [RecentStore]()
    var boolIsOpenFromFavourite : Bool = false
    // MARK: - UIViewController Delegate Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNotificationEvent()
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        let realm = try! Realm()
        
        self.dataRow = [RecentStore]()
        
        for obj in realm.objects(RecentStore.self)
        {
            self.dataRow.append(obj)
        }
        self.mainTableView?.isHidden = false
        self.mainTableView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //API CALL
        dataManager.user_GetAllRecentStores()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .lightContent
        }
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
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //
    //        self.view.endEditing(true)
    //
    //        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetAllRecentStoresEvent),
                name: Notification.Name("user_GetAllRecentStoresEvent"),
                object: nil)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetAllFavouriteStoresEvent),
                name: Notification.Name("user_GetAllFavouriteStoresEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllRecentStoresEvent()
    {
        DispatchQueue.main.async(execute: {
            self.boolIsOpenFromFavourite = false
            let realm = try! Realm()
            try! realm.write({
                realm.delete(realm.objects(RecentStore.self))
                realm.add(dataManager.arrayAllRecentStores)
            })
            
            self.dataRow = [RecentStore]()
            for obj in realm.objects(RecentStore.self)
            {
                self.dataRow.append(obj)
            }
            
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
        })
    }
    
    @objc func user_GetAllFavouriteStoresEvent()
    {
        DispatchQueue.main.async(execute: {
            self.boolIsOpenFromFavourite = true
            let realm = try! Realm()
            try! realm.write({
                realm.delete(realm.objects(RecentStore.self))
                realm.add(dataManager.arrayAllFavouriteStores)
            })
            
            self.dataRow = [RecentStore]()
            for obj in realm.objects(RecentStore.self)
            {
                self.dataRow.append(obj)
            }
            
            
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
        })
    }
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("recent_favourite", value:"Recentes / Favoritos", comment: "")
        
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        mainTableView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundLightGreenColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundLightGreenColor
        mainContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundLightGreenColor
        
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalBackgroundLightGreenColor
        mainTableView?.isHidden = true
        // Initialize
        let items = [NSLocalizedString("menu_recents", value:"Recentes", comment: "") ,NSLocalizedString("menu_favourites", value:"Favoritos", comment: "")]
        self.segmentedController = UISegmentedControl(items : items)
        self.segmentedController.selectedSegmentIndex = 0
        // Add target action method
        self.segmentedController.addTarget(self, action: #selector(segmentValChanged(_:)), for: .valueChanged)
    }
    
    @IBAction func segmentValChanged(_ sender: UISegmentedControl) {
        print("touched")
        switch sender.selectedSegmentIndex{
        case 0:
            //API CALL
            dataManager.user_GetAllRecentStores()
        case 1:
            //API CALL
            dataManager.user_GetAllFavouriteStores()
        default:
            
            break
        }
    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (dataRow.count > 0)
        {
            return dataRow.count
        }
        else
        {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (dataRow.count > 0)
        {
            //return StoreTableViewCellHeight
            let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:StoreTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? StoreTableViewCell
            
            if(cell == nil)
            {
                cell = StoreTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            let defaultWidth : CGFloat = cell.innerContainer.frame.size.width - 170.0
            
            cell.lblName.frame.size.width = defaultWidth
            cell.lblTag.frame.size.width = defaultWidth
            
            cell.lblName.text = dataRow[indexPath.row].strName
            cell.lblTag.text = dataRow[indexPath.row].strTags
            cell.lblDistance.text = ""
            
            cell.lblName.sizeToFit()
            cell.lblTag.frame.origin.y = cell.lblName.frame.origin.y + cell.lblName.frame.size.height + 10
            cell.lblTag.sizeToFit()
            cell.innerContainer.frame.size.height = cell.lblTag.frame.origin.y + cell.lblTag.frame.size.height + 10
            cell.lblDistance.frame.origin.y = (cell.innerContainer.frame.size.height - cell.lblDistance.frame.size.height) / 2
            cell.btnSend.frame.origin.y = (cell.innerContainer.frame.size.height - cell.btnSend.frame.size.height) / 2
            
            if (dataRow[indexPath.row].strPromo == "")
            {
                cell.lblFavourite.isHidden = true
                cell.innerContainer.frame.origin.y = 5
                cell.innerContainer.layer.borderColor = UIColor.clear.cgColor
            }
            else
            {
                cell.lblFavourite.isHidden = false
                cell.innerContainer.frame.origin.y = 25
                cell.innerContainer.layer.borderColor = MySingleton.sharedManager().themeGlobalOrangeColor?.cgColor
            }
            
            cell.mainContainer.frame.size.height = cell.innerContainer.frame.origin.y + cell.innerContainer.frame.size.height + 5
            
            return cell.mainContainer.frame.size.height
        }
        else
        {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (dataRow.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:StoreTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? StoreTableViewCell
            
            if(cell == nil)
            {
                cell = StoreTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            let defaultWidth : CGFloat = cell.innerContainer.frame.size.width - 170.0
            
            cell.lblName.frame.size.width = defaultWidth
            cell.lblTag.frame.size.width = defaultWidth
            
            cell.lblName.text = dataRow[indexPath.row].strName
            cell.lblTag.text = dataRow[indexPath.row].strTags
            cell.lblDistance.text = ""
            
            cell.btnSend.tag = indexPath.row
            cell.btnSend.addTarget(self, action: #selector(self.btnSendClicked(_:)), for: .touchUpInside)
            
            cell.lblName.sizeToFit()
            cell.lblTag.frame.origin.y = cell.lblName.frame.origin.y + cell.lblName.frame.size.height + 10
            cell.lblTag.sizeToFit()
            cell.innerContainer.frame.size.height = cell.lblTag.frame.origin.y + cell.lblTag.frame.size.height + 10
            cell.lblDistance.frame.origin.y = (cell.innerContainer.frame.size.height - cell.lblDistance.frame.size.height) / 2
            cell.btnSend.frame.origin.y = (cell.innerContainer.frame.size.height - cell.btnSend.frame.size.height) / 2
            
            if (dataRow[indexPath.row].strPromo == "")
            {
                cell.lblFavourite.isHidden = true
                cell.innerContainer.frame.origin.y = 5
                cell.innerContainer.layer.borderColor = UIColor.clear.cgColor
            }
            else
            {
                cell.lblFavourite.isHidden = false
                cell.innerContainer.frame.origin.y = 25
                cell.innerContainer.layer.borderColor = MySingleton.sharedManager().themeGlobalOrangeColor?.cgColor
            }
            
            cell.mainContainer.frame.size.height = cell.innerContainer.frame.origin.y + cell.innerContainer.frame.size.height + 5
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
        else
        {
            var lblNoDataFont: UIFont?
            
            if MySingleton.sharedManager().screenWidth == 320
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            }
            else if MySingleton.sharedManager().screenWidth == 375
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            }
            else
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            }
            
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
            
            let lblNoData = UILabel(frame: CGRect(x: 0, y: 0, width: (mainTableView?.frame.size.width)!, height: cell.frame.size.height))
            lblNoData.textAlignment = NSTextAlignment.center
            lblNoData.font = lblNoDataFont
            lblNoData.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
            lblNoData.text = NSLocalizedString("no_fav_store", value:"Nenhuma loja encontrada.", comment: "")
            
            cell.contentView.addSubview(lblNoData)
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (dataRow.count > 0)
        {
            let viewController: User_StoreDetailsViewController = User_StoreDetailsViewController()
            viewController.strSelectedStoreID = dataRow[indexPath.row].strID
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @IBAction func btnSendClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        dataManager.user_UpdateStoreClicks(strStoreID: dataRow[sender.tag].strID, strScreenID: self.strScreenID)
        
        if (dataRow[sender.tag].strPhoneNumber != "")
        {
            let originalString = "https://wa.me/55\(dataRow[sender.tag].strPhoneNumber)?text=Olá. Achei seu contato no AZpop (Cliente n. \(UserDefaults.standard.value(forKey: "hashed_user_id") ?? "-"))&source=&data="
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            print(escapedString)
            
            guard let url = URL(string: escapedString!) else {
                return //be safe
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
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
