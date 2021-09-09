//
//  StoreTVCell.swift
//  AgendaZap
//
//  Created by Innovative on 05/11/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit

class StoreTVCell: UITableViewCell {

    var btnWhatsappClick: ((_ aCell: StoreTVCell) -> Void)?
    
    @IBOutlet var lblStoreName: UILabel!
    @IBOutlet var viewPriorityContainer: UIViewX!
    @IBOutlet var lblPriority: UILabel!
    @IBOutlet var viewFreeDeliveryContainer: UIViewX!
    @IBOutlet var lblFreeDelivery: UILabel!
    @IBOutlet var imageViewIsVerified: UIImageView!
    @IBOutlet var btnWhatsapp: UIButton!
    @IBOutlet var btnViewProfile: UIButtonX!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblCategoryType: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        self.btnWhatsapp.layer.cornerRadius = self.btnWhatsapp.frame.size.height/2
    }
    
    //MARK:- IBActions
    @IBAction func btnWhatsappAction(_ sender: UIButton) {
        if ((self.btnWhatsappClick) != nil)
        {
            self.btnWhatsappClick!(self)
        }
    }
    
    @IBAction func btnViewProfileAction(_ sender: UIButtonX) {
        
    }
    
}
