//
//  ObjWhatsappCategory.swift
//  AgendaZap
//
//  Created by n on 29/10/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class ObjWhatsappCategory: NSObject
{
    var intCategoryID    : Int    = 0
    var strCategoryColor : String = ""
    var strCategoryName  : String = ""
    
    func separateParametersForWhatsappCategory(dictionary :Dictionary<String, Any>)
    {
        intCategoryID    = Int("\(dictionary["id"] ?? "0")") ?? 0
        strCategoryColor = "\(dictionary["color"] ?? "")"
        strCategoryName  = "\(dictionary["name"] ?? "")"
    }
}
