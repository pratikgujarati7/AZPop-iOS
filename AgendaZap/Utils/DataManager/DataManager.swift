//
//  DataManager.swift
//  TopApps
//
//  Created by Dani Arnaout on 9/2/14.
//  Edited by Eric Cerney on 9/27/14.
//  Copyright (c) 2014 Ray Wenderlich All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

import NYAlertViewController

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

////========== DEVELOPMENT SERVER URLs ==========//
////DEVELOPMENT SERVER URL
//let ServerIP = "http://dev.azpop.com.br/API/ws/Webservice.php?Service="
//
////DEVELOPMENT SERVER URL FOR STORE WEBSITE
//let ServerIPForWebsite = "http://dev.azpop.com.br/"
//
////DEVELOPMENT SERVER URL FOR REFERRAL LINK
//let ServerIPForWeb = "http://dev.azpop.com.br"


//========== LIVE SERVER URLs ==========//
////LIVE SERVER URL
let ServerIP = "https://azpop.com.br/API/ws/Webservice.php?Service="

//LIVE SERVER URL FOR STORE WEBSITE
let ServerIPForWebsite = "https://azpop.com.br/"

//LIVE SERVER URL FOR REFERRAL LINK
let ServerIPForWeb = "https://azpop.com.br"

let User_GetSplashResponce = "LoadAllMastersOnSplash"
let User_Register = "register"
let User_RegisterMobileNumber = "RegisterUserWithPhone"
let User_GetAllCities = "GetListOfCities"
let User_UpdateStoreClicks = "UpdateStoreClicks"
let User_GetAllStoreProducts = "GetProducts"
let User_GetAllStoreProductsList = "GetStoreProducts"
let User_GetStoreProductDetails = "GetProductDetail"
let User_GetAllCategories = "GetListOfCategories"
let User_GetAllSubCategories = "GetListOfSubCategories"
let User_GetAllStoresBySubCategory = "GetListOfStoresByCategory"
let User_GetAllStoresBySearch = "GetListOfStoresBySearchName"
let User_GetStoreDetails = "GetStoreDetail"
let User_UpdateStoreFavourite = "UpdateStoreFavorite"
let User_AddReview = "AddStoreReview"
let User_GetAllStoreReviews = "GetAllReviews"
let User_AddProductReview = "AddProductReview"

let User_GetPromotionDetails = "GetPromotionByStoreId"

let User_GetAllRecentStores = "GetListOfRecentSearchStores"
let User_GetAllFavouriteStores = "GetListOfFavoritesStores"
let User_GetAllMyStores = "GetListOfStoresByOwner"

let User_AddStore = "AddStoreOwner"
let User_EditStore = "EditStoreDetails"

let User_AddEditPromotion = "AddPromotion"

let User_GetHotPromotions = "GetListOfHotPromotions"

let User_GetMyProfileDetails = "GetProfile"
let User_UpdateMyProfileDetails = "UpdateProfile"

let User_ContactAdministrator = "submitProblemReport"

let User_MarkStoreAsPremium = "MarkStoreAsPremium"

let User_GetClickReportsOfMyStores = "GetClickReport"
let User_ReportProblemer = "ReportStoreProblem"

let RegisterUsingPassword = "RegisterUsingPassword"
let LoginUsingPassword = "LoginUsingPassword"
let ForgotPassword = "ForgotPassword"

let User_GetWhatsappGroups = "GetWhatsappGroups"
let User_AddWhatsappGroup = "AddWhatsappGroup"

let User_GetPointsDetails = "GetPointsDetails"

//CART
let User_GetCartProducts = "GetStoreCartProducts"
let User_ChangeCartProductQuantity = "ChangeCartProductQuantity"
let User_RemoveCartProduct = "RemoveCartProduct"
let User_VerifyCart = "VerifyCart"
let User_MakeProductOrder = "MakeProductOrder"

let User_GetProductBySearch = "SearchProducts"

let User_UpdateNotificationStatus = "UpdateNotificationStatus"
let User_SendBulkMessages = "SaveBulkMessage"
let User_GetBulkMessageList = "GetBulkMessagesList"

//VENDOR MODE

let User_GetAllMyClients = "GetMyClients"
let User_SaveClientMask = "SaveClientMask"
let User_GetMyStoreOrders = "GetOrders"
let User_GetMyStoreOrderDetails = "GetOrderDetail"

let User_GetMyStoreDiscountLinks = "GetDiscountProducts"
let User_SaveMyStoreDiscount = "SaveProductDiscount"

let User_GetStoreBookingList = "GetStoreBookingList"
let User_GetStoreBookingDetails = "GetStoreBookingDetail"

let User_AddStoreProduct = "SaveStoreProduct"
let User_EditStoreProduct = "EditStoreProduct"
let User_ActivateDeActivateStoreProduct = "DeleteStoreProduct"

let User_CheckLoyaltyReward = "CheckLoyaltyReward"
let User_AddLoyaltyReward = "AddLoyaltyReward"
let User_CheckNewUser = "CheckNewUser"
let User_SaveNewUserForReward = "SaveNewUserForReward"
let User_GetTopRewardList = "GetUserTopRewardList"
let User_AddUserRewardPurchase = "AddUserRewardPurchase"
let User_GetUserRewardHistory = "GetUserRewardHistory"

let User_GetStoreCheckList = "GetStoreChecklist"
let User_VerifyStore = "VerifyStore"

let User_AddReferralPoints = "api/user/add_referral_points"

let User_UpdateStoreNameNumber = "updateUserNamePhone"
let User_UpdateSlug = "api/user/change_slug"
let User_SetStoreVisible = "setStoreVisible"

let User_GetUser = "GetUser"
let User_AddPaymentRequest = "api/user/add_payment_request"

let User_GetAllFreeDeliveryStores = "api/user/get_free_delivery_store"


var dataManager = DataManager()

class DataManager : NSObject
{
    var appDelegate: AppDelegate?
    
    //NOTIFICATION REDIRECTION
    var boolIsSplashScreenPassed: Bool = false
    var boolIsAppOpenedFromNotification: Bool = false
    var strNotificationCode: String = ""
    var strNotificationID: String = ""
    
    let reachability = Reachability()!
    
    var strServerMessage: String = ""
    
    var currentLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    var boolIsCityHavingStorePromotionsOneHome: Bool = true
    
    //SPLASH/HOME
    var boolIsHideFreeDelivery: Bool = true
    var strStoreCountsInCity: String = ""
    var arrayAllMainScreenSearch = [ObjMainScreenSearch]()
    var arrayAllMainScreenPromotion = [ObjMainScreenPromotion]()
    var arrayAllCategories = [ObjCategory]()
    var arrayAllCategoriesForProducts = [ObjCategory]()
    var arrayAllCategoriesForAdd = [ObjCategory]()
    var arrayAllStorePromotionCategories = [ObjCategory]()
    var arrayStorePromotionCategoryIDs = [Int]()
    var arrayStorePromotionCategoryNames = [String]()
    var arrayAllStoreProducts = [ObjStoreProduct]()
    var objSelectedStoreProduct = ObjStoreProduct()
    var arrayAllWhatsappCategories = [ObjWhatsappCategory]()
    var arrayAllWhatsappGroups = [ObjWhatsappGroup]()
    
    var arrayProductsBySearch = [ObjStoreProduct]()
    
    var pageNumber = 1
    var totalPageNumber = 0
    var totalPageNumberForProducts = 0
    
    //SUB CATEGORY
    var arrayAllSubCategories = [ObjSubCategory]()
    
    //STORES LIST
    var arrayAllStores = [ObjStorePromotion]()
    
    //REGISTER MOBILE NUMBER
    var objUser: ObjUser = ObjUser()
    
    var arrayAllCities = [ObjCity]()
    var arrayCityIDs = [Int]()
    var arrayCityNames = [String]()
    
    //STORE DETAILS
    var objSelectedStoreDetails: ObjStoreDetails = ObjStoreDetails()
    var arrayAllReviews = [ObjReview]()
    var arrayStoreProducts = [ObjStoreProduct]()
    
    //PROMOTION DETAILS
    var objSelectedPromotionDetails: ObjPromotionDetails = ObjPromotionDetails()
    
    var arrayHotpromotions = [ObjStorePromotion]()
    
    //RECENT STORES LIST
    var arrayAllRecentStores = [RecentStore]()
    
    //FAVOURITE STORES LIST
    var arrayAllFavouriteStores = [RecentStore]()
    
    //MY STORES LIST
    var arrayAllMyStores = [MyStore]()
    var arrayNotPremiumStores = [MyStore]()
    var arrayNotPremiumStoreIDs = [Int]()
    var arrayNotPremiumStoreNames = [String]()
    
    //MY STORE CLICK REPORTS
    var arrayAllMyStoreClickReports = [MyStoreClickReport]()
    var strMyStoreTotalClickCount: String = ""
    
     var strReferralLink: String = ""
     var strDownloads: String = ""
    
    //MY POINTS
    var strPoints = ""
    
    //CART
    var arrayAllStoreCartProducts = [ObjCartItem]()
    var strTotalMoney = ""
    var strTotalPoints = ""
    var strIsVerified = "0"
    var strNeedAddress = "0"
    
    var strProductCounts = "0"
    
    var arrayBulkMessageClusterList = [ObjBulkMessageCluster]()
    var arrayBulkMessageList = [ObjBulkMessage]()
    
    //VENDOR MODE
    
    var arrayMyClients = [ObjMyClient]()
    var arrayMyStoreOrdersCluster = [ObjMyStoreOrderCluster]()
    var arrayMyStoreOrders = [ObjMyStoreOrder]()
    var totalPageNumberForMyStoreOrders = 0
    var objSelectedStoreOrder = ObjMyStoreOrder()
    
    var arrayMyStoreDiscountLinks = [ObjDiscountLink]()
    var totalPageNumberForMyStoreDiscountLinks = 0
    
    var arrayStoreBookingList = [ObjBookingDate]()
    var objBookingDetails: ObjBookingDetails = ObjBookingDetails()
    
    var boolIsLoyaltyProgramExist: Bool = false
    var strPurchaseRequired: String = ""
    var strReward: String = ""
    var strTotalRewardUsers: String = ""
    
    var boolIsNewUser: Bool = false
    var intUserPurchase: Int = 0
    var intUserPurchaseRequired: Int = 0
    var objSelectedRewardUser: ObjRewardUser?
    
    var arrayTopRewardList = [ObjRewardUser]()
    var intAvailablePurchases: Int = 0
    
    var arrayRewardHistory = [ObjRewardHistory]()
    
    var strStoreName: String = ""
    var strStoreNumber: String = ""
    var strStoreSlug: String = ""
    var arrayStoreCheckList = [String]()
    
    var strVerifyMessage: String = ""
    
    var strPointsToolValues: String = ""
    var boolIsAppStorePointsReceived: Bool = false
    var boolIsInstagramPointsReceived: Bool = false
    var boolIsRequestUnderApproval: Bool = false
    
    //FREE DELIVERY
    var arrayAllFreeDeliveryStores = [ObjStorePromotion]()
    var totalPageNumberForFreeDeliveryStores = 0
    var strTotalFreeDeliveryStores: String = "0"
    
    override init()
    {
        super.init()
        
        //        self.objLoggedInUser = User()
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }
    
    func showInternetNotConnectedError()
    {
        //METHOD 2
        let alertViewController = NYAlertViewController()
        
        // Set a title and message
        alertViewController.title = "Você está sem internet!"
        alertViewController.message = "Verifique a sua conexão."
        
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
        
        // Add alert actions
        let okAction = NYAlertAction(
            title: "Go to Settings",
            style: .default,
            handler: { (action: NYAlertAction!) -> Void in
                AppDelegate.sharedInstance().window?.topMostController()?.dismiss(animated: true, completion: nil)
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
        })
        
        alertViewController.addAction(okAction)
        
        DispatchQueue.main.async {
            AppDelegate.sharedInstance().window?.topMostController()?.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func showAlertViewWithTitle(title: String, detail: String)
    {
        var strTitle : String = title
        var strDetails : String = ""
        
        if title == "Server Error" && (detail == nil || detail.count <= 0)
        {
            strDetails = "Oops! Something went wrong. Please try again later."
        }
        else if title == "Server Error" && (detail != nil || detail.count > 0)
        {
            strTitle = ""
            strDetails = detail
        }
        else
        {
            strDetails = detail
        }
        
        self.appDelegate?.dismissGlobalHUD()
        
        self.appDelegate?.showAlertViewWithTitle(title: strTitle, detail: strDetails)
    }
    
    func convertStringToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary as! [String : AnyObject]? as NSDictionary?
            } catch let error as NSError {
                var errorResponse = [String : AnyObject]()
                errorResponse["Error"] = "Issue" as AnyObject?
                print(error)
                return errorResponse as NSDictionary?
            }
        }
        return nil
    }
    
    func user_session_expired()
    {
        DispatchQueue.main.async(execute: {
            
            UserDefaults.standard.removeObject(forKey: "is_premiem")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "name")
            UserDefaults.standard.removeObject(forKey: "user_id")
            UserDefaults.standard.removeObject(forKey: "user_type")
            UserDefaults.standard.removeObject(forKey: "autologin")
            UserDefaults.standard.synchronize()
            
            let alertViewController = NYAlertViewController()
            
            // Set a title and message
            alertViewController.title = "Session Timeout"
            alertViewController.message = "Your session has been expired please login again to continue."
            
            // Customize appearance as desired
            alertViewController.view.tintColor = UIColor.white
            alertViewController.backgroundTapDismissalGestureEnabled = false
            alertViewController.swipeDismissalGestureEnabled = false
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
                                        
                    self.appDelegate!.window?.rootViewController? .dismiss(animated: true, completion: nil)
                    
                    //let viewController = User_LoginViewController()
                    //self.appDelegate!.navigationController!.pushViewController(viewController, animated: false)
            })
            
            alertViewController.addAction(okAction)
            
            self.appDelegate!.window?.rootViewController?.present(alertViewController, animated: true, completion: nil)
            
        })
    }
    
    // MARK: - API FUNCTIONS
    
    // MARK: - USER FUNCTION FOR GET DATA
    
    func user_GetSplashResponce()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            //appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetSplashResponce))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            let strFcmToken: String = "\(UserDefaults.standard.value(forKey: "fcmToken") ?? "")"
            let strUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "city_id": strSelectedCityID,
                "state_id": strSelectedStateID,
                "device_token": strFcmToken,
                "device_type": "3",
                "user_id": strUserID,
                "store_id": strSelectedStoreID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    let strHideFreeDelivery: String = "\(jsonResult["hideFreeDeliveryBtn"] ?? "0")"
                                    if (strHideFreeDelivery == "1")
                                    {
                                        self.boolIsHideFreeDelivery = true
                                    }
                                    else
                                    {
                                        self.boolIsHideFreeDelivery = false
                                    }
                                    
                                    //counts
                                    self.strStoreCountsInCity = "\(jsonResult["counts"] ?? "0")"
                                    
                                    let filepath = Bundle.main.path(forResource: "home", ofType: "json")
                                    let filedata = NSData(contentsOfFile: filepath!)
                                    
                                    let jsonData = Data(referencing: filedata!)
                                    
                                    do {
                                        let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options:JSONSerialization.ReadingOptions(rawValue: 0))
                                        guard let localJsonResult = jsonObject as? Dictionary<String, Any> else {
                                            return
                                        }
                                        
                                        //MAIN SCREEN SEARCH
                                        self.arrayAllMainScreenSearch = [ObjMainScreenSearch]()
                                        //let arrayMainScreenSearchLocal = localJsonResult["main_screen_search_details"] as? NSArray
                                        let arrayMainScreenSearchLocal = jsonResult["main_screen_search_details"] as? NSArray
                                        if (arrayMainScreenSearchLocal != nil)
                                        {
                                            for objMainScreenSearchTemp in arrayMainScreenSearchLocal!
                                            {
                                                let objMainScreenSearchDictionary = objMainScreenSearchTemp as? NSDictionary
                                                
                                                let objNewMainScreenSearch : ObjMainScreenSearch = ObjMainScreenSearch()
                                                objNewMainScreenSearch.separateParametersForMainScreenSearch(dictionary: objMainScreenSearchDictionary as! Dictionary<String, Any>)
                                                
                                                self.arrayAllMainScreenSearch.append(objNewMainScreenSearch)
                                            }
                                        }
                                        
                                        //MAIN SCREEN PROMOTION
                                        self.arrayAllMainScreenPromotion = [ObjMainScreenPromotion]()
                                        //let arrayMainScreenPromotionLocal = localJsonResult["main_screen_promotion_details"] as? NSArray
                                        let arrayMainScreenPromotionLocal = jsonResult["main_screen_promotion_details"] as? NSArray
                                        if (arrayMainScreenPromotionLocal != nil)
                                        {
                                            for objMainScreenPromotionTemp in arrayMainScreenPromotionLocal!
                                            {
                                                let objMainScreenPromotionDictionary = objMainScreenPromotionTemp as? NSDictionary
                                                
                                                let objNewMainScreenPromotion : ObjMainScreenPromotion = ObjMainScreenPromotion()
                                                objNewMainScreenPromotion .separateParametersForMainScreenPromotion(dictionary: objMainScreenPromotionDictionary as! Dictionary<String, Any>)
                                                
                                                self.arrayAllMainScreenPromotion .append(objNewMainScreenPromotion)
                                            }
                                        }
                                        
                                        //CATEGORIES
                                        self.arrayAllCategories = [ObjCategory]()
                                        let arrayCategoriesLocal = jsonResult["Categories"] as? NSArray
                                        if (arrayCategoriesLocal != nil)
                                        {
                                            for objCategoryTemp in arrayCategoriesLocal!
                                            {
                                                let objCategoryDictionary = objCategoryTemp as? NSDictionary
                                                
                                                let objNewCategory : ObjCategory = ObjCategory()
                                                objNewCategory .separateParametersForCategory(dictionary: objCategoryDictionary as! Dictionary<String, Any>)
                                                
                                                
                                                self.arrayAllCategories .append(objNewCategory)
                                            }
                                        }
                                        
                                        //CATEGORIES FOR PRODUCTS
                                        self.arrayAllCategoriesForProducts = [ObjCategory]()
                                        let arrayCategoriesForProductLocal = jsonResult["productCategories"] as? NSArray
                                        if (arrayCategoriesForProductLocal != nil)
                                        {
                                            for objCategoryTemp in arrayCategoriesForProductLocal!
                                            {
                                                let objCategoryDictionary = objCategoryTemp as? NSDictionary
                                                
                                                let objNewCategory : ObjCategory = ObjCategory()
                                                objNewCategory .separateParametersForCategory(dictionary: objCategoryDictionary as! Dictionary<String, Any>)
                                                
                                                
                                                self.arrayAllCategoriesForProducts .append(objNewCategory)
                                            }
                                        }
                                        
                                        //Whatsapp Categories
                                        self.arrayAllWhatsappCategories = [ObjWhatsappCategory]()
                                        let arrayWhatsappCategoriesLocal = jsonResult["whatsappCategories"] as? NSArray
                                        if (arrayWhatsappCategoriesLocal != nil)
                                        {
                                            for objWhatsappCategoryTemp in arrayWhatsappCategoriesLocal!
                                            {
                                                let objWhatsappCategoryDictionary = objWhatsappCategoryTemp as? NSDictionary
                                                
                                                let objNewWhatsappCategory : ObjWhatsappCategory = ObjWhatsappCategory()
                                                objNewWhatsappCategory.separateParametersForWhatsappCategory(dictionary: objWhatsappCategoryDictionary as! Dictionary<String, Any>)
                                                
                                                self.arrayAllWhatsappCategories.append(objNewWhatsappCategory)
                                            }
                                        }
                                        
                                        } catch let error as NSError {
                                            print("Found an error - \(error)")
                                            let message = error.localizedDescription as? String
                                            self.showAlertViewWithTitle(title: "", detail: message!)
                                        }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetSplashResponceEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }

                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR REGISTER MOBILE NUMBER
    
    func user_Register(strName: String, strMobileNumber: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_Register))!

            //var array = [URLQueryItem]()
                                        
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
            //urlComponents.queryItems = array
            
            let strFcmToken: String = "\(UserDefaults.standard.value(forKey: "fcmToken") ?? "")"
            
            let strReferrerUid: String = "\(UserDefaults.standard.value(forKey: "referrerUid") ?? "")"
            
            let parameters = [
                "access_key" : "AFDlf7odf8jkfljalk098fdjR",
                "device_type" : "3",
                "user_role" : "USER",
                "device_token" : "\(strFcmToken)",
                "name" : "\(strName)",
                "phone_number" : "\(strMobileNumber)",
                "parent_id": strReferrerUid
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strServerMessage = "\(jsonResult["message"] ?? "")"
                                    
                                    if let objTempUser: Dictionary<String, Any> = jsonResult["User"] as? Dictionary<String, Any>
                                    {
                                        self.objUser = ObjUser()
                                        self.objUser.separateParametersForUser(dictionary: objTempUser)
                                        
                                        UserDefaults.standard.setValue(self.objUser.strUserID, forKey: "user_id")
                                        UserDefaults.standard.setValue(self.objUser.strSocialMediaID, forKey: "social_media_id")
                                        UserDefaults.standard.setValue(self.objUser.strUserRole, forKey: "user_role")
                                        UserDefaults.standard.setValue(self.objUser.strFirstName, forKey: "first_name")
                                        UserDefaults.standard.setValue(self.objUser.strLastName, forKey: "last_name")
                                        UserDefaults.standard.setValue(self.objUser.strEmail, forKey: "email")
                                        UserDefaults.standard.setValue(self.objUser.strPhoneNumber, forKey: "phone_number")
                                        UserDefaults.standard.setValue(self.objUser.strGUID, forKey: "guid")
                                        UserDefaults.standard.setValue(self.objUser.strPassword, forKey: "password")
                                        UserDefaults.standard.setValue(self.objUser.strParentId, forKey: "parent_id")
                                        
                                        UserDefaults.standard.setValue(self.objUser.strStoreID, forKey: "selected_store_id")
                                        UserDefaults.standard.setValue(self.objUser.strFirstName, forKey: "selected_store_name")
                                        
                                        print("self.objUser.strPassword: \(self.objUser.strPassword)")
                                        
    //                                    let password: String = "\(jsonResult["password"] ?? "")"
    //                                    UserDefaults.standard.setValue(password, forKey: "password")
                                        
                                        UserDefaults.standard.synchronize()
                                        
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "user_RegisterEvent"), object: self)
                                    }
                                }
                                else
                                {
                                    var message: String = "\(jsonResult["message"] ?? "")"
                                    if (message == "phone_exist")
                                    {
                                        message = "Telefone já existe. Faça o login."
                                    }
                                    else if (message == "invalid_params")
                                    {
                                        message = "Parâmetros inválidos"
                                    }
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
        
    // MARK: - USER FUNCTION FOR REGISTER MOBILE NUMBER
    
    func user_RegisterMobileNumber(strMobileNumber: String, strReferralCode: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_RegisterMobileNumber))!

            //var array = [URLQueryItem]()
                                        
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
            //urlComponents.queryItems = array
            
            let strFcmToken: String = "\(UserDefaults.standard.value(forKey: "fcmToken") ?? "")"
            
            let strReferrerUid: String = "\(UserDefaults.standard.value(forKey: "referrerUid") ?? "")"
            
            let parameters = [
                "access_key" : "AFDlf7odf8jkfljalk098fdjR",
                "device_type" : "3",
                "user_role" : "USER",
                "device_token" : "\(strFcmToken)",
                "phone_number" : "\(strMobileNumber)",
                "referral_code": strReferralCode,
                "parent_id": strReferrerUid
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strServerMessage = "\(jsonResult["message"] ?? "")"
                                    
                                    let arrayUsersLocal = jsonResult["User"] as? NSArray
                                    
                                    if (arrayUsersLocal != nil)
                                    {
                                        if (arrayUsersLocal!.count > 0)
                                        {
                                            let objUserDictionary = arrayUsersLocal![0] as? NSDictionary
                                            
                                            self.objUser = ObjUser()
                                            self.objUser.separateParametersForUser(dictionary: objUserDictionary as! Dictionary<String, Any>)
                                        }
                                    }
                                    
                                    UserDefaults.standard.setValue(self.objUser.strUserID, forKey: "user_id")
                                    UserDefaults.standard.setValue(self.objUser.strSocialMediaID, forKey: "social_media_id")
                                    UserDefaults.standard.setValue(self.objUser.strUserRole, forKey: "user_role")
                                    UserDefaults.standard.setValue(self.objUser.strFirstName, forKey: "first_name")
                                    UserDefaults.standard.setValue(self.objUser.strLastName, forKey: "last_name")
                                    UserDefaults.standard.setValue(self.objUser.strEmail, forKey: "email")
                                    UserDefaults.standard.setValue(self.objUser.strPhoneNumber, forKey: "phone_number")
                                    UserDefaults.standard.setValue(self.objUser.strGUID, forKey: "guid")
                                    UserDefaults.standard.setValue(self.objUser.strPassword, forKey: "password")
                                    UserDefaults.standard.setValue(self.objUser.strParentId, forKey: "parent_id") //n
                                    
                                    let newUserFlag = "\((jsonResult["new_user"] as? Int) ?? 0)"
                                    UserDefaults.standard.setValue(newUserFlag, forKey: "new_user")
                                    
                                    UserDefaults.standard.setValue(self.objUser.strStateID, forKey: "state_id")
                                    UserDefaults.standard.setValue("\(self.objUser.strCityID)", forKey: "city_id")
                                    UserDefaults.standard.setValue(self.objUser.strCityName, forKey: "city_name")
                                    
                                    UserDefaults.standard.setValue(self.objUser.strStoreID, forKey: "selected_store_id")
                                    UserDefaults.standard.setValue(self.objUser.strFirstName, forKey: "selected_store_name")
                                    
                                    print("self.objUser.strPassword: \(self.objUser.strPassword)")
                                    
//                                    let password: String = "\(jsonResult["password"] ?? "")"
//                                    UserDefaults.standard.setValue(password, forKey: "password")
                                    
                                    UserDefaults.standard.synchronize()
                                    
                                    //SPLASH DATA
                                    //counts
                                    self.strStoreCountsInCity = "\(jsonResult["counts"] ?? "0")"
                                    
                                    //MAIN SCREEN SEARCH
                                    self.arrayAllMainScreenSearch = [ObjMainScreenSearch]()
                                    //let arrayMainScreenSearchLocal = localJsonResult["main_screen_search_details"] as? NSArray
                                    let arrayMainScreenSearchLocal = jsonResult["main_screen_search_details"] as? NSArray
                                    if (arrayMainScreenSearchLocal != nil)
                                    {
                                        for objMainScreenSearchTemp in arrayMainScreenSearchLocal!
                                        {
                                            let objMainScreenSearchDictionary = objMainScreenSearchTemp as? NSDictionary
                                            
                                            let objNewMainScreenSearch : ObjMainScreenSearch = ObjMainScreenSearch()
                                            objNewMainScreenSearch.separateParametersForMainScreenSearch(dictionary: objMainScreenSearchDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllMainScreenSearch.append(objNewMainScreenSearch)
                                        }
                                    }
                                    
                                    //MAIN SCREEN PROMOTION
                                    self.arrayAllMainScreenPromotion = [ObjMainScreenPromotion]()
                                    //let arrayMainScreenPromotionLocal = localJsonResult["main_screen_promotion_details"] as? NSArray
                                    let arrayMainScreenPromotionLocal = jsonResult["main_screen_promotion_details"] as? NSArray
                                    if (arrayMainScreenPromotionLocal != nil)
                                    {
                                        for objMainScreenPromotionTemp in arrayMainScreenPromotionLocal!
                                        {
                                            let objMainScreenPromotionDictionary = objMainScreenPromotionTemp as? NSDictionary
                                            
                                            let objNewMainScreenPromotion : ObjMainScreenPromotion = ObjMainScreenPromotion()
                                            objNewMainScreenPromotion .separateParametersForMainScreenPromotion(dictionary: objMainScreenPromotionDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllMainScreenPromotion .append(objNewMainScreenPromotion)
                                        }
                                    }
                                    
                                    //CATEGORIES
                                    self.arrayAllCategories = [ObjCategory]()
                                    let arrayCategoriesLocal = jsonResult["Categories"] as? NSArray
                                    if (arrayCategoriesLocal != nil)
                                    {
                                        for objCategoryTemp in arrayCategoriesLocal!
                                        {
                                            let objCategoryDictionary = objCategoryTemp as? NSDictionary
                                            
                                            let objNewCategory : ObjCategory = ObjCategory()
                                            objNewCategory .separateParametersForCategory(dictionary: objCategoryDictionary as! Dictionary<String, Any>)
                                            
                                            
                                            self.arrayAllCategories .append(objNewCategory)
                                        }
                                    }
                                    
                                    //CATEGORIES FOR PRODUCTS
                                    self.arrayAllCategoriesForProducts = [ObjCategory]()
                                    let arrayCategoriesForProductLocal = jsonResult["productCategories"] as? NSArray
                                    if (arrayCategoriesForProductLocal != nil)
                                    {
                                        for objCategoryTemp in arrayCategoriesForProductLocal!
                                        {
                                            let objCategoryDictionary = objCategoryTemp as? NSDictionary
                                            
                                            let objNewCategory : ObjCategory = ObjCategory()
                                            objNewCategory .separateParametersForCategory(dictionary: objCategoryDictionary as! Dictionary<String, Any>)
                                            
                                            
                                            self.arrayAllCategoriesForProducts .append(objNewCategory)
                                        }
                                    }
                                    
                                    //Whatsapp Categories
                                    self.arrayAllWhatsappCategories = [ObjWhatsappCategory]()
                                    let arrayWhatsappCategoriesLocal = jsonResult["whatsappCategories"] as? NSArray
                                    if (arrayWhatsappCategoriesLocal != nil)
                                    {
                                        for objWhatsappCategoryTemp in arrayWhatsappCategoriesLocal!
                                        {
                                            let objWhatsappCategoryDictionary = objWhatsappCategoryTemp as? NSDictionary
                                            
                                            let objNewWhatsappCategory : ObjWhatsappCategory = ObjWhatsappCategory()
                                            objNewWhatsappCategory.separateParametersForWhatsappCategory(dictionary: objWhatsappCategoryDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllWhatsappCategories.append(objNewWhatsappCategory)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_RegisterMobileNumberEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL COUNTRIES
    
    func user_GetAllCountries()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllCities))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    //let dictionaryData = jsonResult["data"] as? NSDictionary
                                    
                                    self.arrayAllCities = [ObjCity]()
                                    self.arrayCityIDs = [Int]()
                                    self.arrayCityNames = [String]()
                                    let arrayCitiesLocal = jsonResult["Cities"] as? NSArray
                                    if (arrayCitiesLocal != nil)
                                    {
                                        for objCityTemp in arrayCitiesLocal!
                                        {
                                            let objCityDictionary = objCityTemp as? NSDictionary
                                            
                                            let objNewCity : ObjCity = ObjCity()
                                            objNewCity.separateParametersForCity(dictionary: objCityDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayCityIDs.append(Int(objNewCity.intCityID))
                                            self.arrayCityNames.append(objNewCity.strCityName)
                                            self.arrayAllCities.append(objNewCity)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllCountriesEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR UPDATE STORE CLICKS
    
    func user_UpdateStoreClicks(strStoreID: String, strScreenID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            //appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_UpdateStoreClicks))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "screen_id": strScreenID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_UpdateStoreClicksEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL STORE PRODUCTS
    
    func user_GetAllStoreProducts(strCategoryID: String, strOrderBy: String, strPageNumber: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllStoreProducts))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            self.strProductCounts = "0"
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "is_promo": "1",
                "category_id": strCategoryID,
                "city_id": strSelectedCityID,
                "state_id": strSelectedStateID,
                "order_by": strOrderBy,
                "page_number": strPageNumber
            ]
            
            /*
             GetProducts

            added param order_by, page_number
            - If user clicks on products at bottom tab above api will be called
            */
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.boolIsCityHavingStorePromotionsOneHome = true
                                    
                                    self.totalPageNumberForProducts = Int("\(jsonResult["total_pages"] ?? "0")") ?? 0
                                    
                                    self.strProductCounts = "\(jsonResult["total_products"] ?? "0")"
                                    
                                    //STORE PRODUCTS
                                    if (strPageNumber == "1")
                                    {
                                        self.arrayAllStoreProducts = [ObjStoreProduct]()
                                    }
                                    
                                    let arrayStoreProductsLocal = jsonResult["products"] as? NSArray
                                    if (arrayStoreProductsLocal != nil)
                                    {
                                        for objStorePromotionTemp in arrayStoreProductsLocal!
                                        {
                                            let objStorePromotionDictionary = objStorePromotionTemp as? NSDictionary
                                            
                                            let objNewStoreProduct : ObjStoreProduct = ObjStoreProduct()
                                            objNewStoreProduct .separateParametersForStoreProduct(dictionary: objStorePromotionDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllStoreProducts .append(objNewStoreProduct)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllStoreProductsEvent"), object: self)
                                }
                                else
                                {
                                    let strBlocked: String = "\(jsonResult["blocked"] ?? "0")"
                                    
                                    if(strBlocked == "1")
                                    {
                                        let strBlockedTitle: String = "\(jsonResult["blocked_msg_title"] ?? "")"
                                        let strBlockedMessage: String = "\(jsonResult["blocked_msg_desc"] ?? "")"
                                        self.showAlertViewWithTitle(title: strBlockedTitle, detail: strBlockedMessage)
                                    }
                                    else
                                    {
                                        let message: String = "\(jsonResult["message"] ?? "")"
                                        if (message == "There are no any Products found from any store.")
                                        {
                                            self.boolIsCityHavingStorePromotionsOneHome = false
                                        }
                                        else
                                        {
                                            self.showAlertViewWithTitle(title: "", detail: message)
                                        }
                                    }
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL STORE PRODUCTS FOR STORE
    
    func user_GetAllStoreProductsForStore(strStoreID: String, strPageNumber: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllStoreProductsList))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            self.strProductCounts = "0"
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "city_id": strSelectedCityID,
                "page_number": strPageNumber
            ]
            
            /*
             GetProducts

            added param order_by, page_number
            - If user clicks on products at bottom tab above api will be called
            */
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.boolIsCityHavingStorePromotionsOneHome = true
                                    
                                    self.totalPageNumberForProducts = Int("\(jsonResult["total_pages"] ?? "0")") ?? 0
                                    
                                    self.strProductCounts = "\(jsonResult["total_products"] ?? "0")"
                                    
                                    //STORE PRODUCTS
                                    if (strPageNumber == "1")
                                    {
                                        self.arrayAllStoreProducts = [ObjStoreProduct]()
                                    }
                                    
                                    let arrayStoreProductsLocal = jsonResult["products"] as? NSArray
                                    if (arrayStoreProductsLocal != nil)
                                    {
                                        for objStorePromotionTemp in arrayStoreProductsLocal!
                                        {
                                            let objStorePromotionDictionary = objStorePromotionTemp as? NSDictionary
                                            
                                            let objNewStoreProduct : ObjStoreProduct = ObjStoreProduct()
                                            objNewStoreProduct .separateParametersForStoreProduct(dictionary: objStorePromotionDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllStoreProducts .append(objNewStoreProduct)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllStoreProductsEvent"), object: self)
                                }
                                else
                                {
                                    let strBlocked: String = "\(jsonResult["blocked"] ?? "0")"
                                    
                                    if(strBlocked == "1")
                                    {
                                        let strBlockedTitle: String = "\(jsonResult["blocked_msg_title"] ?? "")"
                                        let strBlockedMessage: String = "\(jsonResult["blocked_msg_desc"] ?? "")"
                                        self.showAlertViewWithTitle(title: strBlockedTitle, detail: strBlockedMessage)
                                    }
                                    else
                                    {
                                        let message: String = "\(jsonResult["message"] ?? "")"
                                        if (message == "There are no any Products found from any store.")
                                        {
                                            self.boolIsCityHavingStorePromotionsOneHome = false
                                        }
                                        else
                                        {
                                            self.showAlertViewWithTitle(title: "", detail: message)
                                        }
                                    }
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL STORE PRODUCTS FOR DISCOUNT
    
    func user_GetAllStoreProductsForDiscount(strStoreID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllStoreProducts))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            self.strProductCounts = "0"
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "city_id": strSelectedCityID
            ]
            
            /*
             GetProducts

            added param order_by, page_number
            - If user clicks on products at bottom tab above api will be called
            */
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.boolIsCityHavingStorePromotionsOneHome = true
                                    
                                    self.totalPageNumberForProducts = Int("\(jsonResult["total_pages"] ?? "0")") ?? 0
                                    
                                    self.strProductCounts = "\(jsonResult["total_products"] ?? "0")"
                                    
                                    //STORE PRODUCTS
                                    self.arrayAllStoreProducts = [ObjStoreProduct]()
                                    
                                    let arrayStoreProductsLocal = jsonResult["products"] as? NSArray
                                    if (arrayStoreProductsLocal != nil)
                                    {
                                        for objStorePromotionTemp in arrayStoreProductsLocal!
                                        {
                                            let objStorePromotionDictionary = objStorePromotionTemp as? NSDictionary
                                            
                                            let objNewStoreProduct : ObjStoreProduct = ObjStoreProduct()
                                            objNewStoreProduct .separateParametersForStoreProduct(dictionary: objStorePromotionDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllStoreProducts .append(objNewStoreProduct)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllStoreProductsEvent"), object: self)
                                }
                                else
                                {
                                    let strBlocked: String = "\(jsonResult["blocked"] ?? "0")"
                                    
                                    if(strBlocked == "1")
                                    {
                                        let strBlockedTitle: String = "\(jsonResult["blocked_msg_title"] ?? "")"
                                        let strBlockedMessage: String = "\(jsonResult["blocked_msg_desc"] ?? "")"
                                        self.showAlertViewWithTitle(title: strBlockedTitle, detail: strBlockedMessage)
                                    }
                                    else
                                    {
                                        let message: String = "\(jsonResult["message"] ?? "")"
                                        if (message == "There are no any Products found from any store.")
                                        {
                                            self.boolIsCityHavingStorePromotionsOneHome = false
                                        }
                                        else
                                        {
                                            self.showAlertViewWithTitle(title: "", detail: message)
                                        }
                                    }
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET STORE PRODUCT DETAILS
    
    func user_GetStoreProductDetails(strProductID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetStoreProductDetails))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "product_id": strProductID
            ]
            
            /*
             GetProductDetail

            added param product_id
            - If user clicks on product above api will be called to get product details
            */
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        //self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strPoints = "\(jsonResult["points"] ?? "0")"
                                    
                                    self.boolIsCityHavingStorePromotionsOneHome = true
                                    
                                    //CATEGORIES
                                    
                                    //STORE PRODUCT DETAILS
                                    self.objSelectedStoreProduct = ObjStoreProduct()
                                    if let objData = jsonResult["product"] as? Dictionary<String, Any>
                                    {
                                        self.objSelectedStoreProduct .separateParametersForStoreProduct(dictionary: objData)
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetStoreProductDetailsEvent"), object: self)
                                }
                                else
                                {
                                    let strBlocked: String = "\(jsonResult["blocked"] ?? "0")"
                                    
                                    if(strBlocked == "1")
                                    {
                                        let strBlockedTitle: String = "\(jsonResult["blocked_msg_title"] ?? "")"
                                        let strBlockedMessage: String = "\(jsonResult["blocked_msg_desc"] ?? "")"
                                        self.showAlertViewWithTitle(title: strBlockedTitle, detail: strBlockedMessage)
                                    }
                                    else
                                    {
                                        let message: String = "\(jsonResult["message"] ?? "")"
                                        if (message == "There are no any Products found from any store.")
                                        {
                                            self.boolIsCityHavingStorePromotionsOneHome = false
                                        }
                                        else
                                        {
                                            self.showAlertViewWithTitle(title: "", detail: message)
                                        }
                                    }
                                }
                            })
                            
                        }
                        else
                        {
                            self.appDelegate?.dismissGlobalHUD()
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET PRODUCTS BY SEARCH
    
    func user_GetProductsBySearch(strStoreID: String, strSearchText: String, strOrderBy: String, strPageNumber: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetProductBySearch))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            self.strProductCounts = "0"
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "city_id": strSelectedCityID,
                (strStoreID == "" ? "search_text" : "store_id"): (strStoreID == "" ? strSearchText : strStoreID),
                "order_by": strOrderBy,
                "page_number": strPageNumber
            ]
            
            /*
             SearchProducts

            added param city_id, order_by, page_number
            - If user clicks on products at bottom tab above api will be called
            */
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    
                                    self.totalPageNumberForProducts = Int("\(jsonResult["total_pages"] ?? "0")") ?? 0
                                    
                                    self.strProductCounts = "\(jsonResult["total_products"] ?? "0")"
                                    
                                    //STORE PRODUCTS
                                    if (strPageNumber == "1")
                                    {
                                        self.arrayProductsBySearch = [ObjStoreProduct]()
                                    }
                                    
                                    let arrayStoreProductsLocal = jsonResult["products"] as? NSArray
                                    if (arrayStoreProductsLocal != nil)
                                    {
                                        for objStorePromotionTemp in arrayStoreProductsLocal!
                                        {
                                            let objStorePromotionDictionary = objStorePromotionTemp as? NSDictionary
                                            
                                            let objNewStoreProduct : ObjStoreProduct = ObjStoreProduct()
                                            objNewStoreProduct .separateParametersForStoreProduct(dictionary: objStorePromotionDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayProductsBySearch .append(objNewStoreProduct)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetProductsBySearchEvent"), object: self)
                                }
                                else
                                {
                                    let strBlocked: String = "\(jsonResult["blocked"] ?? "0")"
                                    
                                    if(strBlocked == "1")
                                    {
                                        let strBlockedTitle: String = "\(jsonResult["blocked_msg_title"] ?? "")"
                                        let strBlockedMessage: String = "\(jsonResult["blocked_msg_desc"] ?? "")"
                                        self.showAlertViewWithTitle(title: strBlockedTitle, detail: strBlockedMessage)
                                    }
                                    else
                                    {
                                        let message: String = "\(jsonResult["message"] ?? "")"
                                        if (message == "There are no any Products found from any store.")
                                        {
                                            self.boolIsCityHavingStorePromotionsOneHome = false
                                        }
                                        else
                                        {
                                            self.showAlertViewWithTitle(title: "", detail: message)
                                        }
                                    }
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- USER FUNCTION FOR GET ALL WHATSAPP GROUP
    func user_GetAllWhatsappGroups(strSearchText: String, strCategoryId: String, strPageNumber: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetWhatsappGroups))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "city_id": strSelectedCityID,
                "state_id": strSelectedStateID,
                "search_text": strSearchText,
                "category_id": strCategoryId,
                "page_number": strPageNumber
            ]
            
            /*
             API : GetWhatsappGroups
             Optional params : category_id,search_text,page_number
             By default when you open the screen, page_number should be 1 and then infinite loading should be implemented,
             On the whatsapp groups screen, there is a filter for category on the top right, When someone selects any filter, you will send category_id
             On the search Results screen, You will send me search_text. Which will be category name if someone lands on it using category screens.
            */
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                //Int("\(dictionary["id"] ?? "0")") ?? 0
                                let intTotalPages: Int = Int("\(jsonResult["total_pages"] ?? "0")") ?? 0
                                //"total_pages": 3,
                                self.totalPageNumber = intTotalPages
                                
                                if(strStatus == "1")
                                {
                                    if strPageNumber != String(self.pageNumber) /*&& self.pageNumber != 1 */ {
                                        if Int(strPageNumber)! < intTotalPages {
                                            self.pageNumber = Int(strPageNumber)!
                                            
                                            let arrayWhatsappGroupsLocal = jsonResult["WhatsappGroups"] as? NSArray
                                            if (arrayWhatsappGroupsLocal != nil)
                                            {
                                                for objGroupTemp in arrayWhatsappGroupsLocal!
                                                {
                                                    let objGroupDictionary = objGroupTemp as? NSDictionary
                                                    
                                                    let objNewGroup : ObjWhatsappGroup = ObjWhatsappGroup()
                                                    objNewGroup.separateParametersForWhatsappGroup(dictionary: objGroupDictionary as! Dictionary<String, Any>)
                                                    
                                                    self.arrayAllWhatsappGroups.append(objNewGroup)
                                                }
                                            }
                                            
                                        }
                                    } else {
                                        
                                        self.pageNumber = Int(strPageNumber)!
                                        
                                        self.arrayAllWhatsappGroups = [ObjWhatsappGroup]()
                                        
                                        let arrayWhatsappGroupsLocal = jsonResult["WhatsappGroups"] as? NSArray
                                        if (arrayWhatsappGroupsLocal != nil)
                                        {
                                            for objGroupTemp in arrayWhatsappGroupsLocal!
                                            {
                                                let objGroupDictionary = objGroupTemp as? NSDictionary
                                                
                                                let objNewGroup : ObjWhatsappGroup = ObjWhatsappGroup()
                                                objNewGroup.separateParametersForWhatsappGroup(dictionary: objGroupDictionary as! Dictionary<String, Any>)
                                                
                                                self.arrayAllWhatsappGroups.append(objNewGroup)
                                            }
                                        }
                                        
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllWhatsappGroupEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- ADD WHATSAPP GROUP
    func user_AddWhatsappGroups(strGroupCategory: String, strGroupUrl: String, strGroupTitle: String, strGroupDescription: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_AddWhatsappGroup))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "group_category": strGroupCategory,
                "group_url": strGroupUrl,
                "title": strGroupTitle,
                "description": strGroupDescription,
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    /*
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                    */
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_AddWhatsappGroupEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL CATEGORIES
    
    func user_GetAllCategories()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            //appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllCategories))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "city_id": strSelectedCityID,
                "state_id": strSelectedStateID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    //SUB CATEGORIES
                                    self.arrayAllCategoriesForAdd = [ObjCategory]()
                                    let arrayCategoriesLocal = jsonResult["Categories"] as? NSArray
                                    if (arrayCategoriesLocal != nil)
                                    {
                                        for objCategoryTemp in arrayCategoriesLocal!
                                        {
                                            let objCategoryDictionary = objCategoryTemp as? NSDictionary
                                            
                                            let objNewCategory : ObjCategory = ObjCategory()
                                            objNewCategory .separateParametersForCategory(dictionary: objCategoryDictionary as! Dictionary<String, Any>)
                                            
                                            
                                            self.arrayAllCategoriesForAdd .append(objNewCategory)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllCategoriesEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL SUB CATEGORIES
    
    func user_GetAllSubCategories(strCategoryID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllSubCategories))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "city_id": strSelectedCityID,
                "state_id": strSelectedStateID,
                "category_id" : strCategoryID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    //SUB CATEGORIES
                                    self.arrayAllSubCategories = [ObjSubCategory]()
                                    let arraySubCategoriesLocal = jsonResult["SubCategories"] as? NSArray
                                    if (arraySubCategoriesLocal != nil)
                                    {
                                        for objSubCategoryTemp in arraySubCategoriesLocal!
                                        {
                                            let objSubCategoryDictionary = objSubCategoryTemp as? NSDictionary
                                            
                                            let objNewSubCategory : ObjSubCategory = ObjSubCategory()
                                            objNewSubCategory .separateParametersForSubCategory(dictionary: objSubCategoryDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllSubCategories .append(objNewSubCategory)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllSubCategoriesEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL SUB CATEGORIES FOR ADD STORE
    
    func user_GetAllSubCategoriesForAddStore(strCategoryID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllSubCategories))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "category_id" : strCategoryID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    //SUB CATEGORIES
                                    self.arrayAllSubCategories = [ObjSubCategory]()
                                    let arraySubCategoriesLocal = jsonResult["SubCategories"] as? NSArray
                                    if (arraySubCategoriesLocal != nil)
                                    {
                                        for objSubCategoryTemp in arraySubCategoriesLocal!
                                        {
                                            let objSubCategoryDictionary = objSubCategoryTemp as? NSDictionary
                                            
                                            let objNewSubCategory : ObjSubCategory = ObjSubCategory()
                                            objNewSubCategory .separateParametersForSubCategory(dictionary: objSubCategoryDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllSubCategories .append(objNewSubCategory)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllSubCategoriesEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL STORES BY SUB CATEGORY
    
    func user_GetAllStoresBySubCategories(strCategoryID: String, strSubCategoryID: String, strDistanceRange: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllStoresBySubCategory))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let strLatitude: String = "\(self.currentLocation.coordinate.latitude)"
            let strLongitude: String = "\(self.currentLocation.coordinate.longitude)"
            
            var parameters: [String: Any]
            
            if (strDistanceRange != "")
            {
                parameters = [
                    "access_key": "AFDlf7odf8jkfljalk098fdjR",
                    "device_type": "3",
                    "user_id": strLogedInUserID,
                    "city_id": strSelectedCityID,
                    "state_id": strSelectedStateID,
                    "category_id" : strCategoryID,
                    "subCategory_id" : strSubCategoryID,
                    "lat": strLatitude,
                    "lng": strLongitude,
                    "search_type": "2",
                    "distance": strDistanceRange
                ]
            }
            else
            {
                parameters = [
                    "access_key": "AFDlf7odf8jkfljalk098fdjR",
                    "device_type": "3",
                    "user_id": strLogedInUserID,
                    "city_id": strSelectedCityID,
                    "category_id" : strCategoryID,
                    "subCategory_id" : strSubCategoryID
                ]
            }
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    //SUB CATEGORIES
                                    self.arrayAllStores = [ObjStorePromotion]()
                                    let arrayStoresLocal = jsonResult["Stores"] as? NSArray
                                    if (arrayStoresLocal != nil)
                                    {
                                        for objStoreTemp in arrayStoresLocal!
                                        {
                                            let objStoreDictionary = objStoreTemp as? NSDictionary
                                            
                                            let objNewStore : ObjStorePromotion = ObjStorePromotion()
                                            objNewStore .separateParametersForStoreList(dictionary: objStoreDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllStores .append(objNewStore)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllStoresBySubCategoriesEvent"), object: self)
                                }
                                else
                                {
                                    let strBlocked: String = "\(jsonResult["blocked"] ?? "0")"
                                    
                                    if(strBlocked == "1")
                                    {
                                        let strBlockedTitle: String = "\(jsonResult["blocked_msg_title"] ?? "")"
                                        let strBlockedMessage: String = "\(jsonResult["blocked_msg_desc"] ?? "")"
                                        self.showAlertViewWithTitle(title: strBlockedTitle, detail: strBlockedMessage)
                                    }
                                    else
                                    {
                                        let message: String = "\(jsonResult["blocked_msg_desc"] ?? "")"
                                        self.showAlertViewWithTitle(title: "", detail: NSLocalizedString("no_store_found", value:"Nenhum negócio encontrado.", comment: ""))
                                    }
                                    
                                    self.arrayAllStores.removeAll() //n clear all strores to solve drop down issue
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
//    // MARK: - USER FUNCTION FOR GET ALL STORES BY SUB CATEGORY
//
//    func user_GetAllStoresBySearch(strSearchText: String, strDistanceRange: String)
//    {
//        if (reachability.whenReachable != nil && reachability.connection != .none)
//        {
//            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
//
//            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllStoresBySearch))!
//
//            //var array = [URLQueryItem]()
//
//            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
//
//            //urlComponents.queryItems = array
//
//            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
//            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
//
//            let strLatitude: String = "\(self.currentLocation.coordinate.latitude)"
//            let strLongitude: String = "\(self.currentLocation.coordinate.longitude)"
//
//            var parameters: [String: Any]
//
//            if (strDistanceRange != "")
//            {
//                parameters = [
//                    "access_key": "AFDlf7odf8jkfljalk098fdjR",
//                    "device_type": "3",
//                    "user_id": strLogedInUserID,
//                    "city_id": strSelectedCityID,
//                    "search_word" : strSearchText,
//                    "lat": strLatitude,
//                    "lng": strLongitude,
//                    "search_type": "2",
//                    "distance": strDistanceRange
//                ]
//            }
//            else
//            {
//                parameters = [
//                    "access_key": "AFDlf7odf8jkfljalk098fdjR",
//                    "device_type": "3",
//                    "user_id": strLogedInUserID,
//                    "city_id": strSelectedCityID,
//                    "search_word" : strSearchText
//                ]
//            }
//
//            print("\(urlComponents.url!)")
//
//            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
//
//            //var request = URLRequest(url: URL(string: strUrlString)!)
//            var request = URLRequest(url: urlComponents.url!)
//            let session = URLSession.shared
//            request.httpMethod = "POST"
//            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//            } catch let error {
//                print(error.localizedDescription)
//            }
//            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
//
//            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
//
//                if let data = data {
//                    do {
//                        self.appDelegate?.dismissGlobalHUD()
//
//                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                            DispatchQueue.main.async(execute: {
//
//                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
//
//                                if(strStatus == "1")
//                                {
//                                    //SUB CATEGORIES
//                                    self.arrayAllStores = [ObjStorePromotion]()
//                                    let arrayStoresLocal = jsonResult["Stores"] as? NSArray
//                                    if (arrayStoresLocal != nil)
//                                    {
//                                        for objStoreTemp in arrayStoresLocal!
//                                        {
//                                            let objStoreDictionary = objStoreTemp as? NSDictionary
//
//                                            let objNewStore : ObjStorePromotion = ObjStorePromotion()
//                                            objNewStore .separateParametersForStoreList(dictionary: objStoreDictionary as! Dictionary<String, Any>)
//
//                                            self.arrayAllStores .append(objNewStore)
//                                        }
//                                    }
//
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllStoresBySearchEvent"), object: self)
//                                }
//                                else
//                                {
//                                    let message: String = "\(jsonResult["message"] ?? "")"
//                                    self.showAlertViewWithTitle(title: "", detail: message)
//                                }
//                            })
//
//                        }
//                    } catch let error as NSError {
//                        print(error.localizedDescription)
//                        let jsonStr = String(data: data, encoding: .utf8)
//                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
//                        self.appDelegate?.dismissGlobalHUD()
//                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
//                    }
//                } else if let error = error {
//                    print(error.localizedDescription)
//                    self.appDelegate?.dismissGlobalHUD()
//                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
//                }
//            })
//            task.resume()
//        }
//        else
//        {
//            print("Connection not available. Please check your internet connection.")
//            self.showInternetNotConnectedError()
//        }
//    }
    
    // MARK: - USER FUNCTION FOR GET ALL STORES BY SUB CATEGORY
    
    func user_GetAllStoresBySearch(strSearchText: String, strDistanceRange: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_GetAllStoresBySearch)
            let strImageName = String(format:".png")
            
//            let strAccessToken: String = "\(UserDefaults.standard.value(forKey: "access_token") ?? "")"
            
//            let headers = [
//                "access_token" : "\(strAccessToken)",
//            ]
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let strLatitude: String = "\(self.currentLocation.coordinate.latitude)"
            let strLongitude: String = "\(self.currentLocation.coordinate.longitude)"
            
            var parameters: [String: String]
            
            if (strDistanceRange != "")
            {
                parameters = [
                    "access_key": "AFDlf7odf8jkfljalk098fdjR",
                    "device_type": "3",
                    "user_id": strLogedInUserID,
                    "city_id": strSelectedCityID,
                    "state_id": strSelectedStateID,
                    "search_word" : strSearchText,
                    "lat": strLatitude,
                    "lng": strLongitude,
                    "search_type": "2",
                    "distance": strDistanceRange
                ]
            }
            else
            {
                parameters = [
                    "access_key": "AFDlf7odf8jkfljalk098fdjR",
                    "device_type": "3",
                    "user_id": strLogedInUserID,
                    "city_id": strSelectedCityID,
                    "state_id": strSelectedStateID,
                    "search_word" : strSearchText
                ]
            }
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                multipartFormData.append(Data(), withName: "profileImage",fileName: strImageName , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                //SUB CATEGORIES
                                self.arrayAllStores = [ObjStorePromotion]()
                                let arrayStoresLocal = jsonResult["Stores"] as? NSArray
                                if (arrayStoresLocal != nil)
                                {
                                    for objStoreTemp in arrayStoresLocal!
                                    {
                                        let objStoreDictionary = objStoreTemp as? NSDictionary
                                        
                                        let objNewStore : ObjStorePromotion = ObjStorePromotion()
                                        objNewStore .separateParametersForStoreList(dictionary: objStoreDictionary as! Dictionary<String, Any>)
                                        
                                        self.arrayAllStores .append(objNewStore)
                                    }
                                }
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllStoresBySearchEvent"), object: self)
                            }
                            else
                            {
                                let strBlocked: String = "\(jsonResult["blocked"] ?? "0")"
                                
                                if(strBlocked == "1")
                                {
                                    let strBlockedTitle: String = "\(jsonResult["blocked_msg_title"] ?? "")"
                                    let strBlockedMessage: String = "\(jsonResult["blocked_msg_desc"] ?? "")"
                                    self.showAlertViewWithTitle(title: strBlockedTitle, detail: strBlockedMessage)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                                
                                self.arrayAllStores.removeAll() //n clear all strores to solve drop down issue
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET STORE DETAILS
    
    func user_GetStoreDetails(strStoreID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_GetStoreDetails)
            let strImageName = String(format:".png")
                        
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "is_promo": "1"
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                multipartFormData.append(Data(), withName: "profileImage",fileName: strImageName , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                self.strProductCounts = "\(jsonResult["store_total_products"] ?? "0")"
                                self.strPoints = "\(jsonResult["user_points"] ?? "0")"
                                //"products"
                                self.arrayStoreProducts = [ObjStoreProduct]()
                                if let arrayTemp = jsonResult["products"] as? Array<Dictionary<String, Any>>
                                {
                                    for objTemp in arrayTemp
                                    {
                                        let objNew: ObjStoreProduct = ObjStoreProduct()
                                        objNew.separateParametersForStoreProduct(dictionary: objTemp)
                                        self.arrayStoreProducts.append(objNew)
                                    }
                                }
                                
                                self.objSelectedStoreDetails = ObjStoreDetails()
                                let objStoreDictionary = jsonResult["StoreDetail"] as? NSDictionary
                                
                                self.objSelectedStoreDetails .separateParametersForStoreDetails(dictionary: objStoreDictionary as! Dictionary<String, Any>)
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetStoreDetailsEvent"), object: self)
                            }
                            else
                            {
                                let message: String = "\(jsonResult["message"] ?? "")"
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR UPDATE STORE FAVOURITE
    
    func user_UpdateStoreFavourite(strStoreID: String, strIsFavourite: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_UpdateStoreFavourite)
            let strImageName = String(format:".png")
                        
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "is_favourite": strIsFavourite
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                multipartFormData.append(Data(), withName: "profileImage",fileName: strImageName , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                if (self.objSelectedStoreDetails.strIsFavourite == "1")
                                {
                                    self.objSelectedStoreDetails.strIsFavourite = "0"
                                }
                                else
                                {
                                    self.objSelectedStoreDetails.strIsFavourite = "1"
                                }
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_UpdateStoreFavouriteEvent"), object: self)
                            }
                            else
                            {
                                let message: String = "\(jsonResult["message"] ?? "")"
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET STORE REVIEWS
    
    func user_GetAllStoreReviews(strStoreID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_GetAllStoreReviews)
            let strImageName = String(format:".png")
                        
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                multipartFormData.append(Data(), withName: "profileImage",fileName: strImageName , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                self.arrayAllReviews = [ObjReview]()
                                let arrayStoreReviewsLocal = jsonResult["reviews"] as? NSArray
                                
                                if (arrayStoreReviewsLocal != nil)
                                {
                                    for objStoreReviewTemp in arrayStoreReviewsLocal!
                                    {
                                        let objStoreReviewDictionary = objStoreReviewTemp as? NSDictionary
                                        
                                        let objNewStoreReview : ObjReview = ObjReview()
                                        objNewStoreReview .separateParametersForReview(dictionary: objStoreReviewDictionary as! Dictionary<String, Any>)
                                        
                                        self.arrayAllReviews .append(objNewStoreReview)
                                    }
                                }
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllStoreReviewsEvent"), object: self)
                            }
                            else
                            {
                                let message: String = "\(jsonResult["message"] ?? "")"
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET PRODUCT REVIEWS
    
    func user_GetAllProductReviews(strProductID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_GetAllStoreReviews)
            let strImageName = String(format:".png")
                        
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "product_id": strProductID
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                multipartFormData.append(Data(), withName: "profileImage",fileName: strImageName , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                self.arrayAllReviews = [ObjReview]()
                                let arrayStoreReviewsLocal = jsonResult["reviews"] as? NSArray
                                
                                if (arrayStoreReviewsLocal != nil)
                                {
                                    for objStoreReviewTemp in arrayStoreReviewsLocal!
                                    {
                                        let objStoreReviewDictionary = objStoreReviewTemp as? NSDictionary
                                        
                                        let objNewStoreReview : ObjReview = ObjReview()
                                        objNewStoreReview .separateParametersForReview(dictionary: objStoreReviewDictionary as! Dictionary<String, Any>)
                                        
                                        self.arrayAllReviews .append(objNewStoreReview)
                                    }
                                }
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllProductReviewsEvent"), object: self)
                            }
                            else
                            {
                                let message: String = "\(jsonResult["message"] ?? "")"
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR ADD REVIEW
    
    func user_AddReview(strStoreID: String, strRating: String, strReviewText: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_AddReview)
            let strImageName = String(format:".png")
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "rate": strRating,
                "review_text": strReviewText
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                multipartFormData.append(Data(), withName: "profileImage",fileName: strImageName , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                self.arrayAllReviews = [ObjReview]()
                                let arrayStoreReviewsLocal = jsonResult["Reviews"] as? NSArray
                                
                                if (arrayStoreReviewsLocal != nil)
                                {
                                    for objStoreReviewTemp in arrayStoreReviewsLocal!
                                    {
                                        let objStoreReviewDictionary = objStoreReviewTemp as? NSDictionary
                                        
                                        let objNewStoreReview : ObjReview = ObjReview()
                                        objNewStoreReview .separateParametersForReview(dictionary: objStoreReviewDictionary as! Dictionary<String, Any>)
                                        
                                        self.arrayAllReviews .append(objNewStoreReview)
                                    }
                                }
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_AddReviewEvent"), object: self)
                            }
                            else
                            {
                                let message: String = "\(jsonResult["message"] ?? "")"
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR ADD REVIEW
    
    func user_AddProductReview(strProductID: String, strRating: String, strReviewText: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_AddProductReview)
            let strImageName = String(format:".png")
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "product_id": strProductID,
                "rate": strRating,
                "review_text": strReviewText
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                multipartFormData.append(Data(), withName: "profileImage",fileName: strImageName , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                self.arrayAllReviews = [ObjReview]()
                                let arrayStoreReviewsLocal = jsonResult["Reviews"] as? NSArray
                                
                                if (arrayStoreReviewsLocal != nil)
                                {
                                    for objStoreReviewTemp in arrayStoreReviewsLocal!
                                    {
                                        let objStoreReviewDictionary = objStoreReviewTemp as? NSDictionary
                                        
                                        let objNewStoreReview : ObjReview = ObjReview()
                                        objNewStoreReview .separateParametersForReview(dictionary: objStoreReviewDictionary as! Dictionary<String, Any>)
                                        
                                        self.arrayAllReviews .append(objNewStoreReview)
                                    }
                                }
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_AddProductReviewEvent"), object: self)
                            }
                            else
                            {
                                let message: String = "\(jsonResult["message"] ?? "")"
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET PROMOTION DETAILS
    
    func user_GetPromotionDetails(strStoreID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_GetPromotionDetails)
            let strImageName = String(format:".png")
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                multipartFormData.append(Data(), withName: "profileImage",fileName: strImageName , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                self.objSelectedPromotionDetails = ObjPromotionDetails()
                                let objPromotionDictionary = jsonResult["PromotionDetail"] as? NSDictionary
                                
                                self.objSelectedPromotionDetails .separateParametersForPromotionDetails(dictionary: objPromotionDictionary as! Dictionary<String, Any>)
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetPromotionDetailsEvent"), object: self)
                            }
                            else
                            {
                                let message: String = "\(jsonResult["message"] ?? "")"
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- USER FUNCTION FOR GET HOT PROMOTION DETAILS
    func user_GetHotPromotionDetails()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_GetHotPromotions)
            let strImageName = String(format:".png")
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            //let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "city_id": strSelectedCityID
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                multipartFormData.append(Data(), withName: "profileImage",fileName: strImageName , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                
                                //STORE PROMOTIONS
                                self.arrayHotpromotions = [ObjStorePromotion]()
                                let arrayStorePromotionsLocal = jsonResult["PromotionStores"] as? NSArray
                                if (arrayStorePromotionsLocal != nil)
                                {
                                    for objStorePromotionTemp in arrayStorePromotionsLocal!
                                    {
                                        let objStorePromotionDictionary = objStorePromotionTemp as? NSDictionary
                                        
                                        let objNewStorePromotion : ObjStorePromotion = ObjStorePromotion()
                                        objNewStorePromotion .separateParametersForStorePromotion(dictionary: objStorePromotionDictionary as! Dictionary<String, Any>)
                                        
                                        self.arrayHotpromotions.append(objNewStorePromotion)
                                    }
                                }
                                
                                /*
                                //====
                                self.arrayHotpromotions = [ObjPromotionDetails]()
                                let arrayHotpromotionsLocal = jsonResult["PromotionStores"] as? NSArray
                                
                                if (arrayHotpromotionsLocal != nil)
                                {
                                    for objPromotionDetailsTemp in arrayHotpromotionsLocal!
                                    {
                                        let objPromotionDetailsDictionary = objPromotionDetailsTemp as? NSDictionary
                                        
                                        let objPromotionDetails : ObjPromotionDetails = ObjPromotionDetails()
                                        
                                        objPromotionDetails.separateParametersForPromotionDetails(dictionary: objPromotionDetailsDictionary as! Dictionary<String, Any>)
                                                                                
                                        self.arrayHotpromotions.append(objPromotionDetails)
                                    }
                                }
                                */
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetHotPromotionDetailsEvent"), object: self)
                            }
                            else
                            {
                                let message: String = "\(jsonResult["message"] ?? "")"
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL RECENT STORES
    
    func user_GetAllRecentStores()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllRecentStores))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "city_id": strSelectedCityID,
                "state_id": strSelectedStateID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    //SUB CATEGORIES
                                    self.arrayAllRecentStores = [RecentStore]()
                                    let arrayStoresLocal = jsonResult["RecentSearchStores"] as? NSArray
                                    if (arrayStoresLocal != nil)
                                    {
                                        for objStoreTemp in arrayStoresLocal!
                                        {
                                            let objStoreDictionary = objStoreTemp as? NSDictionary
                                            
                                            let objNewStore : RecentStore = RecentStore()
                                            objNewStore .separateParametersForRecentStoreList(dictionary: objStoreDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllRecentStores .append(objNewStore)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllRecentStoresEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    if (message == "Stores not found.")
                                    {
                                        self.arrayAllRecentStores = [RecentStore]()
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllRecentStoresEvent"), object: self)
                                    }
                                    else
                                    {
                                        self.showAlertViewWithTitle(title: "", detail: message)
                                    }
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL FAVOURITE STORES
    
    func user_GetAllFavouriteStores()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllFavouriteStores))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "city_id": strSelectedCityID,
                "state_id": strSelectedStateID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    //SUB CATEGORIES
                                    self.arrayAllFavouriteStores = [RecentStore]()
                                    let arrayStoresLocal = jsonResult["FavouriteStores"] as? NSArray
                                    if (arrayStoresLocal != nil)
                                    {
                                        for objStoreTemp in arrayStoresLocal!
                                        {
                                            let objStoreDictionary = objStoreTemp as? NSDictionary
                                            
                                            let objNewStore : RecentStore = RecentStore()
                                            objNewStore .separateParametersForRecentStoreList(dictionary: objStoreDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllFavouriteStores .append(objNewStore)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllFavouriteStoresEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    if (message == "Favorite Stores not found.")
                                    {
                                        self.arrayAllFavouriteStores = [RecentStore]()
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllFavouriteStoresEvent"), object: self)
                                    }
                                    else
                                    {
                                        self.showAlertViewWithTitle(title: "", detail: message)
                                    }
                                }
                            })
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL MY STORES
    
    func user_GetAllMyStores()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllMyStores))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            let strSelectedStateID: String = "\(UserDefaults.standard.value(forKey: "state_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "city_id": strSelectedCityID,
                "state_id": strSelectedStateID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                UserDefaults.standard.setValue("\(jsonResult["sku_subscription"] ?? "")", forKey: "sku_subscription")
                                UserDefaults.standard.setValue("\(jsonResult["subscription_title"] ?? "")", forKey: "subscription_title")
                                UserDefaults.standard.setValue("\(jsonResult["subscription_header"] ?? "")", forKey: "subscription_header")
                                
                                UserDefaults.standard.setValue("\(jsonResult["point_1"] ?? "")", forKey: "subscription_point_1")
                                UserDefaults.standard.setValue("\(jsonResult["point_2"] ?? "")", forKey: "subscription_point_2")
                                UserDefaults.standard.setValue("\(jsonResult["point_3"] ?? "")", forKey: "subscription_point_3")
                                UserDefaults.standard.setValue("\(jsonResult["point_4"] ?? "")", forKey: "subscription_point_4")
                                UserDefaults.standard.synchronize()
                                
                                if(strStatus == "1")
                                {
                                    //SUB CATEGORIES
                                    self.arrayAllMyStores = [MyStore]()
                                    self.arrayNotPremiumStores = [MyStore]()
                                    self.arrayNotPremiumStoreIDs = [Int]()
                                    self.arrayNotPremiumStoreNames = [String]()
                                    self.strReferralLink = "\(jsonResult["referral_link"] ?? "")"
                                    self.strDownloads = "\(jsonResult["downloads"] ?? "")"
//                                    referral_link
//                                    downloads
                                    let arrayStoresLocal = jsonResult["Stores"] as? NSArray
                                    if (arrayStoresLocal != nil)
                                    {
                                        for objStoreTemp in arrayStoresLocal!
                                        {
                                            let objStoreDictionary = objStoreTemp as? NSDictionary
                                            
                                            let objNewStore : MyStore = MyStore()
                                            objNewStore .separateParametersForMyStoreList(dictionary: objStoreDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllMyStores .append(objNewStore)
                                            if (Int(objNewStore.strType) ?? 0 == 0)
                                            {
                                                self.arrayNotPremiumStores .append(objNewStore)
                                                self.arrayNotPremiumStoreIDs .append(Int(objNewStore.strID) ?? 0)
                                                self.arrayNotPremiumStoreNames .append(objNewStore.strName)
                                            }
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllMyStoresEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR ADD STORE
    
    func user_AddStore(arrayStoreImages: Array<Data>,
                       strStoreName: String,
                       strStorePhoneNumber: String,
                       strEmail: String,
                       strStoreAddress: String,
                       strIsHideAddress: String,
                       strStoreCityID: String,
                       strStoreStateID: String,
                       strStoreSubcategoryIDs: Array<String>,
                       arrayTags: Array<String>,
                       strStoreDescription: String,
                       strFacebookLink: String,
                       strInstagramLink: String,
                       arrayStoreTimings: Array<String>)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: NSLocalizedString("loading_with_photos", value:"Sending data. Please wait as this process may take a while due to photos.", comment: ""))
            
            let strUrlString = String(format:"%@%@", ServerIP, User_AddStore)
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            var dictStoreTags: Dictionary<String, Any> = Dictionary()
            dictStoreTags["tags"] = arrayTags
            var strStoreTags: String = ""
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: dictStoreTags,
                options: []) {
                strStoreTags = String(data: theJSONData,
                                      encoding: .ascii)!
                print("JSON string = \(strStoreTags)")
            }
            
            
            var arrayStoreTimingTemp = [Dictionary<String, String>]()
            for strTiming in arrayStoreTimings
            {
                var dictTiming: Dictionary<String, String> = Dictionary()
                
                let arrayTimingTemp = strTiming.components(separatedBy: "#")
                
                if (arrayTimingTemp.count == 3)
                {
                    dictTiming["week_day"] = arrayTimingTemp[0]
                    dictTiming["open_time"] = arrayTimingTemp[1]
                    dictTiming["close_time"] = arrayTimingTemp[2]
                }
                
                arrayStoreTimingTemp.append(dictTiming)
            }
            
            
            var dictStoreTimings: Dictionary<String, Any> = Dictionary()
            dictStoreTimings["time"] = arrayStoreTimingTemp
            var strStoreTimings: String = ""
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: dictStoreTimings,
                options: []) {
                strStoreTimings = String(data: theJSONData,
                                      encoding: .ascii)!
                print("JSON string = \(strStoreTimings)")
            }
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_name": strStoreName,
                "store_phone_number": strStorePhoneNumber,
                "email": strEmail,
                "store_address": strStoreAddress,
                "hide_address": strIsHideAddress,
                "store_city_id": strStoreCityID,
                "store_state_id": strStoreStateID,
                "subcategory_id": "\(strStoreSubcategoryIDs.joined(separator: ","))",
                "store_tags": strStoreTags,
                "store_description": strStoreDescription,
                "facebook_link": strFacebookLink,
                "instagram_link": strInstagramLink,
                "store_timings": strStoreTimings
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                
                var index: Int = 1
                for imageData in arrayStoreImages
                {
                    multipartFormData.append(imageData, withName: "fileName_\(index)",fileName: "fileName_\(index).png" , mimeType: "image/png")
//                    multipartFormData.append(imageData, withName: "fileName_\(index)",fileName: "fileName_\(index).jpeg" , mimeType: "image/jpeg")
                    
                    index = index + 1
                }
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_AddStoreEvent"), object: self)
                            }
                            else if (strStatus == "2")
                            {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_AddStoreEvent"), object: self)
                            }
                            else
                            {
                                var message: String = "\(jsonResult["message"] ?? "")"
                                
                                if(message == "Failed to Upload Image.null" || message == "Failed to Upload Image.")
                                {
                                    message = NSLocalizedString("failed_to_upload_image", value: "Erro no envio da imagem. Entre em contato com os administradores.", comment: "")
                                }
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR EDIT STORE
    
    func user_EditStore(strStoreID: String,
                        arrayStoreImages: Array<Data>,
                        strStoreName: String,
                        strStorePhoneNumber: String,
                        strEmail: String,
                        strStoreAddress: String,
                        strIsHideAddress: String,
                        strStoreCityID: String,
                        strStoreStateID: String,
                        strStoreSubcategoryIDs: Array<String>,
                        arrayTags: Array<String>,
                        strStoreDescription: String,
                        strFacebookLink: String,
                        strInstagramLink: String,
                        arrayStoreTimings: Array<String>,
                        arrayDeletedImages: Array<String>)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: NSLocalizedString("loading_with_photos", value:"Sending data. Please wait as this process may take a while due to photos.", comment: ""))
            
            let strUrlString = String(format:"%@%@", ServerIP, User_EditStore)
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            //let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            
            var dictStoreTags: Dictionary<String, Any> = Dictionary()
            dictStoreTags["tags"] = arrayTags
            var strStoreTags: String = ""
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: dictStoreTags,
                options: []) {
                strStoreTags = String(data: theJSONData,
                                      encoding: .ascii)!
                print("JSON string = \(strStoreTags)")
            }
            
            
            var arrayStoreTimingTemp = [Dictionary<String, String>]()
            for strTiming in arrayStoreTimings
            {
                var dictTiming: Dictionary<String, String> = Dictionary()
                
                let arrayTimingTemp = strTiming.components(separatedBy: "#")
                
                if (arrayTimingTemp.count == 3)
                {
                    dictTiming["week_day"] = arrayTimingTemp[0]
                    dictTiming["open_time"] = arrayTimingTemp[1]
                    dictTiming["close_time"] = arrayTimingTemp[2]
                }
                
                arrayStoreTimingTemp.append(dictTiming)
            }
            
            
            var dictStoreTimings: Dictionary<String, Any> = Dictionary()
            dictStoreTimings["time"] = arrayStoreTimingTemp
            var strStoreTimings: String = ""
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: dictStoreTimings,
                options: []) {
                strStoreTimings = String(data: theJSONData,
                                      encoding: .ascii)!
                print("JSON string = \(strStoreTimings)")
            }
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "store_name": strStoreName,
                "store_phone_number": strStorePhoneNumber,
                "email": strEmail,
                "store_address": strStoreAddress,
                "hide_address": strIsHideAddress,
                "store_city_id": strStoreCityID,
                "store_state_id": strStoreStateID,
                "subcategory_id": "\(strStoreSubcategoryIDs.joined(separator: ","))",
                "store_tags": strStoreTags,
                "store_description": strStoreDescription,
                "facebook_link": strFacebookLink,
                "instagram_link": strInstagramLink,
                "store_timings": strStoreTimings,
                "deleted_images": "\(arrayDeletedImages.joined(separator: ","))"
            ]
            
            print("parameters: \(parameters)")
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                
                var index: Int = 1
                for imageData in arrayStoreImages
                {
                    multipartFormData.append(imageData, withName: "fileName_\(index)",fileName: "fileName_\(index).png" , mimeType: "image/png")
//                    multipartFormData.append(imageData, withName: "fileName_\(index)",fileName: "fileName_\(index).jpeg" , mimeType: "image/jpeg")
                    
                    index = index + 1
                }
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_EditStoreEvent"), object: self)
                            }
                            else if (strStatus == "2")
                            {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_EditStoreEvent"), object: self)
                            }
                            else
                            {
                                let message: String = "\(jsonResult["message"] ?? "")"
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR ADD EDIT STORE PROMOTION
    
    func user_AddEditStorePromotion(strStoreID: String, strPromotionID: String, arrayPromotionImagesImages: Array<Data>, strTitle: String, strPromotionDescription: String, arrayDeletedImages: Array<String>)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: NSLocalizedString("loading_with_photos", value:"Sending data. Please wait as this process may take a while due to photos.", comment: ""))
            
            let strUrlString = String(format:"%@%@", ServerIP, User_AddEditPromotion)
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "promotion_id": strPromotionID,
                "title": strTitle,
                "details": strPromotionDescription,
                "deleted_images": "\(arrayDeletedImages.joined(separator: ","))"
            ]
            
            print("parameters: \(parameters)")
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                
                var index: Int = 1
                for imageData in arrayPromotionImagesImages
                {
                    multipartFormData.append(imageData, withName: "fileName_\(index)",fileName: "fileName_\(index).png" , mimeType: "image/png")
//                    multipartFormData.append(imageData, withName: "fileName_\(index)",fileName: "fileName_\(index).jpeg" , mimeType: "image/jpeg")
                    
                    index = index + 1
                }
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8, allowLossyConversion: true)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_AddEditStorePromotionEvent"), object: self)
                            }
                            else if (strStatus == "2")
                            {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_AddEditStorePromotionEvent"), object: self)
                            }
                            else
                            {
                                let message: String = "\(jsonResult["message"] ?? "")"
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION TO GET MY PROFILE DETAILS
    
    func user_GetMyProfileDetails()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_RegisterMobileNumber))!
            
//            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
//
//            let parameters = [
//                "access_key": "AFDlf7odf8jkfljalk098fdjR",
//                "device_type": "3",
//                "user_id": strLogedInUserID
//            ]
            
            let strFcmToken: String = "\(UserDefaults.standard.value(forKey: "fcmToken") ?? "")"
            let strMobileNumber: String = "\(UserDefaults.standard.value(forKey: "phone_number") ?? "")"
            
            let parameters = [
                "access_key" : "AFDlf7odf8jkfljalk098fdjR",
                "device_type" : "3",
                "user_role" : "USER",
                "device_token" : "\(strFcmToken)",
                "phone_number" : "\(strMobileNumber)"
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strServerMessage = "\(jsonResult["message"] ?? "")"
                                    
                                    let arrayUsersLocal = jsonResult["User"] as? NSArray

                                    if (arrayUsersLocal != nil)
                                    {
                                        if (arrayUsersLocal!.count > 0)
                                        {
                                            let objUserDictionary = arrayUsersLocal![0] as? NSDictionary

                                            self.objUser = ObjUser()
                                            self.objUser.separateParametersForUser(dictionary: objUserDictionary as! Dictionary<String, Any>)
                                        }
                                    }
                                    
//                                    UserDefaults.standard.setValue(self.objUser.strUserID, forKey: "user_id")
//                                    UserDefaults.standard.setValue(self.objUser.strSocialMediaID, forKey: "social_media_id")
//                                    UserDefaults.standard.setValue(self.objUser.strUserRole, forKey: "user_role")
                                    UserDefaults.standard.setValue(self.objUser.strFirstName, forKey: "first_name")
                                    UserDefaults.standard.setValue(self.objUser.strLastName, forKey: "last_name")
                                    UserDefaults.standard.setValue(self.objUser.strEmail, forKey: "email")
                                    UserDefaults.standard.setValue(self.objUser.strPhoneNumber, forKey: "phone_number")
                                    //UserDefaults.standard.setValue(self.objUser.strGUID, forKey: "guid")
                                    UserDefaults.standard.synchronize()
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetMyProfileDetailsEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                  //  print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
        
    // MARK: - USER FUNCTION FOR UPDATE MY PROFILE DETAILS
    
    func user_UpdateMyProfileDetails(strFirstName: String, strLastName: String, strEmail: String, strMobileNumber: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_UpdateMyProfileDetails))!

            //var array = [URLQueryItem]()
                                        
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "firstname": strFirstName,
                "lastname": strLastName,
                "email_id": strEmail,
                "phone_number": strMobileNumber
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strServerMessage = "\(jsonResult["message"] ?? "")"
                                    
                                    let arrayUsersLocal = jsonResult["User"] as? NSArray

                                    if (arrayUsersLocal != nil)
                                    {
                                        if (arrayUsersLocal!.count > 0)
                                        {
                                            let objUserDictionary = arrayUsersLocal![0] as? NSDictionary

                                            self.objUser = ObjUser()
                                            self.objUser.separateParametersForUser(dictionary: objUserDictionary as! Dictionary<String, Any>)
                                        }
                                    }
                                    
                                    UserDefaults.standard.setValue(self.objUser.strUserID, forKey: "user_id")
                                    UserDefaults.standard.setValue(self.objUser.strSocialMediaID, forKey: "social_media_id")
                                    UserDefaults.standard.setValue(self.objUser.strUserRole, forKey: "user_role")
                                    UserDefaults.standard.setValue(strFirstName, forKey: "first_name")
                                    UserDefaults.standard.setValue(strLastName, forKey: "last_name")
                                    UserDefaults.standard.setValue(strEmail, forKey: "email")
                                    UserDefaults.standard.setValue(strMobileNumber, forKey: "phone_number")
                                    //UserDefaults.standard.setValue(self.objUser.strGUID, forKey: "guid")
                                    UserDefaults.standard.synchronize()
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_UpdateMyProfileDetailsEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                  //  print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR CONTACT ADMINISTRATOR
    
    func user_ContactAdministrator(strMessage: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_ContactAdministrator))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "message": strMessage
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strServerMessage = "\(jsonResult["message"] ?? "")"
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_ContactAdministratorEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    if (message == "Favorite Stores not found.")
                                    {
                                        self.arrayAllFavouriteStores = [RecentStore]()
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllFavouriteStoresEvent"), object: self)
                                    }
                                    else
                                    {
                                        self.showAlertViewWithTitle(title: "", detail: message)
                                    }
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                       // print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    //print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR MARK STORE AS PREMIUM
    
    func user_MarkStoreAsPermium(strStoreID: String, strProductID: String, strTransactionID: String, strToken: String, strProductPrice: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_MarkStoreAsPremium))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "sku_subscription": strProductID,
                "order_id": strTransactionID,
                "purchase_token": strToken,
                "price_with_currency": strProductPrice
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
               // print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strServerMessage = "\(jsonResult["message"] ?? "")"
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_MarkStoreAsPermiumEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    if (message == "Favorite Stores not found.")
                                    {
                                        self.arrayAllFavouriteStores = [RecentStore]()
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllFavouriteStoresEvent"), object: self)
                                    }
                                    else
                                    {
                                        self.showAlertViewWithTitle(title: "", detail: message)
                                    }
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL MY STORES
    
    func user_GetClickReportsOfMyStores(strStoreID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetClickReportsOfMyStores))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strMyStoreTotalClickCount = "\(jsonResult["total_clicks"] ?? "0")"
                                    
                                    self    .arrayAllMyStoreClickReports = [MyStoreClickReport]()
                                    
                                    let arrayAllMyStoreClickReportsLocal = jsonResult["StoreClicks"] as? NSArray
                                    if (arrayAllMyStoreClickReportsLocal != nil)
                                    {
                                        for objMyStoreClickReportTemp in arrayAllMyStoreClickReportsLocal!
                                        {
                                            let objMyStoreClickReportDictionary = objMyStoreClickReportTemp as? NSDictionary
                                            
                                            let objMyStoreClickReport : MyStoreClickReport = MyStoreClickReport()
                                            objMyStoreClickReport.separateParametersForMyStoreClickReport(dictionary: objMyStoreClickReportDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayAllMyStoreClickReports.append(objMyStoreClickReport)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetClickReportsOfMyStoresEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL MY STORES
    
    func user_ReportAProblem(strProbleText: String , strProblemType: String, strStoreID: String )
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_ReportProblemer))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "problem_text":strProbleText,
                "problem_type":strProblemType,
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {

                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_ReportAProblemEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
//    let RegisterUsingPassword = "RegisterUsingPassword"
//    let LoginUsingPassword = "LoginUsingPassword"
//    let ForgotPassword = "ForgotPassword"
    
    //MARK:- USER FUNCTION TO REGISTER PASSWORD
    
    func registerUsingPassword(strEmailId: String ,strPassword: String, strReferralCode: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, RegisterUsingPassword))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            //let strParentID: String = "\(UserDefaults.standard.value(forKey: "parent_id") ?? "")"
            
            let strReferrerUid: String = "\(UserDefaults.standard.value(forKey: "referrerUid") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "email_id": strEmailId,
                "password": strPassword,
                "referral_code": strReferralCode,
                "parent_id": strReferrerUid
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    let password: String = "\(jsonResult["password"] ?? "")"
                                    UserDefaults.standard.setValue("1", forKey: "isAuthorized")
                                    UserDefaults.standard.setValue(password, forKey: "password")
                                    UserDefaults.standard.synchronize()
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "registeredUsingPasswordEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION TO LOGIN USING PASSWORD
    
    func loginUsingPassword(strPassword: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, LoginUsingPassword))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "password": strPassword
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    let password: String = "\(jsonResult["password"] ?? "")"
                                    UserDefaults.standard.setValue("1", forKey: "isAuthorized")
                                    UserDefaults.standard.setValue(password, forKey: "password")
                                    UserDefaults.standard.synchronize()
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "loggedinUsingPasswordEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR FORGOT PASSWORD
    
    func forgotPassword()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, ForgotPassword))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    let message1: String = NSLocalizedString("forget_password_success_message", value:"WhatsApp Enviamos uma nova senha para  contato", comment: "")
                                    
                                    let message1Attribute = [NSAttributedString.Key.font: MySingleton.sharedManager().themeFontFourteenSizeRegular]
                                    let strMessage1 = NSMutableAttributedString(string: message1, attributes: message1Attribute as [NSAttributedString.Key : Any])
                                    
                                    
                                    
                                    let email: String = "\(jsonResult["email_id"] ?? "")"
                                    
                                    let emailAttribute = [NSAttributedString.Key.font: MySingleton.sharedManager().themeFontFourteenSizeBold]
                                    let strEmail = NSMutableAttributedString(string: email, attributes: emailAttribute as [NSAttributedString.Key : Any])
                                    
                                    let finalAttributedString: NSMutableAttributedString = NSMutableAttributedString()
                                    finalAttributedString.append(strMessage1)
                                    finalAttributedString.append(strEmail)
                                    
                                    let message: String = message1 + email
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "forgotPasswordEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
//                                    self.showAlertViewWithTitle(title: "", detail: message)
                                    
                                    self.showAlertViewWithTitle(title: NSLocalizedString("forget_password_error_title", value:"Erro: email não encontrado", comment: ""), detail: NSLocalizedString("forget_password_error_message", value:"Entre em contato com os administradores pelo menu do aplicativo para recuperar sua senha.", comment: ""))
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- GET POINTS DETAILS
    func user_getPoints()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetPointsDetails))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            /*
            API : GetPointsDetails
            Params : user_id
            Response : rewardPoints,lifetimePoints
            just use reward points from this API
            QUERY: referral_code is missing
            */
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    /*
                                     {
                                         downloads = 0;
                                         lifetimePoints = 0;
                                         message = "Point listed successfully.";
                                         "referral_code" = 18Q6;
                                         "referral_link" = "/r/1736964";
                                         rewardPoints = 0;
                                         status = 1;
                                     }
                                    */
                                    
                                    let points: String = "\(jsonResult["rewardPoints"] ?? "")"
                                    self.strPoints = points
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetPointsDetailsEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- GET STORE CART PRODUCTS
    
    func user_getStoreCartProducts(strStoreID: String, strProductID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetCartProducts))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            /*
            API : GetStoreCartProducts
            Params : user_id, store_id, product_id
            Response : 
            to add product into cart and get cart items in responce
            */
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "product_id": strProductID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strPoints = "\(jsonResult["user_points"] ?? "0")"
                                    
                                    self.arrayAllStoreCartProducts = [ObjCartItem]()
                                    
                                    if let arrayTemp = jsonResult["orders"] as? Array<Dictionary<String, Any>>
                                    {
                                        for objTemp in arrayTemp
                                        {
                                            let objNew: ObjCartItem = ObjCartItem()
                                            objNew.separateParametersForCartItem(dictionary: objTemp)
                                            self.arrayAllStoreCartProducts.append(objNew)
                                        }
                                    }
                                    
                                    if (self.arrayAllStoreCartProducts.count > 0)
                                    {
                                        self.strTotalMoney = self.arrayAllStoreCartProducts[0].strMoneySpent
                                        self.strTotalPoints = self.arrayAllStoreCartProducts[0].strPointsSpent
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_getStoreCartProductsEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- CHANGE CART PRODUCT QUANTITY
    
    func user_changeCartProductQuantity(strOrderID: String, strOrderItemID: String, strProductID: String, strQuantity: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_ChangeCartProductQuantity))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            /*
            API : ChangeCartProductQuantity
            Params : user_id, order_id, order_item_id, product_id, quantity
            Response :
            to update product quantity into cart and get cart items in responce
            */
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "order_id": strOrderID,
                "order_item_id": strOrderItemID,
                "product_id": strProductID,
                "quantity": strQuantity
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strTotalMoney = "\(jsonResult["total_money"] ?? "0")"
                                    self.strTotalPoints = "\(jsonResult["total_points"] ?? "0")"
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_changeCartProductQuantityEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- REMOVE CART PRODUCT
    
    func user_removeCartProduct(strOrderID: String, strOrderItemID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_RemoveCartProduct))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            /*
            API : ChangeCartProductQuantity
            Params : user_id, order_id, order_item_id, product_id, quantity
            Response :
            to update product quantity into cart and get cart items in responce
            */
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "order_id": strOrderID,
                "order_item_id": strOrderItemID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strTotalMoney = "\(jsonResult["total_money"] ?? "0")"
                                    self.strTotalPoints = "\(jsonResult["total_points"] ?? "0")"
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_removeCartProductEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- VERIFY CART
    
    func user_verifyCart(strStoreID: String, strOrderID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_VerifyCart))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            /*
            API : VerifyCart
            Params : user_id, store_id, order_id
            Response :
            to update product quantity into cart and get cart items in responce
            */
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "order_id": strOrderID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.strNeedAddress = "\(jsonResult["need_address"] ?? "0")"
                                    let strVerified: String = "\(jsonResult["verified"] ?? "0")"
                                    if(strVerified == "1")
                                    {
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "user_verifyCartEvent"), object: self)
                                    }
                                    else
                                    {
                                        self.showAlertViewWithTitle(title: "", detail: "Your Cart has been updated ,There is a some changes in cart price ,please review Cart again.")
                                    }
                                    
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- MAKE PRODUCT ORDER
    
    func user_makeProductOrder(strStoreID: String,
                               strCheckoutType: String,
                               strID: String,
                               strMoneySpent: String,
                               strPointsSpent: String,
                               strPhoneNumber: String,
                               strCityID: String,
                               strPaymentMethod: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_MakeProductOrder))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            /*
            API : MakeProductOrder
            Params : user_id, store_id, checkout_type, order_id/product_id, money_spent, point_spent, name, phone_number, email_id, checkout_type, city_id, street, number, observations, payment_method
            Response :
            to update product quantity into cart and get cart items in responce
            */
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "checkoutType": strCheckoutType,
                "product_id" : strID,
                "money_spent": strMoneySpent,
                "point_spent": strPointsSpent,
                "phone_number": strPhoneNumber,
                "city_id": strCityID,
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_makeProductOrderEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- UPDATE NOTIFICAITON STATUS
    
    func user_updateNotificationStatus(strStatus: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_UpdateNotificationStatus))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            /*
            API : MakeProductOrder
            Params : user_id, opt_notification
            Response :
            to update notification status for user
            */
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "opt_notification": strStatus
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_updateNotificationStatusEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- SEND BULK MESSAGE
    
    func user_sendBulkMessage(strType: String, strStoreID: String, strMessage: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_SendBulkMessages))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            /*
            API : SaveBulkMessage
            Params : user_id, type, store_id, message
            Response :
            to update notification status for user
            */
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "type": strType,
                "store_id": strStoreID,
                "message": strMessage
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_sendBulkMessageEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- SEND TOP TEN BULK MESSAGE
    
    func user_sendTopTenBulkMessage(strType: String, strCategoryID: String, strStoreID: String, strMessage: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_SendBulkMessages))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            /*
            API : SaveBulkMessage
            Params : user_id, type, store_id, message
            Response :
            to update notification status for user
            */
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "type": strType,
                "category_id": strCategoryID,
                "store_id": strStoreID,
                "message": strMessage
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_sendBulkMessageEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    //MARK:- GET BULK MESSAGE LIST
    
    func user_getBulkMessageList(strStoreID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetBulkMessageList))!
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            /*
            API : SaveBulkMessage
            Params : user_id, type, store_id, message
            Response :
            to update notification status for user
            */
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.arrayBulkMessageClusterList = [ObjBulkMessageCluster]()
                                    self.arrayBulkMessageList = [ObjBulkMessage]()
                                    let arrayTemp = jsonResult["messages"] as? NSArray
                                    if (arrayTemp != nil)
                                    {
                                        for objTemp in arrayTemp!
                                        {
                                            let objTempDictionary = objTemp as? NSDictionary
                                            
                                            let objNew : ObjBulkMessage = ObjBulkMessage()
                                            objNew .separateParametersForBulkMessage(dictionary: objTempDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayBulkMessageList .append(objNew)
                                            
                                            var boolIsFound: Bool = false
                                            for objTempCluster in self.arrayBulkMessageClusterList
                                            {
                                                if (objTempCluster.strDate == objNew.strDate)
                                                {
                                                    boolIsFound = true
                                                    objTempCluster.arrayMessages.append(objNew)
                                                }
                                            }
                                            
                                            if (boolIsFound == false)
                                            {
                                                let objNewCluster : ObjBulkMessageCluster = ObjBulkMessageCluster()
                                                objNewCluster.strDate = objNew.strDate
                                                objNewCluster.arrayMessages.append(objNew)
                                                
                                                self.arrayBulkMessageClusterList .append(objNewCluster)
                                            }
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_getBulkMessageListEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
        
    // MARK: - VENDOR MOFDE
    
    // MARK: - USER FUNCTION FOR GET ALL MY STORES
    
    func user_GetAllMyClients()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetAllMyClients))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    //SUB CATEGORIES
                                    self.arrayMyClients = [ObjMyClient]()
                                    let arrayClientsLocal = jsonResult["clients"] as? NSArray
                                    if (arrayClientsLocal != nil)
                                    {
                                        for objClientTemp in arrayClientsLocal!
                                        {
                                            let objClientDictionary = objClientTemp as? NSDictionary
                                            
                                            let objNewClient : ObjMyClient = ObjMyClient()
                                            objNewClient .separateParametersForMyClient(dictionary: objClientDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayMyClients .append(objNewClient)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllMyClientsEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR SAVE CLIENT STATUS(MASK)
    
    func user_SaveClientMask(status: String, isStatusUpdate: String, phoneNo: String, clientId: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
//            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_SaveClientMask))!

            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID,
                "status": status,
                "isStatusUpdate": isStatusUpdate,
                "phone_no": phoneNo,
                "client_id": clientId
            ]
            
            print("\(urlComponents.url!)")

            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
//                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
//                            DispatchQueue.main.async(execute: {
//
//                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
//
//                                if(strStatus == "1")
//                                {
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllMyClientsEvent"), object: self)
//                                }
//                                else
//                                {
//                                    let message: String = "\(jsonResult["message"] ?? "")"
//                                    self.showAlertViewWithTitle(title: "", detail: message)
//                                }
//                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
//                        self.appDelegate?.dismissGlobalHUD()
//                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
//                    self.appDelegate?.dismissGlobalHUD()
//                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR CREATE NEW CLIENT
    
    func user_CreateNewClient(status: String, phoneNo: String, clientId: String, name:String, email_id:String, address:String, tax_id:String, observations:String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_SaveClientMask))!

            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID,
                "status": status,
                "phone_no": phoneNo,
                "client_id": clientId,
                "name": name,
                "email_id": email_id,
                "address": address,
                "tax_id": tax_id,
                "observations": observations
            ]
            
            print("\(urlComponents.url!) \n Parameters - \(parameters)")

            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {

                                let strStatus: String = "\(jsonResult["status"] ?? "0")"

                                if(strStatus == "1")
                                {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_CreateNewClientEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL MY STORE ORDERS
    
    func user_GetMyStoreOrders()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetMyStoreOrders))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.totalPageNumberForMyStoreOrders = Int("\(jsonResult["total_pages"] ?? "0")") ?? 0
                                    
                                    self.arrayMyStoreOrdersCluster = [ObjMyStoreOrderCluster]()
                                    self.arrayMyStoreOrders = [ObjMyStoreOrder]()
                                    let arrayOrdersLocal = jsonResult["orders"] as? NSArray
                                    if (arrayOrdersLocal != nil)
                                    {
                                        for objOrderTemp in arrayOrdersLocal!
                                        {
                                            let objOrderDictionary = objOrderTemp as? NSDictionary
                                            
                                            let objNewOrder : ObjMyStoreOrder = ObjMyStoreOrder()
                                            objNewOrder .separateParametersForMyStoreOrderList(dictionary: objOrderDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayMyStoreOrders .append(objNewOrder)
                                            
                                            var boolIsFound: Bool = false
                                            for objTempCluster in self.arrayMyStoreOrdersCluster
                                            {
                                                if (objTempCluster.strDate == objNewOrder.strCreatedDate)
                                                {
                                                    boolIsFound = true
                                                    objTempCluster.arrayOrders.append(objNewOrder)
                                                }
                                            }
                                            
                                            if (boolIsFound == false)
                                            {
                                                let objNewCluster : ObjMyStoreOrderCluster = ObjMyStoreOrderCluster()
                                                objNewCluster.strDate = objNewOrder.strCreatedDate
                                                objNewCluster.arrayOrders.append(objNewOrder)
                                                
                                                self.arrayMyStoreOrdersCluster .append(objNewCluster)
                                            }
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetMyStoreOrdersEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL MY STORE ORDER DETAILS
    
    func user_GetMyStoreOrderDetails(strOrderID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetMyStoreOrderDetails))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "order_id": strOrderID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.objSelectedStoreOrder = ObjMyStoreOrder()
                                    let objOrderDetailsLocal = jsonResult["order"] as? NSDictionary
                                    if (objOrderDetailsLocal != nil)
                                    {
                                        self.objSelectedStoreOrder = ObjMyStoreOrder()
                                        self.objSelectedStoreOrder .separateParametersForMyStoreOrderDetails(dictionary: objOrderDetailsLocal as! Dictionary<String, Any>)
                                        
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetMyStoreOrderDetailsEvent"), object: self)
                                    }
                                    
                                    
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL MY STORE PRODUCT DISCOUNT LINKS
    
    func user_GetMyStoreDiscountLinks(strPageNumber: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetMyStoreDiscountLinks))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID,
                "page_number": strPageNumber
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.totalPageNumberForMyStoreDiscountLinks = Int("\(jsonResult["total_pages"] ?? "0")") ?? 0
                                    
                                    self.arrayMyStoreDiscountLinks = [ObjDiscountLink]()
                                    let arrayOrdersLocal = jsonResult["discounts"] as? NSArray
                                    if (arrayOrdersLocal != nil)
                                    {
                                        for objOrderTemp in arrayOrdersLocal!
                                        {
                                            let objOrderDictionary = objOrderTemp as? NSDictionary
                                            
                                            let objNewOrder : ObjDiscountLink = ObjDiscountLink()
                                            objNewOrder .separateParametersForDiscountLink(dictionary: objOrderDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayMyStoreDiscountLinks .append(objNewOrder)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetMyStoreDiscountLinksEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET ALL MY STORE PRODUCT DISCOUNT LINKS
    
    func user_SaveMyStoreDiscountLink(strProductID: String, strDiscountType: String, strDiscount: String, strExpiryDate: String, strLimit: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_SaveMyStoreDiscount))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                //"store_id": strSelectedStoreID,
                "product_id": strProductID,
                "type": strDiscountType,
                "value": strDiscount,
                "expiration_date": strExpiryDate,
                "limit": strLimit
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_SaveMyStoreDiscountLinkEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET STORE BOOKING LIST
    
    func user_GetStoreBookingList()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetStoreBookingList))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.arrayStoreBookingList = [ObjBookingDate]()
                                    let arrayTemp = jsonResult["bookings"] as? NSArray
                                    if (arrayTemp != nil)
                                    {
                                        for objTemp in arrayTemp!
                                        {
                                            let objTempDictionary = objTemp as? NSDictionary
                                            
                                            let objNew : ObjBookingDate = ObjBookingDate()
                                            objNew .separateParametersForBookingDate(dictionary: objTempDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayStoreBookingList .append(objNew)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetStoreBookingListEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET BOOKING DETAILS
    
    func user_GetBookingDetails(strBookingID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetStoreBookingDetails))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID,
                "booking_id": strBookingID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.objBookingDetails = ObjBookingDetails()
                                    if let objTemp: Dictionary<String, Any> = jsonResult["bookings"] as? Dictionary<String, Any>
                                    {
                                        self.objBookingDetails.separateParametersForBookingDetails(dictionary: objTemp)
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetBookingDetailsEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR ADD STORE PRODUCT
    
    func user_AddStoreProduct(arrayProductImages: Array<Data>,
                              strStoreID: String,
                              strProductType: String,
                              strProductTitle: String,
                              strDescription: String,
                              strMoneyPrice: String,
                              strCityID: String,
                              strIsNational: String,
                              strIsNeedAddress: String,
                              strIsPromo: String,
                              strDiscountedPrice: String,
                              strGift: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: NSLocalizedString("loading_with_photos", value:"Sending data. Please wait as this process may take a while due to photos.", comment: ""))
            
            let strUrlString = String(format:"%@%@", ServerIP, User_AddStoreProduct)
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "product_type": strProductType,
                "title": strProductTitle,
                "description": strDescription,
                "money_price": strMoneyPrice,
                "city": strCityID,
                "is_national": "1",
                "need_address": strNeedAddress,
                "is_promo": strIsPromo,
                "discounted_price": strDiscountedPrice,
                "gift": strGift
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                
                var index: Int = 1
                for imageData in arrayProductImages
                {
                    multipartFormData.append(imageData, withName: "fileName_\(index)",fileName: "fileName_\(index).png" , mimeType: "image/png")
                    
                    index = index + 1
                }
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_AddStoreProductEvent"), object: self)
                            }
                            else
                            {
                                var message: String = "\(jsonResult["message"] ?? "")"
                                
                                if(message == "Failed to Upload Image.null" || message == "Failed to Upload Image.")
                                {
                                    message = NSLocalizedString("failed_to_upload_image", value: "Erro no envio da imagem. Entre em contato com os administradores.", comment: "")
                                }
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR EDIT STORE PRODUCT
    
    func user_EditStoreProduct(arrayProductImages: Array<Data>,
                               strStoreID: String,
                               strProductType: String,
                               strProductTitle: String,
                               strDescription: String,
                               strMoneyPrice: String,
                               strCityID: String,
                               strIsNational: String,
                               strIsNeedAddress: String,
                               strIsPromo: String,
                               strDiscountedPrice: String,
                               strGift: String,
                               strProductID: String,
                               strDeletedImages: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: NSLocalizedString("loading_with_photos", value:"Sending data. Please wait as this process may take a while due to photos.", comment: ""))
            
            let strUrlString = String(format:"%@%@", ServerIP, User_AddStoreProduct)
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "product_type": strProductType,
                "title": strProductTitle,
                "description": strDescription,
                "money_price": strMoneyPrice,
                "city": strCityID,
                "is_national": strIsNational,
                "need_address": strNeedAddress,
                "is_promo": strIsPromo,
                "discounted_price": strDiscountedPrice,
                "gift": strGift,
                "product_id": strProductID,
                "deleted_images": strDeletedImages
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                
                var index: Int = 1
                for imageData in arrayProductImages
                {
                    multipartFormData.append(imageData, withName: "fileName_\(index)",fileName: "fileName_\(index).png" , mimeType: "image/png")
                    
                    index = index + 1
                }
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_EditStoreProductEvent"), object: self)
                            }
                            else
                            {
                                var message: String = "\(jsonResult["message"] ?? "")"
                                
                                if(message == "Failed to Upload Image.null" || message == "Failed to Upload Image.")
                                {
                                    message = NSLocalizedString("failed_to_upload_image", value: "Erro no envio da imagem. Entre em contato com os administradores.", comment: "")
                                }
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR ACTIVATE DEACTIVATE STORE PRODUCT
    
    func user_ActivateDeActivateStoreProduct(strStoreID: String,
                                             strProductID: String,
                                             strIncludeActive: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_ActivateDeActivateStoreProduct))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID,
                "product_id": strProductID,
                "include_active": strIncludeActive
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.appDelegate?.showAlertViewInGreenWithTitle(title: "", detail: message)
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_ActivateDeActivateStoreProductEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET CHECK LOYALTY REWARD
    
    func user_CheckLoyaltyReward(strStoreID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_CheckLoyaltyReward))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.boolIsLoyaltyProgramExist = "\(jsonResult["isExist"] ?? "0")" == "1" ? true : false
                                    
                                    if let dictTemp: Dictionary<String, Any> = jsonResult["rewards"] as? Dictionary<String, Any>
                                    {
                                        self.strPurchaseRequired = "\(dictTemp["purchases_required"] ?? "0")"
                                        self.strReward = "\(dictTemp["reward"] ?? "")"
                                        self.strTotalRewardUsers = "\(dictTemp["totalUsers"] ?? "0")"
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_CheckLoyaltyRewardEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    if (message == "Reward not found!")
                                    {
                                        self.boolIsLoyaltyProgramExist = "\(jsonResult["isExist"] ?? "0")" == "1" ? true : false
                                        
                                        if let dictTemp: Dictionary<String, Any> = jsonResult["rewards"] as? Dictionary<String, Any>
                                        {
                                            self.strPurchaseRequired = "\(dictTemp["purchases_required"] ?? "0")"
                                            self.strReward = "\(dictTemp["reward"] ?? "")"
                                            self.strTotalRewardUsers = "\(dictTemp["totalUsers"] ?? "0")"
                                        }
                                        
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "user_CheckLoyaltyRewardEvent"), object: self)
                                    }
                                    else
                                    {
                                        self.showAlertViewWithTitle(title: "", detail: message)
                                    }
                                    
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR ADD LOYALTY REWARD
    
    func user_AddLoyaltyReward(strStoreID: String, strPurchases: String, strReward: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_AddLoyaltyReward))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "purchases": strPurchases,
                "reward": strReward
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_AddLoyaltyRewardEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR CHECK NEW USER
    
    func user_CheckNewUser(strStoreID: String, strPhoneNumber: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_CheckNewUser))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "phone_number": strPhoneNumber
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.boolIsNewUser = "\(jsonResult["isNew"] ?? "0")" == "1" ? true : false
                                    self.intUserPurchase = Int("\(jsonResult["purchases"] ?? "0")") ?? 0
                                    self.intUserPurchaseRequired = Int("\(jsonResult["purchases_required"] ?? "0")") ?? 0
                                    
                                    if let arrayTemp: Array<Dictionary<String, Any>> = jsonResult["User"] as? Array<Dictionary<String, Any>>
                                    {
                                        if (arrayTemp.count > 0)
                                        {
                                            self.objSelectedRewardUser = ObjRewardUser()
                                            let dictIndex = arrayTemp[0]
                                            self.objSelectedRewardUser?.strID = "\(dictIndex["id"] ?? "0")"
                                            let strFirstName: String = "\(dictIndex["first_name"] ?? "")"
                                            let strLastName: String = "\(dictIndex["last_name"] ?? "")"
                                            if (strFirstName != "<null>" && strLastName != "<null>")
                                            {
                                                self.objSelectedRewardUser?.strFullName = "\(strFirstName) \(strLastName)"
                                            }
                                            else if (strFirstName != "<null>" && strLastName != "<null>")
                                            {
                                                if (strFirstName != "<null>")
                                                {
                                                    self.objSelectedRewardUser?.strFullName = "\(strFirstName)"
                                                }
                                                else
                                                {
                                                    self.objSelectedRewardUser?.strFullName = "\(strLastName)"
                                                }
                                            }
                                            else
                                            {
                                                self.objSelectedRewardUser?.strFullName = ""
                                            }
                                            self.objSelectedRewardUser?.strPhoneNumner = "\(dictIndex["phone_no"] ?? "")"
                                            self.objSelectedRewardUser?.strPurchases = "\(jsonResult["purchases"] ?? "0")"
                                            self.objSelectedRewardUser?.strCreatedDate = "\(dictIndex["created_date"] ?? "")"
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_CheckNewUserEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR SAVE NEW USER FOR REWARD
    
    func user_SaveNewUserForReward(strStoreID: String, strPhoneNumber: String, strFullName: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_SaveNewUserForReward))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "phone_number": strPhoneNumber,
                "name": strFullName
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.objSelectedRewardUser = ObjRewardUser()
                                    self.objSelectedRewardUser?.strID = ""
                                    self.objSelectedRewardUser?.strFullName = strFullName
                                    self.objSelectedRewardUser?.strPhoneNumner = strPhoneNumber
                                    self.objSelectedRewardUser?.strPurchases = "0"
                                    self.objSelectedRewardUser?.strCreatedDate = ""
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "SaveNewUserForRewardEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET TOP REWARD LIST
    
    func user_GetTopRewardList(strStoreID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetTopRewardList))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    self.intAvailablePurchases = Int("\(jsonResult["available_purchases"] ?? "0")") ?? 0
                                    
                                    self.arrayTopRewardList = [ObjRewardUser]()
                                    let arrayTempLocal = jsonResult["rewardUsers"] as? NSArray
                                    if (arrayTempLocal != nil)
                                    {
                                        for objTemp in arrayTempLocal!
                                        {
                                            let objDictionary = objTemp as? NSDictionary
                                            
                                            let objNew : ObjRewardUser = ObjRewardUser()
                                            objNew .separateParametersForRewardUserList(dictionary: objDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayTopRewardList .append(objNew)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetTopRewardListEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR ADD USER REWARD PURCHASE
    
    func user_AddUserRewardPurchase(strStoreID: String, strRewardUserID: String, strValue: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_AddUserRewardPurchase))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                //"user_id": strLogedInUserID,
                "store_id": strStoreID,
                "user_id": strRewardUserID,
                "purchases": strValue
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_AddUserRewardPurchaseEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET USER REWARD HISTORY
    
    func user_GetUserRewardHistory(strStoreID: String, strSelectedUserID: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetUserRewardHistory))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                //"user_id": strLogedInUserID,
                "store_id": strStoreID,
                "user_id": strSelectedUserID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    //self.intAvailablePurchases = Int("\(jsonResult["available_purchases"] ?? "0")") ?? 0
                                    
                                    self.arrayRewardHistory = [ObjRewardHistory]()
                                    let arrayTempLocal = jsonResult["rewardsHistory"] as? NSArray
                                    if (arrayTempLocal != nil)
                                    {
                                        for objTemp in arrayTempLocal!
                                        {
                                            let objDictionary = objTemp as? NSDictionary
                                            
                                            let objNew : ObjRewardHistory = ObjRewardHistory()
                                            objNew .separateParametersForRewardHistory(dictionary: objDictionary as! Dictionary<String, Any>)
                                            
                                            self.arrayRewardHistory .append(objNew)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetUserRewardHistoryEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR GET STORE CHECK LIST
    
    func user_GetStoreCheckList()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_GetStoreCheckList))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    if let objTemp: Dictionary<String, Any> = jsonResult["store"] as? Dictionary<String, Any>
                                    {
                                        self.strStoreName = "\(objTemp["name"] ?? "0")"
                                        self.strStoreSlug = "\(objTemp["slug"] ?? "0")"
                                        let strArray: String = "\(objTemp["checklist"] ?? "0")"
                                        self.arrayStoreCheckList = strArray.components(separatedBy: ",")
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetStoreCheckListEvent"), object: self)
                                }
                                else
                                {
                                    let message: String = "\(jsonResult["message"] ?? "")"
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR VERIFY STORE
    
    func user_VerifyStore(strStoreID: String,
                              strLsncNumber: String,
                              imageData: Data)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: NSLocalizedString("loading_with_photos", value:"Sending data. Please wait as this process may take a while due to photos.", comment: ""))
            
            let strUrlString = String(format:"%@%@", ServerIP, User_VerifyStore)
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strStoreID,
                "tax_id": strLsncNumber
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                
                multipartFormData.append(imageData, withName: "fileName_1",fileName: "fileName_1.png" , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                var message: String = "\(jsonResult["message"] ?? "")"
                                
                                self.strVerifyMessage = message
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_VerifyStoreEvent"), object: self)
                            }
                            else
                            {
                                var message: String = "\(jsonResult["message"] ?? "")"
                                
                                if(message == "Failed to Upload Image.null" || message == "Failed to Upload Image.")
                                {
                                    message = NSLocalizedString("failed_to_upload_image", value: "Erro no envio da imagem. Entre em contato com os administradores.", comment: "")
                                }
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    
    
    // MARK: - USER FUNCTION FOR GET USER
        
    func user_getUser()
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIP, User_GetUser)
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                
                //smultipartFormData.append(imageData, withName: "fileName_1",fileName: "fileName_1.png" , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                if ("\(jsonResult["playstorePointEarned"] ?? "0")" == "1")
                                {
                                    self.boolIsAppStorePointsReceived = true
                                }
                                else
                                {
                                    self.boolIsAppStorePointsReceived = false
                                }
                                
                                if ("\(jsonResult["instagramPointEarned"] ?? "0")" == "1")
                                {
                                    self.boolIsInstagramPointsReceived = true
                                }
                                else
                                {
                                    self.boolIsInstagramPointsReceived = false
                                }
                                
                                if ("\(jsonResult["isRequestUnderApproval"] ?? "0")" == "1")
                                {
                                    self.boolIsRequestUnderApproval = true
                                }
                                else
                                {
                                    self.boolIsRequestUnderApproval = false
                                }
                                
                                if let arrayTemp : Array<Dictionary<String, Any>> = jsonResult["User"] as? Array<Dictionary<String, Any>>
                                {
                                    if arrayTemp.count > 0
                                    {
                                        let dictData = arrayTemp[0]
                                        self.strPointsToolValues = "\(dictData["points"] ?? "")"
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "user_getUserEvent"), object: self)
                                    }
                                }
                            }
                            else
                            {
                                var message: String = "\(jsonResult["message"] ?? "")"
                                
                                if(message == "Failed to Upload Image.null" || message == "Failed to Upload Image.")
                                {
                                    message = NSLocalizedString("failed_to_upload_image", value: "Erro no envio da imagem. Entre em contato com os administradores.", comment: "")
                                }
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR ADD PAYMENT REQUEST
        
    func user_addPaymentRequest(strEmail: String, strName: String, strType: String, strID:String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIPForWebsite, User_AddPaymentRequest)
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            var strKey: String = ""
            if strType == "1"
            {
                strKey = "tax_id"
            }
            else if strType == "2"
            {
                strKey = "payment_code"
            }
            else
            {
                strKey = "address"
            }
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "email": strEmail,
                "name": strName,
                "type": strType,
                strKey: strID,
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                
                //smultipartFormData.append(imageData, withName: "fileName_1",fileName: "fileName_1.png" , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_addPaymentRequestEvent"), object: self)
                            }
                            else
                            {
                                var message: String = "\(jsonResult["message"] ?? "")"
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR ADD REFERRAL POINTS
        
    func user_addReferralPoints(strPoints: String, strType: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIPForWebsite, User_AddReferralPoints)
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "points": strPoints,
                "type": strType
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                
                //smultipartFormData.append(imageData, withName: "fileName_1",fileName: "fileName_1.png" , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                if let dictData: Dictionary<String, Any> = jsonResult["data"] as? Dictionary<String, Any>
                                {
                                    self.strPointsToolValues = "\(dictData["points"] ?? "")"
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_addReferralPointsEvent"), object: self)
                                }
                                
                            }
                            else
                            {
                                var message: String = "\(jsonResult["message"] ?? "")"
                                
                                if(message == "Failed to Upload Image.null" || message == "Failed to Upload Image.")
                                {
                                    message = NSLocalizedString("failed_to_upload_image", value: "Erro no envio da imagem. Entre em contato com os administradores.", comment: "")
                                }
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR UPDATE NAME NUMBER OF STORE
    
    func user_UpdateNameNumberOfStore(strStoreName: String, strStoreNumber: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_UpdateStoreNameNumber))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID,
                "name": strStoreName,
                "phone_number": strStoreNumber
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    if let objTemp: Dictionary<String, Any> = jsonResult["store"] as? Dictionary<String, Any>
                                    {
                                        self.strStoreName = "\(objTemp["name"] ?? "")"
                                        self.strStoreNumber = "\(objTemp["phone_no"] ?? "")"
                                        self.strStoreSlug = "\(objTemp["slug"] ?? "")"
                                    }
                                    
                                    if strStoreName != ""
                                    {
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "user_UpdateNameOfStoreEvent"), object: self)
                                    }
                                    else
                                    {
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "user_UpdateNumberOfStoreEvent"), object: self)
                                    }
                                }
                                else
                                {
                                    var message: String = "\(jsonResult["message"] ?? "")"
                                    
                                    if (message == "user_not_found")
                                    {
                                        message = "User not found"
                                    }
                                    else if (message == "store_not_found")
                                    {
                                        message = "Store not found"
                                    }
                                    else if (message == "user_phone_exists")
                                    {
                                        message = "User PhoneNumber is already Exist"
                                    }
                                    
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR UPDATE SLUG OF STORE
    
    func user_UpdateSlugOfStore(strStoreSlug: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIPForWebsite, User_UpdateSlug)
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID,
                "slug": strStoreSlug
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                
                //smultipartFormData.append(imageData, withName: "fileName_1",fileName: "fileName_1.png" , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                if let objTemp: Dictionary<String, Any> = jsonResult["store"] as? Dictionary<String, Any>
                                {
                                    self.strStoreName = "\(objTemp["name"] ?? "")"
                                    self.strStoreNumber = "\(objTemp["phone_no"] ?? "")"
                                    self.strStoreSlug = "\(objTemp["slug"] ?? "")"
                                }
                                
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "user_UpdateSlugOfStoreEvent"), object: self)
                            }
                            else
                            {
                                var message: String = "\(jsonResult["message"] ?? "")"
                                
                                if (message == "user_not_found")
                                {
                                    message = "User not found"
                                }
                                else if (message == "store_not_found")
                                {
                                    message = "Store not found"
                                }
                                else if (message == "slug_already_exists")
                                {
                                    message = "Slug is already Exist"
                                }
                                
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR MAKE STORE VISIBLE
    
    func user_MakeStoreVisible(strStoreName: String,
                               strStoreNumber: String,
                               strStoreEmail: String,
                               strStoreCategorID: String,
                               strStoreSubCategoryIDs: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let urlComponents = NSURLComponents(string: String(format:"%@%@", ServerIP, User_SetStoreVisible))!
            
            //var array = [URLQueryItem]()
                                    
            //array.append(URLQueryItem(name: "Service", value: "LoadAllMastersOnSplash"))
                        
            //urlComponents.queryItems = array
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            
            let parameters: [String: Any] = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "store_id": strSelectedStoreID,
                "name": strStoreName,
                "phone_number": strStoreNumber,
                "email": strStoreEmail,
                "category_id": strStoreCategorID,
                "subcategory_id": strStoreSubCategoryIDs,
                "store_visible": "1"
            ]
            
            print("\(urlComponents.url!)")
            
            //let strUrlString = String(format:"%@%@", ServerIP, URL_BROWSETAB_DATA)
            
            //var request = URLRequest(url: URL(string: strUrlString)!)
            var request = URLRequest(url: urlComponents.url!)
            let session = URLSession.shared
            request.httpMethod = "POST"
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            } catch let error {
                print(error.localizedDescription)
            }
            //request.setValue(strAccessToken, forHTTPHeaderField: "jwt")
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let data = data {
                    do {
                        self.appDelegate?.dismissGlobalHUD()
                        
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async(execute: {
                                
                                let strStatus: String = "\(jsonResult["status"] ?? "0")"
                                
                                if(strStatus == "1")
                                {
                                    let strPassword: String = "\(jsonResult["password"] ?? "")"
                                    
                                    UserDefaults.standard.setValue(strPassword, forKey: "password")
                                    UserDefaults.standard.setValue("1", forKey: "isAuthorized")
                                    UserDefaults.standard.synchronize()
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_MakeStoreVisibleEvent"), object: self)
                                }
                                else
                                {
                                    var message: String = "\(jsonResult["message"] ?? "")"
                                    
                                    if (message == "user_not_found")
                                    {
                                        message = "User not found"
                                    }
                                    else if (message == "store_not_found")
                                    {
                                        message = "Store not found"
                                    }
                                    else if (message == "user_phone_exists")
                                    {
                                        message = "Este telefone já foi cadastrado. Tente outro."
                                    }
                                    else if (message == "user_email_exists")
                                    {
                                        message = "Este email já foi cadastrado. Tente outro."
                                    }
                                    
                                    self.showAlertViewWithTitle(title: "", detail: message)
                                }
                            })
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        let jsonStr = String(data: data, encoding: .utf8)
                        print("Error could not parse JSON: '\(String(describing: jsonStr))'")
                        self.appDelegate?.dismissGlobalHUD()
                        self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                }
            })
            task.resume()
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
    
    // MARK: - USER FUNCTION FOR UPDATE SLUG OF STORE
    
    func user_GetAllFreeDeliveryStores(strPageNumber: String)
    {
        if (reachability.whenReachable != nil && reachability.connection != .none)
        {
            appDelegate?.showGlobalProgressHUDWithTitle(title: "Loading...")
            
            let strUrlString = String(format:"%@%@", ServerIPForWebsite, User_GetAllFreeDeliveryStores)
            
//            let headers = []
            
            let strLogedInUserID: String = "\(UserDefaults.standard.value(forKey: "user_id") ?? "")"
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            let strSelectedCityID: String = "\(UserDefaults.standard.value(forKey: "city_id") ?? "")"
            
            let parameters = [
                "access_key": "AFDlf7odf8jkfljalk098fdjR",
                "device_type": "3",
                "user_id": strLogedInUserID,
                "city_id": strSelectedCityID,
                "page_number": strPageNumber,
                "per_page": "10"
            ]
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                
                //smultipartFormData.append(imageData, withName: "fileName_1",fileName: "fileName_1.png" , mimeType: "image/png")
                
                for (key, value) in parameters
                {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
            }, usingThreshold:UInt64.init(),
               to: strUrlString, //URL Here
                method: .post,
                headers: nil, //pass header dictionary here
                encodingCompletion:
                { (result) in
                    
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.uploadProgress(closure: { (progress) in
                            //Print progress
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            print(response.result)
                            self.appDelegate?.dismissGlobalHUD()
                            
                            guard response.result.error == nil else {
                                // got an error in getting the data, need to handle it
                                print("error calling POST on /todos/1")
                                print(response.result.error!)
                                self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                return
                            }
                            // make sure we got some JSON since that's what we expect
                            guard let jsonResult = response.result.value as? [String: Any] else {
                                print("didn't get todo object as JSON from API")
                                if let error = response.result.error {
                                    print("Error: \(error)")
                                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                                }
                                return
                            }
                            
                            let strStatus: String = "\(jsonResult["status"] ?? "0")"
                            
                            if(strStatus == "1")
                            {
                                if let dataDict: Dictionary<String, Any> = jsonResult["data"] as? Dictionary<String, Any>
                                {
                                    self.totalPageNumberForFreeDeliveryStores = Int("\(dataDict["totalPages"] ?? "0")") ?? 0
                                    self.strTotalFreeDeliveryStores = "\(dataDict["StoreCount"] ?? "0")"
                                    
                                    if (strPageNumber == "1")
                                    {
                                        self.arrayAllFreeDeliveryStores = [ObjStorePromotion]()
                                    }
                                    
                                    if let arrayStoresLocal: Array<Dictionary<String, Any>> = dataDict["Stores"] as? Array<Dictionary<String, Any>>
                                    {
                                        for objStoreTemp in arrayStoresLocal
                                        {
                                            let objStoreDictionary = objStoreTemp
                                            
                                            let objNewStore : ObjStorePromotion = ObjStorePromotion()
                                            objNewStore .separateParametersForStoreList(dictionary: objStoreDictionary)
                                            
                                            self.arrayAllFreeDeliveryStores .append(objNewStore)
                                        }
                                    }
                                    
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "user_GetAllFreeDeliveryStoresEvent"), object: self)
                                }
                            }
                            else
                            {
                                var message: String = "\(jsonResult["message"] ?? "")"
                                
                                if (message == "user_not_found")
                                {
                                    message = "User not found"
                                }
                                
                                self.showAlertViewWithTitle(title: "", detail: message)
                            }
                        }
                        
                    case .failure(let encodingError): break
                    //print encodingError.description
                    self.appDelegate?.dismissGlobalHUD()
                    self.showAlertViewWithTitle(title: "Server Error", detail: "")
                    }
            })
        }
        else
        {
            print("Connection not available. Please check your internet connection.")
            self.showInternetNotConnectedError()
        }
    }
}
