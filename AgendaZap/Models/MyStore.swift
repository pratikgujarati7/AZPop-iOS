//
//  MyStore.swift
//  AgendaZap
//
//  Created by Dipen on 03/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import RealmSwift

class MyStore: Object
{
    @objc dynamic var strID: String = ""
    @objc dynamic var strUserID: String = ""
    @objc dynamic var strName: String = ""
    @objc dynamic var strSlug: String = ""
    @objc dynamic var strCountryCode: String = ""
    @objc dynamic var strPhoneNumber: String = ""
    @objc dynamic var strAddress: String = ""
    @objc dynamic var strStateID: String = ""
    @objc dynamic var strStateName: String = ""
    @objc dynamic var strCityID: String = ""
    @objc dynamic var strCityName: String = ""
    @objc dynamic var strZipCode: String = ""
    @objc dynamic var strEmail: String = ""
    @objc dynamic var strStatus: String = ""
    @objc dynamic var strTaxIdStatus: String = ""
    @objc dynamic var strType: String = ""
    @objc dynamic var strDescription: String = ""
    @objc dynamic var strProfileScore: String = ""
    @objc dynamic var strIsHideAddress: String = ""
    @objc dynamic var strFormatedAddress: String = ""
    
    @objc dynamic var strIsStoreVisible: String = ""
    
    @objc dynamic var strTags: String = ""
    @objc dynamic var strIsEditUnderApproval: String = ""
    @objc dynamic var strIsPromotionUnderApproval: String = ""
    @objc dynamic var strStoreTags: String = ""
    @objc dynamic var strStoreTime: String = ""
    @objc dynamic var strStoreTimeFormated: String = ""
    @objc dynamic var strImages: String = ""
    
    @objc dynamic var strInstagram_link:String = ""
    @objc dynamic var strFacebook_link:String = ""
    @objc dynamic var strIsFreeDelivery:String = ""
    
    var arrayStoreImages = [String]()
    
    var arrayStoreTimings = [String]()
    var arrayStoreTimingsFormated = [String]()
    
    func separateParametersForMyStoreList(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strUserID = "\(dictionary["user_id"] ?? "")"
        strName = "\(dictionary["name"] ?? "")"
        strSlug = "\(dictionary["slug"] ?? "")"
        strCountryCode = "\(dictionary["country_code"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_no"] ?? "")"
        strAddress = "\(dictionary["address"] ?? "")"
        strStateID = "\(dictionary["state_id"] ?? "")"
        strStateName = "\(dictionary["state_name"] ?? "")"
        strCityID = "\(dictionary["city_id"] ?? "")"
        strCityName = "\(dictionary["city_name"] ?? "")"
        strZipCode = "\(dictionary["zip_code"] ?? "")"
        strEmail = "\(dictionary["email_id"] ?? "")"
        strStatus = "\(dictionary["status"] ?? "")"
        strTaxIdStatus = "\(dictionary["tax_id_status"] ?? "")"
        strType = "\(dictionary["type"] ?? "")"
        strDescription = "\(dictionary["description"] ?? "")"
        strProfileScore = "\(dictionary["profile_score"] ?? "")"
        strIsHideAddress = "\(dictionary["hide_address"] ?? "")"
        strFormatedAddress = "\(dictionary["formatted_address"] ?? "")"
        
        strIsStoreVisible = "\(dictionary["is_visible"] ?? "")"
        
        strInstagram_link = "\(dictionary["instagram_link"] ?? "")"
        strFacebook_link = "\(dictionary["facebook_link"] ?? "")"
        strIsFreeDelivery = "\(dictionary["free_delivery"] ?? "0")"
        
        if ("\(dictionary["slug"] ?? "")" != "<null>")
        {
            strSlug = "\(dictionary["slug"] ?? "")"
        }
        
        if ("\(dictionary["tags"] ?? "")" != "<null>")
        {
            strTags = "\(dictionary["tags"] ?? "")"
        }
        
        strIsEditUnderApproval = "\(dictionary["is_edit_under_approval"] ?? "0")"
        strIsPromotionUnderApproval = "\(dictionary["is_promotion_under_approval"] ?? "0")"
        
        if ("\(dictionary["store_tags"] ?? "")" != "<null>")
        {
            strStoreTags = "\(dictionary["store_tags"] ?? "")"
        }
        
        if ("\(dictionary["store_time"] ?? "")" != "<null>")
        {
            strStoreTime = "\(dictionary["store_time"] ?? "")"
        }
        
        if ("\(dictionary["store_images"] ?? "")" != "<null>")
        {
            strImages = "\(dictionary["store_images"] ?? "")"
        }
        
        
        if (strImages != "")
        {
            arrayStoreImages = strImages.components(separatedBy: ",")
        }
        
        
        //TIMINGS
        if (strStoreTime != "")
        {
            let arrayStoreTimingsTemp = strStoreTime.components(separatedBy: ",")
            arrayStoreTimings = [String]()
            arrayStoreTimingsFormated = [String]()
            for strTiming in arrayStoreTimingsTemp
            {
                arrayStoreTimings.append(strTiming)
                let arrayTimingTemp = strTiming.components(separatedBy: "#")
                
                if (arrayTimingTemp.count == 3)
                {
                    let strFinalTime: String = "\(objCommonUtility.arrayWeakDays[Int(arrayTimingTemp[0]) ?? 0]) das \(arrayTimingTemp[1]) até \(arrayTimingTemp[2])"
                    
                    arrayStoreTimingsFormated.append(strFinalTime)
                }
                else
                {
                    arrayStoreTimingsFormated.append(strTiming)
                }
            }
        }
    }

}
