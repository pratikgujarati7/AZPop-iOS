//
//  ObjReview.swift
//  AgendaZap
//
//  Created by Dipen on 21/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit

class ObjReview: NSObject
{
    var objStoreID: String = ""
    var strUserID: String = ""
    var strRate: String = ""
    var strReviewText: String = ""
    var strReviewDate: String = ""
    
    func separateParametersForReview(dictionary :Dictionary<String, Any>)
    {
        objStoreID = "\(dictionary["store_id"] ?? "")"
        strUserID = "\(dictionary["user_id"] ?? "")"
        strRate = "\(dictionary["rate"] ?? "")"
        strReviewText = "\(dictionary["review_text"] ?? "")"
        strReviewDate = "\(dictionary["created"] ?? "")"
    }
}
