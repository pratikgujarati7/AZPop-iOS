//
//  ObjSubCategory.swift
//  AgendaZap
//
//  Created by Dipen on 12/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit

class ObjSubCategory: NSObject
{
    var intSubCategoryID: Int = 0
    var strSubCategoryID: String = ""
    var strSubCategoryName: String = ""
    
    func separateParametersForSubCategory(dictionary :Dictionary<String, Any>)
    {
        intSubCategoryID = Int("\(dictionary["id"] ?? "0")") ?? 0
        strSubCategoryID = "\(dictionary["id"] ?? "")"
        strSubCategoryName = "\(dictionary["name"] ?? "")"
    }
}
