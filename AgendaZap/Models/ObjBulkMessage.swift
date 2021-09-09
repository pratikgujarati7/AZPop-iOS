//
//  ObjBulkMessage.swift
//  AgendaZap
//
//  Created by Dipen Lad on 02/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class ObjBulkMessage: NSObject {
    
    var strDate: String = ""
    var strMessage: String = ""
    var strPhoneNumner: String = ""
    var strSearchString: String = ""
    var strSubCategoryID: String = ""
    var boolIsExpanded: Bool = false
    
    func separateParametersForBulkMessage(dictionary :Dictionary<String, Any>)
    {
        let getDateFormator: DateFormatter = DateFormatter()
        getDateFormator.dateFormat = "YYYY-MM-DD HH:mm:ss"
        let setDateFormator: DateFormatter = DateFormatter()
        setDateFormator.dateFormat = "DD/MM/YY"
        
        if let date: Date = getDateFormator.date(from: "\(dictionary["created_date"] ?? "")")
        {
            strDate = setDateFormator.string(from: date)
        }
        else
        {
            strDate = "-"
        }
        
        strMessage = "\(dictionary["user_message"] ?? "")"
        strPhoneNumner = "\(dictionary["phone_no"] ?? "")"
        strSearchString = "\(dictionary["search_string"] ?? "")"
        strSubCategoryID = "\(dictionary["subcategory_id"] ?? "")"
    }
}
