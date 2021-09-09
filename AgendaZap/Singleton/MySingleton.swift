//
//  MySingleton.swift
//  SwiftDemo
//
//  Created by Infusion on 6/5/15.
//  Copyright (c) 2015 Infusion. All rights reserved.
//

import UIKit
import Foundation

import LGSideMenuController.LGSideMenuController
import LGSideMenuController.UIViewController_LGSideMenuController

class MySingleton: NSObject
{
    var screenRect: CGRect
    var screenWidth: CGFloat
    let screenHeight: CGFloat
    
    //========================= APPLICATION SPECIFIC SETTINGS ================//
    
    //========================= SIDE MENU SETTINGS ================//
    
    var selectedScreenIndex: NSInteger
    
    var floatLeftSideMenuWidth: CGFloat?
    var floatRightSideMenuWidth: CGFloat?
    
    var leftViewPresentationStyle: LGSideMenuPresentationStyle?
    var rightViewPresentationStyle: LGSideMenuPresentationStyle?
    
    //========================= NAVIGATION BAR SETTINGS ================/
    var navigationBarBackgroundColor: UIColor?
    var navigationBarTitleColor: UIColor?
    var navigationBarTitleFont: UIFont?
    var navigationBarTitleSmallFont: UIFont?
    
    //========================= TAB BAR SETTINGS ================//
    var tabBarBackgroundColor: UIColor?
    var tabBarTitleColor: UIColor?
    var tabTitleFont: UIFont?
    
    //========================= THEME GLOBAL COLORS SETTINGS ================//
    var themeGlobalBackgroundGreyColor: UIColor?
    var themeGlobalBackgroundLightGreenColor: UIColor?
    
    var themeGlobalPurpleColor: UIColor?
    var themeGlobalBlueColor: UIColor?
    var themeGlobalLightBlueColor: UIColor?
    var themeGlobalGreenColor: UIColor?
    var themeGlobalGreen2Color: UIColor?
    var themeGlobalGreenTextColor: UIColor?
    var themeGlobalLightGreenColor: UIColor?
    var themeGlobalSplashGreenColor: UIColor?
    var themeGlobalRedColor: UIColor?
    var themeGlobalRed2Color: UIColor?
    var themeGlobalWhiteColor: UIColor?
    var themeGlobalBlackColor: UIColor?
    var themeGlobalDarkGreyColor: UIColor?
    var themeGlobalDarkGrey2Color: UIColor?
    var themeGlobalLightGreyColor: UIColor?
    var themeGlobalLightestGreyColor: UIColor?
    var themeGlobalSeperatorGreyColor: UIColor?
    var themeGlobalSideMenuSeperatorColor: UIColor?
    var themeGlobalButtonLightGrayColor: UIColor?
    var themeGlobalReportAProblemButtonGrayColor: UIColor?
    
    var textfieldPlaceholderColor: UIColor?
    var textfieldTextColor: UIColor?
    var textfieldRedTextColor: UIColor?
    var textfieldDisabledTextColor: UIColor?
    var textfieldFloatingLabelTextColor: UIColor?
    var textfieldBottomSeparatorColor: UIColor?
    
    var textfieldPlaceholderLoginColor: UIColor?
    var textfieldTextLoginColor: UIColor?
    
    var themeGlobalWhatsappColor: UIColor?
    
    //========================= THEME GLOBAL CUSTOM COLORS SETTINGS ================//
    var themeGlobalOrangeColor: UIColor?
    var themeGlobalFacebookColor: UIColor?
    var themeGlobalGoogleColor: UIColor?
    
    //========================= FLOAT VALUES SETTINGS ================//
    var floatButtonCornerRadius: CGFloat?
    
    //========================= THEME REGULAR FONTS SETTING ================//
    var themeFontFourSizeRegular: UIFont?
    var themeFontFiveSizeRegular: UIFont?
    var themeFontSixSizeRegular: UIFont?
    var themeFontSevenSizeRegular: UIFont?
    var themeFontEightSizeRegular: UIFont?
    var themeFontNineSizeRegular: UIFont?
    var themeFontTenSizeRegular: UIFont?
    var themeFontElevenSizeRegular: UIFont?
    var themeFontTwelveSizeRegular: UIFont?
    var themeFontThirteenSizeRegular: UIFont?
    var themeFontFourteenSizeRegular: UIFont?
    var themeFontFifteenSizeRegular: UIFont?
    var themeFontSixteenSizeRegular: UIFont?
    var themeFontSeventeenSizeRegular: UIFont?
    var themeFontEighteenSizeRegular: UIFont?
    var themeFontNineteenSizeRegular: UIFont?
    var themeFontTwentySizeRegular: UIFont?
    var themeFontTwentyOneSizeRegular: UIFont?
    var themeFontTwentyTwoSizeRegular: UIFont?
    var themeFontTwentyThreeSizeRegular: UIFont?
    var themeFontTwentyFourSizeRegular: UIFont?
    var themeFontTwentyFiveSizeRegular: UIFont?
    var themeFontTwentySixSizeRegular: UIFont?
    var themeFontTwentySevenSizeRegular: UIFont?
    var themeFontTwentyEightSizeRegular: UIFont?
    var themeFontTwentyNineSizeRegular: UIFont?
    var themeFontThirtySizeRegular: UIFont?
    var themeFontThirtyOneSizeRegular: UIFont?
    var themeFontThirtyTwoSizeRegular: UIFont?
    var themeFontThirtyThreeSizeRegular: UIFont?
    var themeFontThirtyFourSizeRegular: UIFont?
    var themeFontThirtyFiveSizeRegular: UIFont?
    var themeFontThirtySixSizeRegular: UIFont?
    var themeFontThirtySevenSizeRegular: UIFont?
    var themeFontThirtyEightSizeRegular: UIFont?
    var themeFontThirtyNineSizeRegular: UIFont?
    var themeFontFourtySizeRegular: UIFont?
    var themeFontFourtyOneSizeRegular: UIFont?
    var themeFontFourtyTwoSizeRegular: UIFont?
    var themeFontFourtyThreeSizeRegular: UIFont?
    var themeFontFourtyFourSizeRegular: UIFont?
    var themeFontFourtyFiveSizeRegular: UIFont?
    var themeFontFourtySixSizeRegular: UIFont?
    var themeFontFourtySevenSizeRegular: UIFont?
    var themeFontFourtyEightSizeRegular: UIFont?
    
    //========================= THEME LIGHT FONTS SETTING ================//
    var themeFontFourSizeLight: UIFont?
    var themeFontFiveSizeLight: UIFont?
    var themeFontSixSizeLight: UIFont?
    var themeFontSevenSizeLight: UIFont?
    var themeFontEightSizeLight: UIFont?
    var themeFontNineSizeLight: UIFont?
    var themeFontTenSizeLight: UIFont?
    var themeFontElevenSizeLight: UIFont?
    var themeFontTwelveSizeLight: UIFont?
    var themeFontThirteenSizeLight: UIFont?
    var themeFontFourteenSizeLight: UIFont?
    var themeFontFifteenSizeLight: UIFont?
    var themeFontSixteenSizeLight: UIFont?
    var themeFontSeventeenSizeLight: UIFont?
    var themeFontEighteenSizeLight: UIFont?
    var themeFontNineteenSizeLight: UIFont?
    var themeFontTwentySizeLight: UIFont?
    var themeFontTwentyOneSizeLight: UIFont?
    var themeFontTwentyTwoSizeLight: UIFont?
    var themeFontTwentyThreeSizeLight: UIFont?
    var themeFontTwentyFourSizeLight: UIFont?
    var themeFontTwentyFiveSizeLight: UIFont?
    var themeFontTwentySixSizeLight: UIFont?
    var themeFontTwentySevenSizeLight: UIFont?
    var themeFontTwentyEightSizeLight: UIFont?
    var themeFontTwentyNineSizeLight: UIFont?
    var themeFontThirtySizeLight: UIFont?
    var themeFontThirtyOneSizeLight: UIFont?
    var themeFontThirtyTwoSizeLight: UIFont?
    var themeFontThirtyThreeSizeLight: UIFont?
    var themeFontThirtyFourSizeLight: UIFont?
    var themeFontThirtyFiveSizeLight: UIFont?
    var themeFontThirtySixSizeLight: UIFont?
    var themeFontThirtySevenSizeLight: UIFont?
    var themeFontThirtyEightSizeLight: UIFont?
    var themeFontThirtyNineSizeLight: UIFont?
    var themeFontFourtySizeLight: UIFont?
    var themeFontFourtyOneSizeLight: UIFont?
    var themeFontFourtyTwoSizeLight: UIFont?
    var themeFontFourtyThreeSizeLight: UIFont?
    var themeFontFourtyFourSizeLight: UIFont?
    var themeFontFourtyFiveSizeLight: UIFont?
    var themeFontFourtySixSizeLight: UIFont?
    var themeFontFourtySevenSizeLight: UIFont?
    var themeFontFourtyEightSizeLight: UIFont?
    
    //========================= THEME MEDIUM FONTS SETTING ================//
    var themeFontFourSizeMedium: UIFont?
    var themeFontFiveSizeMedium: UIFont?
    var themeFontSixSizeMedium: UIFont?
    var themeFontSevenSizeMedium: UIFont?
    var themeFontEightSizeMedium: UIFont?
    var themeFontNineSizeMedium: UIFont?
    var themeFontTenSizeMedium: UIFont?
    var themeFontElevenSizeMedium: UIFont?
    var themeFontTwelveSizeMedium: UIFont?
    var themeFontThirteenSizeMedium: UIFont?
    var themeFontFourteenSizeMedium: UIFont?
    var themeFontFifteenSizeMedium: UIFont?
    var themeFontSixteenSizeMedium: UIFont?
    var themeFontSeventeenSizeMedium: UIFont?
    var themeFontEighteenSizeMedium: UIFont?
    var themeFontNineteenSizeMedium: UIFont?
    var themeFontTwentySizeMedium: UIFont?
    var themeFontTwentyOneSizeMedium: UIFont?
    var themeFontTwentyTwoSizeMedium: UIFont?
    var themeFontTwentyThreeSizeMedium: UIFont?
    var themeFontTwentyFourSizeMedium: UIFont?
    var themeFontTwentyFiveSizeMedium: UIFont?
    var themeFontTwentySixSizeMedium: UIFont?
    var themeFontTwentySevenSizeMedium: UIFont?
    var themeFontTwentyEightSizeMedium: UIFont?
    var themeFontTwentyNineSizeMedium: UIFont?
    var themeFontThirtySizeMedium: UIFont?
    var themeFontThirtyOneSizeMedium: UIFont?
    var themeFontThirtyTwoSizeMedium: UIFont?
    var themeFontThirtyThreeSizeMedium: UIFont?
    var themeFontThirtyFourSizeMedium: UIFont?
    var themeFontThirtyFiveSizeMedium: UIFont?
    var themeFontThirtySixSizeMedium: UIFont?
    var themeFontThirtySevenSizeMedium: UIFont?
    var themeFontThirtyEightSizeMedium: UIFont?
    var themeFontThirtyNineSizeMedium: UIFont?
    var themeFontFourtySizeMedium: UIFont?
    var themeFontFourtyOneSizeMedium: UIFont?
    var themeFontFourtyTwoSizeMedium: UIFont?
    var themeFontFourtyThreeSizeMedium: UIFont?
    var themeFontFourtyFourSizeMedium: UIFont?
    var themeFontFourtyFiveSizeMedium: UIFont?
    var themeFontFourtySixSizeMedium: UIFont?
    var themeFontFourtySevenSizeMedium: UIFont?
    var themeFontFourtyEightSizeMedium: UIFont?
    
    //========================= THEME BOLD FONTS SETTING ================//
    var themeFontFourSizeBold: UIFont?
    var themeFontFiveSizeBold: UIFont?
    var themeFontSixSizeBold: UIFont?
    var themeFontSevenSizeBold: UIFont?
    var themeFontEightSizeBold: UIFont?
    var themeFontNineSizeBold: UIFont?
    var themeFontTenSizeBold: UIFont?
    var themeFontElevenSizeBold: UIFont?
    var themeFontTwelveSizeBold: UIFont?
    var themeFontThirteenSizeBold: UIFont?
    var themeFontFourteenSizeBold: UIFont?
    var themeFontFifteenSizeBold: UIFont?
    var themeFontSixteenSizeBold: UIFont?
    var themeFontSeventeenSizeBold: UIFont?
    var themeFontEighteenSizeBold: UIFont?
    var themeFontNineteenSizeBold: UIFont?
    var themeFontTwentySizeBold: UIFont?
    var themeFontTwentyOneSizeBold: UIFont?
    var themeFontTwentyTwoSizeBold: UIFont?
    var themeFontTwentyThreeSizeBold: UIFont?
    var themeFontTwentyFourSizeBold: UIFont?
    var themeFontTwentyFiveSizeBold: UIFont?
    var themeFontTwentySixSizeBold: UIFont?
    var themeFontTwentySevenSizeBold: UIFont?
    var themeFontTwentyEightSizeBold: UIFont?
    var themeFontTwentyNineSizeBold: UIFont?
    var themeFontThirtySizeBold: UIFont?
    var themeFontThirtyOneSizeBold: UIFont?
    var themeFontThirtyTwoSizeBold: UIFont?
    var themeFontThirtyThreeSizeBold: UIFont?
    var themeFontThirtyFourSizeBold: UIFont?
    var themeFontThirtyFiveSizeBold: UIFont?
    var themeFontThirtySixSizeBold: UIFont?
    var themeFontThirtySevenSizeBold: UIFont?
    var themeFontThirtyEightSizeBold: UIFont?
    var themeFontThirtyNineSizeBold: UIFont?
    var themeFontFourtySizeBold: UIFont?
    var themeFontFourtyOneSizeBold: UIFont?
    var themeFontFourtyTwoSizeBold: UIFont?
    var themeFontFourtyThreeSizeBold: UIFont?
    var themeFontFourtyFourSizeBold: UIFont?
    var themeFontFourtyFiveSizeBold: UIFont?
    var themeFontFourtySixSizeBold: UIFont?
    var themeFontFourtySevenSizeBold: UIFont?
    var themeFontFourtyEightSizeBold: UIFont?
    
    //========================= ALERT VIEW SETTINGS ================//
    var alertViewTitleFont: UIFont?
    var alertViewMessageFont: UIFont?
    var alertViewButtonTitleFont: UIFont?
    var alertViewCancelButtonTitleFont: UIFont?
    
    var alertViewTitleColor: UIColor?
    var alertViewContentColor: UIColor?
    var alertViewLeftButtonFontColor: UIColor?
    var alertViewBackGroundColor: UIColor?
    var alertViewLeftButtonBackgroundColor: UIColor?
    var alertViewRightButtonBackgroundColor: UIColor?
    
    //========================= OTHER CUSTOM METHODS ================//
    
    class func sharedManager() -> MySingleton
    {
        return _sharedManager
    }
    
    override init()
    {
        screenRect = UIScreen.main.bounds
        screenWidth = screenRect.width
        screenHeight = screenRect.height
        
        //========================= APPLICATION SPECIFIC SETTINGS ================//
        
        //========================= SIDE MENU SETTINGS ================//
        
        selectedScreenIndex = 0;
        
        floatLeftSideMenuWidth = (screenWidth/10) * 8
        floatRightSideMenuWidth = (screenWidth/10) * 8
        
        leftViewPresentationStyle = LGSideMenuPresentationStyle.slideAbove//slideBelow
        rightViewPresentationStyle = LGSideMenuPresentationStyle.scaleFromBig
        
        //========================= NAVIGATION BAR SETTINGS ================/
        //navigationBarBackgroundColor = UIColor(rgb: 0xFFFFFF)
        navigationBarBackgroundColor = UIColor(rgb: 0x221F1F) //n
        navigationBarTitleColor = UIColor(rgb: 0xFFFFFF) //UIColor(rgb: 0x000000)
        
        if screenWidth == 320
        {
            navigationBarTitleFont = UIFont(name: "MyriadPro-Bold", size: 16.0)
            navigationBarTitleSmallFont = UIFont(name: "MyriadPro-Bold", size: 14.0)
        }
        else if screenWidth == 375
        {
            navigationBarTitleFont = UIFont(name: "MyriadPro-Bold", size: 17.0)
            navigationBarTitleSmallFont = UIFont(name: "MyriadPro-Bold", size: 14.0)
        }
        else
        {
            navigationBarTitleFont = UIFont(name: "MyriadPro-Bold", size: 18.0)
            navigationBarTitleSmallFont = UIFont(name: "MyriadPro-Bold", size: 14.0)
        }
        
        //========================= TAB BAR SETTINGS ================//
        tabBarBackgroundColor = UIColor(rgb: 0x000000)
        tabBarTitleColor = UIColor(rgb: 0xFFFFFF)
        
        if screenWidth == 320
        {
            tabTitleFont = UIFont(name: "MyriadPro-Bold", size: 12.0)
        }
        else if screenWidth == 375
        {
            tabTitleFont = UIFont(name: "MyriadPro-Bold", size: 13.0)
        }
        else
        {
            tabTitleFont = UIFont(name: "MyriadPro-Bold", size: 14.0)
        }
        
        //========================= THEME GLOBAL COLORS SETTINGS ================//
        themeGlobalBackgroundGreyColor = UIColor(rgb: 0xF3F3F3)
//        themeGlobalBackgroundLightGreenColor = UIColor(rgb: 0xDFEFE5)
        themeGlobalBackgroundLightGreenColor = UIColor(rgb: 0xF3F3F3) // f6e8c2
        
        themeGlobalPurpleColor = UIColor(rgb: 0xff6666)
        themeGlobalBlueColor = UIColor(rgb: 0x28689e)
        themeGlobalLightBlueColor = UIColor(rgb: 0x708E9A)
//        themeGlobalGreenColor = UIColor(rgb: 0x0F9D58)
        themeGlobalGreenColor = UIColor(rgb: 0xE9C427)
        themeGlobalGreen2Color = UIColor(rgb: 0x0b8313)
        
        themeGlobalGreenTextColor = UIColor(rgb: 0x0F9D58)
//        themeGlobalLightGreenColor = UIColor(rgb: 0x56903A)
//        themeGlobalLightGreenColor = UIColor(rgb: 0xE2B434)
        themeGlobalLightGreenColor = UIColor(rgb: 0xDFC010) //n
//        themeGlobalSplashGreenColor = UIColor(rgb: 0x0A2828)
//        themeGlobalSplashGreenColor = UIColor(rgb: 0xe4bb48)
        themeGlobalSplashGreenColor = UIColor(rgb: 0x221F1F) //n dark
        themeGlobalRedColor = UIColor(rgb: 0xA01A1F)
        themeGlobalRed2Color = UIColor(rgb: 0xbe1212)
        themeGlobalWhiteColor = UIColor(rgb: 0xFFFFFF)
        themeGlobalBlackColor = UIColor(rgb: 0x000000)
        themeGlobalDarkGreyColor = UIColor(rgb: 0x5E5E5E)
        themeGlobalDarkGrey2Color = UIColor(rgb: 0x575757)
        themeGlobalLightGreyColor = UIColor(rgb: 0xefefef)
        themeGlobalLightestGreyColor = UIColor(rgb: 0xF2F2F2)
        themeGlobalSeperatorGreyColor = UIColor(rgb: 0xDCDCDC)
        themeGlobalSideMenuSeperatorColor = UIColor(rgb: 0x868686)
        themeGlobalButtonLightGrayColor = UIColor(rgb: 0xABAAAA)
        themeGlobalReportAProblemButtonGrayColor = UIColor(rgb: 0x737171)
        
        textfieldPlaceholderColor = UIColor(rgb: 0x868686)
        textfieldTextColor = UIColor(rgb: 0x4a4a4a)
        textfieldRedTextColor = UIColor(rgb: 0xA01A1F)
        textfieldDisabledTextColor = UIColor(rgb: 0x868686)
        textfieldFloatingLabelTextColor = UIColor(rgb: 0x2A4A7D)
        textfieldBottomSeparatorColor = UIColor(rgb: 0x9FA0A1)
        
        textfieldPlaceholderLoginColor = UIColor(rgb: 0xFFFFFF).withAlphaComponent(0.5)
        textfieldTextLoginColor = UIColor(rgb: 0xFFFFFF)
        
        themeGlobalWhatsappColor = UIColor(rgb: 0x56903A)
        
        //========================= THEME GLOBAL CUSTOM COLORS SETTINGS ================//
        themeGlobalOrangeColor = UIColor(rgb: 0xF49F5F)
        themeGlobalFacebookColor = UIColor(rgb: 0x3b5998)
        themeGlobalGoogleColor = UIColor(rgb: 0xdb3236)
        
        //========================= FLOAT VALUES SETTINGS ================//
        floatButtonCornerRadius = 10.0
        
        //========================= THEME REGULAR FONTS SETTING ================//
        themeFontFourSizeRegular = UIFont(name: "MyriadPro-Regular", size: 4.0)
        themeFontFiveSizeRegular = UIFont(name: "MyriadPro-Regular", size: 5.0)
        themeFontSixSizeRegular = UIFont(name: "MyriadPro-Regular", size: 6.0)
        themeFontSevenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 7.0)
        themeFontEightSizeRegular = UIFont(name: "MyriadPro-Regular", size: 8.0)
        themeFontNineSizeRegular = UIFont(name: "MyriadPro-Regular", size: 9.0)
        themeFontTenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 10.0)
        themeFontElevenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 11.0)
        themeFontTwelveSizeRegular = UIFont(name: "MyriadPro-Regular", size: 12.0)
        themeFontThirteenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 13.0)
        themeFontFourteenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 14.0)
        themeFontFifteenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 15.0)
        themeFontSixteenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 16.0)
        themeFontSeventeenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 17.0)
        themeFontEighteenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 18.0)
        themeFontNineteenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 19.0)
        themeFontTwentySizeRegular = UIFont(name: "MyriadPro-Regular", size: 20.0)
        themeFontTwentyOneSizeRegular = UIFont(name: "MyriadPro-Regular", size: 21.0)
        themeFontTwentyTwoSizeRegular = UIFont(name: "MyriadPro-Regular", size: 22.0)
        themeFontTwentyThreeSizeRegular = UIFont(name: "MyriadPro-Regular", size: 23.0)
        themeFontTwentyFourSizeRegular = UIFont(name: "MyriadPro-Regular", size: 24.0)
        themeFontTwentyFiveSizeRegular = UIFont(name: "MyriadPro-Regular", size: 25.0)
        themeFontTwentySixSizeRegular = UIFont(name: "MyriadPro-Regular", size: 26.0)
        themeFontTwentySevenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 27.0)
        themeFontTwentyEightSizeRegular = UIFont(name: "MyriadPro-Regular", size: 28.0)
        themeFontTwentyNineSizeRegular = UIFont(name: "MyriadPro-Regular", size: 29.0)
        themeFontThirtySizeRegular = UIFont(name: "MyriadPro-Regular", size: 30.0)
        themeFontThirtyOneSizeRegular = UIFont(name: "MyriadPro-Regular", size: 31.0)
        themeFontThirtyTwoSizeRegular = UIFont(name: "MyriadPro-Regular", size: 32.0)
        themeFontThirtyThreeSizeRegular = UIFont(name: "MyriadPro-Regular", size: 33.0)
        themeFontThirtyFourSizeRegular = UIFont(name: "MyriadPro-Regular", size: 34.0)
        themeFontThirtyFiveSizeRegular = UIFont(name: "MyriadPro-Regular", size: 35.0)
        themeFontThirtySixSizeRegular = UIFont(name: "MyriadPro-Regular", size: 36.0)
        themeFontThirtySevenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 37.0)
        themeFontThirtyEightSizeRegular = UIFont(name: "MyriadPro-Regular", size: 38.0)
        themeFontThirtyNineSizeRegular = UIFont(name: "MyriadPro-Regular", size: 39.0)
        themeFontFourtySizeRegular = UIFont(name: "MyriadPro-Regular", size: 40.0)
        themeFontFourtyOneSizeRegular = UIFont(name: "MyriadPro-Regular", size: 41.0)
        themeFontFourtyTwoSizeRegular = UIFont(name: "MyriadPro-Regular", size: 42.0)
        themeFontFourtyThreeSizeRegular = UIFont(name: "MyriadPro-Regular", size: 43.0)
        themeFontFourtyFourSizeRegular = UIFont(name: "MyriadPro-Regular", size: 44.0)
        themeFontFourtyFiveSizeRegular = UIFont(name: "MyriadPro-Regular", size: 45.0)
        themeFontFourtySixSizeRegular = UIFont(name: "MyriadPro-Regular", size: 46.0)
        themeFontFourtySevenSizeRegular = UIFont(name: "MyriadPro-Regular", size: 47.0)
        themeFontFourtyEightSizeRegular = UIFont(name: "MyriadPro-Regular", size: 48.0)
        
        //========================= THEME LIGHT FONTS SETTING ================//
        themeFontFourSizeLight = UIFont(name: "MyriadPro-Light", size: 4.0)
        themeFontFiveSizeLight = UIFont(name: "MyriadPro-Light", size: 5.0)
        themeFontSixSizeLight = UIFont(name: "MyriadPro-Light", size: 6.0)
        themeFontSevenSizeLight = UIFont(name: "MyriadPro-Light", size: 7.0)
        themeFontEightSizeLight = UIFont(name: "MyriadPro-Light", size: 8.0)
        themeFontNineSizeLight = UIFont(name: "MyriadPro-Light", size: 9.0)
        themeFontTenSizeLight = UIFont(name: "MyriadPro-Light", size: 10.0)
        themeFontElevenSizeLight = UIFont(name: "MyriadPro-Light", size: 11.0)
        themeFontTwelveSizeLight = UIFont(name: "MyriadPro-Light", size: 12.0)
        themeFontThirteenSizeLight = UIFont(name: "MyriadPro-Light", size: 13.0)
        themeFontFourteenSizeLight = UIFont(name: "MyriadPro-Light", size: 14.0)
        themeFontFifteenSizeLight = UIFont(name: "MyriadPro-Light", size: 15.0)
        themeFontSixteenSizeLight = UIFont(name: "MyriadPro-Light", size: 16.0)
        themeFontSeventeenSizeLight = UIFont(name: "MyriadPro-Light", size: 17.0)
        themeFontEighteenSizeLight = UIFont(name: "MyriadPro-Light", size: 18.0)
        themeFontNineteenSizeLight = UIFont(name: "MyriadPro-Light", size: 19.0)
        themeFontTwentySizeLight = UIFont(name: "MyriadPro-Light", size: 20.0)
        themeFontTwentyOneSizeLight = UIFont(name: "MyriadPro-Light", size: 21.0)
        themeFontTwentyTwoSizeLight = UIFont(name: "MyriadPro-Light", size: 22.0)
        themeFontTwentyThreeSizeLight = UIFont(name: "MyriadPro-Light", size: 23.0)
        themeFontTwentyFourSizeLight = UIFont(name: "MyriadPro-Light", size: 24.0)
        themeFontTwentyFiveSizeLight = UIFont(name: "MyriadPro-Light", size: 25.0)
        themeFontTwentySixSizeLight = UIFont(name: "MyriadPro-Light", size: 26.0)
        themeFontTwentySevenSizeLight = UIFont(name: "MyriadPro-Light", size: 27.0)
        themeFontTwentyEightSizeLight = UIFont(name: "MyriadPro-Light", size: 28.0)
        themeFontTwentyNineSizeLight = UIFont(name: "MyriadPro-Light", size: 29.0)
        themeFontThirtySizeLight = UIFont(name: "MyriadPro-Light", size: 30.0)
        themeFontThirtyOneSizeLight = UIFont(name: "MyriadPro-Light", size: 31.0)
        themeFontThirtyTwoSizeLight = UIFont(name: "MyriadPro-Light", size: 32.0)
        themeFontThirtyThreeSizeLight = UIFont(name: "MyriadPro-Light", size: 33.0)
        themeFontThirtyFourSizeLight = UIFont(name: "MyriadPro-Light", size: 34.0)
        themeFontThirtyFiveSizeLight = UIFont(name: "MyriadPro-Light", size: 35.0)
        themeFontThirtySixSizeLight = UIFont(name: "MyriadPro-Light", size: 36.0)
        themeFontThirtySevenSizeLight = UIFont(name: "MyriadPro-Light", size: 37.0)
        themeFontThirtyEightSizeLight = UIFont(name: "MyriadPro-Light", size: 38.0)
        themeFontThirtyNineSizeLight = UIFont(name: "MyriadPro-Light", size: 39.0)
        themeFontFourtySizeLight = UIFont(name: "MyriadPro-Light", size: 40.0)
        themeFontFourtyOneSizeLight = UIFont(name: "MyriadPro-Light", size: 41.0)
        themeFontFourtyTwoSizeLight = UIFont(name: "MyriadPro-Light", size: 42.0)
        themeFontFourtyThreeSizeLight = UIFont(name: "MyriadPro-Light", size: 43.0)
        themeFontFourtyFourSizeLight = UIFont(name: "MyriadPro-Light", size: 44.0)
        themeFontFourtyFiveSizeLight = UIFont(name: "MyriadPro-Light", size: 45.0)
        themeFontFourtySixSizeLight = UIFont(name: "MyriadPro-Light", size: 46.0)
        themeFontFourtySevenSizeLight = UIFont(name: "MyriadPro-Light", size: 47.0)
        themeFontFourtyEightSizeLight = UIFont(name: "MyriadPro-Light", size: 48.0)
        
        //========================= THEME MEDIUM FONTS SETTING ================//
        themeFontFourSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 4.0)
        themeFontFiveSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 5.0)
        themeFontSixSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 6.0)
        themeFontSevenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 7.0)
        themeFontEightSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 8.0)
        themeFontNineSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 9.0)
        themeFontTenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 10.0)
        themeFontElevenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 11.0)
        themeFontTwelveSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 12.0)
        themeFontThirteenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 13.0)
        themeFontFourteenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 14.0)
        themeFontFifteenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 15.0)
        themeFontSixteenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 16.0)
        themeFontSeventeenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 17.0)
        themeFontEighteenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 18.0)
        themeFontNineteenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 19.0)
        themeFontTwentySizeMedium = UIFont(name: "MyriadPro-Semibold", size: 20.0)
        themeFontTwentyOneSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 21.0)
        themeFontTwentyTwoSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 22.0)
        themeFontTwentyThreeSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 23.0)
        themeFontTwentyFourSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 24.0)
        themeFontTwentyFiveSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 25.0)
        themeFontTwentySixSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 26.0)
        themeFontTwentySevenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 27.0)
        themeFontTwentyEightSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 28.0)
        themeFontTwentyNineSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 29.0)
        themeFontThirtySizeMedium = UIFont(name: "MyriadPro-Semibold", size: 30.0)
        themeFontThirtyOneSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 31.0)
        themeFontThirtyTwoSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 32.0)
        themeFontThirtyThreeSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 33.0)
        themeFontThirtyFourSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 34.0)
        themeFontThirtyFiveSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 35.0)
        themeFontThirtySixSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 36.0)
        themeFontThirtySevenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 37.0)
        themeFontThirtyEightSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 38.0)
        themeFontThirtyNineSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 39.0)
        themeFontFourtySizeMedium = UIFont(name: "MyriadPro-Semibold", size: 40.0)
        themeFontFourtyOneSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 41.0)
        themeFontFourtyTwoSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 42.0)
        themeFontFourtyThreeSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 43.0)
        themeFontFourtyFourSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 44.0)
        themeFontFourtyFiveSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 45.0)
        themeFontFourtySixSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 46.0)
        themeFontFourtySevenSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 47.0)
        themeFontFourtyEightSizeMedium = UIFont(name: "MyriadPro-Semibold", size: 48.0)
        
        //========================= THEME BOLD FONTS SETTING ================//
        themeFontFourSizeBold = UIFont(name: "MyriadPro-Bold", size: 4.0)
        themeFontFiveSizeBold = UIFont(name: "MyriadPro-Bold", size: 5.0)
        themeFontSixSizeBold = UIFont(name: "MyriadPro-Bold", size: 6.0)
        themeFontSevenSizeBold = UIFont(name: "MyriadPro-Bold", size: 7.0)
        themeFontEightSizeBold = UIFont(name: "MyriadPro-Bold", size: 8.0)
        themeFontNineSizeBold = UIFont(name: "MyriadPro-Bold", size: 9.0)
        themeFontTenSizeBold = UIFont(name: "MyriadPro-Bold", size: 10.0)
        themeFontElevenSizeBold = UIFont(name: "MyriadPro-Bold", size: 11.0)
        themeFontTwelveSizeBold = UIFont(name: "MyriadPro-Bold", size: 12.0)
        themeFontThirteenSizeBold = UIFont(name: "MyriadPro-Bold", size: 13.0)
        themeFontFourteenSizeBold = UIFont(name: "MyriadPro-Bold", size: 14.0)
        themeFontFifteenSizeBold = UIFont(name: "MyriadPro-Bold", size: 15.0)
        themeFontSixteenSizeBold = UIFont(name: "MyriadPro-Bold", size: 16.0)
        themeFontSeventeenSizeBold = UIFont(name: "MyriadPro-Bold", size: 17.0)
        themeFontEighteenSizeBold = UIFont(name: "MyriadPro-Bold", size: 18.0)
        themeFontNineteenSizeBold = UIFont(name: "MyriadPro-Bold", size: 19.0)
        themeFontTwentySizeBold = UIFont(name: "MyriadPro-Bold", size: 20.0)
        themeFontTwentyOneSizeBold = UIFont(name: "MyriadPro-Bold", size: 21.0)
        themeFontTwentyTwoSizeBold = UIFont(name: "MyriadPro-Bold", size: 22.0)
        themeFontTwentyThreeSizeBold = UIFont(name: "MyriadPro-Bold", size: 23.0)
        themeFontTwentyFourSizeBold = UIFont(name: "MyriadPro-Bold", size: 24.0)
        themeFontTwentyFiveSizeBold = UIFont(name: "MyriadPro-Bold", size: 25.0)
        themeFontTwentySixSizeBold = UIFont(name: "MyriadPro-Bold", size: 26.0)
        themeFontTwentySevenSizeBold = UIFont(name: "MyriadPro-Bold", size: 27.0)
        themeFontTwentyEightSizeBold = UIFont(name: "MyriadPro-Bold", size: 28.0)
        themeFontTwentyNineSizeBold = UIFont(name: "MyriadPro-Bold", size: 29.0)
        themeFontThirtySizeBold = UIFont(name: "MyriadPro-Bold", size: 30.0)
        themeFontThirtyOneSizeBold = UIFont(name: "MyriadPro-Bold", size: 31.0)
        themeFontThirtyTwoSizeBold = UIFont(name: "MyriadPro-Bold", size: 32.0)
        themeFontThirtyThreeSizeBold = UIFont(name: "MyriadPro-Bold", size: 33.0)
        themeFontThirtyFourSizeBold = UIFont(name: "MyriadPro-Bold", size: 34.0)
        themeFontThirtyFiveSizeBold = UIFont(name: "MyriadPro-Bold", size: 35.0)
        themeFontThirtySixSizeBold = UIFont(name: "MyriadPro-Bold", size: 36.0)
        themeFontThirtySevenSizeBold = UIFont(name: "MyriadPro-Bold", size: 37.0)
        themeFontThirtyEightSizeBold = UIFont(name: "MyriadPro-Bold", size: 38.0)
        themeFontThirtyNineSizeBold = UIFont(name: "MyriadPro-Bold", size: 39.0)
        themeFontFourtySizeBold = UIFont(name: "MyriadPro-Bold", size: 40.0)
        themeFontFourtyOneSizeBold = UIFont(name: "MyriadPro-Bold", size: 41.0)
        themeFontFourtyTwoSizeBold = UIFont(name: "MyriadPro-Bold", size: 42.0)
        themeFontFourtyThreeSizeBold = UIFont(name: "MyriadPro-Bold", size: 43.0)
        themeFontFourtyFourSizeBold = UIFont(name: "MyriadPro-Bold", size: 44.0)
        themeFontFourtyFiveSizeBold = UIFont(name: "MyriadPro-Bold", size: 45.0)
        themeFontFourtySixSizeBold = UIFont(name: "MyriadPro-Bold", size: 46.0)
        themeFontFourtySevenSizeBold = UIFont(name: "MyriadPro-Bold", size: 47.0)
        themeFontFourtyEightSizeBold = UIFont(name: "MyriadPro-Bold", size: 48.0)
        
        //========================= ALERT VIEW SETTINGS ================//
        alertViewTitleFont = UIFont(name: "MyriadPro-Bold", size: 18.0)
        alertViewMessageFont = UIFont(name: "MyriadPro-Regular", size: 14.0)
        alertViewButtonTitleFont = UIFont(name: "MyriadPro-Regular", size: 16.0)
        alertViewCancelButtonTitleFont = UIFont(name: "MyriadPro-Semibold", size: 16.0)
        
        alertViewTitleColor = UIColor(rgb: 0x0092DD)
        alertViewContentColor = UIColor(rgb: 0x4a4a4a)
        alertViewLeftButtonFontColor = UIColor(rgb: 0xFFFFFF)
        alertViewBackGroundColor = UIColor(rgb: 0xFFFFFF)
        alertViewLeftButtonBackgroundColor = UIColor(rgb: 0xE2B434)
        alertViewRightButtonBackgroundColor = UIColor(rgb: 0x0092DD)
        
        //========================= OTHER CUSTOM METHODS ================//
        
        super.init()
    }
}

let _sharedManager: MySingleton = { MySingleton() }()

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
