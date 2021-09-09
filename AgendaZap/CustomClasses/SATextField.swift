//
//  SATextField.swift
//  Beginner-Constraints
//
//  Created by Sean Allen on 11/29/18.
//  Copyright © 2018 Sean Allen. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SATextField: SkyFloatingLabelTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpField()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setUpField()
    }
    
    
    private func setUpField() {
        
        var txtFont: UIFont?
        
        if MySingleton.sharedManager().screenWidth == 320
        {
            txtFont = MySingleton.sharedManager().themeFontFourteenSizeRegular
        }
        else if MySingleton.sharedManager().screenWidth == 375
        {
            txtFont = MySingleton.sharedManager().themeFontFifteenSizeRegular
        }
        else
        {
            txtFont = MySingleton.sharedManager().themeFontSixteenSizeRegular
        }
        
        tintColor             = MySingleton.sharedManager() .themeGlobalBlackColor
        textColor             = MySingleton.sharedManager().themeGlobalBlackColor
        font                  = txtFont
        backgroundColor       = .clear
        autocorrectionType    = .no
        //layer.cornerRadius    = 25.0
        clipsToBounds         = true
        textAlignment = .left
        
        let placeholder       = self.placeholder != nil ? self.placeholder! : ""
        let placeholderFont   = txtFont
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
             NSAttributedString.Key.font: placeholderFont!])
        
        //let indentView        = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        //leftView              = indentView
        //leftViewMode          = .always
        
        //SYK FLOATING
        placeholderColor = MySingleton.sharedManager() .textfieldPlaceholderColor!
        lineColor = MySingleton.sharedManager() .textfieldBottomSeparatorColor!
        selectedTitleColor = MySingleton.sharedManager() .themeGlobalLightGreenColor!
        selectedLineColor = MySingleton.sharedManager() .themeGlobalLightGreenColor!
        lineHeight = 2.0
        selectedLineHeight = 2.0
        
    }
}
