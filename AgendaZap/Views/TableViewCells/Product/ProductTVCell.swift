//
//  ProductTVCell.swift
//  AgendaZap
//
//  Created by Dipen on 11/12/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class ProductTVCell: UITableViewCell {
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var imageviewProductCover: UIView!
    @IBOutlet var imageviewProduct: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblPricePointsContainerView: UIView!
    @IBOutlet var lblPricePoints: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
