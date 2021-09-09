//
//  ObjDiscountLink.swift
//  AgendaZap
//
//  Created by Dipen on 25/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class ObjDiscountLink: NSObject {
    
    var strID: String = ""
    var strProductID: String = ""
    var strType: String = ""
    var strValue: String = ""
    var strLimit: String = ""
    var strUsedLimit: String = ""
    var strExpirationDate: String = ""
    var strClicks: String = ""
    var strOrders: String = ""
    var strActive: String = ""
    var strCreatedDate: String = ""
    var strUpdatedDate: String = ""
    var strStoreID: String = ""
    var strTitle: String = ""
    var strSlug: String = ""
    var strMoneyPrice: String = ""
    var strPointPrice: String = ""
    var strDiscountLink: String = ""
    
    
    func separateParametersForDiscountLink(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strProductID = "\(dictionary["product_id"] ?? "")"
        strType = "\(dictionary["type"] ?? "")"
        strValue = "\(dictionary["value"] ?? "")"
        strLimit = "\(dictionary["limit"] ?? "")"
        strUsedLimit = "\(dictionary["used_limit"] ?? "")"
        strExpirationDate = "\(dictionary["expiration_date"] ?? "")"
        strClicks = "\(dictionary["clicks"] ?? "")"
        strOrders = "\(dictionary["orders"] ?? "")"
        strActive = "\(dictionary["active"] ?? "")"
        strCreatedDate = "\(dictionary["created_date"] ?? "")"
        strUpdatedDate = "\(dictionary["modified_date"] ?? "")"
        strStoreID = "\(dictionary["store_id"] ?? "")"
        strTitle = "\(dictionary["title"] ?? "")"
        strSlug = "\(dictionary["slug"] ?? "")"
        strMoneyPrice = "\(dictionary["money_price"] ?? "")"
        strPointPrice = "\(dictionary["points_price"] ?? "")"
        strDiscountLink = "\(dictionary["discount_link"] ?? "")"
    }
}
