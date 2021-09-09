//
//  CartVC.swift
//  AgendaZap
//
//  Created by Dipen on 18/12/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CartVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var tblCartItems: UITableView! {
        didSet {
            self.tblCartItems.register(UINib(nibName: "CartTVCell", bundle: nil), forCellReuseIdentifier: "CartTVCell" )
        }
    }
    
    @IBOutlet var lblNoDataFound: UIView!
    
    @IBOutlet var viewCartTotal: UIView!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var btnBuyNow: UIButton!
    @IBOutlet var btnViewProducts: UIButton!
    
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false

    var datarows = [ObjCartItem]()
    var strStoreID : String!
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
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
        
        self.lblTotal.text = "Total = R$ \(dataManager.strTotalMoney.replacingOccurrences(of: ".", with: ",")) ou \(dataManager.strTotalPoints) pontos"
        self.tblCartItems.reloadData()
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
                selector: #selector(self.user_changeCartProductQuantityEvent),
                name: Notification.Name("user_changeCartProductQuantityEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_removeCartProductEvent),
                name: Notification.Name("user_removeCartProductEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_verifyCartEvent),
                name: Notification.Name("user_verifyCartEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_changeCartProductQuantityEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarows = dataManager.arrayAllStoreCartProducts
            self.lblTotal.text = "Total = R$ \(dataManager.strTotalMoney) ou \(dataManager.strTotalPoints) pontos"
            self.tblCartItems.reloadData()
            
        })
    }
    
    @objc func user_removeCartProductEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.lblTotal.text = "Total = R$ \(dataManager.strTotalMoney) ou \(dataManager.strTotalPoints) pontos"
            self.tblCartItems.reloadData()
            
        })
    }
    
    @objc func user_verifyCartEvent()
    {
        DispatchQueue.main.async(execute: {
            
            let viewController: NeedAddressVC = NeedAddressVC()
            viewController.strStoreID = self.datarows[0].strStoreID
            viewController.boolIsAddressNeeded = dataManager.strNeedAddress == "1" ? true : false
            viewController.boolIsOpenedFromCart = true
            viewController.strID = self.datarows[0].strID
            viewController.strMoneyTotal = dataManager.strTotalMoney
            viewController.strPointTotal = dataManager.strTotalPoints
            self.navigationController?.pushViewController(viewController, animated: true)
            
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBuyNowTapped(_ sender: Any) {
        
        //VERIFY CART
        if (datarows.count > 0)
        {
            dataManager.user_verifyCart(strStoreID: datarows[0].strStoreID, strOrderID: datarows[0].strID)
        }
    }
    
    @IBAction func btnViewProductsTapped(_ sender: Any) {
        
        let viewController: ProductListByStoreVC = ProductListByStoreVC()
        viewController.strStoreID = self.strStoreID
        self.navigationController?.pushViewController(viewController, animated: false)
        
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
        
        lblTotal?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblTotal?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        btnBuyNow?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnBuyNow?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnBuyNow?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnBuyNow?.clipsToBounds = true
        btnBuyNow?.layer.cornerRadius = 5
        
        btnViewProducts?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnViewProducts?.backgroundColor = MySingleton.sharedManager().themeGlobalBlackColor
        btnViewProducts?.setTitleColor( MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnViewProducts?.clipsToBounds = true
        btnViewProducts?.layer.cornerRadius = 5
    }

}

//MARK:- Tableview Methods
extension CartVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.datarows.count == 0 {
            self.tblCartItems!.showNoDataLabel("ops,Seu carrinho está vazio, adicione o item.", isScrollable: true)
            self.viewCartTotal.isHidden = true
            return 0
        }
        else {
            self.tblCartItems!.removeNoDataLabel()
            self.viewCartTotal.isHidden = false
            return self.datarows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let objIndex = self.datarows[indexPath.row]
        let intQuantity: Int = Int(objIndex.strQuantity) ?? 0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTVCell") as! CartTVCell
        
        cell.lblProductName.text = objIndex.strTitle
        //cell.lblProductPrice.text = "R$ \(objIndex.strMoneyPrice) ou \(objIndex.strPointPrice) Pontos"
        
        let strMoney: String = String(format: "%.02f", Float(objIndex.strMoneyPrice.replacingOccurrences(of: ",", with: ".")) ?? 0)
        cell.lblProductPrice.text = "R$ \(strMoney.replacingOccurrences(of: ".", with: ",")) ou \(objIndex.strPointPrice) Pontos"
        
        cell.lblQuantity.text = "\(intQuantity)"
        
        cell.btnDeleteClick = {(_ aCell: CartTVCell) -> Void in
            
            //API CALL REMOVE ITEM FROM CART
            dataManager.user_removeCartProduct(
                strOrderID: objIndex.strID,
                strOrderItemID: objIndex.strOrderItemID)
            self.datarows.remove(at: indexPath.row)
        }
        
        cell.btnMinusClick = {(_ aCell: CartTVCell) -> Void in
            
            if intQuantity > 1
            {
                //API CALL UPDATE QUANTITY
                dataManager.user_changeCartProductQuantity(
                    strOrderID: objIndex.strID,
                    strOrderItemID: objIndex.strOrderItemID,
                    strProductID: objIndex.strProductID,
                    strQuantity: "\(intQuantity - 1)")
                objIndex.strQuantity = "\(intQuantity - 1)"
            }
            else
            {
                //API CALL REMOVE ITEM FROM CART
                dataManager.user_removeCartProduct(
                    strOrderID: objIndex.strID,
                    strOrderItemID: objIndex.strOrderItemID)
                self.datarows.remove(at: indexPath.row)
            }
            
        }
        
        cell.btnPlusClick = {(_ aCell: CartTVCell) -> Void in
            
            //API CALL UPDATE QUANTITY
            dataManager.user_changeCartProductQuantity(
                strOrderID: objIndex.strID,
                strOrderItemID: objIndex.strOrderItemID,
                strProductID: objIndex.strProductID,
                strQuantity: "\(intQuantity + 1)")
            objIndex.strQuantity = "\(intQuantity + 1)"
            
        }
        
        return cell
    }
}
