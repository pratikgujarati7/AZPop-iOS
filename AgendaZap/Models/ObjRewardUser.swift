//
//  ObjRewardUser.swift
//  AgendaZap
//
//  Created by Dipen Lad on 11/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class ObjRewardUser: NSObject {
    
    var strID: String = ""
    var strFullName: String = ""
    var strPhoneNumner: String = ""
    var strPurchases: String = ""
    var strCreatedDate: String = ""
    
    func separateParametersForRewardUserList(dictionary :Dictionary<String, Any>)
    {
        strFullName = "\(dictionary["fullname"] ?? "")"
        strPhoneNumner = "\(dictionary["phone_no"] ?? "")"
        strPurchases = "\(dictionary["purchases"] ?? "")"
        strCreatedDate = "\(dictionary["created_date"] ?? "")"
    }

}
