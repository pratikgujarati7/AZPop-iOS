//
//  MyStoreProductListVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 05/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController

class MyStoreProductListVC: UIViewController, UIGestureRecognizerDelegate, UIActionSheetDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var mainTableView: UITableView! {
        didSet {
            self.mainTableView.register(UINib(nibName: "MyProductTVCell", bundle: nil), forCellReuseIdentifier: "MyProductTVCell")
        }
    }
    
    @IBOutlet var viewHeaderContainer: UIView!
    @IBOutlet var lblItemCount: UILabel!
    @IBOutlet var lblAddProduct: UILabel!
    @IBOutlet var btnAddProduct: UIButton!
    
    @IBOutlet var btnVisualizar: UIButton!
    
    //POPUP
    @IBOutlet var viewPopupContainer: UIView!
    @IBOutlet var viewPopupInnerContainer: UIView!
    @IBOutlet var btnViewOnWeb: UIButton!
    @IBOutlet var btnViewOnApp: UIButton!
    
    var pageNumber = 1
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var datarows = [ObjStoreProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        //API CALL
        dataManager.user_GetStoreDetails(strStoreID: strSelectedStoreID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        //API CALL
        pageNumber = 1
        dataManager.user_GetAllStoreProductsForStore(strStoreID: strSelectedStoreID, strPageNumber: "\(pageNumber)")
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
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetStoreDetailsEvent),
                name: Notification.Name("user_GetStoreDetailsEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_ActivateDeActivateStoreProductEvent),
                name: Notification.Name("user_ActivateDeActivateStoreProductEvent"),
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
            self.lblItemCount.text = "\(dataManager.strProductCounts) Items"
            self.mainTableView.reloadData()
            
        })
    }
    
    @objc func user_GetStoreDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
          
            
            
        })
    }
    
    @objc func user_ActivateDeActivateStoreProductEvent()
    {
        DispatchQueue.main.async(execute: {
          
            self.pageNumber = 1
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            //API CALL
            dataManager.user_GetAllStoreProductsForStore(strStoreID: strSelectedStoreID, strPageNumber: "\(self.pageNumber)")
            
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnShareTapped(_ sender: Any) {
        let originalString = "https://wa.me/?text=*\(dataManager.objSelectedStoreDetails.strName)*\n*WhatsApp:* \(dataManager.objSelectedStoreDetails.strPhoneNumber)\n*Email:* \(dataManager.objSelectedStoreDetails.strEmail)\n*Website:* \(ServerIPForWebsite)\(dataManager.objSelectedStoreDetails.strSlug)\(dataManager.objSelectedStoreDetails.strFacebookLink != "" ? "\n*Facebook:* https://www.facebook.com/\(dataManager.objSelectedStoreDetails.strFacebookLink)" : "")\(dataManager.objSelectedStoreDetails.strInstagramLink != "" ? "\n*Instagram:* \(dataManager.objSelectedStoreDetails.strInstagramLink)" : "")\n\nDados do meu negócio ☝️"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: escapedString!) else {
          return //be safe
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func btnAddProductTapped(_ sender: Any) {
        
        let viewController: AddProductVC = AddProductVC()
        viewController.boolIsOpenForEdit = false
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnVisualizarTapped(_ sender: Any) {
        
        self.view.addSubview(viewPopupContainer)
        
    }
    
    @IBAction func btnVisualizarOnWebTapped(_ sender: Any) {
        
        viewPopupContainer.removeFromSuperview()
        
        //WEBSITE
        let strWebsiteURL = ServerIPForWebsite + dataManager.objSelectedStoreDetails.strSlug
        guard let url = URL(string: strWebsiteURL) else { return }
        UIApplication.shared.open(url)
        
    }
    
    @IBAction func btnVisualizarOnAppTapped(_ sender: Any) {
        
        
        viewPopupContainer.removeFromSuperview()
        
        let viewController: User_StoreDetailsViewController = User_StoreDetailsViewController()
        viewController.strSelectedStoreID = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        self.navigationController?.pushViewController(viewController, animated: false)
        
        
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        viewNavigation?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        //navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        //navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        let strSelectedStoreName: String = "\(UserDefaults.standard.value(forKey: "selected_store_name") ?? "")"
        lblNavigationTitle?.text = "Produtos / Serviços"//"Produtos - \(strSelectedStoreName)"
        
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        viewPopupContainer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        viewPopupContainer.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewPopupContainer.addGestureRecognizer(tap)
        
        btnViewOnWeb.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnViewOnWeb.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnViewOnWeb.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnViewOnWeb.clipsToBounds = true
        btnViewOnWeb.layer.cornerRadius = 5
        
        btnViewOnApp.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnViewOnApp.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnViewOnApp.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnViewOnApp.clipsToBounds = true
        btnViewOnApp.layer.cornerRadius = 5
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        viewPopupContainer.removeFromSuperview()
    }
}

//MARK:- TableView Methods
extension MyStoreProductListVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return viewHeaderContainer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return datarows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.register(UINib(nibName: "MyProductTVCell", bundle: nil), forCellReuseIdentifier: "MyProductTVCell\(indexPath.row)")
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:MyProductTVCell! = tableView.dequeueReusableCell(withIdentifier: "MyProductTVCell\(indexPath.row)") as? MyProductTVCell
        
        if(cell == nil)
        {
            cell = MyProductTVCell(style: .default, reuseIdentifier: "MyProductTVCell\(indexPath.row)")
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
        
        if objIndex.strIsActive == "1"
        {
            cell.lblProductName.text = objIndex.strTitle
        }
        else
        {
            let nameAttribute = [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().themeGlobalBlackColor!] as [NSAttributedString.Key : Any]
            let inactiveAttribute = [NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().themeGlobalRed2Color!] as [NSAttributedString.Key : Any]
            
            let mainString = NSMutableAttributedString(string: "", attributes: nameAttribute)
            let str1 = NSAttributedString(string: "\(objIndex.strTitle)", attributes: nameAttribute)
            mainString.append(str1)
            let str2 = NSAttributedString(string: " (Inativo)", attributes: inactiveAttribute)
            mainString.append(str2)
            cell.lblProductName.attributedText = mainString
        }
        
        
        let floatValue: Float = Float(objIndex.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
        if (floatValue > 0)
        {
            let floatDiscountValue: Float = Float(objIndex.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
            if (floatDiscountValue > 0)
            {
                let strDiscountValue: String = String(format: "%.02f", Float(objIndex.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                let strValue: String = String(format: "%.02f", Float(objIndex.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "R$ \(strValue)".replacingOccurrences(of: ".", with: ","))
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                let attributeString2: NSMutableAttributedString = NSMutableAttributedString(string: " R$ \(strDiscountValue)".replacingOccurrences(of: ".", with: ","))
                attributeString2.addAttribute(NSAttributedString.Key.foregroundColor, value: MySingleton.sharedManager().themeGlobalBlackColor!, range: NSMakeRange(0, attributeString2.length))
                attributeString.append(attributeString2)
                cell.lblProductPrice.attributedText = attributeString
            }
            else
            {
                let strValue: String = String(format: "%.02f", Float(objIndex.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                            
                cell.lblProductPrice.text = "R$ \(strValue)".replacingOccurrences(of: ".", with: ",")
            }
        }
        else
        {
            cell.lblProductPrice.text = "Preço sob consulta"//objIndex.strMoneyText
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
        
        cell.btnShareClick = {(_ aCell: MyProductTVCell) -> Void in
            
            var strPrice: String = ""
            let floatValue: Float = Float(objIndex.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
            if (floatValue > 0)
            {
                let floatDiscountValue: Float = Float(objIndex.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
                if (floatDiscountValue > 0)
                {
                    let strDiscountValue: String = String(format: "%.02f", Float(objIndex.strDiscountedPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                    let strValue: String = String(format: "%.02f", Float(objIndex.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                    
                    strPrice = "\n💲Preço normal: R$\(strValue)\n*💲Preço com desconto: R$\(strDiscountValue)*".replacingOccurrences(of: ".", with: ",")
                }
                else
                {
                    let strValue: String = String(format: "%.02f", Float(objIndex.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
                    
                    strPrice = "\n💲Preço normal: R$\(strValue)".replacingOccurrences(of: ".", with: ",")
                }
            }
            
            if (objIndex.strGift != "" && objIndex.strGift != "<null>")
            {
                strPrice = "\(strPrice)\n*Brinde:* \(objIndex.strGift)"
            }
            
            let originalString = "https://wa.me/?text=Verifique as informações do item 👇\n✅\(objIndex.strTitle)\(strPrice)\n\n📱Link para o pedido: \(ServerIPForWebsite)p/\(objIndex.strSlug)\n\n📱Meu WhatsApp: \(objIndex.strPhoneNumber)\n🌐Veja outros produtos em nosso site: \(ServerIPForWebsite)\(dataManager.objSelectedStoreDetails.strSlug)"
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            guard let url = URL(string: escapedString!) else {
              return //be safe
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: {_ in
                
            })
            
        }
                
        cell.btnOptionsClick = {(_ aCell: MyProductTVCell) -> Void in
            
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            
            let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                print("Cancel")
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            
            let editActionButton = UIAlertAction(title: "Editar", style: .default)
            { _ in
                print("Editar")
                self.navigationController?.dismiss(animated: true, completion: {
                    
                    let viewController: AddProductVC = AddProductVC()
                    viewController.boolIsOpenForEdit = true
                    viewController.objMyStoreProduct = objIndex
                    self.navigationController?.pushViewController(viewController, animated: true)
                    
                })
                
            }
            actionSheetControllerIOS8.addAction(editActionButton)
            
            if (objIndex.strIsActive == "1")
            {
                let deActivateActionButton = UIAlertAction(title: "Ativar", style: .default)
                { _ in
                    print("Inativo\(indexPath.row)")
                    self.navigationController?.dismiss(animated: true, completion: {
                        
                        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
                        //API CALL
                        dataManager.user_ActivateDeActivateStoreProduct(strStoreID: strSelectedStoreID, strProductID: objIndex.strID, strIncludeActive: "1")
                        
                    })
                }
                actionSheetControllerIOS8.addAction(deActivateActionButton)
            }
            else
            {
                let activateActionButton = UIAlertAction(title: "Desativar", style: .default)
                { _ in
                    print("Ativo\(indexPath.row)")
                    self.navigationController?.dismiss(animated: true, completion: {
                        
                        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
                        //API CALL
                        dataManager.user_ActivateDeActivateStoreProduct(strStoreID: strSelectedStoreID, strProductID: objIndex.strID, strIncludeActive: "0")
                        
                    })
                }
                actionSheetControllerIOS8.addAction(activateActionButton)
            }
            
            
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            
        }
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let objIndex: ObjStoreProduct = datarows[indexPath.row]
        
        let viewController: ProductDetailsVC = ProductDetailsVC()
        viewController.strSelectedStoreProductID = objIndex.strID
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
