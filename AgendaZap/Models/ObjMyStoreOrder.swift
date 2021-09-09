//
//  ObjMyStoreOrder.swift
//  AgendaZap
//
//  Created by Dipen on 09/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class ObjMyStoreOrder: NSObject
{
    var strID: String = ""
    var strMoneySpent: String = ""
    var strPointSpent: String = ""
    var strProductCount: String = ""
    var strCreatedDate: String = ""
    
    //DETAILS
    var strUserID: String = ""
    var strPromoID: String = ""
    var strStoreID: String = ""
    var strProductID: String = ""
    var strDiscount: String = ""
    var strCityID: String = ""
    var strName: String = ""
    var strEmail: String = ""
    var strPhoneNumber: String = ""
    var strStreet: String = ""
    var strNumber: String = ""
    var strObservations: String = ""
    var strZipcode: String = ""
    var strPaymentMethod: String = ""
    var strUpdatedDate: String = ""
    var strStoreName: String = ""
    var strUserCity: String = ""
    var arrayOrderItems = [ObjOrderItem]()
    
    
    func separateParametersForMyStoreOrderList(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strMoneySpent = "\(dictionary["money_spent"] ?? "")"
        strPointSpent = "\(dictionary["points_spent"] ?? "")"
        strProductCount = "\(dictionary["product_count"] ?? "")"
        strPaymentMethod = "\(dictionary["payment_method"] ?? "")"
        strName = "\(dictionary["name"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_number"] ?? "")"
        
        let getDateFormator: DateFormatter = DateFormatter()
        getDateFormator.dateFormat = "YYYY-MM-DD HH:mm:ss"
        let setDateFormator: DateFormatter = DateFormatter()
        setDateFormator.dateFormat = "DD/MM/YYYY"
        
        if let date: Date = getDateFormator.date(from: "\(dictionary["created_date"] ?? "")")
        {
            strCreatedDate = setDateFormator.string(from: date)
        }
        else
        {
            strCreatedDate = "-"
        }
    }
    
    
    func separateParametersForMyStoreOrderDetails(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strMoneySpent = "\(dictionary["money_spent"] ?? "")"
        strPointSpent = "\(dictionary["points_spent"] ?? "")"
        strProductCount = "\(dictionary["product_count"] ?? "")"
        strUserID = "\(dictionary["user_id"] ?? "")"
        strPromoID = "\(dictionary["promo_id"] ?? "")"
        strStoreID = "\(dictionary["store_id"] ?? "")"
        strProductID = "\(dictionary["product_id"] ?? "")"
        strDiscount = "\(dictionary["discount"] ?? "")"
        strCityID = "\(dictionary["city_id"] ?? "")"
        strName = "\(dictionary["name"] ?? "")"
        strEmail = "\(dictionary["email"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_number"] ?? "")"
        strStreet = "\(dictionary["street"] ?? "")"
        strNumber = "\(dictionary["number"] ?? "")"
        strObservations = "\(dictionary["observations"] ?? "")"
        strZipcode = "\(dictionary["zipcode"] ?? "")"
        strPaymentMethod = "\(dictionary["payment_method"] ?? "")"
        strUpdatedDate = "\(dictionary["modified_date"] ?? "")"
        strStoreName = "\(dictionary["store_name"] ?? "")"
        strUserCity = "\(dictionary["user_city"] ?? "")"
        
        let getDateFormator: DateFormatter = DateFormatter()
        getDateFormator.dateFormat = "YYYY-MM-DD HH:mm:ss"
        let setDateFormator: DateFormatter = DateFormatter()
        setDateFormator.dateFormat = "DD/MM/YYYY"
        
        if let date: Date = getDateFormator.date(from: "\(dictionary["created_date"] ?? "")")
        {
            strCreatedDate = setDateFormator.string(from: date)
        }
        else
        {
            strCreatedDate = "-"
        }
        
        self.arrayOrderItems = [ObjOrderItem]()
        let arrayProductsLocal = dictionary["order_items"] as? NSArray
        if (arrayProductsLocal != nil)
        {
            for objProductTemp in arrayProductsLocal!
            {
                let objProductDictionary = objProductTemp as? NSDictionary
                
                let objNew : ObjOrderItem = ObjOrderItem()
                objNew .separateParametersForOrderItem(dictionary: objProductDictionary as! Dictionary<String, Any>)
                
                self.arrayOrderItems .append(objNew)
            }
        }
    }
}
