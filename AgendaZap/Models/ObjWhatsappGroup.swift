//
//  ObjWhatsappGroup.swift
//  AgendaZap
//
//  Created by n on 29/10/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class ObjWhatsappGroup: NSObject
{
    var intGroupID          : Int    = 0
    var strGroupTitle       : String = ""
    var strGroupDescription : String = ""
    var strGroupUrl         : String = ""
    var intGroupCategory    : Int    = 0
    var strSlug             : String = ""
    var strCategoryName     : String = ""
    var strTags             : String = ""
    
    func separateParametersForWhatsappGroup(dictionary :Dictionary<String, Any>)
    {
        intGroupID          = Int("\(dictionary["id"] ?? "0")") ?? 0
        strGroupTitle       = "\(dictionary["title"] ?? "")"
        strGroupDescription = "\(dictionary["description"] ?? "")"
        strGroupUrl         = "\(dictionary["group_url"] ?? "")"
        intGroupCategory    = Int("\(dictionary["group_category"] ?? "0")") ?? 0
        strSlug             = "\(dictionary["slug"] ?? "")"
        strCategoryName     = "\(dictionary["category_name"] ?? "")"
        
        if ("\(dictionary["tags"] ?? "")" != "<null>")
        {
            strTags = "\(dictionary["tags"] ?? "")"
        }
    }
    
    
}
