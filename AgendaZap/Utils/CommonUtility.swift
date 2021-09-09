//
//  CommonUtility.swift
//  Swift Demo
//
//  Created by Pratik Gujarati on 09/08/18.
//  Copyright © 2018 Innovative Iteration. All rights reserved.
//

import UIKit
import CoreLocation

class CommonUtility: NSObject {
    
    let arrayWeakDays = ["Seg", "Ter", "Qua", "Qui", "Sex", "Sab", "Dom"]

    override init()
    {
        super.init()
    }
    
    func isValidEmailAddress(strEmailString: String)-> Bool
    {
//        let emailRegEx = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: strEmailString)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        //UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 5.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func pushViewController(viewController: UIViewController)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn//push
        transition.subtype = CATransitionSubtype.fromTop
        AppDelegate.sharedInstance().navigationController?.view.layer.add(transition, forKey: kCATransition)
        AppDelegate.sharedInstance().navigationController?.pushViewController(viewController, animated: false)
    }
    
    func pushViewControllerTopToBottom(viewController: UIViewController)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn//push
        transition.subtype = CATransitionSubtype.fromBottom
        AppDelegate.sharedInstance().navigationController?.view.layer.add(transition, forKey: kCATransition)
        AppDelegate.sharedInstance().navigationController?.pushViewController(viewController, animated: false)
    }
    
    func popViewController() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal//fade
        transition.subtype = CATransitionSubtype.fromBottom
        
    AppDelegate.sharedInstance().navigationController?.view.layer.add(transition, forKey:kCATransition)
        let _ = AppDelegate.sharedInstance().navigationController?.popViewController(animated: false)
    }
    
    func calculateDistanceInKiloMeters(coordinateOne: CLLocation, coordinateTwo: CLLocation) -> String
    {
        let distanceInMeters = coordinateOne.distance(from: coordinateTwo)
        
        let km =   String(format: "%.2f", (distanceInMeters / 1000))
        return km
    }
    
    var fourDigitNumber: String {
     var result = ""
     repeat {
         // Create a string with a random number 0...9999
         result = String(format:"%04d", arc4random_uniform(10000) )
     } while result.count < 4
     return result
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
        //let test1 = getQueryStringParameter(url, param: "test1") example
    }

    
}

extension UILabel {

    func addImageWith(name: String, behindText: Bool) {

        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: name)
        let attachmentString = NSAttributedString(attachment: attachment)

        guard let txt = self.text else {
            return
        }

        if behindText {
            let strLabelText = NSMutableAttributedString(string: txt)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: txt)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
        }
    }
    
    func addImageWith(image: UIImage, behindText: Bool) {

        let attachment = NSTextAttachment()
        attachment.image = image
        let attachmentString = NSAttributedString(attachment: attachment)

        guard let txt = self.text else {
            return
        }

        if behindText {
            let strLabelText = NSMutableAttributedString(string: txt)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: txt)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
        }
    }

    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
    
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
    
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
    
    //print(yourLabel.maxNumberOfLines)
    //print(yourLabel.numberOfVisibleLines)
}

extension UIView {

    var heightConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }

    var widthConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension UITableView
{
    func scroll(to: scrollsTo, animated: Bool)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    
    enum scrollsTo {
        case top,bottom
    }
    
    func positionedAtBottom() -> Bool
    {
        let height = self.contentSize.height - self.frame.size.height
        
        if self.contentOffset.y < 10 {
            //reach top
            return false
        }
        else if self.contentOffset.y < height/2.0
        {
            //not top and not bottom
            return false
        }
        else
        {
            return true
        }
    }
    
    func showNoDataLabel(_ strAltMsg: String, isScrollable: Bool)
    {
        let noDataView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let msglbl               = UILabel(frame: CGRect(x: 12, y: 25, width: self.bounds.size.width-24, height: self.bounds.size.height-50))
        msglbl.text          = strAltMsg
        msglbl.textAlignment = .center
        msglbl.font          = UIFont(name: "Montserrat-Regular", size: 20.0)
        msglbl.numberOfLines = 0
        msglbl.textColor     = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1) //UIColor(white: 0.9, alpha: 1.0)
        
        msglbl.translatesAutoresizingMaskIntoConstraints = true
        
        noDataView.addSubview(msglbl)
        noDataView.translatesAutoresizingMaskIntoConstraints = true
        
        self.isScrollEnabled = isScrollable
        self.backgroundView  = noDataView
    }
    
    func removeNoDataLabel()
    {
        self.isScrollEnabled = true
        self.backgroundView  = nil
    }
    
}

extension UICollectionView
{
    func showNoDataLabel(_ strAltMsg: String, isScrollable: Bool)
    {
        let noDataView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let msglbl               = UILabel(frame: CGRect(x: 12, y: 25, width: self.bounds.size.width-24, height: self.bounds.size.height-50))
        msglbl.text          = strAltMsg
        msglbl.textAlignment = .center
        msglbl.font          = UIFont(name: "Montserrat-Regular", size: 20.0)
        msglbl.numberOfLines = 0
        msglbl.textColor     = #colorLiteral(red: 0.7882352941, green: 0.7882352941, blue: 0.7882352941, alpha: 1) //UIColor(white: 0.9, alpha: 1.0)
        
        noDataView.addSubview(msglbl)
        
        self.isScrollEnabled = isScrollable
        self.backgroundView  = noDataView
    }
    
    func removeNoDataLabel()
    {
        self.isScrollEnabled = true
        self.backgroundView  = nil
    }
}

extension UINavigationController {

  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
      popToViewController(vc, animated: animated)
    }
  }

  func popViewControllers(viewsToPop: Int, animated: Bool = true) {
    if viewControllers.count > viewsToPop {
      let vc = viewControllers[viewControllers.count - viewsToPop - 1]
      popToViewController(vc, animated: animated)
    }
  }

}

extension UILabel
{
    func addImage(imageName: String)
    {
        let attachment:NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)

        let attachmentString:NSAttributedString = NSAttributedString(attachment: attachment)
        let myString:NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
        myString.append(attachmentString)

        self.attributedText = myString
    }
}

class UnderlinedLabel: UILabel {

override var text: String? {
    didSet {
        guard let text = text else { return }
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        // Add other attributes if needed
        self.attributedText = attributedText
        }
    }
}

extension String {

    // formatting text for currency textField
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal//.currencyAccounting
        //formatter.currencySymbol = ""
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
