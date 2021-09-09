//
//  ObjUser.swift
//  AgendaZap
//
//  Created by Dipen on 09/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit

class ObjUser: NSObject
{
    var strUserID: String = ""
    var strSocialMediaID: String = ""
    var strUserRole: String = ""
    var strFirstName: String = ""
    var strLastName: String = ""
    var strEmail: String = ""
    var strPhoneNumber: String = ""
    var strGUID: String = ""
    var strPassword: String = ""
    var strParentId: String = ""
    var strStoreID: String = ""
    
    var strStateID: String = ""
    var strCityID: String = ""
    var strCityName: String = ""
    
    func separateParametersForUser(dictionary :Dictionary<String, Any>)
    {
        strUserID = "\(dictionary["id"] ?? "")"
        strSocialMediaID = "\(dictionary["social_media_id"] ?? "")"
        strUserRole = "\(dictionary["roles"] ?? "")"
        strFirstName = "\(dictionary["first_name"] ?? "")"
        strLastName = "\(dictionary["last_name"] ?? "")"
        strEmail = "\(dictionary["email_id"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_no"] ?? "")"
        strGUID = "\(dictionary["guid"] ?? "")"
        strPassword = "\(dictionary["password"] ?? "")"
        
        if ("\(dictionary["parent_id"] ?? "")" != "<null>")
        {
            strParentId = "\(dictionary["parent_id"] ?? "")"
        }
        
        if ("\(dictionary["store_id"] ?? "")" != "<null>")
        {
            strStoreID = "\(dictionary["store_id"] ?? "")"
        }
        
        if ("\(dictionary["state_id"] ?? "")" != "<null>")
        {
            strStateID = "\(dictionary["state_id"] ?? "")"
        }
        
        if ("\(dictionary["city_id"] ?? "")" != "<null>")
        {
            strCityID = "\(dictionary["city_id"] ?? "")"
        }
        
        if ("\(dictionary["city"] ?? "")" != "<null>")
        {
            strCityName = "\(dictionary["city"] ?? "")"
        }
    }
}
