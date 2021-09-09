//
//  ObjBookingDetails.swift
//  AgendaZap
//
//  Created by Shashank Bansal on 27/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class ObjBookingDetails: NSObject
{
    var strID: String = ""
    var strUserID: String = ""
    var strStoreID: String = ""
    var strName: String = ""
    var strBookingDate: String = ""
    var strLength: String = ""
    var strObservations: String = ""
    var strCreatedDate: String = ""
    var strPhoneNumber: String = ""
    var strStoreName: String = ""
    var strBookingTime: String = ""
    var strBookingDay: String = ""
    var strBookingMonth: String = ""
    var strBookingYear: String = ""
    
    func separateParametersForBookingDetails(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strUserID = "\(dictionary["user_id"] ?? "")"
        strStoreID = "\(dictionary["store_id"] ?? "")"
        strName = "\(dictionary["name"] ?? "")"
        strBookingDate = "\(dictionary["booking_date"] ?? "")"
        strLength = "\(dictionary["length"] ?? "")"
        strObservations = "\(dictionary["observations"] ?? "")"
        strCreatedDate = "\(dictionary["created_date"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_no"] ?? "")"
        strStoreName = "\(dictionary["store_name"] ?? "")"
        strBookingTime = "\(dictionary["booking_time"] ?? "")"
        strBookingDay = "\(dictionary["booking_day"] ?? "")"
        strBookingMonth = "\(dictionary["booking_month"] ?? "")"
        strBookingYear = "\(dictionary["booking_year"] ?? "")"
    }
}
