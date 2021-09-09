//
//  MyStoreClickReport.swift
//  AgendaZap
//
//  Created by Innovative Iteration on 16/04/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class MyStoreClickReport: NSObject
{
    var strPhoneNumber: String = ""
    var strClickDate: String = ""
    var strClickTime: String = ""
    
    func separateParametersForMyStoreClickReport(dictionary :Dictionary<String, Any>)
    {
        strPhoneNumber = "\(dictionary["phone_no"] ?? "")"
        strClickDate = "\(dictionary["click_date"] ?? "")"
        strClickTime = "\(dictionary["click_time"] ?? "")"
    }
}
