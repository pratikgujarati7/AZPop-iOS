//
//  NeedAddressVC.swift
//  AgendaZap
//
//  Created by Dipen on 21/12/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import iOSDropDown
import IQKeyboardManagerSwift

class NeedAddressVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtPhoneNumber: UITextField!
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var addressDetailsContainerView: UIView!
    @IBOutlet var nslcAddressDetailsContainerViewHeight: NSLayoutConstraint!
    @IBOutlet var txtZipCode: UITextField!
    @IBOutlet var dropdownCity: DropDown!
    @IBOutlet var txtRua: UITextField!
    @IBOutlet var txtNumero: UITextField!
    
    @IBOutlet var txtObesrvation: UITextField!
    
    //AZPOPPOPINTS
    @IBOutlet var imageViewPontosAZpop: UIImageView!
    @IBOutlet var lblPontosAZpop: UILabel!
    @IBOutlet var btnPontosAZpop: UIButton!
    //DINHEIRO
    @IBOutlet var imageViewDinheiro: UIImageView!
    @IBOutlet var lblDinheiro: UILabel!
    @IBOutlet var btnDinheiro: UIButton!
    //CREDIT
    @IBOutlet var imageViewCredit: UIImageView!
    @IBOutlet var lblCredit: UILabel!
    @IBOutlet var btnCredit: UIButton!
    //DEBIT
    @IBOutlet var imageViewDebit: UIImageView!
    @IBOutlet var lblDebit: UILabel!
    @IBOutlet var btnDebit: UIButton!
    //BOLETO
    @IBOutlet var imageViewBoleto: UIImageView!
    @IBOutlet var lblBoleto: UILabel!
    @IBOutlet var btnBoleto: UIButton!
    
    @IBOutlet var lblPaymentOptionWarning: UILabel!
    @IBOutlet var btnFinalizar: UIButton!
    
    //SUCCESS
    @IBOutlet var successContainerView: UIView!
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var boolIsAddressNeeded: Bool!
    var boolIsOpenedFromCart: Bool!
    var strID: String!
    var strStoreID: String!
    var strMoneyTotal: String!
    var strPointTotal: String!
    
    var intSelectedIndex: Int? = nil

    //CITy
    var dataRowsCityIDs = [Int]()
    var dataRowsCityNames = [String]()
    var intSelectedCityID: Int?
    var strSelectedCityName: String?
    
    //DETAILS
    var objStoreDetails: ObjStoreDetails?
    //dataManager.objSelectedStoreProduct
    //dataManager.arrayAllStoreCartProducts
    
    // MARK: - UIViewController Delegate Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.user_GetAllCountries()
        
        self.setupNotificationEvent()
        self.setUpNavigationBar()
        self.setupInitialView()
        
        lblPaymentOptionWarning.isHidden = true
        
        if (boolIsAddressNeeded == false)
        {
            nslcAddressDetailsContainerViewHeight.constant = 0
            addressDetailsContainerView.isHidden = true
        }
        
        let intMyPoints = Int(dataManager.strPoints) ?? 0
        let intCartPoints = Int(strPointTotal) ?? 0
        
        if (intMyPoints < intCartPoints)
        {
            imageViewPontosAZpop.alpha = 0.5
            lblPontosAZpop.alpha = 0.5
            btnPontosAZpop.isUserInteractionEnabled = false
        }
        
        let strFirstName = "\(UserDefaults.standard.value(forKey: "first_name") ?? "")"
        let strLastName = "\(UserDefaults.standard.value(forKey: "last_name") ?? "")"
        let strName = (strFirstName.lowercased() == "<null>" ? "" : strFirstName) + " " + (strLastName.lowercased() == "<null>" ? "" : strLastName)
        let strPhoneNumber = "\(UserDefaults.standard.value(forKey: "phone_number") ?? "")"
        let strEmail = "\(UserDefaults.standard.value(forKey: "email") ?? "")"
        
        txtName.text = strName.lowercased() == "<null>" ? "" : strName
        txtPhoneNumber.text = strPhoneNumber.lowercased() == "<null>" ? "" : strPhoneNumber
        txtEmail.text = strEmail.lowercased() == "<null>" ? "" : strEmail
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
    
    //MARK:- Setup Notification Methods
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
                selector: #selector(self.user_makeProductOrderEvent),
                name: Notification.Name("user_makeProductOrderEvent"),
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
            self.dataRowsCityIDs = dataManager.arrayCityIDs
            self.dataRowsCityNames = dataManager.arrayCityNames
            
            self.dropdownCity?.optionArray = self.dataRowsCityNames
            self.dropdownCity?.optionIds = self.dataRowsCityIDs
            self.dropdownCity?.handleKeyboard = false
            self.dropdownCity?.isSearchEnable = false
            self.dropdownCity?.hideOptionsWhenSelect = true
            self.dropdownCity?.checkMarkEnabled = false
            self.dropdownCity?.selectedRowColor = (MySingleton.sharedManager().themeGlobalLightGreenColor?.withAlphaComponent(0.5))!
            
            self.dropdownCity?.listHeight =  (self.view?.frame.size.height)! / 3
            
            self.dropdownCity?.didSelect{(selectedText , index ,id) in
                
                self.intSelectedCityID = id
                self.strSelectedCityName = selectedText
            }
            
            let strSelectedCity = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            
            for index in 0...(dataManager.arrayCityIDs.count - 1)
            {
                if ("\(dataManager.arrayCityIDs[index])" == strSelectedCity)
                {
                    self.dropdownCity?.selectedIndex = index
                    self.intSelectedCityID = dataManager.arrayCityIDs[index]
                    self.strSelectedCityName = dataManager.arrayCityNames[index]
                    self.dropdownCity?.text = self.strSelectedCityName
                }
            }
            
        })
    }
    
    @objc func user_makeProductOrderEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.lblNavigationTitle.text = "Pedido feito com sucesso!"
            self.successContainerView.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                
                //dataManager.arrayAllStoreCartProducts
                //dataManager.objSelectedStoreProduct
                
                var strSendNumber: String = ""
                if (self.boolIsOpenedFromCart)
                {
                    strSendNumber = dataManager.arrayAllStoreCartProducts[0].strPhoneNumber
                }
                else
                {
                    strSendNumber = dataManager.objSelectedStoreProduct.strPhoneNumber
                }
                
                var originalString = "https://wa.me/55\(strSendNumber)?text=*---Pedido AZpop---*"
                
                if (self.boolIsOpenedFromCart)
                {
                    for objIndex in dataManager.arrayAllStoreCartProducts
                    {
                        originalString = "\(originalString)\n*Produto:* \(objIndex.strTitle)\n*Preço:* \(objIndex.strMoneyPrice)"
                    }
                }
                else
                {
                    originalString = "\(originalString)\n*Produto:* \(dataManager.objSelectedStoreProduct.strTitle)\n*Preço:* \(dataManager.objSelectedStoreProduct.strMoneyPrice)"
                }
                
                var strPaymentType: String = ""
                if self.intSelectedIndex == 1 {
                    strPaymentType = "Pontos AZpop"
                }
                else if self.intSelectedIndex == 2 {
                    strPaymentType = "Dinheiro"
                }
                else if self.intSelectedIndex == 3 {
                    strPaymentType = "Cartão de Crédito"
                }
                else if self.intSelectedIndex == 4 {
                    strPaymentType = "Cartão de Débito"
                }
                else {
                    strPaymentType = "Boleto"
                }
                
                originalString = "\(originalString)\n*Método de Pgto.:* \(strPaymentType)\n*-----------------------------------------*\n*TOTAL:* R$ \((self.strMoneyTotal ?? "0").replacingOccurrences(of: ".", with: ","))\n\n*Cliente:* \((self.txtName.text)!)\n*WhatsApp:* \((self.txtPhoneNumber.text)!)\n*Observações:* \((self.txtObesrvation.text)!)"
                if (self.boolIsAddressNeeded)
                {
                    originalString = "\(originalString)\n*Cidade:* \((self.dropdownCity.text)!)\n*Endereço:* \((self.txtRua.text)!), \((self.txtNumero.text)!)\n*CEP:* \((self.txtZipCode.text)!)"
                }
                
                let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

                guard let url = URL(string: escapedString!) else {
                  return //be safe
                }

                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
            
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnRadioTapped(_ sender: UIButton) {
        
        imageViewPontosAZpop.image = UIImage(named: "checkbox_normal.png")
        imageViewDinheiro.image = UIImage(named: "checkbox_normal.png")
        imageViewCredit.image = UIImage(named: "checkbox_normal.png")
        imageViewDebit.image = UIImage(named: "checkbox_normal.png")
        imageViewBoleto.image = UIImage(named: "checkbox_normal.png")
        
        if (sender == btnPontosAZpop)
        {
            intSelectedIndex = 1
            imageViewPontosAZpop.image = UIImage(named: "checkbox_selected_black.png")
            lblPaymentOptionWarning.isHidden = true
        }
        else if (sender == btnDinheiro)
        {
            intSelectedIndex = 2
            imageViewDinheiro.image = UIImage(named: "checkbox_selected_black.png")
            lblPaymentOptionWarning.isHidden = false
        }
        else if (sender == btnCredit)
        {
            intSelectedIndex = 3
            imageViewCredit.image = UIImage(named: "checkbox_selected_black.png")
            lblPaymentOptionWarning.isHidden = false
        }
        else if (sender == btnDebit)
        {
            intSelectedIndex = 4
            imageViewDebit.image = UIImage(named: "checkbox_selected_black.png")
            lblPaymentOptionWarning.isHidden = false
        }
        else
        {
            intSelectedIndex = 5
            imageViewBoleto.image = UIImage(named: "checkbox_selected_black.png")
            lblPaymentOptionWarning.isHidden = false
        }
    }
    
    @IBAction func btnFinalizarTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        guard self.isValidatedAllFields() else { return }
        
        //API Call
//        dataManager.user_makeProductOrder(
//            strStoreID: strStoreID,
//            strCheckoutType: boolIsOpenedFromCart ? "cart" : "product",
//            strID: strID,
//            strMoneySpent: strMoneyTotal,
//            strPointsSpent: strPointTotal,
//            strName: txtName.text!,
//            strPhoneNumber: txtPhoneNumber.text!,
//            strEmail: txtEmail.text!,
//            strZipcode: txtZipCode.text!,
//            strCityID: "\(intSelectedCityID ?? 0)",
//            strRua: txtRua.text!,
//            strNumber: txtNumero.text!,
//            strObservation: txtObesrvation.text!,
//            strPaymentMethod: "\(intSelectedIndex ?? 0)")
    }
    
    @IBAction func btnViewMyPointsTapped(_ sender: Any) {
        
//        appDelegate?.openTabBarVCScreenPoints()
        
    }
    
    @IBAction func btnViewMoreProductsTapped(_ sender: Any) {
        
        //appDelegate?.setTabBarVC()
//        appDelegate?.openTabBarVCScreenProducts()
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        viewNavigation?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        //navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        //navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        //navigationTitle?.text = ""
        
        if boolIsAddressNeeded
        {
            lblNavigationTitle.text = "Confirme seus dados"
        }
        else
        {
            lblNavigationTitle.text = "Ordem de Compra"
        }
        
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    func isValidatedAllFields() -> Bool {
        
        self.view.endEditing(true)
        
        if self.txtName.text!.isEmpty {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Preencha todos os campos acima.")
            return false
        }
        else if self.txtPhoneNumber.text!.isEmpty {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Preencha todos os campos acima.")
            return false
        }
        else if self.txtEmail.text!.isEmpty {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Preencha todos os campos acima.")
            return false
        }
        else if boolIsAddressNeeded && self.txtZipCode.text!.isEmpty {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Preencha todos os campos acima.")
            return false
        }
        else if boolIsAddressNeeded && self.intSelectedCityID == nil {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Preencha todos os campos acima.")
            return false
        }
        else if boolIsAddressNeeded && self.txtRua.text!.isEmpty {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Preencha todos os campos acima.")
            return false
        }
        else if boolIsAddressNeeded && self.txtNumero.text!.isEmpty {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Preencha todos os campos acima.")
            return false
        }
        else if intSelectedIndex == nil {
            appDelegate?.showAlertViewWithTitle(title: "", detail: "Preencha todos os campos acima.")
            return false
        }
        
        return true
    }

}
