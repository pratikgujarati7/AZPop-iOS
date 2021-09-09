//
//  DiscountLinkTVCell.swift
//  AgendaZap
//
//  Created by Dipen on 22/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class DiscountLinkTVCell: UITableViewCell {
    
    var btnCopyLinkClick: ((_ aCell: DiscountLinkTVCell) -> Void)?
    var btnShareClick: ((_ aCell: DiscountLinkTVCell) -> Void)?
    
    @IBOutlet var imageViewProductImage: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblDiscountValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- IBActions
    @IBAction func btnCopyLinkAction(_ sender: UIButton) {
        if ((self.btnCopyLinkClick) != nil)
        {
            self.btnCopyLinkClick!(self)
        }
    }
    
    @IBAction func btnShareAction(_ sender: UIButton) {
        if ((self.btnShareClick) != nil)
        {
            self.btnShareClick!(self)
        }
    }
    
}
