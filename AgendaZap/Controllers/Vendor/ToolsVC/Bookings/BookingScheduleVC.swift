//
//  BookingScheduleVC.swift
//  AgendaZap
//
//  Created by Shashank Bansal on 26/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController

class BookingScheduleVC: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var headerContainerView: UIView!
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var lblLink: UILabel!
    @IBOutlet var lblCopy: UILabel!
    @IBOutlet var btnCopy: UIButton!
    @IBOutlet var lblShare: UILabel!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var lblDescription: UILabel!
    
    
    @IBOutlet var mainTableView: UITableView! {
        didSet {
            self.mainTableView.register(UINib(nibName: "BookingScheduleTVCell", bundle: nil), forCellReuseIdentifier: "BookingScheduleTVCell")
        }
    }
    @IBOutlet var nslcMainTableViewHeight: NSLayoutConstraint!
    
    //MARK:- Variables
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var objStoreDetails: ObjStoreDetails!
    var datarows = [ObjBookingDate]()
    
    
    //MARK:- Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.segmentedControl.selectedSegmentIndex = 0
        
        //API CALL
        let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
        dataManager.user_GetStoreDetails(strStoreID: strSelectedStoreID)
        dataManager.user_GetStoreBookingList()
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
                selector: #selector(self.user_GetStoreDetailsEvent),
                name: Notification.Name("user_GetStoreDetailsEvent"),
                object: nil)
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_GetStoreBookingListEvent),
                name: Notification.Name("user_GetStoreBookingListEvent"),
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
          
            self.objStoreDetails = dataManager.objSelectedStoreDetails
            
            var strLink: String = ""
            if (self.segmentedControl.selectedSegmentIndex == 0)
            {
                strLink = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/15"
            }
            else if (self.segmentedControl.selectedSegmentIndex == 1)
            {
                strLink = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/30"
            }
            else
            {
                strLink = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/60"
            }
            self.lblLink.text = strLink
        })
    }
    
    @objc func user_GetStoreBookingListEvent()
    {
        DispatchQueue.main.async(execute: {
          
            self.datarows = dataManager.arrayStoreBookingList
            self.mainTableView.reloadData()
            self.nslcMainTableViewHeight.constant = self.mainTableView.contentSize.height
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("case0")
            if (self.objStoreDetails != nil)
            {
                lblLink.text = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/15"
            }
            
        case 1:
            print("case1")
            if (self.objStoreDetails != nil)
            {
                lblLink.text = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/30"
            }
        case 2:
            print("case2")
            if (self.objStoreDetails != nil)
            {
                lblLink.text = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/60"
            }
        default:
            break
        }
    }
    
    @IBAction func btnCopyTapped(_ sender: Any) {
        
        if (self.objStoreDetails != nil)
        {
            var strLink: String = ""
            if (segmentedControl.selectedSegmentIndex == 0)
            {
                strLink = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/15"
            }
            else if (segmentedControl.selectedSegmentIndex == 1)
            {
                strLink = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/30"
            }
            else
            {
                strLink = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/60"
            }
            
            UIPasteboard.general.string = strLink
            AppDelegate.showToast(message : NSLocalizedString("Copy_to_ClipBoard", value:"Link copiado", comment: ""), font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
        }
        
    }
    
    @IBAction func btnShareTapped(_ sender: Any) {
        
        if (self.objStoreDetails != nil)
        {
            var strLink: String = ""
            if (segmentedControl.selectedSegmentIndex == 0)
            {
                strLink = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/15"
            }
            else if (segmentedControl.selectedSegmentIndex == 1)
            {
                strLink = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/30"
            }
            else
            {
                strLink = "\(ServerIPForWebsite)\(self.objStoreDetails.strSlug)/agenda/60"
            }
            
            let string: String = "*Olá!*\n\n🕑 *Utilize o link abaixo para agendar um horário com:* \(self.objStoreDetails.strName)\n👉 \(strLink)"
            
            let originalString = "https://wa.me/?text=\(string)"
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
            
            guard let url = URL(string: escapedString!) else {
              return //be safe
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
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
extension BookingScheduleVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return datarows.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return datarows[section].arrayBookings.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let objIndex: ObjBookingDate = datarows[section]
        
        let viewHeader: UIView = UIView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: tableView.frame.size.width,
                                                      height: 50))
        viewHeader.backgroundColor = UIColor.black
        
        let lblHeader: UILabel = UILabel(frame: CGRect(x: 10,
                                                       y: 0, width: viewHeader.frame.size.width - 20,
                                                       height: viewHeader.frame.size.height))
        
        lblHeader.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        lblHeader.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblHeader.textAlignment = .center
        lblHeader.text = objIndex.strDate
        
        viewHeader.addSubview(lblHeader)
        
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        tableView.register(UINib(nibName: "BookingScheduleTVCell", bundle: nil), forCellReuseIdentifier: "BookingScheduleTVCell\(indexPath.section)-\(indexPath.row)")
        
        //========== TABLEVIEW CELL PROGRAMMATICALLY ==========//
        var cell:BookingScheduleTVCell! = tableView.dequeueReusableCell(withIdentifier: "BookingScheduleTVCell\(indexPath.section)-\(indexPath.row)") as? BookingScheduleTVCell
        
        if(cell == nil)
        {
            cell = BookingScheduleTVCell(style: .default, reuseIdentifier: "BookingScheduleTVCell\(indexPath.section)-\(indexPath.row)")
        }
        
        let objIndexSection: ObjBookingDate = datarows[indexPath.section]
        let objIndex: ObjBooking = objIndexSection.arrayBookings[indexPath.row]
        
        cell.lblBookingTime.text = objIndex.strBookingTime
        cell.lblName.text = objIndex.strName
        
        cell.btnDetailsClick = {(_ aCell: BookingScheduleTVCell) -> Void in
            
            let viewController: BookingDetailsVC = BookingDetailsVC()
            viewController.strSelectedBookingID = objIndex.strID
            self.navigationController?.pushViewController(viewController, animated: true)
            
        }
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
}
