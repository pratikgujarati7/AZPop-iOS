//
//  CategoryTableViewCell.swift
//  AgendaZap
//
//  Created by Dipen on 11/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
var CategoryTableViewCellHeight: CGFloat = 47

class CategoryTableViewCell: UITableViewCell
{
    var mainContainer: UIView = UIView()
    var innerContainer: UIView = UIView()
    var lblCategoryName: UILabel = UILabel()
    var imgRightArrow = UIImageView()

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
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: CategoryTableViewCellHeight))
        mainContainer.backgroundColor = UIColor.clear
        
        //======= ADD INNER CONTAINER VIEW =======//
        innerContainer = UIView(frame: CGRect(x: 10, y: 5, width: mainContainer.frame.size.width - 20, height: mainContainer.frame.size.height - 7))
        innerContainer.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        innerContainer.clipsToBounds = true
        innerContainer.layer.cornerRadius = 5
            
        //======= ADD LABEL CATEGORy INTO INNER CONTAINER VIEW =======//
        lblCategoryName = UILabel(frame: CGRect(x: 10, y: 5, width: (innerContainer.frame.size.width - 50), height: (innerContainer.frame.size.height - 10)))
        lblCategoryName.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblCategoryName.textColor = UIColor.gray //MySingleton.sharedManager().themeGlobalBlackColor
        lblCategoryName.textAlignment = .left
        lblCategoryName.numberOfLines = 1
        lblCategoryName.layer.masksToBounds = true
        innerContainer.addSubview(lblCategoryName)
        
        //======= ADD RIGHT ARROW INTO INNER CONTAINER VIEW =======//
        imgRightArrow = UIImageView(frame: CGRect(x: self.lblCategoryName.frame.maxX + 10, y: 12.5, width: 15, height: 15))
        imgRightArrow.image = UIImage(named: "rigth_arrow_black")
        innerContainer.addSubview(imgRightArrow)
        
        mainContainer.addSubview(innerContainer)
        self.addSubview(mainContainer)
    }
        
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
}
