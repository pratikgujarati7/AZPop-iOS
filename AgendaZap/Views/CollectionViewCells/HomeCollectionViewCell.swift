//
//  HomeCollectionViewCell.swift
//  AgendaZap
//
//  Created by Dipen on 11/12/19.
//  Copyright © 2019 AgendaZap. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell
{
    var mainContainer: UIView = UIView()
    var imageViewOption: UIImageView = UIImageView()
    var lblOptionName: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        let cellWidth:CGFloat = frame.width
        let cellHeight:CGFloat = frame.height
        
        //======= ADD MAIN CONTAINER VIEW =======//
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: cellWidth, height: cellHeight))
        mainContainer.backgroundColor = .clear
        
        //======= ADD DEVICE IMAGE VIEW MAIN INTO MAIN CONTAINER VIEW =======//
        imageViewOption = UIImageView(frame: CGRect(x: 5, y: 5, width: mainContainer.frame.size.width - 10, height: mainContainer.frame.size.height - 35))
        imageViewOption.contentMode = .scaleAspectFit
        imageViewOption.clipsToBounds = true
        mainContainer.addSubview(imageViewOption)
        
        //======= ADD LBL OPTION NAME MAIN INTO MAIN CONTAINER VIEW =======//
        lblOptionName = UILabel(frame: CGRect(x: 5, y: mainContainer.frame.size.height - 25, width: mainContainer.frame.size.width - 10, height: 20))
        lblOptionName.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblOptionName.textColor =  MySingleton.sharedManager().themeGlobalBlackColor
        lblOptionName.textAlignment = .center
        lblOptionName.numberOfLines = 0
        lblOptionName.adjustsFontSizeToFitWidth = true
        mainContainer.addSubview(lblOptionName)
        self.contentView.addSubview(mainContainer)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
