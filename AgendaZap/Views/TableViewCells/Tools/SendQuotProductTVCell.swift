//
//  SendQuotProductTVCell.swift
//  AgendaZap
//
//  Created by Dipen on 20/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class SendQuotProductTVCell: UITableViewCell {
    
    var btnAddClick: ((_ aCell: SendQuotProductTVCell) -> Void)?
    
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
    @IBAction func btnAddAction(_ sender: UIButton) {
        if ((self.btnAddClick) != nil)
        {
            self.btnAddClick!(self)
        }
    }
    
}
