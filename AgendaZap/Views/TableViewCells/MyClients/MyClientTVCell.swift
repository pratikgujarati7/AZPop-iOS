//
//  MyClientTVCell.swift
//  AgendaZap
//
//  Created by Dipen on 06/01/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import iOSDropDown

class MyClientTVCell: UITableViewCell {
    
    var btnToggleClick: ((_ aCell: MyClientTVCell) -> Void)?
    
    var btnDetailsClick: ((_ aCell: MyClientTVCell) -> Void)?
    var btnEditClick: ((_ aCell: MyClientTVCell) -> Void)?
    var btnWhatsappClick: ((_ aCell: MyClientTVCell) -> Void)?
    
    @IBOutlet var nslcInnerContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet var viewClientStatus: UIViewX!
    @IBOutlet var lblClientName: UILabel!
    @IBOutlet var dropdownStatus: DropDown!
    @IBOutlet var viewClientStatusOnDropDown: UIViewX!
    @IBOutlet var lblObservationsValue: UILabel!

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
    
    
    @IBAction func btnDetailsAction(_ sender: UIButton) {
        if ((self.btnDetailsClick) != nil)
        {
            self.btnDetailsClick!(self)
        }
    }
    
    @IBAction func btnEditAction(_ sender: UIButton) {
        if ((self.btnEditClick) != nil)
        {
            self.btnEditClick!(self)
        }
    }
    
    @IBAction func btnWhatsappAction(_ sender: UIButton) {
        if ((self.btnWhatsappClick) != nil)
        {
            self.btnWhatsappClick!(self)
        }
    }
    
}
