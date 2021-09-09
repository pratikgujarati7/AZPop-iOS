//
//  ObjCity.swift
//  AgendaZap
//
//  Created by Dipen on 10/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit

class ObjCity: NSObject
{
    var intCityID: Int = 0
    var strCityID: String = ""
    var strStateID: String = ""
    var strCityName: String = ""
    var strCityNonAccentedName: String = ""
    
    func separateParametersForCity(dictionary :Dictionary<String, Any>)
    {
        intCityID = Int("\(dictionary["id"] ?? "0")") ?? 0
        strCityID = "\(dictionary["id"] ?? "")"
        strStateID = "\(dictionary["state_id"] ?? "")"
        strCityName = "\(dictionary["name"] ?? "")"
        strCityNonAccentedName = "\(dictionary["nonAccentedName"] ?? "")"
    }
}
