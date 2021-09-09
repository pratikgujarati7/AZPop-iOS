//
//  MyStoreClickReportsTableViewCell.swift
//  AgendaZap
//
//  Created by Innovative Iteration on 17/04/20.
//  Copyright © 2020 AgendaZap. All rights reserved.
//

import UIKit
var MyStoreClickReportsTableViewCellHeight: CGFloat = 40

class MyStoreClickReportsTableViewCell: UITableViewCell
{
    var mainContainer: UIView = UIView()
    var lblDate: UILabel = UILabel()
    var lblTime: UILabel = UILabel()
    var lblPhoneNumber: UILabel = UILabel()
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //======= ADD MAIN CONTAINER VIEW =======//
        mainContainer = UIView(frame: CGRect(x: 0, y: 0, width: MySingleton.sharedManager().screenWidth, height: CheckboxTableViewCellHeight))
        mainContainer.backgroundColor = UIColor.clear
        
        //======= ADD DATE LABEL INTO MAIN CONTAINER VIEW =======//
        lblDate = UILabel(frame: CGRect(x: 5, y: 0, width: (mainContainer.frame.size.width - 20)/3, height: 40))
        lblDate.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblDate.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblDate.textAlignment = NSTextAlignment.left
        lblDate.numberOfLines = 0
        mainContainer.addSubview(lblDate)
        
        //======= ADD TIME LABEL INTO MAIN CONTAINER VIEW =======//
        lblTime = UILabel(frame: CGRect(x: (lblDate.frame.origin.x + lblDate.frame.size.width + 5), y: 0, width: (mainContainer.frame.size.width - 20)/3, height: 40))
        lblTime.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblTime.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblTime.textAlignment = NSTextAlignment.center
        lblTime.numberOfLines = 0
        mainContainer.addSubview(lblTime)
        
        //======= ADD PHONE NUMBER LABEL INTO MAIN CONTAINER VIEW =======//
        lblPhoneNumber = UILabel(frame: CGRect(x: (lblTime.frame.origin.x + lblTime.frame.size.width + 5), y: 0, width: (mainContainer.frame.size.width - 20)/3, height: 40))
        lblPhoneNumber.font = MySingleton.sharedManager().themeFontTwelveSizeRegular
        lblPhoneNumber.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        lblPhoneNumber.textAlignment = NSTextAlignment.right
        lblPhoneNumber.numberOfLines = 0
        mainContainer.addSubview(lblPhoneNumber)
        
        self.addSubview(mainContainer)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
}
