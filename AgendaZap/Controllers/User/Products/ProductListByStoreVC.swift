//
//  ProductListByStoreVC.swift
//  AgendaZap
//
//  Created by Dipen on 24/12/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ProductListByStoreVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
{
    //MARK:- IBOutlet
    //NAVIGATION BAR
    @IBOutlet var navigationBarView: UIView?
    @IBOutlet var lblCartCount: UILabel!
    
    @IBOutlet var mainTableView: UITableView? {
        didSet {
            self.mainTableView?.register(UINib(nibName: "ProductTVCell", bundle: nil), forCellReuseIdentifier: "ProductTVCell")
        }
    }
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var boolIsNavigate: Bool = false
    
    var strStoreID: String!
    var datarows = [ObjStoreProduct]()
    
    var pageNumber = 1
    
    //MARK:- UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNotificationEvent()
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        //API CALL
        pageNumber = 1
//        dataManager.user_GetProductsBySearch(
//            strStoreID: self.strStoreID,
//            strSearchText: "",
//            strOrderBy: "0",
//            strPageNumber: "1")
        dataManager.user_GetAllStoreProductsForStore(strStoreID: self.strStoreID, strPageNumber: "\(pageNumber)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //API CALL
        dataManager.user_getStoreCartProducts(strStoreID: self.strStoreID, strProductID: "")
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
        
        dataManager.arrayAllWhatsappGroups.removeAll()
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
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_getStoreCartProductsEvent),
                name: Notification.Name("user_getStoreCartProductsEvent"),
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
            
            self.datarows = [ObjStoreProduct]()
            for obj in dataManager.arrayAllStoreProducts
            {
                if obj.strIsActive == "1"
                {
                    self.datarows.append(obj)
                }
            }
            
            self.mainTableView?.reloadData()
        })
    }
    
    @objc func user_getStoreCartProductsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            if (self.boolIsNavigate)
            {
                self.boolIsNavigate = false
                let viewController: CartVC = CartVC()
                viewController.datarows = dataManager.arrayAllStoreCartProducts
                viewController.strStoreID = self.strStoreID
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                //DOSPLAY COUNT
                if (dataManager.arrayAllStoreCartProducts.count > 0)
                {
                    self.lblCartCount.isHidden = false
                    self.lblCartCount.text = "\(dataManager.arrayAllStoreCartProducts.count)"
                }
                else
                {
                    self.lblCartCount.isHidden = true
                    self.lblCartCount.text = ""
                }
            }
        })
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        //navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        //navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        //navigationTitle?.text = ""
        
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView()
    {
        //mainTableView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        mainTableView?.isHidden = false //true
        mainTableView?.separatorStyle = .none
        //mainTableView?.tableFooterView = UIView()
        mainTableView?.separatorColor = .clear
        
        lblCartCount.layer.cornerRadius = 10
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCartTapped(_ sender: Any) {
        
        let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
        let strPassword: String = "\(UserDefaults.standard.value(forKey: "password") ?? "")"
        if(strIsAuthorized != "1")
        {
            if(strPassword != "" && strPassword.count > 0)
            {
                let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
                viewController.boolIsLoadedFromSplashScreen = false
//                viewController.boolIsNoWayBack = true
                self.navigationController?.pushViewController(viewController, animated: false)
            }
            else
            {
//                let viewController: User_RegisterEmailViewController = User_RegisterEmailViewController()
//                viewController.boolIsLoadedFromSplashScreen = false
//                viewController.boolIsNoWayBack = true
//                self.navigationController?.pushViewController(viewController, animated: false)
            }
        }
        else
        {
            //API CALL
            self.boolIsNavigate = true
            dataManager.user_getStoreCartProducts(strStoreID: self.strStoreID, strProductID: "")
        }
    }

}

//MARK:- Textfield Delegates
extension ProductListByStoreVC {
    
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
extension ProductListByStoreVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.datarows.count == 0)
        {
            self.mainTableView!.showNoDataLabel(NSLocalizedString("no_store_found", value:"Nenhum negócio encontrado.", comment: ""), isScrollable: true)
            return 0
        }
        else
        {
            self.mainTableView!.removeNoDataLabel()
            return self.datarows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let objProduct = self.datarows[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTVCell") as! ProductTVCell
        
        
        if (objProduct.arrayProductImages.count > 0)
        {
            cell.imageviewProduct.contentMode = .scaleAspectFill
            cell.imageviewProduct.sd_setImage(with: URL(string: objProduct.arrayProductImages[0]), placeholderImage: objProduct.strProductType == "1" ? UIImage(named: "product_placeholder") : UIImage(named: "service_placeholder"))
        }
        else
        {
            cell.imageviewProduct.contentMode = .scaleAspectFit
            cell.imageviewProduct.image = objProduct.strProductType == "1" ? UIImage(named: "product_placeholder") : UIImage(named: "service_placeholder")
        }
        cell.imageviewProductCover.isHidden = false
        
        cell.lblProductName.text = objProduct.strTitle
        //cell.lblPricePoints.text = "R$\(objProduct.strMoneyPrice) ou\(objProduct.strPointPrice) Pontos"
        
        //let strMoney: String = String(format: "%.02f", Float(objProduct.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
        
        //cell.lblPricePoints.text = "R$ \(strMoney.replacingOccurrences(of: ".", with: ",")) ou \(objProduct.strPointPrice) Pontos"
        
        let floatValue: Float = Float(objProduct.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
        if (floatValue > 0)
        {
            let floatDiscountValue: Float = Float(objProduct.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
            if (floatDiscountValue > 0)
            {
                let strDiscountValue: String = String(format: "%.02f", Float(objProduct.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                let strValue: String = String(format: "%.02f", Float(objProduct.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "R$ \(strValue)".replacingOccurrences(of: ".", with: ","))
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                let attributeString2: NSMutableAttributedString = NSMutableAttributedString(string: " R$ \(strDiscountValue)".replacingOccurrences(of: ".", with: ","))
                attributeString2.addAttribute(NSAttributedString.Key.foregroundColor, value: MySingleton.sharedManager().themeGlobalBlackColor!, range: NSMakeRange(0, attributeString2.length))
                attributeString.append(attributeString2)
                cell.lblPricePoints.attributedText = attributeString
            }
            else
            {
                let strValue: String = String(format: "%.02f", Float(objProduct.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                            
                cell.lblPricePoints.text = "R$ \(strValue)".replacingOccurrences(of: ".", with: ",")
            }
        }
        else
        {
            cell.lblPricePoints.text = ""
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
//                dataManager.user_GetProductsBySearch(
//                    strStoreID: self.strStoreID,
//                    strSearchText: "",
//                    strOrderBy: "0",
//                    strPageNumber: "\(pageNumber)")
                
                dataManager.user_GetAllStoreProductsForStore(strStoreID: self.strStoreID, strPageNumber: "\(pageNumber)")
            }
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objProduct = self.datarows[indexPath.row]
        
        let viewController = ProductDetailsVC()
        viewController.strSelectedStoreProductID = objProduct.strID
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }
    
}

