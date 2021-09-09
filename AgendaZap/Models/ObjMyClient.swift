//
//  ObjMyClient.swift
//  AgendaZap
//
//  Created by Dipen on 06/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class ObjMyClient: NSObject
{
    var strID: String = ""
    var strName: String = ""
    var strPhoneNumber: String = ""
    var strStoreID: String = ""
    var strEmail: String = ""
    var strAddress: String = ""
    var strObservations: String = ""
    var strTaxID: String = ""
    var strStatus: String = ""
    var strUpdateDate: String = ""
    
    func separateParametersForMyClient(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strName = "\(dictionary["name"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_no"] ?? "")"
        strStoreID = "\(dictionary["store_id"] ?? "")"
        strEmail = "\(dictionary["email_id"] ?? "")"
        strAddress = "\(dictionary["address"] ?? "")"
        strObservations = "\(dictionary["observations"] ?? "")"
        strTaxID = "\(dictionary["tax_id"] ?? "")"
        strStatus = "\(dictionary["status"] ?? "")"
        strUpdateDate = "\(dictionary["modified_date"] ?? "")"
    }
}
