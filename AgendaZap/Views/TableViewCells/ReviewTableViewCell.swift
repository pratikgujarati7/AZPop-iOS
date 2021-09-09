//
//  ReviewTableViewCell.swift
//  AgendaZap
//
//  Created by Dipen on 22/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit
var ReviewTableViewCellHeight: CGFloat = 80

class ReviewTableViewCell: UITableViewCell
{
    var mainContainer: UIView = UIView()
    var innerContainer: UIView = UIView()
    var ratingViewUserRating: CosmosView = CosmosView()
    var lblDate: UILabel = UILabel()
    var lblReviewText: UILabel = UILabel()

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
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: ReviewTableViewCellHeight))
        mainContainer.backgroundColor = UIColor.clear
        
        //======= ADD INNER CONTAINER VIEW =======//
        innerContainer = UIView(frame: CGRect(x: 10, y: 5, width: mainContainer.frame.size.width - 20, height: mainContainer.frame.size.height - 10))
        innerContainer.backgroundColor = MySingleton.sharedManager().themeGlobalWhiteColor
        
        //======= ADD USER RATINg CONTAINER VIEW =======//
        ratingViewUserRating = CosmosView(frame: CGRect(x: 10, y: 10, width: 120, height: 20))
        ratingViewUserRating.backgroundColor = .clear
        ratingViewUserRating.settings.fillMode = .full
        ratingViewUserRating.settings.starSize = 20
        ratingViewUserRating.settings.starMargin = 5
        ratingViewUserRating.settings.filledColor = MySingleton.sharedManager().themeGlobalLightGreenColor!
        ratingViewUserRating.settings.emptyBorderColor = MySingleton.sharedManager().themeGlobalDarkGreyColor!
        ratingViewUserRating.isUserInteractionEnabled = false
        innerContainer.addSubview(ratingViewUserRating)
        
        //======= ADD LBL DATE CONTAINER VIEW =======//
        lblDate = UILabel(frame: CGRect(x: 140, y: 10, width: innerContainer.frame.size.width - 150, height: 20))
        lblDate.font = MySingleton.sharedManager().themeFontSixteenSizeRegular
        lblDate.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblDate.textAlignment = .left
        lblDate.numberOfLines = 1
        innerContainer.addSubview(lblDate)
        
        //======= ADD LBL REVIEW TEXT CONTAINER VIEW =======//
        lblReviewText = UILabel(frame: CGRect(x: 10, y: 40, width: innerContainer.frame.size.width - 20, height: 20))
        lblReviewText.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        lblReviewText.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblReviewText.textAlignment = .left
        lblReviewText.numberOfLines = 0
        innerContainer.addSubview(lblReviewText)
            
        mainContainer.addSubview(innerContainer)
        self.addSubview(mainContainer)
    }
            
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
        

}
