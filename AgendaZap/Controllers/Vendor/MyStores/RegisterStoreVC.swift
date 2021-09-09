//
//  RegisterStoreVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 02/04/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import iOSDropDown
import NYAlertViewController

class RegisterStoreVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblName: UILabel?
    @IBOutlet var txtNameContainerView: UIViewX?
    @IBOutlet var txtName: UITextField?
    
    @IBOutlet var lblMobileNumber: UILabel?
    @IBOutlet var txtMobileNumberContainerView: UIViewX?
    @IBOutlet var txtMobileNumber: UITextField?
    
    @IBOutlet var lblEmail: UILabel?
    @IBOutlet var txtEmailContainerView: UIViewX?
    @IBOutlet var txtEmail: UITextField?
    
    @IBOutlet var lblCategory: UILabel?
    @IBOutlet var txtCategoryContainerView: UIViewX?
    @IBOutlet var txtCategory: DropDown?
    
    @IBOutlet var lblSubCategory: UILabel?
    @IBOutlet var txtSubCategoryContainerView: UIViewX?
    @IBOutlet var txtSubCategory: UITextField?
    @IBOutlet var btnSubCategory: UIButton?
    
    @IBOutlet var btnSave: UIButton?
    
    //SUBCATEGORY POPUP
    @IBOutlet var subCategoryContainerView: UIView?
    @IBOutlet var subCategoryInnerContainerView: UIView?
    @IBOutlet var subCategoryTableView: UITableView?
    @IBOutlet var btnSubCategoryOk: UIButton?
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var objSelectedStore: MyStore!
    
    //CATEGORY
    var dataRowsCategory = [ObjCategory]()
    var dataRowsCategoryIDs = [Int]()
    var dataRowsCategoryNames = [String]()
    
    var intSelectedCategoryID: Int?
    var strSelectedCategoryName: String?
    //SUBCATEGORY
    var dataRowsSubCategory = [ObjSubCategory]()
    var arraySelectedSubCategoryIDs = [ObjSubCategory]()
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        //API CALL
        dataManager.user_GetAllCategories()
        
        txtMobileNumber?.text = objSelectedStore.strPhoneNumber
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
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.txtCategory?.listHeight = (self.view?.frame.size.height)! / 3
        
        subCategoryContainerView?.frame.size = self.view.frame.size
    }
    
    //MARK:- Setup Notification Methods
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetAllCategoriesEvent),
                name: Notification.Name("user_GetAllCategoriesEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetAllSubCategoriesEvent),
                name: Notification.Name("user_GetAllSubCategoriesEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_MakeStoreVisibleEvent),
                name: Notification.Name("user_MakeStoreVisibleEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllCategoriesEvent()
    {
        DispatchQueue.main.async(execute: {
          
            self.dataRowsCategory = dataManager.arrayAllCategoriesForAdd
            self.dataRowsCategoryIDs = [Int]()
            self.dataRowsCategoryNames = [String]()
            for objCategory in dataManager.arrayAllCategoriesForAdd
            {
                self.dataRowsCategoryIDs.append(Int(objCategory.strCategoryID) ?? 0)
                self.dataRowsCategoryNames.append(objCategory.strCategoryName)
            }
            
            self.txtCategory?.isUserInteractionEnabled = true
            self.txtCategory?.optionArray = self.dataRowsCategoryNames
            self.txtCategory?.optionIds = self.dataRowsCategoryIDs
            self.txtCategory?.handleKeyboard = false
            self.txtCategory?.isSearchEnable = false
            self.txtCategory?.hideOptionsWhenSelect = true
            self.txtCategory?.checkMarkEnabled = false
            self.txtCategory?.selectedRowColor = (MySingleton.sharedManager().themeGlobalLightGreenColor?.withAlphaComponent(0.5))!
            
            self.txtCategory?.didSelect{(selectedText , index ,id) in
                
                self.intSelectedCategoryID = id
                self.strSelectedCategoryName = selectedText
                
                //API CALL
                dataManager.user_GetAllSubCategoriesForAddStore(strCategoryID: "\(id)")
            }
            
        })
    }
    
    @objc func user_GetAllSubCategoriesEvent()
    {
        DispatchQueue.main.async(execute: {
            self.dataRowsSubCategory = dataManager.arrayAllSubCategories
            self.subCategoryTableView?.reloadData()
        })
    }
    
    @objc func user_MakeStoreVisibleEvent()
    {
        DispatchQueue.main.async(execute: {
            
                //show Rating alert
                let alertViewController = NYAlertViewController()
                
                // Set a title and message
                alertViewController.title = "Cadastro enviado! Aguardando aprovação."
                alertViewController.message = "Sucesso! Você já pode criar e compartilhar produtos, cartão de visita, orçamentos e muito mais com seus clientes."
                
                // Customize appearance as desired
                alertViewController.view.tintColor = UIColor.white
                alertViewController.backgroundTapDismissalGestureEnabled = true
                alertViewController.swipeDismissalGestureEnabled = true
                alertViewController.transitionStyle = NYAlertViewControllerTransitionStyle.fade
                
                alertViewController.titleFont = MySingleton.sharedManager().alertViewTitleFont
                alertViewController.messageFont = MySingleton.sharedManager().alertViewMessageFont
                alertViewController.buttonTitleFont = MySingleton.sharedManager().alertViewButtonTitleFont
                alertViewController.cancelButtonTitleFont = MySingleton.sharedManager().alertViewCancelButtonTitleFont
                alertViewController.buttonTitleColor = MySingleton.sharedManager().themeGlobalBlackColor
                alertViewController.cancelButtonTitleColor = MySingleton.sharedManager().themeGlobalBlackColor
                
                alertViewController.buttonColor = MySingleton.sharedManager().alertViewLeftButtonBackgroundColor
                
                alertViewController.cancelButtonColor = MySingleton.sharedManager().themeGlobalRedColor
                
                // Add alert actions
                let okAction = NYAlertAction(
                    title: "Sim",
                    style: .default,
                    handler: { (action: NYAlertAction!) -> Void in
                        
                        self.navigationController!.dismiss(animated: true, completion: nil)
                        
                        let viewController: User_PurchasePremiumViewController = User_PurchasePremiumViewController()
                        viewController.boolIsOpendFromAddStore = true
                        self.navigationController?.pushViewController(viewController, animated: false)
                        
                        
                })
                
                alertViewController.addAction(okAction)
                                    
                self.navigationController!.present(alertViewController, animated: true, completion: nil)
            
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        viewNavigation?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        //navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        //navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        txtName?.delegate = self
        txtMobileNumber?.delegate = self
        txtEmail?.delegate = self
        txtCategory?.delegate = self
        txtSubCategory?.delegate = self
        
        btnSave?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSave?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSave?.clipsToBounds = true
        btnSave?.layer.cornerRadius = 5
        
        //SUB CATEGORY POPUP
        subCategoryContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBlackColor?.withAlphaComponent(0.5)
        
        subCategoryInnerContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        subCategoryTableView?.delegate = self
        subCategoryTableView?.dataSource = self
        subCategoryTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        subCategoryTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalWhiteColor
        
        btnSubCategoryOk?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSubCategoryOk?.backgroundColor = UIColor.clear
        btnSubCategoryOk?.setTitle(NSLocalizedString("ok", value: "OK", comment: ""), for: .normal)
        btnSubCategoryOk?.setTitleColor(MySingleton.sharedManager().themeGlobalLightGreenColor, for: .normal)
    }
    
    @IBAction func btnSubCategoryClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (intSelectedCategoryID != nil)
        {
            self.view.addSubview(subCategoryContainerView!)
        }
        else
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select store category.")
        }
    }
    
    @IBAction func btnSubCategoryOkClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        subCategoryContainerView?.removeFromSuperview()
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if (txtName?.text?.isEmpty == true || txtMobileNumber?.text?.isEmpty == true || txtEmail?.text?.isEmpty == true || txtCategory?.text?.isEmpty == true || txtSubCategory?.text?.isEmpty == true)
        {
            if (txtName?.text?.isEmpty == true)
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter store name.")
            }
            else if (txtMobileNumber?.text?.isEmpty == true)
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter mobile number.")
            }
            else if (txtEmail?.text?.isEmpty == true)
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please enter email.")
            }
            else if (txtCategory?.text?.isEmpty == true)
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select store category.")
            }
            else
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Please select store sub-category.")
            }
        }
        else if (objCommonUtility.isValidEmailAddress(strEmailString: (txtEmail?.text)!) == false)
        {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Invalid Email.")
        }
        else
        {
            var arrayTempIDs = [String]()
            for objTemp in arraySelectedSubCategoryIDs
            {
                arrayTempIDs.append(objTemp.strSubCategoryID)
            }
            //API CALL
            dataManager.user_MakeStoreVisible(strStoreName: (txtName?.text)!,
                                              strStoreNumber: (txtMobileNumber?.text)!,
                                              strStoreEmail: (txtEmail?.text)!,
                                              strStoreCategorID: "\(self.intSelectedCategoryID ?? 0)",
                                              strStoreSubCategoryIDs: arrayTempIDs.joined(separator: ","))
        }
    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.dataRowsSubCategory.count > 0)
        {
            return self.dataRowsSubCategory.count
        }
        else
        {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (self.dataRowsSubCategory.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:CheckboxTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? CheckboxTableViewCell
            
            if(cell == nil)
            {
                cell = CheckboxTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblText.frame.size.width = cell.mainContainer.frame.size.width - 50
            
            cell.lblText.text = self.dataRowsSubCategory[indexPath.row].strSubCategoryName
            
            cell.lblText.sizeToFit()
            
            return cell.lblText.frame.size.height + 20
        }
        else
        {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (self.dataRowsSubCategory.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String
            
            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:CheckboxTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? CheckboxTableViewCell
            
            if(cell == nil)
            {
                cell = CheckboxTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblText.frame.size.width = cell.mainContainer.frame.size.width - 50
            
            cell.lblText.text = self.dataRowsSubCategory[indexPath.row].strSubCategoryName
            cell.lblText.sizeToFit()
            
            cell.mainContainer.frame.size.height = cell.lblText.frame.size.height + 20
            
            cell.imageViewCheckbox.frame.origin.y = (cell.mainContainer.frame.size.height - cell.imageViewCheckbox.frame.size.height) / 2
            
            if self.arraySelectedSubCategoryIDs.firstIndex(of: self.dataRowsSubCategory[indexPath.row]) != nil
            {
                cell.imageViewCheckbox.image = UIImage(named: "ic_green_tick.png")
            }
            else
            {
                cell.imageViewCheckbox.image = UIImage(named: "ic_grey_tick.png")
            }
            
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
        if (self.dataRowsSubCategory.count > 0)
        {
            if let indexValue = self.arraySelectedSubCategoryIDs.firstIndex(of: self.dataRowsSubCategory[indexPath.row])
            {
                self.arraySelectedSubCategoryIDs.remove(at: indexValue)
            }
            else
            {
                self.arraySelectedSubCategoryIDs.append(self.dataRowsSubCategory[indexPath.row])
            }
            
            subCategoryTableView?.reloadData()
            var strSelectedSubCategories: String = ""
            for objSubCategory in self.arraySelectedSubCategoryIDs
            {
                if (strSelectedSubCategories != "")
                {
                    strSelectedSubCategories = "\(strSelectedSubCategories), "
                }
                strSelectedSubCategories = "\(strSelectedSubCategories)\(objSubCategory.strSubCategoryName)"
            }
            
            txtSubCategory?.text = strSelectedSubCategories
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
