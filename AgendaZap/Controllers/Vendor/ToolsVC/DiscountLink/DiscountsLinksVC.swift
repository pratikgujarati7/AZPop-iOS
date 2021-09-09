//
//  DiscountsLinksVC.swift
//  AgendaZap
//
//  Created by Dipen on 22/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController

class DiscountsLinksVC: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var mainTableView: UITableView! {
        didSet {
            self.mainTableView.register(UINib(nibName: "DiscountLinkTVCell", bundle: nil), forCellReuseIdentifier: "DiscountLinkTVCell")
        }
    }
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var datarows = [ObjDiscountLink]()
    var intPageNumber: Int = 1
    
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
        
        //API CALL
        dataManager.user_GetMyStoreDiscountLinks(strPageNumber: "\(intPageNumber)")
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
                selector: #selector(self.user_GetMyStoreDiscountLinksEvent),
                name: Notification.Name("user_GetMyStoreDiscountLinksEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetMyStoreDiscountLinksEvent()
    {
        DispatchQueue.main.async(execute: {
          
            self.datarows = dataManager.arrayMyStoreDiscountLinks
            self.mainTableView.reloadData()
            
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCreateNewLinkTapped(_ sender: Any) {
        
        let viewController: CreateDiscountLinkVC = CreateDiscountLinkVC()
        self.navigationController?.pushViewController(viewController, animated: true)
        
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
    }

}

//MARK:- TableView Methods
extension DiscountsLinksVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return datarows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.register(UINib(nibName: "DiscountLinkTVCell", bundle: nil), forCellReuseIdentifier: "DiscountLinkTVCell\(indexPath.row)")
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:DiscountLinkTVCell! = tableView.dequeueReusableCell(withIdentifier: "DiscountLinkTVCell\(indexPath.row)") as? DiscountLinkTVCell
        
        if(cell == nil)
        {
            cell = DiscountLinkTVCell(style: .default, reuseIdentifier: "DiscountLinkTVCell\(indexPath.row)")
        }
        
        let objIndex: ObjDiscountLink = datarows[indexPath.row]
        
        cell.lblProductName.text = objIndex.strTitle
        if (objIndex.strType == "2")
        {
            let strValue: String = String(format: "%.02f", Float(objIndex.strValue.replacingOccurrences(of: ",", with: ".")) ?? 0)
                        
            cell.lblDiscountValue.text = "R$ \(strValue)".replacingOccurrences(of: ".", with: ",")
        }
        else
        {
            cell.lblDiscountValue.text = "% \(objIndex.strValue)".replacingOccurrences(of: ".", with: ",")
        }
        
        cell.btnCopyLinkClick = {(_ aCell: DiscountLinkTVCell) -> Void in
            
            let lblSharableLink: String = "\(ServerIPForWeb)\(objIndex.strDiscountLink)"
            UIPasteboard.general.string = lblSharableLink
            AppDelegate.showToast(message : NSLocalizedString("Copy_to_ClipBoard", value:"Link copiado", comment: ""), font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
            
        }
        
        cell.btnShareClick = {(_ aCell: DiscountLinkTVCell) -> Void in
            
            let lblSharableLink: String = "\(ServerIPForWeb)\(objIndex.strDiscountLink)"
            let originalString: String = "https://wa.me/?text=Aproveite o desconto de \(cell.lblDiscountValue.text ?? "") para comprar \(objIndex.strTitle)\n\nSegue o link para fazer o pedido e garantir seu desconto:\n🌐 \(lblSharableLink)"
            
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            guard let url = URL(string: escapedString!) else {
              return //be safe
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
        
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
