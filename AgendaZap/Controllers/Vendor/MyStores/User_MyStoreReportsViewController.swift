//
//  User_MyStoreReportsViewController.swift
//  AgendaZap
//
//  Created by Innovative Iteration on 17/04/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import SDWebImage
import MBProgressHUD

class User_MyStoreReportsViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource
{
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
    
    @IBOutlet var mainScrollView: UIScrollView?
    @IBOutlet var scrollContaineView: UIView?
    
    @IBOutlet var lblInstruction1: UILabel?
    @IBOutlet var lblInstruction2: UILabel?
    
    @IBOutlet var lblTotalClicks: UILabel?
    
    @IBOutlet var separatorView: UIView?
    
    @IBOutlet var lblTableTitle: UILabel?
    
    @IBOutlet var mainTableView: UITableView?
    
    //HEADER VIEW
    @IBOutlet var headerContainerView: UIView?
    @IBOutlet var lblDateHeader: UILabel?
    @IBOutlet var lblTimeHeader: UILabel?
    @IBOutlet var lblPhoneNumberHeader: UILabel?
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var objMyStore: MyStore!
    var dataRows = [MyStoreClickReport]()
    
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
            selector: #selector(self.user_GetClickReportsOfMyStoresEvent),
            name: Notification.Name("user_GetClickReportsOfMyStoresEvent"),
            object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_GetClickReportsOfMyStoresEvent()
    {
        DispatchQueue.main.async(execute: {
            self.lblTotalClicks?.text = NSLocalizedString("total_clicks_received", value: "Total de cliques recebidos", comment: "") + ": " + dataManager.strMyStoreTotalClickCount
            
            self.dataRows = dataManager.arrayAllMyStoreClickReports
            self.mainTableView?.isHidden = false
            self.mainTableView?.reloadData()
        })
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
        navigationTitle?.text = NSLocalizedString("btn_reports", value:"Relatório", comment: "")
        
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
        mainScrollView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        homeBarContainerView?.backgroundColor = MySingleton.sharedManager().themeGlobalBackgroundGreyColor
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        scrollContaineView?.backgroundColor = .clear
        
        lblInstruction1?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblInstruction1?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblInstruction1?.text = NSLocalizedString("my_store_click_reports_instruction_1", value: "Lembre-se que nem todos clientes que mandarem mensagem para seu WhatsApp irão se identificar como vindos do AgendaZap, pois eles podem apagar a mensagem padrão", comment: "")
        
        lblInstruction2?.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblInstruction2?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblInstruction2?.text = NSLocalizedString("my_store_click_reports_instruction_2", value: "Você pode buscar no WhatsApp pelos 4 últimos dígitos do telefone dos clientes listados abaixo para verificar se de fato houve contato.", comment: "")
        
        lblTotalClicks?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        lblTotalClicks?.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblTotalClicks?.backgroundColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        
        lblTableTitle?.font = MySingleton.sharedManager().themeFontFourteenSizeMedium
        lblTableTitle?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblTableTitle?.text = NSLocalizedString("my_store_click_reports_table_title", value: "Histórico de cliques", comment: "")
        
        mainTableView?.delegate = self
        mainTableView?.dataSource = self
        mainTableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTableView?.backgroundColor = MySingleton.sharedManager() .themeGlobalBackgroundGreyColor
        mainTableView?.isHidden = true
        mainTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //HEADER VIEW
        headerContainerView?.backgroundColor = MySingleton.sharedManager() .themeGlobalBackgroundGreyColor
        
        lblDateHeader?.font = MySingleton.sharedManager().themeFontTwelveSizeBold
        lblDateHeader?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblDateHeader?.text = NSLocalizedString("date", value: "Dia", comment: "")
        lblDateHeader?.textAlignment = NSTextAlignment.left
        
        lblTimeHeader?.font = MySingleton.sharedManager().themeFontTwelveSizeBold
        lblTimeHeader?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblTimeHeader?.text = NSLocalizedString("hour", value: "Hora", comment: "")
        lblTimeHeader?.textAlignment = NSTextAlignment.center
        
        lblPhoneNumberHeader?.font = MySingleton.sharedManager().themeFontTwelveSizeBold
        lblPhoneNumberHeader?.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblPhoneNumberHeader?.text = NSLocalizedString("last_4_digits", value: "Últimos 4 dígitos", comment: "")
        
        lblPhoneNumberHeader?.textAlignment = NSTextAlignment.right
        
        dataManager.user_GetClickReportsOfMyStores(strStoreID: self.objMyStore.strID)
    }
    
    // MARK: - UITableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if (section == 0)
        {
            return (headerContainerView?.frame.size.height)!
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if (section == 0)
        {
            return headerContainerView
        }
        else
        {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (section == 0)
        {
            if (dataRows.count > 0)
            {
                return dataRows.count
            }
            else
            {
                return 1
            }
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (dataRows.count > 0)
        {
            return 40.0
        }
        else
        {
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (dataRows.count > 0)
        {
            let reusableIdentifier = NSString(format:"cell-1:%d", indexPath.row) as String

            //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
            var cell:MyStoreClickReportsTableViewCell! = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier) as? MyStoreClickReportsTableViewCell

            if(cell == nil)
            {
                cell = MyStoreClickReportsTableViewCell(style: .default, reuseIdentifier: reusableIdentifier)
            }
            
            cell.lblDate.text = dataRows[indexPath.row].strClickDate
            cell.lblTime.text = dataRows[indexPath.row].strClickTime
            cell.lblPhoneNumber.text = dataRows[indexPath.row].strPhoneNumber
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
        else
        {
            var lblNoDataFont: UIFont?
            
            if MySingleton.sharedManager().screenWidth == 320
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
            }
            else if MySingleton.sharedManager().screenWidth == 375
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
            }
            else
            {
                lblNoDataFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
            }
            
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
            
            let lblNoData = UILabel(frame: CGRect(x: 0, y: 0, width: (mainTableView?.frame.size.width)!, height: cell.frame.size.height))
            lblNoData.textAlignment = NSTextAlignment.center
            lblNoData.font = lblNoDataFont
            lblNoData.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
            lblNoData.text = "Nenhum resultado encontrado"
            
            cell.contentView.addSubview(lblNoData)
            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if (dataRows.count > 0)
        {
        }
    }
    
    // MARK: - UIScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll called")
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return true
    }
    
    // MARK: - Other Methods
}
