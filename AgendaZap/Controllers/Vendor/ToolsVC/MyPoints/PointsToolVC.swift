//
//  PointsToolVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 30/03/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import RealmSwift
import FirebaseDynamicLinks

class PointsToolVC: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblVoice: UILabel!
    @IBOutlet var lblPontosValue: UILabel!
    @IBOutlet var lblPontos: UILabel!
    
    @IBOutlet var lblLink: UILabel!
    
    //COPY
    @IBOutlet var viewCopy: UIView!
    @IBOutlet var imageViewCopy: UIImageView!
    @IBOutlet var btnCopy: UIButton!
    
    //WHATSAPP
    @IBOutlet var viewWhatsapp: UIView!
    @IBOutlet var imageViewWhatsapp: UIImageView!
    @IBOutlet var lblWhatsapp: UILabel!
    @IBOutlet var btnWhatsapp: UIButton!
    
    //APPSTORE
    @IBOutlet var viewAppStore: UIView!
    @IBOutlet var imageViewAppStore: UIImageView!
    @IBOutlet var lblAppStore: UILabel!
    @IBOutlet var btnAppStore: UIButton!
    
    //INSTAGRAM
    @IBOutlet var viewInstagram: UIView!
    @IBOutlet var imageViewInstagram: UIImageView!
    @IBOutlet var lblInstagram: UILabel!
    @IBOutlet var btnInstagram: UIButton!
    
    @IBOutlet var btnWithdrawoMoney: UIButton!
    
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var boolIsAPICalledOnce: Bool = false
    var boolIsScreenOpenedFromNotification: Bool = false
    
    var strRefferalLink: String = ""
    
    var intCallType: Int = 0
    
    //MARK:- Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        strRefferalLink = "\(UserDefaults.standard.value(forKey: "refferalLink") ?? "")"
        
        if strRefferalLink == "" {
            self.generateDynamicLink()
        }
        else
        {
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let underlineAttributedString = NSAttributedString(string: self.strRefferalLink, attributes: underlineAttribute)
            self.lblLink.attributedText = underlineAttributedString
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //API CALL
        dataManager.user_getUser()
        
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
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_addReferralPointsEvent),
                name: Notification.Name("user_addReferralPointsEvent"),
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
            
            self.lblPontosValue.text = dataManager.strPointsToolValues
            self.lblPontosValue.adjustsFontSizeToFitWidth = true
            
            if (dataManager.boolIsAppStorePointsReceived == true)
            {
                self.viewAppStore.alpha = 0.5
            }
            else
            {
                self.viewAppStore.alpha = 1.0
            }
            
            if (dataManager.boolIsInstagramPointsReceived == true)
            {
                self.viewInstagram.alpha = 0.5
            }
            else
            {
                self.viewInstagram.alpha = 1.0
            }
            
        })
    }
    
    @objc func user_addReferralPointsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            if (self.intCallType == 0)
            {
                //OPEN URL OF APPSTORE
                if let url = URL(string: "itms-apps://apple.com/app/id1496435175") {
                    UIApplication.shared.open(url)
                }
            }
            else if (self.intCallType == 1)
            {
                //OPEN WHATSAPP
                guard self.strRefferalLink != "" else { return }
                
                let text = "Estou lhe dando 2 pontos (equivalente a R$2,00) para você trocar por descontos de até *100%* em produtos e serviços dentro do app *AZpop!*  É só baixar o aplicativo pelo link abaixo: \n\n\(self.strRefferalLink)"
                let textShare = [text]
                let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
            else
            {
                //OPEN INSTAGRAM
                guard let url = URL(string: "https://www.instagram.com/azpop.com.br") else {
                  return //be safe
                }

                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
            self.lblPontosValue.text = dataManager.strPointsToolValues
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.view.endEditing(true)
        if (boolIsScreenOpenedFromNotification == true)
        {
            appDelegate?.setTabBarVC()
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnCopyTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        UIPasteboard.general.string = self.lblLink.text
        AppDelegate.showToast(message : NSLocalizedString("Copy_to_ClipBoard", value:"Link copiado", comment: ""), font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
        
    }
    
    @IBAction func btnWhatsappTapped(_ sender: Any) {
        self.view.endEditing(true)
        intCallType = 1
        //API CALL
        dataManager.user_addReferralPoints(strPoints: "1", strType: "5")
    }
    
    @IBAction func btnAppStoreTapped(_ sender: Any) {
        self.view.endEditing(true)
        if (dataManager.boolIsAppStorePointsReceived == false)
        {
            intCallType = 0
            //API CALL
            dataManager.user_addReferralPoints(strPoints: "3", strType: "4")
        }
    }
    
    @IBAction func btnInstagramTapped(_ sender: Any) {
        self.view.endEditing(true)
        if (dataManager.boolIsInstagramPointsReceived == false)
        {
            intCallType = 2
            //API CALL
            dataManager.user_addReferralPoints(strPoints: "2", strType: "5")
        }
    }
    
    @IBAction func btnWithdrawoMoneyTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        let viewController: PointsRedeemVC = PointsRedeemVC()
        self.navigationController?.pushViewController(viewController, animated: true)
        
//        let intPoints: Int = Int(dataManager.strPointsToolValues) ?? 0
//        if (intPoints < 100)
//        {
//            self.appDelegate?.showAlertViewWithTitle(title: "", detail: "Você precisa atingir 100 pontos para solicitar o resgaste.")
//        }
//        else
//        {
//            let originalString = "https://wa.me/5519998975227?text=Atingi 100 pontos no AZpop e quero solicitar o resgate de R$50"
//            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//
//            guard let url = URL(string: escapedString!) else {
//              return //be safe
//            }
//
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
        
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
        
        lblWhatsapp.text = "Compartilhe No WhatsApp E\nGanhe 1 Ponto Por Download".uppercased()
        lblAppStore.text = "Avalie na App Store e ganhe 3 pontos".uppercased()
        lblInstagram.text = "Siga nosso instagram\ne ganhe 2 pontos".uppercased()
        
        btnWithdrawoMoney.setTitle("Ver Recompensas".uppercased(), for: .normal)
        btnWithdrawoMoney.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnWithdrawoMoney.backgroundColor = MySingleton.sharedManager().themeGlobalGreen2Color
        btnWithdrawoMoney.setTitleColor( MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        btnWithdrawoMoney.clipsToBounds = true
        btnWithdrawoMoney.layer.cornerRadius = 5
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
    
    //To Generate Dynamic Referral Link
    func generateDynamicLink() {
        
        let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
        
        let strLink = "https://azpop.com.br/?invitedby=" + strLogedInUserID
        
        guard let link = URL(string: strLink) else { return }
        let dynamicLinksDomainURIPrefix = "https://app.azpop.com.br"
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)

        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.agenda-zap")
        linkBuilder?.iOSParameters?.appStoreID = "1496435175"
        
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.agendazap")
        
        /*
         guard let longDynamicLink = linkBuilder?.url else { return }
         print("The long URL is: \(longDynamicLink)")
         */
        
        linkBuilder?.shorten() { url, warnings, error in
            
            guard let refferalLink = url, error == nil else { return }
            print("The short URL is: \(refferalLink)")
            
            UserDefaults.standard.setValue(refferalLink.absoluteString, forKey: "refferalLink_new")
            UserDefaults.standard.synchronize()
            
            self.strRefferalLink = refferalLink.absoluteString
            let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
            let underlineAttributedString = NSAttributedString(string: self.strRefferalLink, attributes: underlineAttribute)
            self.lblLink.attributedText = underlineAttributedString
        }
    }

}
