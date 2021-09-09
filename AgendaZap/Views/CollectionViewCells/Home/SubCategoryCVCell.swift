//
//  SubCategoryCVCell.swift
//  AgendaZap
//
//  Created by Innovative on 31/10/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class SubCategoryCVCell: UICollectionViewCell {

    @IBOutlet var mainContainerView: UIView!
    @IBOutlet var imgSubCategory: UIImageView!
    @IBOutlet var lblSubCatName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        self.imgSubCategory.layer.cornerRadius = 10.0
    }
    
}
