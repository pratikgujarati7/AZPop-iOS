//
//  User_SideMenuViewController.swift
//  AgendaZap
//
//  Created by Dipen on 10/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import LGSideMenuController

class User_SideMenuViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate
{
    
    //========== IBOUTLETS ==========//
    @IBOutlet var mainTableView: UITableView?
    
    @IBOutlet var headerView: UIView?
    @IBOutlet var mainLogoImageView: UIImageView?
    
    //========== OTHER VARIABLES ==========//
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    // MARK: - UIViewController Delegate Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sideMenuController?.isLeftViewSwipeGestureEnabled = false
        self.sideMenuController?.isRightViewSwipeGestureEnabled = false
        
        self.setupNotificationEvent()
        self.setupInitialView()
        
        self.sideMenuController?.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.sideMenuController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
            selector: #selector(self.user_RegisterMobileNumberEvent),
            name: Notification.Name("user_RegisterMobileNumberEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_RegisterMobileNumberEvent()
    {
        DispatchQueue.main.async(execute: {
            
            
        })
    }
    
    // MARK: - Layout Subviews Methods
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    // MARK: - Setting Initial Views Methods
    
    func setupInitialView()
    {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //MAIN TABLEVIEW
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalWhiteColor
        mainTableView?.isHidden = false
    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return (headerView?.frame.size.height)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return SideMenuTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let reusableIdentifier = NSString(format:"cell:%d", indexPath.row) as String
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:SideMenuTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? SideMenuTableViewCell
        
        if(cell == nil)
        {
            cell = SideMenuTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
        }
        
        if indexPath.row == 0
        {
            cell.imageViewItem.image = UIImage(named: "ic_change_city.png")
            cell.lblItemName.text = NSLocalizedString("menu_change_city", value:"Trocar cidade", comment: "")
        }
        else if indexPath.row == 1
        {
            cell.imageViewItem.image = UIImage(named: "menu_contact.png")
            cell.lblItemName.text = NSLocalizedString("menu_zap_sam_contact", value:"WhatsApp sem contato", comment: "")
        }
        else if indexPath.row == 2
        {
                   cell.imageViewItem.image = UIImage(named: "ic_menu_home.png")
                   cell.lblItemName.text = NSLocalizedString("menu_manage_stores", value:"Cadastrar meu negócio", comment: "")
        }
        else if indexPath.row == 3
        {
            cell.imageViewItem.image = UIImage(named: "ic_menu_recent_history.png")
            cell.lblItemName.text = NSLocalizedString("recent_favourite", value:"Recentes / Favoritos", comment: "")
        }
//        else if indexPath.row == 4
//        {
//            cell.imageViewItem.image = UIImage(named: "ic_menu_star.png")
//            cell.lblItemName.text = NSLocalizedString("menu_favourites", value:"Favoritos", comment: "")
//        }
        else if indexPath.row == 4
        {
            cell.imageViewItem.image = UIImage(named: "ic_menu_friendslist.png")
            cell.lblItemName.text = NSLocalizedString("menu_my_profile", value:"Meu perfil", comment: "")
        }
        else if indexPath.row == 5
        {
            cell.imageViewItem.image = UIImage(named: "ic_menu_share_holo_light.png")
            cell.lblItemName.text = NSLocalizedString("menu_recommend", value:"Recomende o AgendaZap", comment: "")
        }
        else if indexPath.row == 6
        {
            cell.imageViewItem.image = UIImage(named: "sym_action_email.png")
            cell.lblItemName.text = NSLocalizedString("menu_contact_us", value:"Contatar os administradores", comment: "")
        }
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.sideMenuController?.hideLeftViewAnimated()
        
        if indexPath.row == 0//Trocar cidade
        {
            let viewController: User_SelectCityViewController = User_SelectCityViewController()
            viewController.backContainerView?.isHidden = false
            self.sideMenuController?.navigationController?.pushViewController(viewController, animated: false)
        }
        else if indexPath.row == 1//Zap sem contato
        {
            //ContactlessZap
            let viewController: User_ContactlessZapViewController = User_ContactlessZapViewController()
            self.sideMenuController?.navigationController?.pushViewController(viewController, animated: false)
        }
        else if indexPath.row == 2//Cadastrar meu megocio
        {
            //MY STORES
            let strIsAuthorized: String = "\(UserDefaults.standard.value(forKey: "isAuthorized") ?? "")"
            let strPassword: String = "\(UserDefaults.standard.value(forKey: "password") ?? "")"
            
            if(strIsAuthorized == "1")
            {
                //AUTHORIZED
                let viewController: User_MyStoresListViewController = User_MyStoresListViewController()
                self.sideMenuController?.navigationController?.pushViewController(viewController, animated: false)
            }
            else if(strPassword != "" && strPassword.count > 0)
            {
                //PASSWORD IS CREATED
                let viewController: User_LoginUsingPasswordViewController = User_LoginUsingPasswordViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else
            {
                //PASSWORD IS NOT CREATED
//                let viewController: User_RegisterEmailViewController = User_RegisterEmailViewController()
//                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else if indexPath.row == 3//Recentes
        {
            //RECENT
            let viewController: User_RecentViewController = User_RecentViewController()
            self.sideMenuController?.navigationController?.pushViewController(viewController, animated: false)
        }
//        else if indexPath.row == 4//Favouritos
//        {
//            //FAVOURITE
//            let viewController: User_FavouriteViewController = User_FavouriteViewController()
//            self.sideMenuController?.navigationController?.pushViewController(viewController, animated: false)
//        }
        
        else if indexPath.row == 4//Meu perfil
        {
            //MY PROFILE
            let viewController: User_MyProfileViewController = User_MyProfileViewController()
            self.sideMenuController?.navigationController?.pushViewController(viewController, animated: false)
        }
        else if indexPath.row == 5//Recomende o AgendaZap
        {
            //Recommend
            let viewController: User_RecommendViewController = User_RecommendViewController()
            self.sideMenuController?.navigationController?.pushViewController(viewController, animated: false)
        }
        else if indexPath.row == 6//Contatar os administradores
        {
            //Contact ADMINISTRATOR
            let viewController: User_ContactAdminViewController = User_ContactAdminViewController()
            self.sideMenuController?.navigationController?.pushViewController(viewController, animated: false)
        }
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
