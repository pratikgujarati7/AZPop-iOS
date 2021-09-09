//
//  StoreTableViewCell.swift
//  AgendaZap
//
//  Created by Dipen on 12/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
var StoreTableViewCellHeight: CGFloat = 100

class StoreTableViewCell: UITableViewCell
{
    var mainContainer: UIView = UIView()
    var lblFavourite: UILabel = UILabel()
    var innerContainer: UIView = UIView()
    var lblName: UILabel = UILabel()
    var lblTag: UILabel = UILabel()
    var lblDistance: UILabel = UILabel()
    var btnSend: UIButton = UIButton()

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
        
        //======= ADD LABLE FAVOURITE INTO MAIN CONTAINER VIEW =======//
        lblFavourite = UILabel(frame: CGRect(x: 10, y: 5, width: (mainContainer.frame.size.width - 20), height: 20))
        lblFavourite.font = MySingleton.sharedManager().themeFontSixteenSizeRegular
        lblFavourite.textColor = MySingleton.sharedManager().themeGlobalWhiteColor
        lblFavourite.backgroundColor = MySingleton.sharedManager().themeGlobalOrangeColor
        lblFavourite.textAlignment = .center
        lblFavourite.numberOfLines = 1
        lblFavourite.layer.masksToBounds = true
        lblFavourite.text = NSLocalizedString("tem_promo", value: "Tem Promoção", comment: "").uppercased()
        mainContainer.addSubview(lblFavourite)
        
        //======= ADD INNER CONTAINER VIEW =======//
        innerContainer = UIView(frame: CGRect(x: 10, y: 25, width: mainContainer.frame.size.width - 20, height: mainContainer.frame.size.height - 10 - 20))
        innerContainer.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        innerContainer.layer.borderWidth = 2
        innerContainer.layer.borderColor = MySingleton.sharedManager().themeGlobalOrangeColor?.cgColor
            
        //======= ADD IMAGE VIEW SEND INTO INNER CONTAINER VIEW =======//
        btnSend = UIButton(frame: CGRect(x: innerContainer.frame.size.width - 50, y: 5, width: 40, height: 40))
        btnSend.backgroundColor = MySingleton.sharedManager().themeGlobalWhatsappColor
        btnSend.setBackgroundImage(UIImage(named: "ic_paper_plane_2.png"), for: .normal)
        btnSend.clipsToBounds = true
        btnSend.layer.cornerRadius = btnSend.frame.size.height / 2
        innerContainer.addSubview(btnSend)
            
        //======= ADD LABLE DISTANCE INTO INNER CONTAINER VIEW =======//
        lblDistance = UILabel(frame: CGRect(x: innerContainer.frame.size.width - 140.0, y: 20, width: 80, height: 20))
        lblDistance.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblDistance.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblDistance.textAlignment = .center
        lblDistance.numberOfLines = 1
        lblDistance.layer.masksToBounds = true
        innerContainer.addSubview(lblDistance)
            
        //======= ADD LABEL NAME INTO INNER CONTAINER VIEW =======//
        lblName = UILabel(frame: CGRect(x: 10, y: 10, width: (innerContainer.frame.size.width - 170.0), height: 20))
        lblName.font = MySingleton.sharedManager().themeFontSixteenSizeRegular
        lblName.textColor = MySingleton.sharedManager().themeGlobalLightBlueColor
        lblName.textAlignment = .left
        lblName.numberOfLines = 0
        lblName.layer.masksToBounds = true
        innerContainer.addSubview(lblName)
            
        //======= ADD LABLE TAG INTO INNER CONTAINER VIEW =======//
        lblTag = UILabel(frame: CGRect(x: 10, y: 40, width: (innerContainer.frame.size.width - 170.0), height: 20))
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
