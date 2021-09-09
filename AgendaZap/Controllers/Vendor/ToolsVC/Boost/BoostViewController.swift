//
//  BoostViewController.swift
//  AgendaZap
//
//  Created by Dipen Lad on 19/07/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController

class BoostViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblInstruction1: UILabel!
    @IBOutlet var lblInstruction1Details: UILabel!
    
    @IBOutlet var lblInstruction2: UILabel!
    @IBOutlet var lblInstruction2Details: UILabel!
    
    @IBOutlet var lblInstruction3: UILabel!
    @IBOutlet var lblInstruction3Details: UILabel!
    
    @IBOutlet var lblDescription2: UILabel!
    
    @IBOutlet var btnWhatsapp: UIButton!
    
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    //MARK:- Methods

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
                selector: #selector(self.user_getUserEvent),
                name: Notification.Name("user_getUserEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_getUserEvent()
    {
        DispatchQueue.main.async(execute: {
            
            
            
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
    @IBAction func btnWhatsappTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let originalString = "https://wa.me/5519986070183?text=Quero impulsionar meu negócio com o AZpop"
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: escapedString!) else {
          return //be safe
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
        
        lblDescription.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblDescription.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        lblTitle.font = MySingleton.sharedManager().themeFontSixteenSizeMedium
        lblTitle.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        lblInstruction1.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblInstruction1.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        lblInstruction2.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblInstruction2.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        lblInstruction3.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblInstruction3.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        lblDescription2.font = MySingleton.sharedManager().themeFontTwelveSizeMedium
        lblDescription2.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        let normalAttribute = [NSAttributedString.Key.font: MySingleton.sharedManager().themeFontFourteenSizeRegular! ,
                              NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().themeGlobalBlackColor!] as [NSAttributedString.Key : Any]
        
        let boldAttribute = [NSAttributedString.Key.font: MySingleton.sharedManager().themeFontFourteenSizeMedium! ,
                              NSAttributedString.Key.foregroundColor: MySingleton.sharedManager().themeGlobalBlackColor!] as [NSAttributedString.Key : Any]
        
        let strInstruction1Details1 = NSMutableAttributedString(string: "Cadastro Google Meu Negócio: ", attributes: boldAttribute)
        let strInstruction1Details2 = NSAttributedString(string: "seu negócio aparecerá nas buscas do Google, Google Maps, poderá receber avaliações no Google e mais. (R$49,90 taxa única)", attributes: normalAttribute)
        strInstruction1Details1.append(strInstruction1Details2)
        lblInstruction1Details.attributedText = strInstruction1Details1
        
        let strInstruction2Details1 = NSMutableAttributedString(string: "Impulsionamento Insta/Face ou Google: ", attributes: boldAttribute)
        let strInstruction2Details2 = NSAttributedString(string: "fazemos a gestão completa do impulsionamento e enviamos um relatorio com os resultados ao final. (R$100,00 mínimo, com 30% de taxa de gestão)", attributes: normalAttribute)
        strInstruction2Details1.append(strInstruction2Details2)
        lblInstruction2Details.attributedText = strInstruction2Details1
        
        let strInstruction3Details1 = NSMutableAttributedString(string: "Gestão de redes sociais: ", attributes: boldAttribute)
        let strInstruction3Details2 = NSAttributedString(string: "8 artes + texto + hashtags criadas e publicadas no seu Insta e Face todo mês. (R$99,90 /mês)", attributes: normalAttribute)
        strInstruction3Details1.append(strInstruction3Details2)
        lblInstruction3Details.attributedText = strInstruction3Details1
        
        btnWhatsapp?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnWhatsapp?.backgroundColor = MySingleton.sharedManager().themeGlobalGreen2Color
        btnWhatsapp?.setTitleColor( MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnWhatsapp?.clipsToBounds = true
        btnWhatsapp?.layer.cornerRadius = 5
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
