//
//  BookingScheduleTVCell.swift
//  AgendaZap
//
//  Created by Shashank Bansal on 26/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit

class BookingScheduleTVCell: UITableViewCell {
    
    var btnDetailsClick: ((_ aCell: BookingScheduleTVCell) -> Void)?
    
    @IBOutlet var lblBookingTime: UILabel!
    @IBOutlet var lblName: UILabel!

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
    
}
