//
//  SendQuotationVC.swift
//  AgendaZap
//
//  Created by Dipen on 12/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import iOSDropDown
import RealmSwift
import MessageUI

class SendQuotationVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var txtTitle: SATextField!
    @IBOutlet var lblTitleValidation: UILabel!
    @IBOutlet var txtClientName: SATextField!
    @IBOutlet var lblClientNameValidation: UILabel!
    @IBOutlet var txtDate: SATextField!
    @IBOutlet var lblDateValidation: UILabel!
    
    @IBOutlet var lblSelectProduct: UILabel!
    
    @IBOutlet var mainTableView: UITableView!
    @IBOutlet var nslcMainTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var totalContainerView: UIView!
    @IBOutlet var nslcTotalContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet var lblSubTotalTitle: UILabel!
    @IBOutlet var lblSubTotalValue: UILabel!
    
    @IBOutlet var lblQuantityTitleOne: UILabel!
    @IBOutlet var txtQuantity: DropDown!
    @IBOutlet var lblQuantityTitleTwo: UILabel!
    
    @IBOutlet var lblDiscountTitleOne: UILabel!
    @IBOutlet var txtDiscount: UITextField!
    @IBOutlet var lblDiscountTitleTwo: UILabel!
    @IBOutlet var lblDiscountValue: UILabel!
    
    @IBOutlet var lblTotalTitle: UILabel!
    @IBOutlet var lblTotalValue: UILabel!
    
    //PAYMENT METHOD
    @IBOutlet var lblPaymentMethod: UILabel!
    //CASH
    @IBOutlet var cashContainerView: UIView!
    @IBOutlet var imageViewCash: UIImageView!
    @IBOutlet var lblCash: UILabel!
    @IBOutlet var btnCash: UIButton!
    //CREDIT
    @IBOutlet var creditContainerView: UIView!
    @IBOutlet var imageViewCredit: UIImageView!
    @IBOutlet var lblCredit: UILabel!
    @IBOutlet var btnCredit: UIButton!
    //DEBIT
    @IBOutlet var debitContainerView: UIView!
    @IBOutlet var imageViewDebit: UIImageView!
    @IBOutlet var lblDebit: UILabel!
    @IBOutlet var btnDebit: UIButton!
    //CONTACT
    @IBOutlet var contactContainerView: UIView!
    @IBOutlet var imageViewContact: UIImageView!
    @IBOutlet var lblContact: UILabel!
    @IBOutlet var btnContact: UIButton!
    
    @IBOutlet var vwWhatsappOther: UIViewX!
    @IBOutlet var vwEmailDetail: UIViewX!
    
    
    //POPUP
    @IBOutlet var viewPopupContainer: UIView!
    @IBOutlet var viewPopupInnerContainer: UIView!
    @IBOutlet var txtMobileNumber: UITextField!
    @IBOutlet var btnSend: UIButton?
    
    //POPUP
    @IBOutlet var viewPopupLabourContainer: UIView!
    @IBOutlet var viewPopupLabourInnerContainer: UIView!
    @IBOutlet var txtLabourAmount: UITextField!
    @IBOutlet var btnSaveLabourAmount: UIButton?
    
    //ADD PRODUCT
    @IBOutlet var viewPopupAddProductContainer: UIView!
    @IBOutlet var viewPopupAddProductInnerContainer: UIView!
    @IBOutlet var txtAddProductName: UITextField!
    @IBOutlet var txtAddProductPrice: UITextField!
    @IBOutlet var btnSaveProduct: UIButton?
    
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var myDatePicker : UIDatePicker!
    let arrayQuantityIDs = [0,1,2,3,4,5,6,7,8,9,10,11]
    let arrayQuantityValues = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    var arrayPaymentOptions = [1,1,1,1]
    
    var dataRows = [ObjQuotationProduct]()
    
    var objSelectedStoreDetails: ObjStoreDetails!
    
    var isFromClientEdit: Bool!
    var strCustomerName: String!
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        lblTitleValidation.text = ""
        lblClientNameValidation.text = ""
        lblDateValidation.text = ""
        
        myDatePicker!.setDate(Date(), animated: false)
        handleDatePicker(myDatePicker)
        
        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        dataManager.user_GetStoreDetails(strStoreID: strSelectedStoreID)
        
        if isFromClientEdit {
            vwEmailDetail.isHidden = true
            vwWhatsappOther.isHidden = true
            txtClientName.text = strCustomerName
        }else{
            vwEmailDetail.isHidden = false
            vwWhatsappOther.isHidden = false
        }
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
        viewPopupLabourContainer.frame.size = self.view.frame.size
        viewPopupAddProductContainer.frame.size = self.view.frame.size
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
        
        let realm = try! Realm()

        self.dataRows = [ObjQuotationProduct]()
        
        for obj in realm.objects(ObjQuotationProduct.self)
        {
            self.dataRows.append(obj)
        }
        self.mainTableView?.isHidden = false
        self.mainTableView?.reloadData()
        self.calculateTotal()
        nslcMainTableViewHeight.constant = CGFloat(self.dataRows.count > 0 ? (80 * self.dataRows.count) : 0)
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
                selector: #selector(self.user_GetStoreDetailsEvent),
                name: Notification.Name("user_GetStoreDetailsEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetStoreDetailsEvent()
    {
        DispatchQueue.main.async(execute: {
          
            self.objSelectedStoreDetails = dataManager.objSelectedStoreDetails
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectProductTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        let viewController: SendQuotProductsViewController = SendQuotProductsViewController()
        viewController.datarowsSavedProducts = dataRows
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @IBAction func btnSelectLabourChargeTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        txtLabourAmount.text = ""
        self.view.addSubview(viewPopupLabourContainer)
    }
    
    @IBAction func btnAddNewProductTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        txtAddProductName.text = ""
        txtAddProductPrice.text = ""
        self.view.addSubview(viewPopupAddProductContainer)
    }
    
    @IBAction func btnCloseLabourChargeTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        viewPopupLabourContainer.removeFromSuperview()
    }
    
    @IBAction func btnSaveLabourChargeTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        //ADD LABOUR CHARGE
        if txtLabourAmount.text != ""
        {
            var txtValue: String = txtLabourAmount.text ?? "0,00"
            txtValue = txtValue.replacingOccurrences(of: ".", with: "")
            
            let objNew: ObjQuotationProduct = ObjQuotationProduct()
            objNew.strID = "0"
            objNew.strProductName = "Mão de Obra"
            objNew.strProductQuantity = "1"
            objNew.strProductPrice = txtValue
            
            let realm = try! Realm()
            try! realm.write({
                realm.add(objNew)
            })
            
            self.dataRows = [ObjQuotationProduct]()
            
            for obj in realm.objects(ObjQuotationProduct.self)
            {
                self.dataRows.append(obj)
            }
            self.mainTableView.reloadData()
            self.calculateTotal()
            self.nslcMainTableViewHeight.constant = CGFloat(self.dataRows.count > 0 ? (80 * self.dataRows.count) : 0)
            
            viewPopupLabourContainer.removeFromSuperview()
        }
        else
        {
            AppDelegate.showToast(message : "Enter amount", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
        }
    }
    
    @IBAction func btnCloseAddNewProductTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        viewPopupAddProductContainer.removeFromSuperview()
    }
    
    @IBAction func btnSaveNewProductTapped(_ sender: Any) {
        
        self.view.endEditing(true)
        //ADD NEW PRODUCT
        if (txtAddProductName.text == "" || txtAddProductPrice.text == "")
        {
            if (txtAddProductName.text == "")
            {
                AppDelegate.showToast(message : "Enter product name", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
            }
            else
            {
                AppDelegate.showToast(message : "Enter product price", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
            }
        }
        else
        {
            let objNew: ObjQuotationProduct = ObjQuotationProduct()
            objNew.strID = "0"
            objNew.strProductName = txtAddProductName.text ?? ""
            objNew.strProductQuantity = "1"
            objNew.strProductPrice = txtAddProductPrice.text ?? "0"
            
            let realm = try! Realm()
            try! realm.write({
                realm.add(objNew)
            })
            
            self.dataRows = [ObjQuotationProduct]()
            
            for obj in realm.objects(ObjQuotationProduct.self)
            {
                self.dataRows.append(obj)
            }
            self.mainTableView.reloadData()
            self.calculateTotal()
            self.nslcMainTableViewHeight.constant = CGFloat(self.dataRows.count > 0 ? (80 * self.dataRows.count) : 0)
            
            viewPopupAddProductContainer.removeFromSuperview()
        }
    }
    
    @IBAction func btnPaymentOptionTapped(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if (sender == btnCash)
        {
            if (arrayPaymentOptions[0] == 0)
            {
                arrayPaymentOptions[0] = 1
                imageViewCash.image = UIImage(named: "checkbox_square_black_selected")
            }
            else
            {
                arrayPaymentOptions[0] = 0
                imageViewCash.image = UIImage(named: "checkbox_square_black_normal")
            }
        }
        else if (sender == btnCredit)
        {
            if (arrayPaymentOptions[1] == 0)
            {
                arrayPaymentOptions[1] = 1
                imageViewCredit.image = UIImage(named: "checkbox_square_black_selected")
            }
            else
            {
                arrayPaymentOptions[1] = 0
                imageViewCredit.image = UIImage(named: "checkbox_square_black_normal")
            }
        }
        else if (sender == btnDebit)
        {
            if (arrayPaymentOptions[2] == 0)
            {
                arrayPaymentOptions[2] = 1
                imageViewDebit.image = UIImage(named: "checkbox_square_black_selected")
            }
            else
            {
                arrayPaymentOptions[2] = 0
                imageViewDebit.image = UIImage(named: "checkbox_square_black_normal")
            }
        }
        else
        {
            if (arrayPaymentOptions[3] == 0)
            {
                arrayPaymentOptions[3] = 1
                imageViewContact.image = UIImage(named: "checkbox_square_black_selected")
            }
            else
            {
                arrayPaymentOptions[3] = 0
                imageViewContact.image = UIImage(named: "checkbox_square_black_normal")
            }
        }
    }
    
    func generateSharableString () -> String
    {
        var strString: String = "✅ *Segue o Orçamento*\n\n*Detalhes:*"
        
        for objProduct in dataRows
        {
            strString = "\(strString)\n*\(objProduct.strProductName)* : R$ \(objProduct.strProductPrice.replacingOccurrences(of: ".", with: ","))"
        }
        
        strString = "\(strString)\n ➡️ Total: \(lblSubTotalValue.text ?? "") ⬅️ "
        
        let intInstallments: Int = Int(self.txtQuantity.text ?? "1") ?? 1
        if (intInstallments > 1)
        {
        
            let floatSubTotal: Float = Float((lblSubTotalValue.text ?? "0").replacingOccurrences(of: ",", with: ".")) ?? 0
            let floatInstallments = floatSubTotal / Float(intInstallments)
            let strInstallment: String = "\(floatInstallments)".replacingOccurrences(of: ".", with: ",")
            
            strString = "\(strString)(em ate \(intInstallments)x de R$\(strInstallment))"
        }
        
        if (txtDiscount.text != "")
        {
            strString = "\(strString)\n\n*Desconto p/pgto ā vista:* \(txtDiscount.text ?? "0")%"
            strString = "\(strString)\n ➡️ Total ā vista: \(lblTotalValue.text ?? "") ⬅️ "
        }
        
        strString = "\(strString)\n\n*Formas de Pagamento Aceitas:*"
        
        if (arrayPaymentOptions[0] == 1)
        {
            strString = "\(strString)\n✔️ Dinheiro"
        }
        if (arrayPaymentOptions[1] == 1)
        {
            strString = "\(strString)\n✔️ Cartão de Crédito"
        }
        if (arrayPaymentOptions[2] == 1)
        {
            strString = "\(strString)\n✔️ Cartão de Débito"
        }
        if (arrayPaymentOptions[3] == 1)
        {
            strString = "\(strString)\n✔️ Boleto"
        }
        
        let strSelectedStoreName: String = "\(UserDefaults.standard.value(forKey: "selected_store_name") ?? "-")"
        strString = "\(strString)\n\n*Orçamento Válido até:* \(txtDate.text ?? "")\n\n*\(strSelectedStoreName)*\n*WhatsApp:* \(objSelectedStoreDetails.strPhoneNumber)\n\n*Website:* \(ServerIPForWebsite)\(objSelectedStoreDetails.strSlug)\n\nQualquer dúvida, estou à disposição."
        
        
        
        return strString
    }
    
    @IBAction func btnOption1Tapped(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let originalString = "https://wa.me/?text=\(self.generateSharableString())"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        guard let url = URL(string: escapedString!) else {
          return //be safe
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: {_ in
        
            //CLEAR DATA
            let realm = try! Realm()
            try! realm.write({
                realm.delete(realm.objects(ObjQuotationProduct.self))
            })
            self.dataRows = [ObjQuotationProduct]()
            self.mainTableView.reloadData()
            self.calculateTotal()
            self.nslcMainTableViewHeight.constant = CGFloat(self.dataRows.count > 0 ? (80 * self.dataRows.count) : 0)
        })
    }
    
    @IBAction func btnOption2Tapped(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.view.addSubview(viewPopupContainer)
    }
    
    @IBAction func btnPopupCloseTapped(_ sender: UIButton)
    {
        self.view.endEditing(true)
        txtMobileNumber.text = ""
        viewPopupContainer.removeFromSuperview()
    }
    
    @IBAction func btnPopupSendTapped(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if(txtMobileNumber?.text?.count == 0 || ((txtMobileNumber?.text?.isEmpty) == nil)){
            
            appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
            
        }else{
            let intMobileNumber = Int(txtMobileNumber!.text!) ?? 0
            if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
            {
                let originalString = "https://wa.me/55\(intMobileNumber)?text=\(self.generateSharableString())"
                let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                
                guard let url = URL(string: escapedString!) else {
                  return //be safe
                }
                
                UIApplication.shared.open(url, options: [:], completionHandler: {_ in
                    
                    let realm = try! Realm()
                    try! realm.write({
                        realm.delete(realm.objects(ObjQuotationProduct.self))
                    })
                    self.dataRows = [ObjQuotationProduct]()
                    self.mainTableView.reloadData()
                    self.calculateTotal()
                    self.nslcMainTableViewHeight.constant = CGFloat(self.dataRows.count > 0 ? (80 * self.dataRows.count) : 0)
                    
                    self.txtMobileNumber.text = ""
                    self.viewPopupContainer.removeFromSuperview()
                    
                })
            }
            else
            {
                appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("invalid_phone", value:"número de telefone inválido", comment: ""))
            }
        }
    }
    
    @IBAction func btnOption3Tapped(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([""])
                mail.setMessageBody("\(self.generateSharableString())", isHTML: false)

                present(mail, animated: true)
            } else {
                // show failure alert
            }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        let realm = try! Realm()
        try! realm.write({
            realm.delete(realm.objects(ObjQuotationProduct.self))
        })
        self.dataRows = [ObjQuotationProduct]()
        self.mainTableView.reloadData()
        self.calculateTotal()
        self.nslcMainTableViewHeight.constant = CGFloat(self.dataRows.count > 0 ? (80 * self.dataRows.count) : 0)
        
        controller.dismiss(animated: true, completion: nil)
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
        
        txtTitle.delegate = self
        txtClientName.delegate = self
        txtDate.delegate = self
        txtDiscount.delegate = self
        txtMobileNumber.delegate = self
        txtLabourAmount.delegate = self
        txtAddProductName.delegate = self
        txtAddProductPrice.delegate = self
        
        myDatePicker = UIDatePicker()
        myDatePicker.datePickerMode = .date
        myDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 10, to: Date())
        txtDate.inputView = myDatePicker
        myDatePicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalBackgroundLightGreenColor
        mainTableView?.isHidden = true
        
        txtQuantity.optionIds = arrayQuantityIDs
        txtQuantity.optionArray = arrayQuantityValues
        txtQuantity.handleKeyboard = false
        txtQuantity.isSearchEnable = false
        txtQuantity.hideOptionsWhenSelect = true
        txtQuantity.checkMarkEnabled = false
        txtQuantity.selectedRowColor = (MySingleton.sharedManager().themeGlobalLightGreenColor?.withAlphaComponent(0.5))!
        txtQuantity.listHeight =  (self.view?.frame.size.height)! / 3
        
        txtQuantity.didSelect{(selectedText , index ,id) in
            
            self.txtQuantity.text = selectedText
        }
        
        txtQuantity.selectedIndex = 0
        txtQuantity.text = arrayQuantityValues[0]
        
        txtDiscount.keyboardType = .numberPad
        
        viewPopupContainer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        txtMobileNumber.keyboardType = .numberPad
        
        btnSend?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSend?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSend?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSend?.clipsToBounds = true
        btnSend?.layer.cornerRadius = 5
        
        viewPopupLabourContainer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        txtLabourAmount.delegate = self
        txtLabourAmount.keyboardType = .numberPad
        txtLabourAmount.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        btnSaveLabourAmount?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSaveLabourAmount?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSaveLabourAmount?.setTitleColor(MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSaveLabourAmount?.clipsToBounds = true
        btnSaveLabourAmount?.layer.cornerRadius = 5
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    // MARK: - DATE PICKER
    
    @IBAction func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/M/yyyy"
        dateFormatter.timeZone = TimeZone.current
        txtDate!.text = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField == txtDiscount)
        {
            self.calculateTotal()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == txtDiscount)
        {
            let maxLength = 2
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            
//            if (textField.text != "")
//            {
//                txtDiscount.errorMessage = ""
//            }
            
            return newString.length <= maxLength
        }
        
        return true
    }
    
    // MARK: - Calculate Total
    func calculateTotal()
    {
        var floatSubTotal: Float = 0
        
        for objProduct in dataRows
        {
            let floatPrice: Float = Float(objProduct.strProductPrice.replacingOccurrences(of: ",", with: ".")) ?? 0
            let floatQuantity: Float = Float(objProduct.strProductQuantity) ?? 0
            floatSubTotal = floatSubTotal + (floatPrice * floatQuantity)
        }
        
        let strSUBT: String = String(format: "%.02f", floatSubTotal)
        lblSubTotalValue.text = "R$\(strSUBT)".replacingOccurrences(of: ".", with: ",")
        if (txtDiscount.text != "")
        {
            let floatDiscount: Float = Float(txtDiscount.text ?? "0") ?? 0
            let floatDiscountValue: Float = (floatSubTotal * floatDiscount) / 100
            let floatTotalValue: Float = floatSubTotal - floatDiscountValue
            if (floatDiscount > 0 && floatDiscount < 100)
            {
                let strDISC: String = String(format: "%.02f", floatDiscountValue)
                let strTOT: String = String(format: "%.02f", floatTotalValue)
                lblDiscountValue.text = "R$\(strDISC)".replacingOccurrences(of: ".", with: ",")
                lblTotalValue.text = "R$\(strTOT)".replacingOccurrences(of: ".", with: ",")
            }
            else
            {
                lblDiscountValue.text = ""
                let strTOT: String = String(format: "%.02f", floatSubTotal)
                lblTotalValue.text = "R$\(strTOT)".replacingOccurrences(of: ".", with: ",")
            }
        }
        else
        {
            lblDiscountValue.text = ""
            let strTOT: String = String(format: "%.02f", floatSubTotal)
            lblTotalValue.text = "R$\(strTOT)".replacingOccurrences(of: ".", with: ",")
        }
    }
}

//MARK:- TableView Methods
extension SendQuotationVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.register(UINib(nibName: "SendQuotationTVCell", bundle: nil), forCellReuseIdentifier: "SendQuotationTVCell\(indexPath.row)")
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:SendQuotationTVCell! = tableView.dequeueReusableCell(withIdentifier: "SendQuotationTVCell\(indexPath.row)") as? SendQuotationTVCell
        
        if(cell == nil)
        {
            cell = SendQuotationTVCell(style: .default, reuseIdentifier: "SendQuotationTVCell\(indexPath.row)")
        }
        
        let objIndex: ObjQuotationProduct = dataRows[indexPath.row]
        
        cell.lblProductName.text = objIndex.strProductName
        
        let strPrice: String = objIndex.strProductPrice.replacingOccurrences(of: ",", with: ".")
        let floatPrice: Float = Float(strPrice) ?? 0
        let intQty: Int = Int(objIndex.strProductQuantity) ?? 0
        cell.lblQuantity.text = objIndex.strProductQuantity
        let floatSubTotal: Float = floatPrice * Float(intQty)
        if (floatSubTotal > 0)
        {
            let strSUBT: String = String(format: "%.02f", floatSubTotal)
            cell.lblProductPrice.text = "R$\(strSUBT)".replacingOccurrences(of: ".", with: ",")
        }
        else
        {
            cell.lblProductPrice.text = "Preço sob consulta"
        }
        cell.lblProductPrice.adjustsFontSizeToFitWidth = true
        
        cell.btnMinusClick = {(_ aCell: SendQuotationTVCell) -> Void in
            
            let realm = try! Realm()
            try! realm.write({
                
                if (intQty > 1)
                {
                    objIndex.strProductQuantity = "\(intQty - 1)"
                }
                
            })
            
            self.mainTableView.reloadData()
            self.calculateTotal()
            
        }
        
        cell.btnPlusClick = {(_ aCell: SendQuotationTVCell) -> Void in
            
            let realm = try! Realm()
            try! realm.write({
                
                objIndex.strProductQuantity = "\(intQty + 1)"
            })
            
            self.mainTableView.reloadData()
            self.calculateTotal()
            
        }
        
        cell.btnDeleteClick = {(_ aCell: SendQuotationTVCell) -> Void in
            
            //SHOW ALERT
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = ""
            alertViewController.message = "Tem certeza de que deseja excluir este item?"
            
            // Customize appearance as desired
            alertViewController.view.tintColor = UIColor.white
            alertViewController.backgroundTapDismissalGestureEnabled = false
            alertViewController.swipeDismissalGestureEnabled = false
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
                title: "Não",
                style: .cancel,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.navigationController!.dismiss(animated: true, completion: {
                        
                        
                        
                    })
            })
            
            // Add alert actions
            let okAction = NYAlertAction(
                title: "Sim",
                style: .default,
                handler: { (action: NYAlertAction!) -> Void in
                    
                    self.navigationController!.dismiss(animated: true, completion: {
                        
                        let realm = try! Realm()
                        try! realm.write({
                            realm.delete(objIndex)
                        })
                        
                        self.dataRows = [ObjQuotationProduct]()
                        
                        for obj in realm.objects(ObjQuotationProduct.self)
                        {
                            self.dataRows.append(obj)
                        }
                        self.mainTableView.reloadData()
                        self.calculateTotal()
                        self.nslcMainTableViewHeight.constant = CGFloat(self.dataRows.count > 0 ? (80 * self.dataRows.count) : 0)
                        
                    })
                    
            })
            
            alertViewController.addAction(cancelAction)
            alertViewController.addAction(okAction)
                                
            self.navigationController!.present(alertViewController, animated: true, completion: nil)
        }
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
}
