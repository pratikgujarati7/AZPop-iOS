//
//  ObjMainScreenSearch.swift
//  AgendaZap
//
//  Created by Dipen on 11/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit

class ObjMainScreenSearch: NSObject
{
    var strID: String = ""
    var strCityID: String = ""
    var strType: String = ""
    var StrSortOrder: String = ""
    var strIconID: String = ""
    var strTitle: String = ""
    var strSearchKeyword: String = ""
    var strCategoryID: String = ""
    var strIconURL: String = ""
    var strCategoryName: String = ""
    
    func separateParametersForMainScreenSearch(dictionary :Dictionary<String, Any>)
    {
        strID = "\(dictionary["id"] ?? "")"
        strCityID = "\(dictionary["city_id"] ?? "")"
        strType = "\(dictionary["type"] ?? "")"
        StrSortOrder = "\(dictionary["sort_order"] ?? "")"
        strIconID = "\(dictionary["icon_id"] ?? "0")"
        strTitle = "\(dictionary["title"] ?? "")"
        strSearchKeyword = "\(dictionary["search_keyword"] ?? "")"
        strCategoryID = "\(dictionary["category_id"] ?? "")"
        strIconURL = "\(dictionary["icon_url"] ?? "")"
        strCategoryName = "\(dictionary["category_name"] ?? "")"
    }
}
