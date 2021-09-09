//
//  ReporterProblemViewController.swift
//  AgendaZap
//
//  Created by Aditya Mac on 15/05/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController

//TEMP

class ReporterProblemViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet var statusBarContainerView: UIView?
    @IBOutlet var homeBarContainerView: UIView?
    @IBOutlet var masterContainerView: UIView?
    
    //NAVIGATION BAR
    @IBOutlet var navigationBarView: UIView?
    @IBOutlet var navigationTitle: UILabel?
    //BACK
    @IBOutlet var backContainerView: UIView?
    @IBOutlet var imageViewBack: UIImageView?
    @IBOutlet var btnBack: UIButton?
    
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var whatsappInvalidoView: UIView!
    @IBOutlet var lblWhatsappInvalido: UILabel!
    @IBOutlet var imgWhatsappInvalido: UIImageView!
    @IBOutlet var btnWhatsappInvalido: UIButton!
    
    @IBOutlet var inappropriateView: UIView!
    @IBOutlet var lblInappropriate: UILabel!
    @IBOutlet var imgInappropriate: UIImageView!
    @IBOutlet var btnInappropriate: UIButton!
    
    @IBOutlet var noAnswerView: UIView!
    @IBOutlet var lblNoAnswer: UILabel!
    @IBOutlet var imgNoAnswer: UIImageView!
    @IBOutlet var btnNoAnswer: UIButton!
    
    @IBOutlet var whatsappBusinessView: UIView!
    @IBOutlet var lblwhatsappBusiness: UILabel!
    @IBOutlet var imgwhatsappBusiness: UIImageView!
    @IBOutlet var btnwhatsappBusiness: UIButton!
    
    @IBOutlet var otherView: UIView!
    @IBOutlet var lblOther: UILabel!
    @IBOutlet var imgOther: UIImageView!
    @IBOutlet var btnOther: UIButton!
    
    @IBOutlet var txtOther: UITextView!
    @IBOutlet var txtConstraintHieght: NSLayoutConstraint!
    @IBOutlet var btnSubmit: UIButton!
    
    // MARK: - Other Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    var strOnlineSelected: String = "1"
    var strStoreID: String = ""
    
    // MARK: - UIViewController Delegate Methods
    
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
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .lightContent
        }
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
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //
    //        self.view.endEditing(true)
    //
    //        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup Notification Methods
    
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_ReportAProblemEvent),
                name: Notification.Name("user_ReportAProblemEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_ReportAProblemEvent()
    {
        
        //show Rating alert
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = NSLocalizedString("problem_success", value:"Problema reportado com sucesso", comment: "")
        alertViewController.message = NSLocalizedString("problema_reportado", value:"Iremos investigar e tomar as atitudes necessárias. Obrigado pela ajuda!", comment: "")
        
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
        let okAction = NYAlertAction(
            title: "OK",
            style: .default,
            handler: { (action: NYAlertAction!) -> Void in
                self.navigationController!.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: false)
                
        })
        
        alertViewController.addAction(okAction)
        self.navigationController!.present(alertViewController, animated: true, completion: nil)
        
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    // MARK: - NavigationBar Methods
    
    func setUpNavigationBar()
    {
        statusBarContainerView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationBarView?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        navigationTitle?.text = NSLocalizedString("activity_title_Problem_reporter", value:"Tipo do problema", comment: "")
        
        btnBack?.addTarget(self, action: #selector(self.btnBackClicked(_:)), for: .touchUpInside)
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        lblWhatsappInvalido?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblWhatsappInvalido?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblWhatsappInvalido?.text = NSLocalizedString("whatsapp_invalid", value:"WhatsApp não abre - número inválido", comment: "")
        imgWhatsappInvalido?.image = UIImage (named: "checkbox_selected.png")
        btnWhatsappInvalido?.addTarget(self, action: #selector(self.btnWhatsappclicked(_:)), for: .touchUpInside)
        
        lblwhatsappBusiness?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
       lblwhatsappBusiness?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
       lblwhatsappBusiness?.text = NSLocalizedString("whatsapp_Business", value:"WhatsApp não pertence ao negócio", comment: "")
       imgwhatsappBusiness?.image = UIImage (named: "checkbox_normal.png")
       btnwhatsappBusiness?.addTarget(self, action: #selector(self.btnWhatsappBusinessClicked(_:)), for: .touchUpInside)
        
        lblNoAnswer?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblNoAnswer?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblNoAnswer?.text = NSLocalizedString("no_answer", value:"Não obtive resposta", comment: "")
        imgNoAnswer?.image = UIImage (named: "checkbox_normal.png")
        btnNoAnswer?.addTarget(self, action: #selector(self.btnNoAnswerClicked(_:)), for: .touchUpInside)
        
        lblInappropriate?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblInappropriate?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblInappropriate?.text = NSLocalizedString("inappropriate_content", value:"Conteúdo impróprio", comment: "")
        imgInappropriate?.image = UIImage (named: "checkbox_normal.png")
        btnInappropriate?.addTarget(self, action: #selector(self.btnInappropriateClicked(_:)), for: .touchUpInside)
        
        lblOther?.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblOther?.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblOther?.text = NSLocalizedString("other", value:"Outro", comment: "")
        imgOther?.image = UIImage (named: "checkbox_normal.png")
        btnOther?.addTarget(self, action: #selector(self.btnOtherClicked(_:)), for: .touchUpInside)
        
        //OTHER DETAIL
        self.txtConstraintHieght.constant = 0
        txtOther?.delegate = self
        txtOther!.text = NSLocalizedString("describe_the_problem", value:"Descreva o problema", comment: "")
        txtOther!.textColor = MySingleton.sharedManager() .themeGlobalButtonLightGrayColor
        txtOther!.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        //  txtOther!.backgroundColor       = .clear
        txtOther!.autocorrectionType    = .no
        //layer.cornerRadius    = 25.0
        txtOther!.clipsToBounds         = true
        txtOther!.textAlignment = .left
        
        btnSubmit.setTitle(NSLocalizedString("submit", value:"Enviar", comment: ""), for: UIControl.State.normal)
        btnSubmit.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSubmit?.addTarget(self, action: #selector(self.btnSubmitClicked(_:)), for: .touchUpInside)
        btnSubmit.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        //            btnSubmit.titleLabel?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        btnSubmit!.titleLabel!.font = MySingleton.sharedManager().themeFontFourteenSizeBold
    }
    
    @IBAction func btnWhatsappclicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.txtConstraintHieght.constant = 0
        strOnlineSelected = "1"
        imgWhatsappInvalido?.image = UIImage (named: "checkbox_selected.png")
        imgwhatsappBusiness?.image = UIImage (named: "checkbox_normal.png")
        imgNoAnswer?.image = UIImage (named: "checkbox_normal.png")
        imgInappropriate?.image = UIImage (named: "checkbox_normal.png")
        imgOther?.image = UIImage (named: "checkbox_normal.png")
    }
    @IBAction func btnWhatsappBusinessClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.txtConstraintHieght.constant = 0
        strOnlineSelected = "4"
        imgwhatsappBusiness?.image = UIImage (named: "checkbox_selected.png")
        imgWhatsappInvalido?.image = UIImage (named: "checkbox_normal.png")
        imgNoAnswer?.image = UIImage (named: "checkbox_normal.png")
        imgInappropriate?.image = UIImage (named: "checkbox_normal.png")
        imgOther?.image = UIImage (named: "checkbox_normal.png")
    }
    
    @IBAction func btnNoAnswerClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.txtConstraintHieght.constant = 0
        strOnlineSelected = "2"
        imgNoAnswer?.image = UIImage (named: "checkbox_selected.png")
        imgwhatsappBusiness?.image = UIImage (named: "checkbox_normal.png")
        imgWhatsappInvalido?.image = UIImage (named: "checkbox_normal.png")
        imgInappropriate?.image = UIImage (named: "checkbox_normal.png")
        imgOther?.image = UIImage (named: "checkbox_normal.png")
    }
    @IBAction func btnInappropriateClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        self.txtConstraintHieght.constant = 0
        strOnlineSelected = "3"
        imgInappropriate?.image = UIImage (named: "checkbox_selected.png")
        imgNoAnswer?.image = UIImage (named: "checkbox_normal.png")
        imgwhatsappBusiness?.image = UIImage (named: "checkbox_normal.png")
        imgWhatsappInvalido?.image = UIImage (named: "checkbox_normal.png")
        imgOther?.image = UIImage (named: "checkbox_normal.png")
    }
    @IBAction func btnOtherClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        strOnlineSelected = "0"
        self.txtConstraintHieght.constant = 100
        // self.txtOther.text = ""
        imgOther?.image = UIImage (named: "checkbox_selected.png")
        imgNoAnswer?.image = UIImage (named: "checkbox_normal.png")
        imgwhatsappBusiness?.image = UIImage (named: "checkbox_normal.png")
        imgInappropriate?.image = UIImage (named: "checkbox_normal.png")
        imgWhatsappInvalido?.image = UIImage (named: "checkbox_normal.png")
    }
    
    @IBAction func btnSubmitClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if(strOnlineSelected == "0"){
            
            if(txtOther.text .isEmpty || txtOther.text == NSLocalizedString("describe_the_problem", value:"Descreva o problema", comment: ""))
            {
                self.appDelegate?.showAlertViewWithTitle(title: "", detail: NSLocalizedString("it_is_necessary_to_describe_the_problem", value:"Error", comment: ""))
                
            }else{
                //API CALL
                dataManager.user_ReportAProblem(strProbleText: self.txtOther.text, strProblemType: strOnlineSelected, strStoreID: strStoreID)
            }
            
        }else{
            dataManager.user_ReportAProblem(strProbleText: "", strProblemType: strOnlineSelected, strStoreID: strStoreID)
        }
        
    }
    
    // MARK: - UITextView Delagate Methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.txtOther!.text.count > 1 {
            self.txtOther!.text = ""
            self.txtOther!.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.txtOther!.text.isEmpty {
            
            self.txtOther!.text = NSLocalizedString("describe_the_problem", value:"Descreva o problema", comment: "")
            self.txtOther!.textColor = MySingleton.sharedManager().themeGlobalButtonLightGrayColor
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
