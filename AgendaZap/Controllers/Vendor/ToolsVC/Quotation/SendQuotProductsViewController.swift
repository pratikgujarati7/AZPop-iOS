//
//  SendQuotProductsViewController.swift
//  AgendaZap
//
//  Created by Dipen on 20/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import RealmSwift

class SendQuotProductsViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    
    //POPUP
    @IBOutlet var viewPopupContainer: UIView!
    @IBOutlet var viewPopupInnerContainer: UIView!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var btnSend: UIButton?
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var datarowsSavedProducts = [ObjQuotationProduct]()
    var datarows = [ObjStoreProduct]()
    var intSelectedIndex: Int!
    
    @IBOutlet var mainTableView: UITableView! {
        didSet {
            self.mainTableView.register(UINib(nibName: "SendQuotProductTVCell", bundle: nil), forCellReuseIdentifier: "SendQuotProductTVCell")
        }
    }
    
    var pageNumber = 1
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let strSelectedStoreName: String = "\(UserDefaults.standard.value(forKey: "selected_store_name") ?? "-")"
        lblNavigationTitle.text = "Produtos - \(strSelectedStoreName)"
        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        //API CALL
        dataManager.user_GetAllStoreProductsForStore(strStoreID: strSelectedStoreID, strPageNumber: "\(pageNumber)")
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
                selector: #selector(self.user_GetAllStoreProductsEvent),
                name: Notification.Name("user_GetAllStoreProductsEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllStoreProductsEvent()
    {
        DispatchQueue.main.async(execute: {
          
            self.datarows = dataManager.arrayAllStoreProducts
            self.mainTableView.reloadData()
            
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        
        txtPrice.text = ""
        viewPopupContainer.removeFromSuperview()
        
    }
    
    @IBAction func btnSendTapped(_ sender: Any) {
        
        if txtPrice.text != ""
        {
            var txtValue: String = txtPrice.text ?? "0,00"
            txtValue = txtValue.replacingOccurrences(of: ".", with: "")
            
            var boolIsFound: Bool = false
            
            for objSavedProduct in datarowsSavedProducts
            {
                if (objSavedProduct.strID == datarows[intSelectedIndex].strID)
                {
                    let floatOldPrice: Float = Float(objSavedProduct.strProductPrice) ?? 0
                    let floatNewPrice: Float = Float(txtValue.replacingOccurrences(of: ",", with: ".")) ?? 0
                    
                    if (floatNewPrice == floatOldPrice)
                    {
                        boolIsFound = true
                        let realm = try! Realm()
                        try! realm.write({
                            
                            let intQuantity: Int = Int(objSavedProduct.strProductQuantity) ?? 0
                            objSavedProduct.strProductQuantity = "\(intQuantity + 1)"
                        })
                    }
                }
            }
            
            if boolIsFound == false
            {
                let objIndex: ObjStoreProduct = datarows[intSelectedIndex]
                
                let objNew: ObjQuotationProduct = ObjQuotationProduct()
                objNew.strID = objIndex.strID
                objNew.strProductName = objIndex.strTitle
                objNew.strProductQuantity = "1"
                objNew.strProductPrice = txtValue.replacingOccurrences(of: ",", with: ".")
                
                let realm = try! Realm()
                try! realm.write({
                    realm.add(objNew)
                })
            }
            
            
            
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            AppDelegate.showToast(message : "Please enter amount", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
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
        txtPrice.delegate = self
        txtPrice.keyboardType = .numberPad
        txtPrice.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        btnSend?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSend?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSend?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSend?.clipsToBounds = true
        btnSend?.layer.cornerRadius = 5
    }    
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
}

//MARK:- TableView Methods
extension SendQuotProductsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return datarows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.register(UINib(nibName: "SendQuotProductTVCell", bundle: nil), forCellReuseIdentifier: "SendQuotProductTVCell\(indexPath.row)")
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:SendQuotProductTVCell! = tableView.dequeueReusableCell(withIdentifier: "SendQuotProductTVCell\(indexPath.row)") as? SendQuotProductTVCell
        
        if(cell == nil)
        {
            cell = SendQuotProductTVCell(style: .default, reuseIdentifier: "SendQuotProductTVCell\(indexPath.row)")
        }
        
        let objIndex: ObjStoreProduct = datarows[indexPath.row]
        
        cell.imageViewProduct.layer.cornerRadius = 10
        
        if (objIndex.arrayProductImages.count > 0)
        {
            cell.imageViewProduct.contentMode = .scaleAspectFill
            cell.imageViewProduct.sd_setImage(with: URL(string: objIndex.arrayProductImages[0]), placeholderImage: objIndex.strProductType == "1" ? UIImage(named: "product_placeholder") : UIImage(named: "service_placeholder"))
        }
        else
        {
            cell.imageViewProduct.contentMode = .scaleAspectFit
            cell.imageViewProduct.image = objIndex.strProductType == "1" ? UIImage(named: "product_placeholder") : UIImage(named: "service_placeholder")
        }
        
        cell.lblProductName.text = objIndex.strTitle
        
        let strMoney: String = String(format: "%.02f", Float(objIndex.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
        
        cell.lblProductPrice.text = "R$ \(strMoney.replacingOccurrences(of: ".", with: ","))"
        //cell.lblProductPrice.text = "R$\(objIndex.strMoneyPrice)"
        
        cell.btnAddClick = {(_ aCell: SendQuotProductTVCell) -> Void in
            
            let strPrice: String = objIndex.strMoneyPrice.replacingOccurrences(of: ",", with: ".")
            let floatPrice: Float = Float(strPrice) ?? 0
            if (floatPrice > 0)
            {
                let objNew: ObjQuotationProduct = ObjQuotationProduct()
                objNew.strID = objIndex.strID
                objNew.strProductName = objIndex.strTitle
                objNew.strProductQuantity = "1"
                objNew.strProductPrice = objIndex.strMoneyPrice
                
                let realm = try! Realm()
                try! realm.write({
                    realm.add(objNew)
                })
                
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.intSelectedIndex = indexPath.row
                self.view.addSubview(self.viewPopupContainer)
            }
        }
        
        let sectionsAmount = tableView.numberOfSections
        let rowsAmount = tableView.numberOfRows(inSection: indexPath.section)
        if ((indexPath.section == sectionsAmount - 1) && (indexPath.row == rowsAmount - 1))
        {
            // This is the last cell in the table
            if (pageNumber < dataManager.totalPageNumberForProducts)
            {
                pageNumber = pageNumber + 1
                //API CALL
                let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
                dataManager.user_GetAllStoreProductsForStore(strStoreID: strSelectedStoreID, strPageNumber: "\(pageNumber)")
            }
        }
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}


