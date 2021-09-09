//
//  ProductCVCell.swift
//  AgendaZap
//
//  Created by Dipen on 24/12/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class ProductCVCell: UICollectionViewCell {
    
    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var imgViewProduct: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblProductPricePoints: UILabel!
    
    @IBOutlet var viewAllContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
