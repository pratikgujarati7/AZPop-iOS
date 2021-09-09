//
//  ProductsVC.swift
//  AgendaZap
//
//  Created by Dipen on 11/12/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RealmSwift
import iOSDropDown
import NYAlertViewController

class ProductsVC: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    @IBOutlet var btnCreateContainerView: UIViewX!
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var viewSortBy: UIView!
    
    //Result and Sortby view
    @IBOutlet var orderByContainerView: UIView!
    @IBOutlet var lblOrderBy: UILabel!
    @IBOutlet var lblSortByName: UILabel!
    @IBOutlet var btnArrow: UIButton!
    @IBOutlet var txtSortBy: DropDown!
    
    @IBOutlet var tblHighlightedProducts: UITableView! {
        didSet {
            self.tblHighlightedProducts.register(UINib(nibName: "ProductTVCell", bundle: nil), forCellReuseIdentifier: "ProductTVCell" )
        }
    }
    
    @IBOutlet var collCategories: UICollectionView! {
        didSet {
            self.collCategories.register(UINib(nibName: "SubCategoryCVCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCVCell")
        }
    }
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var arrStoresProducts = [ObjStoreProduct]()
    
    var arrCategoriesImages = [
                                "ic_sub_6",
                                "ic_sub_311",
                                "ic_sub_43",
                                "ic_sub_59",
                                "ic_sub_68",
                                "ic_sub_83",
                                "ic_sub_112",
                                "ic_sub_46",
                                "ic_sub_129",
                                "ic_sub_175",
                                "ic_sub_170",
                                "ic_sub_197",
                                "ic_sub_292",
                                "ic_sub_368",
                                "ic_sub_369"
                                ]
    
    var pageNumber = 1
    
    var arrSortByIds = [0,1,2]
    var arrSortByNames = ["Populares","Menor Preço","Maior Preço"]
    
    var intSelectedCategoryID: Int = 0
    var strSelectedSegment: String = "recent"
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var arrayIDs: Array<Int> = []
        var arrayValuess: Array<String> = []
        
        arrayIDs.append(0)
        arrayValuess.append("Filtrar por categoria")
        
        for objTemp in dataManager.arrayAllCategoriesForProducts
        {
            arrayIDs.append(objTemp.intCategoryID)
            arrayValuess.append(objTemp.strCategoryName)
        }
        arrSortByIds = arrayIDs
        arrSortByNames = arrayValuess
        
        self.setupNotificationEvent()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //API CALL
        dataManager.user_GetAllMyStores()
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
                selector: #selector(self.user_GetAllStoreProductsEvent),
                name: Notification.Name("user_GetAllStoreProductsEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetHotPromotionDetailsEvent),
                name: Notification.Name("user_GetHotPromotionDetailsEvent"),
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
            
            self.arrStoresProducts = dataManager.arrayAllStoreProducts
            
            self.tblHighlightedProducts?.isHidden = false
            self.tblHighlightedProducts?.reloadData()
        })
    }
    
    @objc func user_GetHotPromotionDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.arrStoresProducts = dataManager.arrayAllStoreProducts
            
            self.tblHighlightedProducts?.isHidden = false
            self.tblHighlightedProducts?.reloadData()
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnCreateTapped(_ sender: Any) {
                
        if (dataManager.arrayAllMyStores.count > 0)
        {
            if (dataManager.arrayAllMyStores[0].strIsStoreVisible == "1")
            {
                let viewController: AddProductVC = AddProductVC()
                viewController.boolIsOpenForEdit = false
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                let alertViewController = NYAlertViewController()
                
                // Set a title and message
                alertViewController.title = ""
                alertViewController.message = "Antes de criar uma promoção você precisa cadastrar o seu negócio no AZpop (gratuito)"
                
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
                let cancelAction = NYAlertAction(
                    title: "Cadastrar",
                    style: .cancel,
                    handler: { (action: NYAlertAction!) -> Void in
                        
                        let viewController: RegisterStoreVC = RegisterStoreVC()
                        viewController.objSelectedStore = dataManager.arrayAllMyStores[0]
                        self.navigationController?.pushViewController(viewController, animated: true)
                        
                        self.navigationController!.dismiss(animated: true, completion: nil)
                })
                
                let cancelOk = NYAlertAction(
                    title: "Não quero",
                    style: .cancel,
                    handler: { (action: NYAlertAction!) -> Void in
                        
                        self.navigationController!.dismiss(animated: true, completion: nil)
                })
                
                alertViewController.addAction(cancelAction)
                alertViewController.addAction(cancelOk)
                                    
                self.navigationController!.present(alertViewController, animated: true, completion: nil)
            }
        }
        
        
    }
    
    @IBAction func btnModeTapped(_ sender: Any) {
        
        let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
        if(strIsAuthorized != "1")
        {
            let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
            viewController.boolIsLoadedFromSplashScreen = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else
        {
            UserDefaults.standard.setValue("1", forKey: "is_show_vendor_mode")
            UserDefaults.standard.synchronize()
//            AppDelegate().Delegate().setVendorTabBarVC()
        }
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.strSelectedSegment = "recent"
        case 1:
            self.strSelectedSegment = "score_highest"
        default:
            break
        }
        
        //API CALL
        dataManager.user_GetAllStoreProducts(
            strCategoryID: "\(self.intSelectedCategoryID)",
            strOrderBy: self.strSelectedSegment,
            strPageNumber: "\(self.pageNumber)")
    }
    
    //MARK:- Functions
    func setupInitialView() {
            
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        self.tblHighlightedProducts.tableFooterView = UIView()
        
        self.tblHighlightedProducts.isHidden = false
        self.orderByContainerView.isHidden = false
        
        self.tblHighlightedProducts?.separatorStyle = .none
        //self.tblHighlightedPromotions?.tableFooterView = UIView()
        self.tblHighlightedProducts?.separatorColor = .clear
        
        self.collCategories.isHidden = true
        
        //API CALL Get all PRODUCTS
        pageNumber = 1
        dataManager.user_GetAllStoreProducts(
            strCategoryID: "\(self.intSelectedCategoryID)",
            strOrderBy: self.strSelectedSegment,
            strPageNumber: "\(self.pageNumber)")
        
        // Setup Dropdown
        self.setupDropDown()
        
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
            
            self.pageNumber = 1
            self.intSelectedCategoryID = id
            //Perform Action
            dataManager.user_GetAllStoreProducts(
                strCategoryID: "\(self.intSelectedCategoryID)",
                strOrderBy: self.strSelectedSegment,
                strPageNumber: "\(self.pageNumber)")
            
            //self.txtFilterClicked(self.txtFilter!)
            self.tblHighlightedProducts?.reloadData()
        }
        
    }
}

//MARK:- TableView Methods
extension ProductsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrStoresProducts.count > 0 ? self.arrStoresProducts.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objProduct = self.arrStoresProducts[indexPath.row]
        
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
                dataManager.user_GetAllStoreProducts(
                    strCategoryID: "\(self.intSelectedCategoryID)",
                    strOrderBy: self.strSelectedSegment,
                    strPageNumber: "\(self.pageNumber)")
                
//                if txtSortBy.selectedIndex == 0 {
//
//                    dataManager.user_GetAllStoreProducts(
//                        strCategoryID: "",
//                        strOrderBy: "Populares",
//                        strPageNumber: "\(pageNumber)")
//
//                } else if txtSortBy.selectedIndex == 1 {
//
//                    dataManager.user_GetAllStoreProducts(
//                        strCategoryID: "",
//                        strOrderBy: "price_lowest",
//                        strPageNumber: "\(pageNumber)")
//
//                } else {
//
//                    dataManager.user_GetAllStoreProducts(
//                        strCategoryID: "",
//                        strOrderBy: "price_highest",
//                        strPageNumber: "\(pageNumber)")
//                }
            }
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objProduct = self.arrStoresProducts[indexPath.row]
        
        let viewController = ProductDetailsVC()
        viewController.strSelectedStoreProductID = objProduct.strID
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }
}

//MARK:- Collection View Methods
extension ProductsVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.arrayAllCategoriesForProducts.count > 0 ? dataManager.arrayAllCategoriesForProducts.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let mainCatObj = dataManager.arrayAllCategoriesForProducts[indexPath.item]
                
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCVCell", for: indexPath) as! SubCategoryCVCell
                
        if (arrCategoriesImages.count >= mainCatObj.intCategoryID)
        {
            cell.imgSubCategory.image = UIImage(named: arrCategoriesImages[(mainCatObj.intCategoryID - 1)])
        }
        cell.lblSubCatName.text = mainCatObj.strCategoryName
        cell.lblSubCatName.textAlignment = .center
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width/3.9), height: ((collectionView.frame.size.width)/3.9) + 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let mainCatObj = dataManager.arrayAllCategoriesForProducts[indexPath.item]
        
        let viewController: ProductListVC = ProductListVC()
        viewController.strCategoryID = mainCatObj.strCategoryID
        viewController.strSearchText = mainCatObj.strCategoryName
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }
    
}
