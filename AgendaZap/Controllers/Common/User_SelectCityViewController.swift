//
//  User_SelectCityViewController.swift
//  AgendaZap
//
//  Created by Dipen on 06/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import iOSDropDown
import LGSideMenuController

class User_SelectCityViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
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
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var scrollContainerView: UIView?
    
    @IBOutlet var txtSelectCityContainerView: UIView?
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var txtSelectCity: UITextField?
    @IBOutlet var mainTableView: UITableView?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var boolIsLoadedFromSplashScreen: Bool = false
    
    var dataRows = [ObjCity]()
    
    var intSelectedCityID: Int?
    var strSelectedCityName: String?
    var strSelectedStateID: String?
    
    var isFromHomeScreen = false
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNotificationEvent()
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
            selector: #selector(self.user_GetAllCountriesEvent),
            name: Notification.Name("user_GetAllCountriesEvent"),
            object: nil)
            
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.user_GetSplashResponceEvent),
            name: Notification.Name("user_GetSplashResponceEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllCountriesEvent()
    {
        DispatchQueue.main.async(execute: {
            self.txtSelectCity?.text = ""
            self.dataRows = dataManager.arrayAllCities
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
        })
    }
    
    @objc func user_GetSplashResponceEvent()
    {
        DispatchQueue.main.async(execute: {
            
            if self.isFromHomeScreen {
                self.navigationController?.popViewController(animated: true)
            } else {
                AppDelegate().Delegate().setTabBarVC()
            }
            
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        txtSelectCityContainerView?.layer.masksToBounds = false
        txtSelectCityContainerView?.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        txtSelectCityContainerView?.layer.shadowPath = UIBezierPath(roundedRect: txtSelectCityContainerView!.bounds, cornerRadius: (txtSelectCityContainerView?.layer.cornerRadius)!).cgPath
        txtSelectCityContainerView?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        txtSelectCityContainerView?.layer.shadowOpacity = 0.5
        txtSelectCityContainerView?.layer.shadowRadius = 1.0
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("pick_city", value: "Escolha a cidade", comment: "")
        
        if boolIsLoadedFromSplashScreen
        {
            btnBack?.isHidden = true
        }
        else
        {
            btnBack?.isHidden = false
        }
        
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
        if #available(iOS 11.0, *)
        {
            mainScrollView?.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        else
        {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        mainScrollView?.delegate = self
        mainScrollView?.backgroundColor = .clear
        scrollContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        txtSelectCityContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        txtSelectCityContainerView?.layer.cornerRadius = 5.0
        
        txtSelectCity?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtSelectCity?.delegate = self
        txtSelectCity?.backgroundColor = .clear
        txtSelectCity?.tintColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtSelectCity?.attributedPlaceholder = NSAttributedString(string: "Buscar...",
                                                                attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        txtSelectCity?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtSelectCity?.textAlignment = .left
        txtSelectCity?.autocorrectionType = UITextAutocorrectionType.no
        txtSelectCity?.addTarget(self, action: #selector(self.txtSelectCityClicked(_:)), for: .editingChanged)
        
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalBackgroundGreyColor
        mainTableView?.isHidden = true
        
        //API CALL
        dataManager.user_GetAllCountries()
    }
    
    @IBAction func txtSelectCityClicked(_ sender: UITextField)
    {
        self.dataRows = [ObjCity]()

        if ((txtSelectCity?.text?.count)! <= 0)
        {
            self.dataRows = dataManager.arrayAllCities
        }
        else
        {
            for objCity in dataManager.arrayAllCities
            {
                if objCity.strCityName.lowercased().containsIgnoringCase(find: (txtSelectCity?.text?.lowercased())!) || objCity.strCityNonAccentedName.lowercased().containsIgnoringCase(find: (txtSelectCity?.text?.lowercased())!)
                {
                    self.dataRows.append(objCity)
                }
            }
        }

        self.mainTableView?.reloadData()
    }
    
    // MARK: - UITableView Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataRows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CategoryTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:CategoryTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? CategoryTableViewCell
        
        if(cell == nil)
        {
            cell = CategoryTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
        }
        
        cell.lblCategoryName.text = self.dataRows[indexPath.row].strCityName
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.intSelectedCityID = Int(self.dataRows[indexPath.row].strCityID)
        self.strSelectedCityName = self.dataRows[indexPath.row].strCityName
        self.strSelectedStateID = self.dataRows[indexPath.row].strStateID

        UserDefaults.standard.setValue(self.strSelectedStateID!, forKey: "state_id")
        UserDefaults.standard.setValue("\(self.intSelectedCityID!)", forKey: "city_id")
        UserDefaults.standard.setValue(self.strSelectedCityName!, forKey: "city_name")
        UserDefaults.standard.synchronize()

        dataManager.user_GetSplashResponce()
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
