//
//  ObjOrderItem.swift
//  AgendaZap
//
//  Created by Dipen on 09/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class ObjOrderItem: NSObject
{
    var strID: String = ""
    var strOrderID: String = ""
    var strProductID: String = ""
    var strMoneyPrice: String = ""
    var strPointPrice: String = ""
    var strDiscount: String = ""
    var strQuantity: String = ""
    var strCreatedDate: String = ""
    var strUpdatedDate: String = ""
    var strStoreID: String = ""
    var strCategoryID: String = ""
    var strTitle: String = ""
    var strSlug: String = ""
    var strDescription: String = ""
    var strCityID: String = ""
    var strIsNational: String = ""
    var strProductType: String = ""
    var strNeedAddress: String = ""
    var strRejectReason: String = ""
    var strQualityScore: String = ""
    
    
    func separateParametersForOrderItem(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strOrderID = "\(dictionary["order_id"] ?? "")"
        strProductID = "\(dictionary["product_id"] ?? "")"
        strMoneyPrice = "\(dictionary["money_price"] ?? "")"
        strPointPrice = "\(dictionary["points_price"] ?? "")"
        strDiscount = "\(dictionary["discount"] ?? "")"
        strQuantity = "\(dictionary["quantity"] ?? "")"
        strCreatedDate = "\(dictionary["created_date"] ?? "")"
        strUpdatedDate = "\(dictionary["modified_date"] ?? "")"
        strStoreID = "\(dictionary["store_id"] ?? "")"
        strCategoryID = "\(dictionary["category_id"] ?? "")"
        strTitle = "\(dictionary["title"] ?? "")"
        strSlug = "\(dictionary["slug"] ?? "")"
        strDescription = "\(dictionary["description"] ?? "")"
        strCityID = "\(dictionary["city_id"] ?? "")"
        strIsNational = "\(dictionary["is_national"] ?? "")"
        strProductType = "\(dictionary["product_type"] ?? "")"
        strNeedAddress = "\(dictionary["need_address"] ?? "")"
        strRejectReason = "\(dictionary["reject_reason"] ?? "")"
        strQualityScore = "\(dictionary["quality_score"] ?? "")"
    }
}
