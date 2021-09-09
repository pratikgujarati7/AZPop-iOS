//
//  Cell.swift
//  Fantsy Golf Bag
//
//  Created by Dipen on 15/11/19.
//  Copyright © 2019 Fantsy Golf Bag. All rights reserved.
//

import UIKit
import ZMJGanttChart

class HeaderCell: ZMJCell {
    let topLine = UIView()
    let label = UILabel()
    let sortArrow = UILabel()
    let bottomLine = UIView()

    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 4, dy: 2)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        topLine.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0.5)
        topLine.autoresizingMask = [.flexibleWidth]
        topLine.backgroundColor = MySingleton.sharedManager().themeGlobalBlackColor
        contentView.addSubview(topLine)
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = MySingleton.sharedManager().themeGlobalDarkGreyColor
        contentView.addSubview(label)

        sortArrow.text = ""
        sortArrow.font = UIFont.boldSystemFont(ofSize: 14)
        sortArrow.textAlignment = .center
        contentView.addSubview(sortArrow)
        
        bottomLine.frame = CGRect(x: 0, y: frame.size.height - 0.5, width: frame.size.width, height: 0.5)
        bottomLine.autoresizingMask = [.flexibleWidth]
        bottomLine.backgroundColor = MySingleton.sharedManager().themeGlobalBlackColor
        contentView.addSubview(bottomLine)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        sortArrow.sizeToFit()
        sortArrow.frame.origin.x = frame.width - sortArrow.frame.width - 8
        sortArrow.frame.origin.y = (frame.height - sortArrow.frame.height) / 2
    }
}

class TextCell: ZMJCell {
    let label = UILabel()

    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 4, dy: 2)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.0)
        selectedBackgroundView = backgroundView

        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = MySingleton.sharedManager().themeFontFourteenSizeRegular
        label.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        label.textAlignment = .center
        label.numberOfLines = 0

        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
