//
//  CreateDiscountLinkVC.swift
//  AgendaZap
//
//  Created by Shashank Bansal on 26/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import iOSDropDown

class CreateDiscountLinkVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var dropdownProduct: DropDown!
    
    @IBOutlet var lblDiscountType: UILabel!
    //FLAT
    @IBOutlet var imageViewFlatDiscountCheckbox: UIImageView!
    @IBOutlet var lblFlatDiscount: UILabel!
    @IBOutlet var btnFlatDiscount: UIButton!
    //PERCENTAGE
    @IBOutlet var imageViewPercentageDiscountCheckbox: UIImageView!
    @IBOutlet var lblPercentageDiscount: UILabel!
    @IBOutlet var btnPercentageDiscount: UIButton!
    
    @IBOutlet var lblHowMuchDiscount: UILabel!
    @IBOutlet var lblDiscountTypeValue: UILabel!
    @IBOutlet var txtDiscountValue: UITextField!
    
    @IBOutlet var lblProductName: UILabel!
    //
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblPriceValue: UILabel!
    @IBOutlet var lblDiscount: UILabel!
    @IBOutlet var lblDiscountValue: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lblTotalValue: UILabel!
    
    //OPTIONS
    @IBOutlet var lblOptions: UILabel!
    //EXPIRY DATE
    @IBOutlet var imageViewExpiryDateCheckbox: UIImageView!
    @IBOutlet var lblExpiryDate: UILabel!
    @IBOutlet var btnExpiryDate: UIButton!
    //VALUE
    @IBOutlet var viewExpiryDate: UIView!
    @IBOutlet var nslcViewExpiryDateHeight: NSLayoutConstraint!
    @IBOutlet var lblExpiryDateTitle: UILabel!
    @IBOutlet var txtExpiryDateValue: UITextField!
    
    //USE LIMIT
    @IBOutlet var imageViewUseLimitCheckbox: UIImageView!
    @IBOutlet var lblUseLimit: UILabel!
    @IBOutlet var btnUseLimit: UIButton!
    //VALUE
    @IBOutlet var viewUseLimit: UIView!
    @IBOutlet var nslcViewUseLimitHeight: NSLayoutConstraint!
    @IBOutlet var lblUseLimitTitle: UILabel!
    @IBOutlet var txtUseLimitValue: UITextField!
    
    @IBOutlet var btnSave: UIButton!
    
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var arrayProductIDs = [Int]()
    var arrayProductNames = [String]()
    var arrayProducts = [ObjStoreProduct]()
    var objSelectedProduct: ObjStoreProduct!
    
    var intDiscountType: Int = 1
    var boolIsExpiryDateActive: Bool = false
    var myDatePicker : UIDatePicker!
    var boolIsUseLimitActive: Bool = false
        
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        viewExpiryDate.isHidden = true
        nslcViewExpiryDateHeight.constant = 0
        viewUseLimit.isHidden = true
        nslcViewUseLimitHeight.constant = 0
        
        myDatePicker!.setDate(Date(), animated: false)
        handleDatePicker(myDatePicker)
        
        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        dataManager.user_GetAllStoreProductsForDiscount(strStoreID: strSelectedStoreID)
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
                selector: #selector(self.user_GetAllStoreProductsEvent),
                name: Notification.Name("user_GetAllStoreProductsEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_SaveMyStoreDiscountLinkEvent),
                name: Notification.Name("user_SaveMyStoreDiscountLinkEvent"),
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
          
            self.arrayProducts = [ObjStoreProduct]()
            for objTemp in dataManager.arrayAllStoreProducts
            {
                let floatPrice: Float = Float(objTemp.strMoneyPrice) ?? 0
                if (floatPrice > 0)
                {
                    self.arrayProducts.append(objTemp)
                }
            }
            
            self.arrayProductIDs = [Int]()
            self.arrayProductNames = [String]()
            if (self.arrayProducts.count > 0)
            {
                self.dropdownProduct.isUserInteractionEnabled = true
                
                for objProduct in self.arrayProducts
                {
                    self.arrayProductIDs.append(Int(objProduct.strID) ?? 0)
                    self.arrayProductNames.append(objProduct.strTitle)
                }
                
                self.dropdownProduct.optionIds = self.arrayProductIDs
                self.dropdownProduct.optionArray = self.arrayProductNames
                
                self.dropdownProduct.didSelect{(selectedText , index ,id) in
                    
                    self.objSelectedProduct = self.arrayProducts[index]
                    self.calculateDiscount()
                    
                }
                
                self.dropdownProduct.selectedIndex = 0
                self.dropdownProduct.text = self.arrayProductNames[0]
                self.objSelectedProduct = self.arrayProducts[0]
                self.calculateDiscount()
            }
            else
            {
                self.dropdownProduct.isUserInteractionEnabled = false
            }
            
        })
    }
    
    @objc func user_SaveMyStoreDiscountLinkEvent()
    {
        DispatchQueue.main.async(execute: {
            
            AppDelegate.showToast(message : "Discount Link generated successfully", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
            self.navigationController?.popViewController(animated: false)
            
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDiscountTypeTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if (sender == btnFlatDiscount)
        {
            intDiscountType = 1
            imageViewFlatDiscountCheckbox.image = UIImage(named: "checkbox_selected_black.png")
            imageViewPercentageDiscountCheckbox.image = UIImage(named: "checkbox_normal.png")
            lblDiscountTypeValue.text = "R$"
            lblHowMuchDiscount.text = "Quantos R$ quer dar de desconto?"
        }
        else
        {
            intDiscountType = 2
            imageViewFlatDiscountCheckbox.image = UIImage(named: "checkbox_normal.png")
            imageViewPercentageDiscountCheckbox.image = UIImage(named: "checkbox_selected_black.png")
            lblDiscountTypeValue.text = "%"
            lblHowMuchDiscount.text = "Quantos % quer dar de desconto?"
        }
        txtDiscountValue.text = ""
        self.calculateDiscount()
    }
    
    @IBAction func btnExpiryDateTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if (boolIsExpiryDateActive)
        {
            boolIsExpiryDateActive = false
            nslcViewExpiryDateHeight.constant = 0
            viewExpiryDate.isHidden = true
            imageViewExpiryDateCheckbox.image = UIImage(named: "ic_grey_tick.png")
        }
        else
        {
            boolIsExpiryDateActive = true
            nslcViewExpiryDateHeight.constant = 50
            viewExpiryDate.isHidden = false
            imageViewExpiryDateCheckbox.image = UIImage(named: "ic_green_tick.png")
        }
    }
    
    @IBAction func btnUseLimitTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if (boolIsUseLimitActive)
        {
            boolIsUseLimitActive = false
            nslcViewUseLimitHeight.constant = 0
            viewUseLimit.isHidden = true
            imageViewUseLimitCheckbox.image = UIImage(named: "ic_grey_tick.png")
        }
        else
        {
            boolIsUseLimitActive = true
            nslcViewUseLimitHeight.constant = 50
            viewUseLimit.isHidden = false
            imageViewUseLimitCheckbox.image = UIImage(named: "ic_green_tick.png")
        }
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        var txtValue: String = txtDiscountValue.text ?? "0,00"
        if intDiscountType == 1
        {
            txtValue = txtValue.replacingOccurrences(of: ".", with: "")
            txtValue = txtValue.replacingOccurrences(of: ",", with: ".")
        }
        
        let floatPoductPrice: Float = Float(objSelectedProduct.strMoneyPrice) ?? 0
        let floatDiscount: Float = Float(txtValue) ?? 0
        if (floatDiscount <= 0)
        {
            AppDelegate.showToast(message : "Please enter discount amount", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
            return
        }
        
        if (intDiscountType == 1 && floatDiscount > floatPoductPrice)
        {
            AppDelegate.showToast(message : "Discount amount should be less then product price", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
            return
        }
        
        if (intDiscountType == 2 && (floatDiscount < 0 || floatDiscount > 100))
        {
            AppDelegate.showToast(message : "Discount % should be between 0-100", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
            return
        }
        
        if (boolIsExpiryDateActive && txtExpiryDateValue.text == "")
        {
            AppDelegate.showToast(message : "Please select offer expiry date", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
            return
        }
        
        if (boolIsUseLimitActive && txtUseLimitValue.text == "")
        {
            AppDelegate.showToast(message : "Please enter utilization limit", font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
            return
        }
        
        //API CALL
        dataManager.user_SaveMyStoreDiscountLink(strProductID: self.objSelectedProduct.strID, strDiscountType: intDiscountType == 1 ? "2" : "1", strDiscount: "\(floatDiscount)", strExpiryDate: (txtExpiryDateValue.text)!, strLimit: (txtUseLimitValue.text)!)
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
        
        self.dropdownProduct.selectedRowColor = (MySingleton.sharedManager().themeGlobalLightGreenColor?.withAlphaComponent(0.5))!
        self.dropdownProduct.isSearchEnable = false
        self.dropdownProduct.delegate = self
        
        txtDiscountValue.delegate = self
        txtExpiryDateValue.delegate = self
        txtUseLimitValue.delegate = self
        
        myDatePicker = UIDatePicker()
        myDatePicker.datePickerMode = .date
        myDatePicker.minimumDate = Date()
        txtExpiryDateValue.inputView = myDatePicker
        myDatePicker.addTarget(self, action: #selector(self.handleDatePicker(_:)), for: UIControl.Event.valueChanged)
        
        btnSave.layer.borderWidth = 1
        btnSave.layer.borderColor = UIColor.init(named: "Color1_ThemeBlack")?.cgColor
        
        txtDiscountValue.delegate = self
        txtDiscountValue.keyboardType = .numberPad
        txtDiscountValue.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
//        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if intDiscountType == 1
        {
            if let amountString = textField.text?.currencyInputFormatting() {
                textField.text = amountString
            }
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - DATE PICKER
    
    @IBAction func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy"
        dateFormatter.timeZone = TimeZone.current
        txtExpiryDateValue!.text = dateFormatter.string(from: sender.date)
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField == txtDiscountValue)
        {
            self.calculateDiscount()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Calculate Discount
    func calculateDiscount()
    {
        lblProductName.text = objSelectedProduct.strTitle
        
        let floatPoductPrice: Float = Float(objSelectedProduct.strMoneyPrice) ?? 0
        lblPriceValue.text = String(format: "%.02f", floatPoductPrice).replacingOccurrences(of: ".", with: ",")
        lblTotalValue.text = String(format: "%.02f", floatPoductPrice).replacingOccurrences(of: ".", with: ",")
        let floatDiscount: Float = Float(txtDiscountValue.text ?? "0") ?? 0
        if (intDiscountType == 1)
        {
            lblDiscountValue.text = "R$ 0,00".replacingOccurrences(of: ".", with: ",")
            if (floatDiscount < floatPoductPrice)
            {
                lblDiscountValue.text = String(format: "%.02f", floatDiscount).replacingOccurrences(of: ".", with: ",")
                    
                lblTotalValue.text = String(format: "%.02f", floatPoductPrice - floatDiscount).replacingOccurrences(of: ".", with: ",")
                    
                    //"R$ \(floatPoductPrice - floatDiscount)".replacingOccurrences(of: ".", with: ",")
            }
            else
            {
                txtDiscountValue.text = ""
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Discount should be less than product price")
            }
            
        }
        else
        {
            lblDiscountValue.text = "R$ 0".replacingOccurrences(of: ".", with: ",")
            if (floatDiscount <= 100)
            {
                lblDiscountValue.text = "% \(floatDiscount)".replacingOccurrences(of: ".", with: ",")
                let floatDiscountedPrice = (floatPoductPrice / 100) * floatDiscount
                lblTotalValue.text = String(format: "%.02f", floatPoductPrice - floatDiscountedPrice).replacingOccurrences(of: ".", with: ",")
                    
                    //"R$ \(floatPoductPrice - floatDiscountedPrice)".replacingOccurrences(of: ".", with: ",")
            }
            else
            {
                txtDiscountValue.text = ""
                appDelegate?.showAlertViewWithTitle(title: "", detail: "Discount % should between 0-100")
            }
        }
    }
    
}
