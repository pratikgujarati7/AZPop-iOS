//
//  ObjCartItem.swift
//  AgendaZap
//
//  Created by Dipen on 18/12/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class ObjCartItem: NSObject
{
    var strID: String = ""
    var strUserID: String = ""
    var strPromoID: String = ""
    var strStoreID: String = ""
    var strProductID: String = ""
    var strMoneySpent: String = ""
    var strPointsSpent: String = ""
    var strCityID: String = ""
    var strName: String = ""
    var strEmail: String = ""
    var strPhoneNumber: String = ""
    var strStreet: String = ""
    var strNumber: String = ""
    var strObservation: String = ""
    var strZipcode: String = ""
    var strPaymentMethod: String = ""
    var strActive: String = ""
    var strCreatedDate: String = ""
    var strUpdateDate: String = ""
    var strIsActive: String = ""
    var strIsDelete: String = ""
    var strIsTestData: String = ""
    var strTitle: String = ""
    var strMoneyPrice: String = ""
    var strPointPrice: String = ""
    var strQuantity: String = ""
    var strOrderItemID: String = ""
    
    func separateParametersForCartItem(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strUserID = "\(dictionary["user_id"] ?? "")"
        strPromoID = "\(dictionary["promo_id"] ?? "")"
        strStoreID = "\(dictionary["store_id"] ?? "")"
        strProductID = "\(dictionary["product_id"] ?? "")"
        strMoneySpent = "\(dictionary["money_spent"] ?? "")"
        strPointsSpent = "\(dictionary["points_spent"] ?? "")"
        strCityID = "\(dictionary["city_id"] ?? "")"
        strName = "\(dictionary["name"] ?? "")"
        strEmail = "\(dictionary["email"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_number"] ?? "")"
        strStreet = "\(dictionary["street"] ?? "")"
        strNumber = "\(dictionary["number"] ?? "")"
        strObservation = "\(dictionary["observations"] ?? "")"
        strZipcode = "\(dictionary["zipcode"] ?? "")"
        strPaymentMethod = "\(dictionary["payment_method"] ?? "")"
        strActive = "\(dictionary["active"] ?? "")"
        strCreatedDate = "\(dictionary["created_date"] ?? "")"
        strUpdateDate = "\(dictionary["modified_date"] ?? "")"
        strIsDelete = "\(dictionary["is_delete"] ?? "")"
        strIsTestData = "\(dictionary["is_testdata"] ?? "")"
        strTitle = "\(dictionary["title"] ?? "")"
        strMoneyPrice = "\(dictionary["money_price"] ?? "")"
        strPointPrice = "\(dictionary["points_price"] ?? "")"
        strQuantity = "\(dictionary["quantity"] ?? "")"
        strOrderItemID = "\(dictionary["order_item_id"] ?? "")"
    }
}
