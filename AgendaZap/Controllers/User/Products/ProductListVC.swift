//
//  ProductListVC.swift
//  AgendaZap
//
//  Created by Dipen on 23/12/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import iOSDropDown

class ProductListVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    //MARK:- IBOutlet
    //NAVIGATION BAR
    @IBOutlet var navigationBarView: UIView?
    @IBOutlet var searchViewContainer: UIViewX!
    @IBOutlet var txtSearch: UITextField!
    
    //Result and Sortby view
    @IBOutlet var lblResults: UILabel!
    @IBOutlet var viewSortBy: UIView!
    
    @IBOutlet var lblOrderBy: UILabel!
    @IBOutlet var lblSortByName: UILabel!
    @IBOutlet var btnArrow: UIButton!
    @IBOutlet var txtSortBy: DropDown!
    
    @IBOutlet var mainTableView: UITableView? {
        didSet {
            self.mainTableView?.register(UINib(nibName: "ProductTVCell", bundle: nil), forCellReuseIdentifier: "ProductTVCell")
        }
    }
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var strCategoryID: String!
    var strSearchText: String!
    
    var pageNumber = 1
    
    var arrSortByIds = [0,1,2]
    var arrSortByNames = ["Populares","Menor Preço","Maior Preço"]
    
    var datarows = [ObjStoreProduct]()
    
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
                selector: #selector(self.user_GetProductsBySearchEvent),
                name: Notification.Name("user_GetProductsBySearchEvent"),
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
            
            self.lblResults.text = "\(dataManager.strProductCounts) resultados"
            
            self.mainTableView?.isHidden = false
            
            self.datarows = dataManager.arrayAllStoreProducts
            
            self.mainTableView?.reloadData()
            
        })
    }
    
    @objc func user_GetProductsBySearchEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarows = dataManager.arrayProductsBySearch
            
            self.lblResults.text = "\(dataManager.strProductCounts) resultados"
            
            self.mainTableView?.isHidden = false
            
            self.datarows = dataManager.arrayProductsBySearch
            
            self.mainTableView?.reloadData()
            
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
        
        txtSearch?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        txtSearch?.delegate = self
        txtSearch?.backgroundColor = .clear
        txtSearch?.tintColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtSearch?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("search_here", value: "Digite o que está buscando", comment: ""),
                                                                attributes: [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().textfieldPlaceholderColor!])
        
        
        txtSearch?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        txtSearch?.textAlignment = .left
        txtSearch?.autocorrectionType = UITextAutocorrectionType.no
        txtSearch?.clearButtonMode = .whileEditing
        txtSearch?.returnKeyType = .search
        
        // Setup Dropdown
        self.setupDropDown()
        
        //API CALL
        txtSearch.text = strSearchText
        pageNumber = 1
        dataManager.user_GetAllStoreProducts(
            strCategoryID: strCategoryID,
            strOrderBy: "Populares",
            strPageNumber: "1")
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDropDownTapped(_ sender: Any) {
        
    }
    
    //MARK:- Functions
    func setupDropDown() {
        
        self.txtSortBy?.optionArray = self.arrSortByNames
        self.txtSortBy?.optionIds = self.arrSortByIds
        self.txtSortBy?.selectedRowColor = (MySingleton.sharedManager().themeGlobalLightGreenColor?.withAlphaComponent(0.5))!
        self.txtSortBy?.selectedIndex = 0
        self.txtSortBy?.text = self.arrSortByNames[0]
        
        //self.txtSortBy?.listHeight =  (self.view?.frame.size.height)! / 3
        
        self.txtSortBy?.didSelect{(selectedText , index ,id) in
            
            //Perform Action
            if index == 0 {
                self.pageNumber = 1
                if (self.strCategoryID == "")
                {
                    dataManager.user_GetProductsBySearch(
                        strStoreID: "",
                        strSearchText: self.txtSearch.text!,
                        strOrderBy: "Populares",
                        strPageNumber: "1")
                }
                else
                {
                    dataManager.user_GetAllStoreProducts(
                        strCategoryID: self.strCategoryID,
                        strOrderBy: "Populares",
                        strPageNumber: "1")
                }
            }
            else if index == 1 {
                self.pageNumber = 1
                if (self.strCategoryID == "")
                {
                    dataManager.user_GetProductsBySearch(
                        strStoreID: "",
                        strSearchText: self.txtSearch.text!,
                        strOrderBy: "price_lowest",
                        strPageNumber: "1")
                }
                else
                {
                    dataManager.user_GetAllStoreProducts(
                        strCategoryID: self.strCategoryID,
                        strOrderBy: "price_lowest",
                        strPageNumber: "1")
                }
            }
            else {
                self.pageNumber = 1
                if (self.strCategoryID == "")
                {
                    dataManager.user_GetProductsBySearch(
                        strStoreID: "",
                        strSearchText: self.txtSearch.text!,
                        strOrderBy: "price_highest",
                        strPageNumber: "1")
                }
                else
                {
                    dataManager.user_GetAllStoreProducts(
                        strCategoryID: self.strCategoryID,
                        strOrderBy: "price_highest",
                        strPageNumber: "1")
                }
            }
        }
        
    }

}

//MARK:- Textfield Delegates
extension ProductListVC {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField == txtSearch)
        {
            if ((txtSearch?.text!.count)! <= 0)
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("error_required", value:"Campo obrigatório!", comment: ""))
            }
            else
            {
                pageNumber = 1
                strCategoryID = ""
                
                var strShorting: String!
                if (txtSortBy.selectedIndex == 0)
                {
                    strShorting = "Populares"
                }
                else if (txtSortBy.selectedIndex == 1)
                {
                    strShorting = "price_lowest"
                }
                else
                {
                    strShorting = "price_highest"
                }
                
                dataManager.user_GetProductsBySearch(
                    strStoreID: "",
                    strSearchText: txtSearch.text!,
                    strOrderBy: strShorting,
                    strPageNumber: "1")
            }
        }
        
        return true
    }
    
}

//MARK:- Tableview Methods
extension ProductListVC {
    
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
        
        //cell.lblPricePoints.text = "R$ \(strMoney.replacingOccurrences(of: ".", with: ","))"
        
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
                
                var strShorting: String!
                if (txtSortBy.selectedIndex == 0)
                {
                    strShorting = "Populares"
                }
                else if (txtSortBy.selectedIndex == 1)
                {
                    strShorting = "price_lowest"
                }
                else
                {
                    strShorting = "price_highest"
                }
                
                if (strCategoryID == "")
                {
                    dataManager.user_GetProductsBySearch(
                        strStoreID: "",
                        strSearchText: txtSearch.text!,
                        strOrderBy: strShorting,
                        strPageNumber: "\(pageNumber)")
                }
                else
                {
                    dataManager.user_GetAllStoreProducts(
                        strCategoryID: strCategoryID,
                        strOrderBy: strShorting,
                        strPageNumber: "\(pageNumber)")
                }
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
