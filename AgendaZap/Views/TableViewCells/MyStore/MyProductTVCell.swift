//
//  MyProductTVCell.swift
//  AgendaZap
//
//  Created by Dipen Lad on 05/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class MyProductTVCell: UITableViewCell {
    
    var btnShareClick: ((_ aCell: MyProductTVCell) -> Void)?
    var btnOptionsClick: ((_ aCell: MyProductTVCell) -> Void)?
    
    @IBOutlet var imageViewProduct: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblProductPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- IBActions
    @IBAction func btnShareAction(_ sender: UIButton) {
        if ((self.btnShareClick) != nil)
        {
            self.btnShareClick!(self)
        }
    }
    
    @IBAction func btnOptionsAction(_ sender: UIButton) {
        if ((self.btnOptionsClick) != nil)
        {
            self.btnOptionsClick!(self)
        }
    }
}
