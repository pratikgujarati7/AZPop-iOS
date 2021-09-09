//
//  VerifyStoreVC.swift
//  AgendaZap
//
//  Created by Dipen Lad on 15/02/21.
//  Copyright © 2021 AgendaZap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import NYAlertViewController
import Photos
import TLPhotoPicker

class VerifyStoreVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, TLPhotosPickerViewControllerDelegate {
    
    //MARK:- Outlets
    @IBOutlet var viewNavigation: UIView!
    @IBOutlet var lblNavigationTitle: UILabel!
    
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var txtLsncNumber: UITextField!
    
    @IBOutlet var imageViewLsnc: UIImageView!
    
    @IBOutlet var btnAddImageContainerView: UIView!
    @IBOutlet var lblAddImage: UILabel!
    @IBOutlet var btnAddImage: UIButton!
    @IBOutlet var btnSave: UIButton!
    
    // MARK: - Other Variables
    
    var appDelegate: AppDelegate?
    var boolIsSetupNotificationEventCalledOnce: Bool = false
    
    var objSelectedStore: MyStore!
    var selectedImage: UIImage?
    
    // MARK: - UIViewController Delegate Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.setupInitialView()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        if self.checkValidation()
        {
            self.btnSave.backgroundColor = MySingleton.sharedManager().themeGlobalGreenColor
        }
        else
        {
            self.btnSave.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNotificationEvent()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
        
        self.removeNotificationEventObserver()
    }
    
    //MARK:- Setup Notification Methods
    func setupNotificationEvent()
    {
        if(boolIsSetupNotificationEventCalledOnce == false)
        {
            boolIsSetupNotificationEventCalledOnce = true
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.user_VerifyStoreEventEvent),
                name: Notification.Name("user_VerifyStoreEventEvent"),
                object: nil)
        }
    }
    
    func removeNotificationEventObserver()
    {
        boolIsSetupNotificationEventCalledOnce = false
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func user_VerifyStoreEventEvent()
    {
        DispatchQueue.main.async(execute: {
                        
            AppDelegate.showToast(message : dataManager.strVerifyMessage, font:MySingleton.sharedManager().themeFontFourteenSizeBold!, view: self.view)
            
            self.navigationController?.popViewController(animated: false)
            
        })
    }
    
    //MARK:- IBActions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddImageClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        let viewController = TLPhotosPickerViewController(withPHAssets: {(assets) in // PHAssets
            
            let imageManager = PHImageManager.init()
            let options = PHImageRequestOptions.init()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            options.isSynchronous = true
            options.isNetworkAccessAllowed = true
                                
            for asset: PHAsset in assets
            {
                let identifier = asset.value(forKey: "uniformTypeIdentifier") as! String
                print("identifier: \(identifier)")
                
                print("image width before resizing: \(asset.pixelWidth)")
                print("image height before resizing: \(asset.pixelHeight)")
                
                var targetWidth: CGFloat = 0
                var targetHeight: CGFloat = 0
                
                if(asset.pixelWidth > asset.pixelHeight)
                {
                    targetWidth = 1000
                    targetHeight = self.getProportionalHeightAccordingToWidth(widthToBeResizedIn: targetWidth, oldWidth: CGFloat(asset.pixelWidth), oldHeight: CGFloat(asset.pixelHeight))
                }
                else
                {
                    targetHeight = 1000
                    targetWidth = self.getProportionalWidthAccordingToHeight(heightToBeResizedIn: targetHeight, oldWidth: CGFloat(asset.pixelWidth), oldHeight: CGFloat(asset.pixelHeight))
                }
                
                let targetSize = CGSize(width: targetWidth, height: targetHeight)
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    
//                            print("image width after resizing: \(image!.size.width)")
//                            print("image height after resizing: \(image!.size.height)")
                    
                    self.imageViewLsnc.image = image
                    self.selectedImage = image
                    
                    if self.checkValidation()
                    {
                        self.btnSave.backgroundColor = MySingleton.sharedManager().themeGlobalGreenColor
                    }
                    else
                    {
                        self.btnSave.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
                    }
                })
            }
            
        }, didCancel: nil)
        viewController.didExceedMaximumNumberOfSelection = {(picker) in
            //exceed max selection
        }
        viewController.handleNoAlbumPermissions = {(picker) in
            // handle denied albums permissions case
            
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    let alertController = UIAlertController(title: "Allow photo album access?", message: "Need your permission to access photo albums", preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    alertController.addAction(dismissAction)
                    alertController.addAction(settingsAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                })
            }
        }
        viewController.handleNoCameraPermissions = {(picker) in
            // handle denied camera permissions case
            
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    let alertController = UIAlertController(title: "Allow camera album access?", message: "Need your permission to take a photo", preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }
                    alertController.addAction(dismissAction)
                    alertController.addAction(settingsAction)

                    // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
                    picker.present(alertController, animated: true, completion: nil)
                })
            }
        }

        
//                viewController.selectedAssets = self.selectedAssets
        viewController.delegate = self
//                viewController.logDelegate = self
        
        var configure = TLPhotosPickerConfigure()
        configure.mediaType = .image
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 1
        configure.selectedColor = MySingleton.sharedManager().themeGlobalGreenColor!
        viewController.configure = configure
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if self.checkValidation()
        {
            
            let strSelectedStoreID: String = "\(UserDefaults.standard.value(forKey: "selected_store_id") ?? "")"
            //API CALL
            dataManager.user_VerifyStore(strStoreID: strSelectedStoreID, strLsncNumber: (txtLsncNumber.text)!, imageData: (selectedImage?.pngData())!)
        }
    }
    
    //MARK:- NavigationBar Methods
    func setUpNavigationBar()
    {
        viewNavigation?.backgroundColor = MySingleton.sharedManager().navigationBarBackgroundColor
        
        //navigationTitle?.font = MySingleton.sharedManager().navigationBarTitleFont
        //navigationTitle?.textColor = MySingleton.sharedManager().navigationBarTitleColor
        //navigationTitle?.text = ""
        
    }
    
    //MARK: - Setting Initial Views Methods
    func setupInitialView() {
        
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        txtLsncNumber.delegate = self
        txtLsncNumber.keyboardType = .numberPad
        
        btnAddImageContainerView.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnAddImageContainerView.clipsToBounds = true
        btnAddImageContainerView.layer.cornerRadius = 5
        
        lblAddImage.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        lblAddImage.textColor = MySingleton.sharedManager().themeGlobalBlackColor
        
        btnSave.titleLabel?.font = MySingleton.sharedManager().themeFontSixteenSizeBold
        btnSave.backgroundColor = MySingleton.sharedManager().themeGlobalLightGreenColor
        btnSave.setTitleColor( MySingleton.sharedManager().themeGlobalBlackColor, for: .normal)
        btnSave.clipsToBounds = true
        btnSave.layer.cornerRadius = 5
        
    }
    
    func checkValidation() -> Bool!
    {
        if (txtLsncNumber.text?.isEmpty == true)
        {
            return false
        }
        else if (txtLsncNumber.text?.isValidCPF == false && txtLsncNumber.text?.isValidCNPJ == false)
        {
            return false
        }
        else if (selectedImage == nil)
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if self.checkValidation()
        {
            self.btnSave.backgroundColor = MySingleton.sharedManager().themeGlobalGreenColor
        }
        else
        {
            self.btnSave.backgroundColor = MySingleton.sharedManager().themeGlobalRedColor
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Other Methods
    
    func getProportionalHeightAccordingToWidth(widthToBeResizedIn: CGFloat, oldWidth: CGFloat, oldHeight: CGFloat) -> CGFloat!
    {
        let scaleFactor:CGFloat = widthToBeResizedIn/oldWidth
        
        let newHeight:CGFloat = oldHeight * scaleFactor
        let newWidth:CGFloat = oldWidth * scaleFactor
        
        return newHeight
    }
    
    func getProportionalWidthAccordingToHeight(heightToBeResizedIn: CGFloat, oldWidth: CGFloat, oldHeight: CGFloat) -> CGFloat!
    {
        let scaleFactor:CGFloat = heightToBeResizedIn/oldHeight
        
        let newWidth:CGFloat = oldWidth * scaleFactor
        let newHeight:CGFloat = oldHeight * scaleFactor
        
        return newWidth
    }
    
    func resizeImageWithWidth(sourceImage: UIImage, widthToBeResizedIn: CGFloat) -> UIImage!
    {
        let oldWidth:CGFloat = sourceImage.size.width
        let scaleFactor:CGFloat = widthToBeResizedIn/oldWidth
        
        let newHeight:CGFloat = sourceImage.size.height * scaleFactor
        let newWidth:CGFloat = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeImageWithHeight(sourceImage: UIImage, heightToBeResizedIn: CGFloat) -> UIImage!
    {
        let oldHeight:CGFloat = sourceImage.size.height
        let scaleFactor:CGFloat = heightToBeResizedIn/oldHeight
        
        let newWidth:CGFloat = sourceImage.size.width * scaleFactor
        let newHeight:CGFloat = oldHeight * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize.init(width: newWidth, height: newHeight))
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

// MARK: - CPF VALIDATION

extension Collection where Element == Int {
    var digitoCPF: Int {
        var number = count + 2
        let digit = 11 - reduce(into: 0) {
            number -= 1
            $0 += $1 * number
        } % 11
        return digit > 9 ? 0 : digit
    }
    
    var digitoCNPJ: Int {
        var number = 1
        let digit = 11 - reversed().reduce(into: 0) {
            number += 1
            $0 += $1 * number
            if number == 9 { number = 1 }
        } % 11
        return digit > 9 ? 0 : digit
    }
}

extension StringProtocol {
    var isValidCPF: Bool {
        let numbers = compactMap(\.wholeNumberValue)
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        return numbers.prefix(9).digitoCPF == numbers[9] &&
               numbers.prefix(10).digitoCPF == numbers[10]
    }
    
    var isValidCNPJ: Bool {
        let numbers = compactMap(\.wholeNumberValue)
        guard numbers.count == 14 && Set(numbers).count != 1 else { return false }
        return numbers.prefix(12).digitoCNPJ == numbers[12] &&
               numbers.prefix(13).digitoCNPJ == numbers[13]
    }
}
