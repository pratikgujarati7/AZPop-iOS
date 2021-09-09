//
//  MyStoreTableViewCellNew.swift
//  AgendaZap
//
//  Created by Dipen on 02/01/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
var MyStoreTableViewCellNewHeight: CGFloat = 135

class MyStoreTableViewCellNew: UITableViewCell
{
    var mainContainer: UIView = UIView()
    var innerContainer: UIView = UIView()
    var lblName: UILabel = UILabel()
    var lblPremium: UILabel = UILabel()
    var lblTag: UILabel = UILabel()
    var btnEdit: UIButton = UIButton()
    var btnPromotion: UIButton = UIButton()
    var btnReports: UIButton = UIButton()
    var btnWebsite: UIButton = UIButton()

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
        
        self.contentView.isUserInteractionEnabled = true
        
        //======= ADD MAIN CONTAINER VIEW =======//
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: StoreTableViewCellHeight))
        mainContainer.backgroundColor = UIColor.clear
        
        //======= ADD INNER CONTAINER VIEW =======//
        innerContainer = UIView(frame: CGRect(x: 10, y: 25, width: mainContainer.frame.size.width - 20, height: mainContainer.frame.size.height - 10 - 20))
        innerContainer.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        innerContainer.layer.borderWidth = 2
        innerContainer.layer.borderColor = MySingleton.sharedManager().themeGlobalOrangeColor?.cgColor
        
        //======= ADD LABEL NAME INTO INNER CONTAINER VIEW =======//
        lblName = UILabel(frame: CGRect(x: 10, y: 10, width: (innerContainer.frame.size.width - 120.0), height: 20))
//        lblName.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        lblName.font = MySingleton.sharedManager().themeFontSixteenSizeRegular
        lblName.textColor = MySingleton.sharedManager().themeGlobalLightBlueColor
        lblName.textAlignment = .left
        lblName.numberOfLines = 0
        lblName.layer.masksToBounds = true
        innerContainer.addSubview(lblName)
        
        //======= ADD LABEL PREMIUM INTO INNER CONTAINER VIEW =======//
        lblPremium = UILabel(frame: CGRect(x: (lblName.frame.origin.x + lblName.frame.size.width + 10), y: 10, width: 90, height: 20))
//        lblPremium.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        lblPremium.font = MySingleton.sharedManager().themeFontSixteenSizeRegular
        lblPremium.textColor = MySingleton.sharedManager().themeGlobalGreenTextColor //themeGlobalGreenColor
        lblPremium.text = "(Premium)"
        lblPremium.textAlignment = .left
        lblPremium.numberOfLines = 0
        lblPremium.layer.masksToBounds = true
        innerContainer.addSubview(lblPremium)
            
        //======= ADD LABLE TAG INTO INNER CONTAINER VIEW =======//
        lblTag = UILabel(frame: CGRect(x: 10, y: 40, width: (innerContainer.frame.size.width - 20.0), height: 20))
        lblTag.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblTag.textColor = MySingleton.sharedManager().themeGlobalOrangeColor
        lblTag.textAlignment = .left
        lblTag.numberOfLines = 2
        lblTag.layer.masksToBounds = true
        innerContainer.addSubview(lblTag)
            
        //======= ADD BUTTON EDIT INTO INNER CONTAINER VIEW =======//
        btnEdit = UIButton(frame: CGRect(x: 10, y: (lblTag.frame.origin.y + lblTag.frame.size.height + 5), width: (innerContainer.frame.size.width-26)/4, height: 30))
        btnEdit.backgroundColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        btnEdit.titleLabel?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        btnEdit.setTitle(NSLocalizedString("btn_edit_store", value:"Editar", comment: ""), for: UIControl.State.normal)
        btnEdit.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: UIControl.State.normal)
        btnEdit.clipsToBounds = true
        innerContainer.addSubview(btnEdit)
        
        //======= ADD BUTTON PROMOTION INTO INNER CONTAINER VIEW =======//
        btnPromotion = UIButton(frame: CGRect(x: (btnEdit.frame.origin.x + btnEdit.frame.size.width + 2), y: btnEdit.frame.origin.y, width: (innerContainer.frame.size.width-26)/4, height: 30))
        btnPromotion.backgroundColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        btnPromotion.titleLabel?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        btnPromotion.setTitle(NSLocalizedString("btn_promotion", value:"Promoção", comment: ""), for: UIControl.State.normal)
        btnPromotion.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: UIControl.State.normal)
        btnPromotion.clipsToBounds = true
        innerContainer.addSubview(btnPromotion)
        
        //======= ADD BUTTON REPORTS INTO INNER CONTAINER VIEW =======//
        btnReports = UIButton(frame: CGRect(x: (btnPromotion.frame.origin.x + btnPromotion.frame.size.width + 2), y: btnEdit.frame.origin.y, width: (innerContainer.frame.size.width-26)/4, height: 30))
        btnReports.backgroundColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        btnReports.titleLabel?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        btnReports.setTitle(NSLocalizedString("btn_reports", value:"Relatório", comment: ""), for: UIControl.State.normal)
        btnReports.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: UIControl.State.normal)
        btnReports.clipsToBounds = true
        innerContainer.addSubview(btnReports)
        
        //======= ADD BUTTON WEBSITE INTO INNER CONTAINER VIEW =======//
        btnWebsite = UIButton(frame: CGRect(x: (btnReports.frame.origin.x + btnReports.frame.size.width + 2), y: btnEdit.frame.origin.y, width: (innerContainer.frame.size.width-26)/4, height: 30))
        btnWebsite.backgroundColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        btnWebsite.titleLabel?.font = MySingleton.sharedManager().themeFontFourteenSizeBold
        btnWebsite.setTitle(NSLocalizedString("btn_website", value:"Website", comment: ""), for: UIControl.State.normal)
        btnWebsite.setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: UIControl.State.normal)
        btnWebsite.clipsToBounds = true
        innerContainer.addSubview(btnWebsite)
            
        mainContainer.addSubview(innerContainer)
        self.addSubview(mainContainer)
    }
            
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
