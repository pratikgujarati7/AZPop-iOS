//
//  ObjPromotionDetails.swift
//  AgendaZap
//
//  Created by Dipen on 28/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit

class ObjPromotionDetails: NSObject
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
    var strType: String = ""
    var strTitle: String = ""
    var strDescription: String = ""
    var strProfileScore: String = ""
    var strLatitude: String = ""
    var strLongitude: String = ""
    var strDistance: String = ""
    var strIsHideAddress: String = ""
    var strPromotionID: String = ""
    var strPromotionImages: String = ""
    var strFormatedAddress: String = ""
    
    var arrayImages = [String]()
    
    func separateParametersForPromotionDetails(dictionary :Dictionary<String, Any>)
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
        
        strTitle = "\(dictionary["title"] ?? "")"
        
        strDescription = "\(dictionary["details"] ?? "")"
        strProfileScore = "\(dictionary["profile_score"] ?? "")"
        strLatitude = "\(dictionary["lat"] ?? "")"
        strLongitude = "\(dictionary["lng"] ?? "")"
        strIsHideAddress = "\(dictionary["hide_address"] ?? "")"
        
        strPromotionID = "\(dictionary["promotion_id"] ?? "")"
        if(strPromotionID == "")
        {
            strPromotionID = "0"
        }
        
        if ("\(dictionary["promotion_images"] ?? "")" != "<null>")
        {
            strPromotionImages = "\(dictionary["promotion_images"] ?? "")"
        }
        
        strFormatedAddress = "\(dictionary["formatted_address"] ?? "")"
        
        
        //TAGS
        if (strPromotionImages != "")
        {
            let arrayImagesTemp = strPromotionImages.components(separatedBy: ",")
            arrayImages = [String]()
            for strImageURL in arrayImagesTemp
            {
                arrayImages.append(strImageURL)
            }
        }
    }
}
