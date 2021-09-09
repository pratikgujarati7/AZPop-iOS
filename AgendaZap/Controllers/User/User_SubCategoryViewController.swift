//
//  User_SubCategoryViewController.swift
//  AgendaZap
//
//  Created by Dipen on 12/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class User_SubCategoryViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate
{
    //MARK:- IBOutlet
    @IBOutlet var masterContainerView: UIView?
    
    //NAVIGATION BAR
    @IBOutlet var navigationBarView: UIView?
    @IBOutlet var navigationTitle: UILabel?
    //BACK
    @IBOutlet var btnBack: UIButton?
    
    @IBOutlet var mainTableView: UITableView?
    @IBOutlet var collSubCategories: UICollectionView! {
        didSet {
            self.collSubCategories.register(UINib(nibName: "SubCategoryCVCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCVCell")
        }
    }
    
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var objSelectedCategory: ObjCategory!
    var objSelectedSubCategory: ObjSubCategory!
    
    var strSelectedCategoryID = "0"
    
    var dataRows = [ObjSubCategory]()
    
    //MARK:- UIViewController Delegate Methods
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
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        
//        self.view.endEditing(true)
//        
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//    }
    
    //MARK:- Setup Notification Methods
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.user_GetAllSubCategoriesEvent),
            name: Notification.Name("user_GetAllSubCategoriesEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllSubCategoriesEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.dataRows = dataManager.arrayAllSubCategories
            
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
            self.collSubCategories.reloadData()
        })
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("pick_sub_category", value:"Escolha a subcategoria", comment: "")
        
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK:- Setting Initial Views Methods
    func setupInitialView()
    {
        mainTableView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
                
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalBackgroundLightGreenColor
        mainTableView?.isHidden = true
        
        //API CALL
        dataManager.user_GetAllSubCategories(strCategoryID: self.strSelectedCategoryID) //  self.objSelectedCategory.strCategoryID
    }
    
}

//MARK:- Textfield delegates
extension User_SubCategoryViewController : UITextFieldDelegate {
    
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
extension User_SubCategoryViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (dataRows.count > 0)
        {
            return 0 //dataRows.count
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (dataRows.count > 0)
        {
            return CategoryTableViewCellHeight
        }
        else
        {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (dataRows.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:CategoryTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? CategoryTableViewCell
            
            if(cell == nil)
            {
                cell = CategoryTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblCategoryName.text = dataRows[indexPath.row].strSubCategoryName
            
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
            
            let lblNoData = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: cell.frame.size.height))
            lblNoData.textAlignment = NSTextAlignment.center
            lblNoData.font = lblNoDataFont
            lblNoData.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
            lblNoData.text = "No data found!"
            
            cell.contentView.addSubview(lblNoData)
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (dataRows.count > 0)
        {
            let viewController: User_StoreListViewController = User_StoreListViewController()
            viewController.strScreenID = "2"
            viewController.boolIsOpenedFromSearch = false
            viewController.isFromHome = true
            viewController.strSearchText = ""
            viewController.objSelectedCategory = self.objSelectedCategory
            viewController.objSelectedSubCategory = dataRows[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
}

//MARK:- CollectionView Methods
extension User_SubCategoryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataRows.count > 0 ? self.dataRows.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let subCatObj = self.dataRows[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCVCell", for: indexPath) as! SubCategoryCVCell
        
        cell.imgSubCategory.image = UIImage(named: "ic_sub_\(subCatObj.intSubCategoryID)")
        cell.lblSubCatName.text = subCatObj.strSubCategoryName
        cell.lblSubCatName.textAlignment = .center
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width/3), height: ((collectionView.frame.size.width)/3) + 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let subCatObj = self.dataRows[indexPath.item]
        
        let viewController: User_StoreListViewController = User_StoreListViewController()
        viewController.strScreenID = "0"
        viewController.boolIsOpenedFromSearch = false
        viewController.strSearchText = ""
        viewController.objSelectedCategory = objSelectedCategory
        viewController.objSelectedSubCategory = subCatObj
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }
    
}
