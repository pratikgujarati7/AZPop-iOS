//
//  MyStoreTableViewCell.swift
//  AgendaZap
//
//  Created by Dipen on 02/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
var MyStoreTableViewCellHeight: CGFloat = 100

class MyStoreTableViewCell: UITableViewCell
{
    var mainContainer: UIView = UIView()
    var innerContainer: UIView = UIView()
    var lblName: UILabel = UILabel()
    var lblTag: UILabel = UILabel()
    var btnEdit: UIButton = UIButton()
    var btnPromotion: UIButton = UIButton()

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
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: StoreTableViewCellHeight))
        mainContainer.backgroundColor = UIColor.clear
        
        //======= ADD INNER CONTAINER VIEW =======//
        innerContainer = UIView(frame: CGRect(x: 10, y: 25, width: mainContainer.frame.size.width - 20, height: mainContainer.frame.size.height - 10 - 20))
        innerContainer.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        innerContainer.layer.borderWidth = 2
        innerContainer.layer.borderColor = MySingleton.sharedManager().themeGlobalOrangeColor?.cgColor
            
        //======= ADD IMAGE VIEW PROMOTION INTO INNER CONTAINER VIEW =======//
        btnPromotion = UIButton(frame: CGRect(x: innerContainer.frame.size.width - 50, y: 5, width: 40, height: 40))
        btnPromotion.setBackgroundImage(UIImage(named: "promotion_edit.png"), for: .normal)
        btnPromotion.clipsToBounds = true
        innerContainer.addSubview(btnPromotion)
            
        //======= ADD IMAGE VIEW EDIT INTO INNER CONTAINER VIEW =======//
        btnEdit = UIButton(frame: CGRect(x: innerContainer.frame.size.width - 90, y: 5, width: 40, height: 40))
        btnEdit.setBackgroundImage(UIImage(named: "ic_edit.png"), for: .normal)
        btnEdit.clipsToBounds = true
        innerContainer.addSubview(btnEdit)
            
        //======= ADD LABEL NAME INTO INNER CONTAINER VIEW =======//
        lblName = UILabel(frame: CGRect(x: 10, y: 10, width: (innerContainer.frame.size.width - 120.0), height: 20))
        lblName.font = MySingleton.sharedManager().themeFontSixteenSizeRegular
        lblName.textColor = MySingleton.sharedManager().themeGlobalLightBlueColor
        lblName.textAlignment = .left
        lblName.numberOfLines = 0
        lblName.layer.masksToBounds = true
        innerContainer.addSubview(lblName)
            
        //======= ADD LABLE TAG INTO INNER CONTAINER VIEW =======//
        lblTag = UILabel(frame: CGRect(x: 10, y: 40, width: (innerContainer.frame.size.width - 120.0), height: 20))
        lblTag.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblTag.textColor = MySingleton.sharedManager().themeGlobalOrangeColor
        lblTag.textAlignment = .left
        lblTag.numberOfLines = 2
        lblTag.layer.masksToBounds = true
        innerContainer.addSubview(lblTag)
            
        mainContainer.addSubview(innerContainer)
        self.addSubview(mainContainer)
    }
            
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
