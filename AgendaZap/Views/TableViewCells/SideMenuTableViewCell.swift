//
//  SideMenuTableViewCell.swift
//  AgendaZap
//
//  Created by Dipen on 11/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
var SideMenuTableViewCellHeight: CGFloat = 50

class SideMenuTableViewCell: UITableViewCell
{
    var mainContainer: UIView = UIView()
    var imageViewItem: UIImageView = UIImageView()
    var lblItemName: UILabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = bgColorView
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //======= ADD MAIN CONTAINER VIEW =======//
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: SideMenuTableViewCellHeight))
        mainContainer.backgroundColor = UIColor.clear
        
        //======= ADD LABEL TITLE INTO MAIN CONTAINER VIEW =======//
        imageViewItem = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))
        imageViewItem.contentMode = .scaleAspectFit
        imageViewItem.clipsToBounds = true
        mainContainer.addSubview(imageViewItem)
        
        //======= ADD LABEL TITLE INTO MAIN CONTAINER VIEW =======//
        lblItemName = UILabel(frame: CGRect(x: 60, y: 10, width: (mainContainer.frame.size.width - 70), height: 30))
        lblItemName.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblItemName.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblItemName.textAlignment = .left
        lblItemName.numberOfLines = 1
        lblItemName.layer.masksToBounds = true
        mainContainer.addSubview(lblItemName)
        
        self.addSubview(mainContainer)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
