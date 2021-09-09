//
//  ObjStorePromotion.swift
//  AgendaZap
//
//  Created by Dipen on 12/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import CoreLocation

class ObjStorePromotion: NSObject
{
    var strID: String = ""
    var strUserID: String = ""
    var strName: String = ""
    var strCountryCode: String = ""
    var strPhoneNumber: String = ""
    var strAddress: String = ""
    var strStateID: String = ""
    var strCityID: String = ""
    var strZipCode: String = ""
    var strEmail: String = ""
    var strStatus: String = ""
    var strTaxIdStatus: String = ""
    var strType: String = ""
    var strTitle: String = ""
    var strDescription: String = ""
    var strProfileScore: String = ""
    var strLatitude: String = ""
    var strLongitude: String = ""
    var strDistance: String = ""
    var strIsHideAddress: String = ""
    var strCats: String = ""
    
    var arrayCategoryIDs = [Int]()
    
    var strPromo: String = ""
    var strTags: String = ""
    var strIsFavourite: String = ""
    var strIsBlocked: String = ""
    var strBlockedTitle: String = ""
    var strBlockedMessage: String = ""
    var strIsFreeDelivery: String = ""
    
    func separateParametersForStorePromotion(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strUserID = "\(dictionary["user_id"] ?? "")"
        strName = "\(dictionary["name"] ?? "")"
        strCountryCode = "\(dictionary["country_code"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_no"] ?? "")"
        strAddress = "\(dictionary["address"] ?? "")"
        strStateID = "\(dictionary["state_id"] ?? "")"
        strCityID = "\(dictionary["city_id"] ?? "")"
        strZipCode = "\(dictionary["zip_code"] ?? "")"
        strEmail = "\(dictionary["email_id"] ?? "")"
        strStatus = "\(dictionary["status"] ?? "")"
        strTaxIdStatus = "\(dictionary["tax_id_status"] ?? "")"
        strType = "\(dictionary["type"] ?? "")"
        strTitle = "\(dictionary["title"] ?? "")"
        strDescription = "\(dictionary["description"] ?? "")"
        strProfileScore = "\(dictionary["profile_score"] ?? "")"
        strLatitude = "\(dictionary["lat"] ?? "")"
        strLongitude = "\(dictionary["lng"] ?? "")"
        strIsHideAddress = "\(dictionary["hide_address"] ?? "")"
        strCats = "\(dictionary["cats"] ?? "")"
        
        let arrayCategoryTemp = strCats.components(separatedBy: ",")
        arrayCategoryIDs = [Int]()
        for strCategory in arrayCategoryTemp
        {
            let intCategoryID = Int(strCategory) ?? 0
            arrayCategoryIDs.append(intCategoryID)
        }
        
        strIsBlocked = "\(dictionary["blocked"] ?? "0")"
        strBlockedTitle = "\(dictionary["blocked_msg_title"] ?? "")"
        strBlockedMessage = "\(dictionary["blocked_msg_desc"] ?? "")"
        strIsFreeDelivery = "\(dictionary["free_delivery"] ?? "0")"
    }
    
    func separateParametersForStoreList(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strUserID = "\(dictionary["user_id"] ?? "")"
        strName = "\(dictionary["name"] ?? "")"
        strCountryCode = "\(dictionary["country_code"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_no"] ?? "")"
        strAddress = "\(dictionary["address"] ?? "")"
        strStateID = "\(dictionary["state_id"] ?? "")"
        strCityID = "\(dictionary["city_id"] ?? "")"
        strZipCode = "\(dictionary["zip_code"] ?? "")"
        strEmail = "\(dictionary["email_id"] ?? "")"
        strStatus = "\(dictionary["status"] ?? "")"
        strTaxIdStatus = "\(dictionary["tax_id_status"] ?? "")"
        strType = "\(dictionary["type"] ?? "")"
        strTitle = "\(dictionary["title"] ?? "")"
        strDescription = "\(dictionary["description"] ?? "")"
        strProfileScore = "\(dictionary["profile_score"] ?? "")"
        strLatitude = "\(dictionary["lat"] ?? "")"
        strLongitude = "\(dictionary["lng"] ?? "")"
        
        if ((Float(strLatitude) ?? 0) != 0 && (Float(strLongitude) ?? 0) != 0 && dataManager.currentLocation.coordinate.latitude != 0 && dataManager.currentLocation.coordinate.latitude != 0)
        {
            let storeLocation: CLLocation = CLLocation(latitude: (CLLocationDegrees(Float(strLatitude) ?? 0)), longitude: (CLLocationDegrees(Float(strLongitude) ?? 0)))

            let strDistanceTemp: String = objCommonUtility.calculateDistanceInKiloMeters(coordinateOne: dataManager.currentLocation, coordinateTwo: storeLocation)

            strDistance = "\(strDistanceTemp)"

        }
        else
        {
            strDistance = "9999999999"
        }
        
        strIsHideAddress = "\(dictionary["hide_address"] ?? "")"
        
        if ("\(dictionary["promo"] ?? "")" != "<null>")
        {
            strPromo = "\(dictionary["promo"] ?? "")"
        }
        strTags = "\(dictionary["tags"] ?? "")"
        strIsFavourite = "\(dictionary["is_fav"] ?? "0")"
        
        strIsBlocked = "\(dictionary["blocked"] ?? "0")"
        strBlockedTitle = "\(dictionary["blocked_msg_title"] ?? "")"
        strBlockedMessage = "\(dictionary["blocked_msg_desc"] ?? "")"
        strIsFreeDelivery = "\(dictionary["free_delivery"] ?? "0")"
    }
}
