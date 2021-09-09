//
//  GroupTVCell.swift
//  AgendaZap
//
//  Created by Innovative on 05/11/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
import TTTAttributedLabel

protocol GroupTVCellDelegate {
    func labelTapped(index: Int, cell: GroupTVCell)
}

class GroupTVCell: UITableViewCell {

    var btnWhatsappClick: ((_ aCell: GroupTVCell) -> Void)?
    var btnViewMoreClick: ((_ aCell: GroupTVCell) -> Void)?
    
    var delegate: GroupTVCellDelegate?
    
    //MARK:- Outlets
    @IBOutlet var viewCategoryContainer: UIView!
    @IBOutlet var lblCategoryName: UILabel!
    @IBOutlet var lblGroupName: UILabel!
    @IBOutlet var lblGroupDescription: UILabel!
    @IBOutlet var lblGroupCategory: UILabel!
    @IBOutlet var btnViewMore: UIButton!
    @IBOutlet var btnViewMoreHeightConstraint: NSLayoutConstraint! // 15.0
    @IBOutlet var viewEnterGroupContainer: UIViewX!
    @IBOutlet var btnWhatsappLogo: UIButton!
    @IBOutlet var lblEnterGroup: UILabel!
    
    //MARK:- Variables
    
    var intIndex = 0
    
    //MARK:- Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        self.btnWhatsappLogo.layer.cornerRadius = self.btnWhatsappLogo.frame.size.height/2
    }
    
    //MARK:- IBActions
    @IBAction func btnWhatsappAction(_ sender: UIButton) {
        if ((self.btnWhatsappClick) != nil) {
            self.btnWhatsappClick!(self)
        }
    }
    
    @IBAction func btnViewMoreAction(_ sender: UIButton) {
        if ((self.btnViewMoreClick) != nil) {
            self.btnViewMoreClick!(self)
        }
    }
    
}

