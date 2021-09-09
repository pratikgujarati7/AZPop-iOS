//
//  PromocoesTableViewCell.swift
//  AgendaZap
//
//  Created by Dipen on 11/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
var PromocoesTableViewCellHeight: CGFloat = 80

class PromocoesTableViewCell: UITableViewCell
{
    var mainContainer: UIView = UIView()
    var innerContainer: UIView = UIView()
    var lblName: UILabel = UILabel()
    var btnSend: UIButton = UIButton()
    var lblPromotionText: UILabel = UILabel()

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
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: PromocoesTableViewCellHeight))
        mainContainer.backgroundColor = UIColor.clear
        
        //======= ADD INNER CONTAINER VIEW =======//
        innerContainer = UIView(frame: CGRect(x: 10, y: 5, width: mainContainer.frame.size.width - 20, height: mainContainer.frame.size.height - 10))
        innerContainer.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        innerContainer.clipsToBounds = true
        innerContainer.layer.cornerRadius = 5
            
        //======= ADD IMAGE VIEW SEND INTO INNER CONTAINER VIEW =======//
        btnSend = UIButton(frame: CGRect(x: innerContainer.frame.size.width - 50, y: 5, width: 40, height: 40))
//        btnSend.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSend.backgroundColor = MySingleton.sharedManager().themeGlobalWhatsappColor
        btnSend.setBackgroundImage(UIImage(named: "ic_paper_plane_2.png"), for: .normal)
        btnSend.clipsToBounds = true
        btnSend.layer.cornerRadius = btnSend.frame.size.height / 2
        innerContainer.addSubview(btnSend)
            
        //======= ADD LABEL NAME INTO INNER CONTAINER VIEW =======//
        lblName = UILabel(frame: CGRect(x: 10, y: 10, width: (innerContainer.frame.size.width - 10 - 40 - 20), height: 20))
        lblName.font = MySingleton.sharedManager().themeFontSixteenSizeRegular
        lblName.textColor = MySingleton.sharedManager().themeGlobalLightBlueColor
        lblName.textAlignment = .left
        lblName.numberOfLines = 0
        lblName.layer.masksToBounds = true
        innerContainer.addSubview(lblName)
            
        //======= ADD LABEL PROMOTION INTO INNER CONTAINER VIEW =======//
        lblPromotionText = UILabel(frame: CGRect(x: 10, y: 40, width: (innerContainer.frame.size.width - 10 - 40 - 20), height: 20))
        lblPromotionText.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblPromotionText.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        lblPromotionText.textAlignment = .left
        lblPromotionText.numberOfLines = 0
        lblPromotionText.layer.masksToBounds = true
        innerContainer.addSubview(lblPromotionText)
        
        mainContainer.addSubview(innerContainer)
        self.addSubview(mainContainer)
    }
        
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }

}
