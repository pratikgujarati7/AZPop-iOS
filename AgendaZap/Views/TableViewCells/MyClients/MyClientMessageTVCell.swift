//
//  MyClientMessageTVCell.swift
//  AgendaZap
//
//  Created by Dipen Lad on 21/04/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class MyClientMessageTVCell: UITableViewCell {
    
    @IBOutlet var btnToggle: UIButton!
    var btnToggleClick: ((_ aCell: MyClientMessageTVCell) -> Void)?
    var btnWhatsappClick: ((_ aCell: MyClientMessageTVCell) -> Void)?
    
    @IBOutlet var lblMessage: UILabel!
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
    @IBAction func btnToggleAction(_ sender: UIButton) {
        if ((self.btnToggleClick) != nil)
        {
            self.btnToggleClick!(self)
        }
    }
    
    @IBAction func btnWhatsappAction(_ sender: UIButton) {
        if ((self.btnWhatsappClick) != nil)
        {
            self.btnWhatsappClick!(self)
        }
    }
    
}
