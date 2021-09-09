//
//  ObjRewardHistory.swift
//  AgendaZap
//
//  Created by Dipen Lad on 11/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class ObjRewardHistory: NSObject {

    var strDate: String = ""
    var strPurchases: String = ""
    var strFullName: String = ""
    
    func separateParametersForRewardHistory(dictionary :Dictionary<String, Any>)
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
        
        strPurchases = "\(dictionary["purchases"] ?? "")"
        strFullName = "\(dictionary["fullname"] ?? "")"
    }
    
}
