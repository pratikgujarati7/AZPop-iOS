//
//  ObjQuotationProduct.swift
//  AgendaZap
//
//  Created by Dipen on 18/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import RealmSwift

class ObjQuotationProduct: Object {

    @objc dynamic var strID: String = ""
    @objc dynamic var strProductName: String = ""
    @objc dynamic var strProductQuantity: String = ""
    @objc dynamic var strProductPrice: String = ""
    
}
