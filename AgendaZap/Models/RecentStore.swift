//
//  RecentStore.swift
//  AgendaZap
//
//  Created by Dipen on 31/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
import RealmSwift

class RecentStore: Object
{
    @objc dynamic var strID: String = ""
    @objc dynamic var strUserID: String = ""
    @objc dynamic var strName: String = ""
    @objc dynamic var strCountryCode: String = ""
    @objc dynamic var strPhoneNumber: String = ""
    @objc dynamic var strAddress: String = ""
    @objc dynamic var strStateID: String = ""
    @objc dynamic var strCityID: String = ""
    @objc dynamic var strZipCode: String = ""
    @objc dynamic var strEmail: String = ""
    @objc dynamic var strStatus: String = ""
    @objc dynamic var strType: String = ""
    @objc dynamic var strTitle: String = ""
    @objc dynamic var strDescription: String = ""
    @objc dynamic var strProfileScore: String = ""
    @objc dynamic var strLatitude: String = ""
    @objc dynamic var strLongitude: String = ""
    @objc dynamic var strDistance: String = ""
    @objc dynamic var strIsHideAddress: String = ""
    @objc dynamic var strCats: String = ""
    
    var arrayCategoryIDs = [Int]()
    
    @objc dynamic var strPromo: String = ""
    @objc dynamic var strTags: String = ""
    @objc dynamic var strIsFavourite: String = ""
    
    func separateParametersForRecentStoreList(dictionary :Dictionary<String, Any>)
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
        strType = "\(dictionary["type"] ?? "")"
        strTitle = "\(dictionary["title"] ?? "")" //N
        strDescription = "\(dictionary["description"] ?? "")"
        strProfileScore = "\(dictionary["profile_score"] ?? "")"
        strLatitude = "\(dictionary["lat"] ?? "")"
        strLongitude = "\(dictionary["lng"] ?? "")"
        strDistance = ""
        strIsHideAddress = "\(dictionary["hide_address"] ?? "")"
        
        if ("\(dictionary["promo"] ?? "")" != "<null>")//N
        {
            strPromo = "\(dictionary["promo"] ?? "")"
        }
        strTags = "\(dictionary["subs"] ?? "")"
        strIsFavourite = "\(dictionary["is_fav"] ?? "0")"
    }
}

