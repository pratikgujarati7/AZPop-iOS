//
//  SAButton.swift
//  Beginner-Constraints
//
//  Created by Sean Allen on 11/29/18.
//  Copyright © 2018 Sean Allen. All rights reserved.
//

import UIKit

class SAButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    private func setupButton() {
        
        var btnTitleFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            btnTitleFont = MySingleton.sharedManager().themeFontFourteenSizeBold
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            btnTitleFont = MySingleton.sharedManager().themeFontFifteenSizeBold
        }
        else
        {
            btnTitleFont = MySingleton.sharedManager().themeFontSixteenSizeBold
        }
        
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        backgroundColor     = MySingleton.sharedManager().themeGlobalRedColor
        titleLabel?.font    = btnTitleFont
        titleLabel?.adjustsFontSizeToFitWidth = true
        //layer.cornerRadius  = frame.size.height/2
        setTitleColor(MySingleton.sharedManager().themeGlobalWhiteColor, for: .normal)
        clipsToBounds = true
        tintColor = MySingleton.sharedManager().themeGlobalWhiteColor
    }
}
