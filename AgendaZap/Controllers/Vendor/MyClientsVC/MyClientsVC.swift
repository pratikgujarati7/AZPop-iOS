//
//  MyClientsVC.swift
//  AgendaZap
//
//  Created by Dipen on 01/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class MyClientsVC: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var btnCreateClient: UIButton!
    
    @IBOutlet var mainTableView: UITableView! {
        didSet {
            self.mainTableView.register(UINib(nibName: "MyClientTVCell", bundle: nil), forCellReuseIdentifier: "MyClientTVCell")
        }
    }
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var datarows = [ObjMyClient]()
    
    let arrayStatusID = [1,2,3,4]
    let arrayStatusValues = ["Status do cliente não definido",
                            "Cliente aguardando meu retorno",
                            "Aguardando retorno do cliente",
                            "Concluído com sucesso"]
    
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
        
        //API CALL
        dataManager.user_GetAllMyClients()
        
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
        
        dataManager.arrayAllWhatsappGroups.removeAll()
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
                selector: #selector(self.user_GetAllMyClientsEvent),
                name: Notification.Name("user_GetAllMyClientsEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetAllMyClientsEvent()
    {
        DispatchQueue.main.async(execute: {
            
            self.datarows = dataManager.arrayMyClients
            self.mainTableView.isHidden = false
            self.mainTableView.reloadData()
            
        })
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        viewNavigation.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        //navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        //navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        //navigationTitle?.text = ""
        
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView()
    {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        btnCreateClient?.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnCreateClient?.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnCreateClient?.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnCreateClient?.clipsToBounds = false
        btnCreateClient?.layer.cornerRadius = 5
        btnCreateClient.layer.shadowColor = MySingleton.sharedManager().themeGlobalBlackColor?.cgColor
        btnCreateClient.layer.shadowOpacity = 0.5
        btnCreateClient.layer.shadowRadius = 2.0
        btnCreateClient.layer.shadowOffset = .zero
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
    
    // MARK: - Other Methods
    
    @IBAction func btnCreateClientTapped(_ sender: Any) {
        let viewController: CreateClientVC = CreateClientVC()
        viewController.clientId = ""
        viewController.strStatus = "1"
        viewController.isEditClient = false
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

//MARK:- TableView Methods
extension MyClientsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.datarows.count > 0 ? self.datarows.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objClient = self.datarows[indexPath.row]
        
        tableView.register(UINib(nibName: "MyClientTVCell", bundle: nil), forCellReuseIdentifier: "MyClientTVCell\(indexPath.row)")
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:MyClientTVCell! = tableView.dequeueReusableCell(withIdentifier: "MyClientTVCell\(indexPath.row)") as? MyClientTVCell
        
        if(cell == nil)
        {
            cell = MyClientTVCell(style: .default, reuseIdentifier: "MyClientTVCell\(indexPath.row)")
        }
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyClientTVCell") as! MyClientTVCell
        
        cell.lblClientName.text = objClient.strName != "<null>" ? objClient.strName : objClient.strPhoneNumber
        cell.lblObservationsValue.text = objClient.strObservations != "<null>" ? objClient.strObservations : "-"
        
        
        if (objClient.strStatus == "1")
        {
            cell.viewClientStatus.backgroundColor = UIColor.gray
            cell.viewClientStatusOnDropDown.backgroundColor = UIColor.gray
            cell.dropdownStatus.text = "Status do cliente não definido"
        }
        else if (objClient.strStatus == "2")
        {
            cell.viewClientStatus.backgroundColor = UIColor.red
            cell.viewClientStatusOnDropDown.backgroundColor = UIColor.red
            cell.dropdownStatus.text = "Cliente aguardando meu retorno"
        }
        else if (objClient.strStatus == "3")
        {
            cell.viewClientStatus.backgroundColor = UIColor.yellow
            cell.viewClientStatusOnDropDown.backgroundColor = UIColor.yellow
            cell.dropdownStatus.text = "Aguardando retorno do cliente"
        }
        else
        {
            cell.viewClientStatus.backgroundColor = UIColor.green
            cell.viewClientStatusOnDropDown.backgroundColor = UIColor.green
            cell.dropdownStatus.text = "Concluído com sucesso"
        }
        
        cell.dropdownStatus.isUserInteractionEnabled = true
        cell.dropdownStatus.optionArray = arrayStatusValues
        cell.dropdownStatus.isSearchEnable = false
        cell.dropdownStatus.selectedRowColor = .white
        cell.dropdownStatus.checkMarkEnabled = false
        cell.dropdownStatus.didSelect { (selectedText, index, Id) in
            print("Selected String: \(selectedText) \n index: \(index) \n Id: \(Id)")
            
            //API CALL
            dataManager.user_SaveClientMask(status: "\(self.arrayStatusID[index])", isStatusUpdate: "1", phoneNo: objClient.strPhoneNumber, clientId: objClient.strID)
            
            if (index == 0)
            {
                cell.viewClientStatus.backgroundColor = UIColor.gray
                cell.viewClientStatusOnDropDown.backgroundColor = UIColor.gray
                objClient.strStatus = "1"
            }
            else if (index == 1)
            {
                cell.viewClientStatus.backgroundColor = UIColor.red
                cell.viewClientStatusOnDropDown.backgroundColor = UIColor.red
                objClient.strStatus = "2"
            }
            else if (index == 2)
            {
                cell.viewClientStatus.backgroundColor = UIColor.yellow
                cell.viewClientStatusOnDropDown.backgroundColor = UIColor.yellow
                objClient.strStatus = "3"
            }
            else
            {
                cell.viewClientStatus.backgroundColor = UIColor.green
                cell.viewClientStatusOnDropDown.backgroundColor = UIColor.green
                objClient.strStatus = "4"
            }
        }
        
        cell.btnToggleClick = {(_ aCell: MyClientTVCell) -> Void in
            
            cell.nslcInnerContainerViewHeight.constant = cell.nslcInnerContainerViewHeight.constant == 40 ? 155 : 40
            tableView.reloadData()
            
        }
        
        cell.btnDetailsClick = {(_ aCell: MyClientTVCell) -> Void in
            
            let viewController: ClientDetailsVC = ClientDetailsVC()
            viewController.objSelectedClient = objClient
            self.navigationController?.pushViewController(viewController, animated: true)
        }
                
        cell.btnEditClick = {(_ aCell: MyClientTVCell) -> Void in
            print("Edit client ID - \(objClient.strID)")
            let viewController: CreateClientVC = CreateClientVC()
            viewController.clientId = objClient.strID
            viewController.objClient = objClient
            viewController.isEditClient = true
            viewController.strStatus = objClient.strStatus
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        cell.btnWhatsappClick = {(_ aCell: MyClientTVCell) -> Void in
            
            if (objClient.strPhoneNumber != "")
            {
                print("self.objStoreDetails.strPhoneNumber :\(objClient.strPhoneNumber)")
                
                let originalString = "https://wa.me/55\(objClient.strPhoneNumber)"
                let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
                
                guard let url = URL(string: escapedString!) else {
                  return //be safe
                }
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
}
