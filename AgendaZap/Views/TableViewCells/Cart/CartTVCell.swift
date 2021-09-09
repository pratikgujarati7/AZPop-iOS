//
//  CartTVCell.swift
//  AgendaZap
//
//  Created by Dipen on 18/12/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class CartTVCell: UITableViewCell {
    
    var btnDeleteClick: ((_ aCell: CartTVCell) -> Void)?
    var btnMinusClick: ((_ aCell: CartTVCell) -> Void)?
    var btnPlusClick: ((_ aCell: CartTVCell) -> Void)?
    
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblProductPrice: UILabel!
    
    @IBOutlet var btnDelete: UIButton!
    
    @IBOutlet var btnMinus: UIButton!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var btnPlus: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- IBActions
    @IBAction func btnDeleteAction(_ sender: UIButton) {
        if ((self.btnDeleteClick) != nil)
        {
            self.btnDeleteClick!(self)
        }
    }
    
    @IBAction func btnMinusAction(_ sender: UIButton) {
        if ((self.btnMinusClick) != nil)
        {
            self.btnMinusClick!(self)
        }
    }
    
    @IBAction func btnPlusAction(_ sender: UIButton) {
        if ((self.btnPlusClick) != nil)
        {
            self.btnPlusClick!(self)
        }
    }
    
}
