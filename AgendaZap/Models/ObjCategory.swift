//
//  ObjCategory.swift
//  AgendaZap
//
//  Created by Dipen on 11/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit

class ObjCategory: NSObject
{
    var intCategoryID: Int = 0
    var strCategoryID: String = ""
    var strCategoryName: String = ""
    var strSlug: String = ""
    var arraySubCategories = [ObjSubCategory]()
    
    func separateParametersForCategory(dictionary :Dictionary<String, Any>)
    {
        intCategoryID = Int("\(dictionary["id"] ?? "0")") ?? 0
        strCategoryID = "\(dictionary["id"] ?? "")"
        strCategoryName = "\(dictionary["name"] ?? "")"
        strSlug = "\(dictionary["slug"] ?? "")"
        
        if let arrSubcategories = (dictionary["SubCategories"] as? NSArray) {
            
            for objSubcategoryTemp in arrSubcategories {
                let objSubcategoryDictionary = objSubcategoryTemp as? NSDictionary
                
                let objSubcategory : ObjSubCategory = ObjSubCategory()
                objSubcategory.separateParametersForSubCategory(dictionary: objSubcategoryDictionary as! Dictionary<String, Any>)
                                
                arraySubCategories.append(objSubcategory)
            }
        }
    }
}
