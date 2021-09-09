//
//  CheckboxTableViewCell.swift
//  AgendaZap
//
//  Created by Dipen on 07/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
var CheckboxTableViewCellHeight: CGFloat = 40

class CheckboxTableViewCell: UITableViewCell
{
    var mainContainer: UIView = UIView()
    var imageViewCheckbox: UIImageView = UIImageView()
    var lblText: UILabel = UILabel()

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
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth - 40, height: CheckboxTableViewCellHeight))
        mainContainer.backgroundColor = UIColor.clear
        
        //======= ADD CHECKBOX INTO MAIN CONTAINER VIEW =======//
        imageViewCheckbox = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageViewCheckbox.contentMode = .scaleAspectFit
        mainContainer.addSubview(imageViewCheckbox)
        
        //======= ADD TEXT INTO MAIN CONTAINER VIEW =======//
        lblText = UILabel(frame: CGRect(x: 40, y: 10, width: mainContainer.frame.size.width - 50, height: 20))
        lblText.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblText.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblText.numberOfLines = 0
        mainContainer.addSubview(lblText)
            
        self.addSubview(mainContainer)
    }
            
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
