//
//  PromotionTVCell.swift
//  AgendaZap
//
//  Created by Innovative on 05/11/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class PromotionTVCell: UITableViewCell {

    var btnWhatsappClick: ((_ aCell: PromotionTVCell) -> Void)?
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var btnSeeDetails: UIButtonX!
    @IBOutlet var viewWhatsappContainer: UIViewX!
    @IBOutlet var btnWhatsapp: UIButton!
    @IBOutlet var lblWhatsapp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //lblCategoryName.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        self.btnWhatsapp.layer.cornerRadius = self.btnWhatsapp.frame.size.height/2
    }
    
    @IBAction func btnSeeDetailsAction(_ sender: UIButtonX) {
    }
    
    @IBAction func btnWhatsappAction(_ sender: UIButton) {
        if ((self.btnWhatsappClick) != nil)
        {
            self.btnWhatsappClick!(self)
        }
    }
    
}
