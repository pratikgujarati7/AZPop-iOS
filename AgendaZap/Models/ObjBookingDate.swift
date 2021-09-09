//
//  ObjBookingDate.swift
//  AgendaZap
//
//  Created by Shashank Bansal on 26/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class ObjBookingDate: NSObject {

    var strDate: String = ""
    var arrayBookings = [ObjBooking]()
    
    func separateParametersForBookingDate(dictionary :Dictionary<String, Any>)
    {
        strDate = "\(dictionary["booking_date"] ?? "")"
        
        arrayBookings = [ObjBooking]()
        
        if let arrayTemp: Array<Dictionary<String, Any>> = dictionary["booking"] as? Array<Dictionary<String, Any>>
        {
            for objTemp in arrayTemp
            {
                let objNew: ObjBooking = ObjBooking()
                objNew.separateParametersForBooking(dictionary: objTemp)
                arrayBookings.append(objNew)
            }
            
        }
    }
}
