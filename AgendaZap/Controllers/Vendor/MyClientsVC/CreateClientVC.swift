//
//  CreateClientVC.swift
//  AgendaZap
//
//  Created by Dipen on 08/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import iOSDropDown
import NYAlertViewController


class CreateClientVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var vwBg: UIView!
    @IBOutlet var txtWhatsappNumber: SATextField!
    @IBOutlet var lblOptional: UILabel!
    @IBOutlet var txtCustomerName: SATextField!
    @IBOutlet var txtAddress: SATextField!
    @IBOutlet var txtEmail: SATextField!
    @IBOutlet var txtCPF: SATextField!
    @IBOutlet var txtNotes: SATextField!
    @IBOutlet var lblClientStatus: UILabel!
    @IBOutlet var dropdownStatus: DropDown!
    @IBOutlet var viewClientStatusOnDropDown: UIViewX!
    @IBOutlet var btnSave: UIButton!
    
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    let arrayStatusValues = ["Status do cliente não definido",
                            "Cliente aguardando meu retorno",
                            "Aguardando retorno do cliente",
                            "Concluído com sucesso"]
    var strStatus: String!
    var isEditClient: Bool!
    var isOpenedFromDetails: Bool = false
    var clientId: String!
    var objClient:ObjMyClient!
    
    //MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
                selector: #selector(self.user_CreateNewClientEvent),
                name: Notification.Name("user_CreateNewClientEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_CreateNewClientEvent()
    {
        DispatchQueue.main.async(execute: {
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = "Sucesso"
            alertViewController.message = "Cliente criado com sucesso!"
            
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
            
            // Add alert actions
            let okAction = NYAlertAction(
                title: "Ok",
                style: .default,
                handler: { (action: NYAlertAction!) -> Void in
                    self.dismiss(animated: true, completion: nil)
                    if (self.isOpenedFromDetails)
                    {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    else
                    {
                        self.navigationController?.popViewController(animated: true)
                    }
            })
            
            alertViewController.addAction(okAction)
                    
            self.present(alertViewController, animated: true, completion: nil)
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSaveTapped(_ sender: Any) {
        
        if isEditClient {
            if (self.txtEmail?.text?.count)! > 0 {
                if (objCommonUtility.isValidEmailAddress(strEmailString: (txtEmail?.text)!) == false)
                 {
                    txtEmail.errorMessage = "E-mail inválido"
                 }
                 else
                 {
                    //API CALL
                    dataManager.user_CreateNewClient(status: strStatus, phoneNo: txtWhatsappNumber.placeholder ?? "", clientId: clientId, name: txtCustomerName.text ?? "", email_id: txtEmail.text ?? "", address: txtAddress.text ?? "", tax_id: txtCPF.text ?? "", observations: txtNotes.text ?? "")
                 }
            }else{
                //API CALL
                dataManager.user_CreateNewClient(status: strStatus, phoneNo: txtWhatsappNumber.placeholder ?? "", clientId: clientId, name: txtCustomerName.text ?? "", email_id: txtEmail.text ?? "", address: txtAddress.text ?? "", tax_id: txtCPF.text ?? "", observations: txtNotes.text ?? "")
            }
        }else{
            if (self.txtWhatsappNumber?.text?.count)! <= 0 {
                txtWhatsappNumber.errorMessage = "Insira um número de celular"
                if (self.txtEmail?.text?.count)! > 0 {
                    if (objCommonUtility.isValidEmailAddress(strEmailString: (txtEmail?.text)!) == false)
                     {
                        txtEmail.errorMessage = "E-mail inválido"
                     }
                }
            }else{
                let intMobileNumber = Int(txtWhatsappNumber!.text!) ?? 0
                if ("\(intMobileNumber)".count == 10 || "\(intMobileNumber)".count == 11)
                {
                    if (self.txtEmail?.text?.count)! > 0 {
                        if (objCommonUtility.isValidEmailAddress(strEmailString: (txtEmail?.text)!) == false)
                         {
                            txtEmail.errorMessage = "E-mail inválido"
                         }
                         else
                         {
                            //API CALL
                            dataManager.user_CreateNewClient(status: strStatus, phoneNo: txtWhatsappNumber.text ?? "", clientId: clientId, name: txtCustomerName.text ?? "", email_id: txtEmail.text ?? "", address: txtAddress.text ?? "", tax_id: txtCPF.text ?? "", observations: txtNotes.text ?? "")
                         }
                    }else{
                        //API CALL
                        dataManager.user_CreateNewClient(status: strStatus, phoneNo: txtWhatsappNumber.text ?? "", clientId: clientId, name: txtCustomerName.text ?? "", email_id: txtEmail.text ?? "", address: txtAddress.text ?? "", tax_id: txtCPF.text ?? "", observations: txtNotes.text ?? "")
                    }
                }else{
                    txtWhatsappNumber.errorMessage = "Insira um número de celular"
                    if (self.txtEmail?.text?.count)! > 0 {
                        if (objCommonUtility.isValidEmailAddress(strEmailString: (txtEmail?.text)!) == false)
                         {
                            txtEmail.errorMessage = "E-mail inválido"
                         }
                    }
                }
            }
        }
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        viewNavigation?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        vwBg?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        btnSave?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSave?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSave?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSave?.clipsToBounds = false
        btnSave?.layer.cornerRadius = 5
        btnSave.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        btnSave.layer.shadowOpacity = 0.5
        btnSave.layer.shadowRadius = 2.0
        btnSave.layer.shadowOffset = .zero
        
        txtWhatsappNumber?.delegate = self
        txtEmail?.delegate = self
        
        lblOptional.font = MySingleton.sharedManager().themeFontEighteenSizeBold
        lblOptional.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        lblClientStatus.font = MySingleton.sharedManager().themeFontEighteenSizeBold
        lblClientStatus.textColor = MySingleton.sharedManager().themeGlobalBlackColor
                        
        if (strStatus == "1")
        {
            viewClientStatusOnDropDown.backgroundColor = UIColor.gray
            dropdownStatus.text = "Status do cliente não definido"
        }
        else if (strStatus == "2")
        {
            viewClientStatusOnDropDown.backgroundColor = UIColor.red
            dropdownStatus.text = "Cliente aguardando meu retorno"
        }
        else if (strStatus == "3")
        {
            viewClientStatusOnDropDown.backgroundColor = UIColor.yellow
            dropdownStatus.text = "Aguardando retorno do cliente"
        }
        else
        {
            viewClientStatusOnDropDown.backgroundColor = UIColor.green
            dropdownStatus.text = "Concluído com sucesso"
        }
        
        dropdownStatus.isUserInteractionEnabled = true
        dropdownStatus.optionArray = arrayStatusValues
        dropdownStatus.selectedRowColor = .white
        dropdownStatus.handleKeyboard = false
        dropdownStatus.isSearchEnable = false
        dropdownStatus.hideOptionsWhenSelect = true
        dropdownStatus.checkMarkEnabled = false

        dropdownStatus.didSelect { (selectedText, index, Id) in
            print("Selected String: \(selectedText) \n index: \(index) \n Id: \(Id)")
            
            if (index == 0)
            {
                self.dropdownStatus.text = "Status do cliente não definido"
                self.viewClientStatusOnDropDown.backgroundColor = UIColor.gray
                self.strStatus = "1"
            }
            else if (index == 1)
            {
                self.dropdownStatus.text = "Cliente aguardando meu retorno"
                self.viewClientStatusOnDropDown.backgroundColor = UIColor.red
                self.strStatus = "2"
            }
            else if (index == 2)
            {
                self.dropdownStatus.text = "Aguardando retorno do cliente"
                self.viewClientStatusOnDropDown.backgroundColor = UIColor.yellow
                self.strStatus = "3"
            }
            else
            {
                self.dropdownStatus.text = "Concluído com sucesso"
                self.viewClientStatusOnDropDown.backgroundColor = UIColor.green
                self.strStatus = "4"
            }
        }
        
        if isEditClient {
            txtWhatsappNumber.isUserInteractionEnabled = false
            if !objClient.strPhoneNumber.isEmpty{
                if objClient.strPhoneNumber != "<null>" {
                    txtWhatsappNumber.placeholder = objClient.strPhoneNumber
                }else{
                    txtWhatsappNumber.text = ""
                }
            }else{
                txtWhatsappNumber.text = ""
            }
            
            if !objClient.strName.isEmpty{
                if objClient.strName != "<null>" {
                    txtCustomerName.text = objClient.strName
                }else{
                    txtCustomerName.text = ""
                }
            }else{
                txtCustomerName.text = ""
            }
            
            if !objClient.strAddress.isEmpty{
                if objClient.strAddress != "<null>" {
                    txtAddress.text = objClient.strAddress
                }else{
                    txtAddress.text = ""
                }
            }else{
                txtAddress.text = ""
            }
            
            if !objClient.strEmail.isEmpty{
                if objClient.strEmail != "<null>" {
                    txtEmail.text = objClient.strEmail
                }else{
                    txtEmail.text = ""
                }
            }else{
                txtEmail.text = ""
            }
            
            if !objClient.strTaxID.isEmpty{
                if objClient.strTaxID != "<null>" {
                    txtCPF.text = objClient.strTaxID
                }else{
                    txtCPF.text = ""
                }
            }else{
                txtCPF.text = ""
            }
            
            if !objClient.strObservations.isEmpty{
                if objClient.strObservations != "<null>" {
                    txtNotes.text = objClient.strObservations
                }else{
                    txtNotes.text = ""
                }
            }else{
                txtNotes.text = ""
            }
        }
    }
    
    //MARK:- TextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (textField == txtWhatsappNumber)
        {
            let maxLength = 11
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            
            if (textField.text != "")
            {
                txtWhatsappNumber.errorMessage = ""
            }
            
            return newString.length <= maxLength
        }
        
        if (textField == txtEmail)
        {
            if (textField.text != "")
            {
                txtEmail.errorMessage = ""
            }
        }
        
        return true
    }

}
