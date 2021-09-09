//
//  ObjBooking.swift
//  AgendaZap
//
//  Created by Shashank Bansal on 26/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class ObjBooking: NSObject {

    var strID: String = ""
    var strBookingDate: String = ""
    var strLength: String = ""
    var strCreatedDate: String = ""
    var strName: String = ""
    var strPhoneNumber: String = ""
    var strStoreName: String = ""
    var strBookingTime: String = ""
    
    func separateParametersForBooking(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strBookingDate = "\(dictionary["booking_date"] ?? "")"
        strLength = "\(dictionary["length"] ?? "")"
        strCreatedDate = "\(dictionary["created_date"] ?? "")"
        strName = "\(dictionary["name"] ?? "")"
        strPhoneNumber = "\(dictionary["phone_no"] ?? "")"
        strStoreName = "\(dictionary["store_name"] ?? "")"
        strBookingTime = "\(dictionary["booking_time"] ?? "")"
    }
    
}
