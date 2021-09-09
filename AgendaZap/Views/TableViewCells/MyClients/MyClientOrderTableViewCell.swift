//
//  MyClientOrderTableViewCell.swift
//  AgendaZap
//
//  Created by Dipen Lad on 21/04/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class MyClientOrderTableViewCell: UITableViewCell {
    
    var btnDetailsClick: ((_ aCell: MyClientOrderTableViewCell) -> Void)?
    var btnWhatsappClick: ((_ aCell: MyClientOrderTableViewCell) -> Void)?
    
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var lblNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- IBActions
    @IBAction func btnDetailsAction(_ sender: UIButton) {
        if ((self.btnDetailsClick) != nil)
        {
            self.btnDetailsClick!(self)
        }
    }
    
    @IBAction func btnWhatsappAction(_ sender: UIButton) {
        if ((self.btnWhatsappClick) != nil)
        {
            self.btnWhatsappClick!(self)
        }
    }
    
}
